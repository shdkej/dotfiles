#!/usr/bin/env bash
# diary-sync.sh — 30분마다 세션/시청 raw 데이터를 Claude로 정제해
# agent-wiki/diary/YYYY-MM-DD.md 에 merge하고 push. 7일 경과 파일 삭제.
set -euo pipefail

export PATH="/Users/seongho-noh/.asdf/installs/nodejs/24.3.0/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"
export HOME="${HOME:-/Users/seongho-noh}"

REPO="$HOME/workspace/agent-wiki"
DIARY_DIR="$REPO/diary"
SESSIONS_SCRIPT="$HOME/workspace/prompt-archive/scripts/daily-sessions.py"
PROMPT_TEMPLATE="$HOME/workspace/prompt-archive/prompts/diary-sync.prompt.md"
TODAY=$(date +%F)
TARGET="$DIARY_DIR/$TODAY.md"
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$DIARY_DIR" "$LOG_DIR"

log() { printf '[%s] %s\n' "$(date +'%F %T')" "$*"; }

retry() {
  local n=0 max=3 delay=5
  until "$@"; do
    n=$((n+1))
    [[ $n -ge $max ]] && return 1
    sleep $delay
    delay=$((delay*2))
  done
}

cd "$REPO"
if ! retry git pull --rebase --quiet origin main; then
  log "error: git pull failed after retries, skipping run to avoid divergence"
  exit 0
fi

RAW_SESSIONS=$(python3 "$SESSIONS_SCRIPT" 2>/dev/null || true)

TMP_DB="/tmp/chrome-history-$$.db"
RAW_MEDIA=""
if cp "$HOME/Library/Application Support/Google/Chrome/Profile 1/History" "$TMP_DB" 2>/dev/null; then
  RAW_MEDIA=$(sqlite3 "$TMP_DB" "SELECT CASE WHEN url LIKE '%youtube.com/watch%' THEN 'YouTube' WHEN url LIKE '%netflix.com/watch%' THEN 'Netflix' END AS platform, title, datetime(last_visit_time/1000000-11644473600, 'unixepoch', 'localtime') AS visit_time FROM urls WHERE (url LIKE '%youtube.com/watch%' OR url LIKE '%netflix.com/watch%') AND date(last_visit_time/1000000-11644473600, 'unixepoch', 'localtime') = date('now', 'localtime') ORDER BY last_visit_time DESC;" 2>/dev/null || true)
  rm -f "$TMP_DB"
fi

EXISTING="(빈 파일)"
[[ -f "$TARGET" ]] && EXISTING=$(cat "$TARGET")

NOW_ISO=$(date -Iseconds)
PROMPT_FILE="/tmp/diary-prompt-$$.txt"

if [[ ! -f "$PROMPT_TEMPLATE" ]]; then
  log "error: prompt template not found: $PROMPT_TEMPLATE"
  exit 1
fi

export TODAY NOW_ISO EXISTING RAW_SESSIONS RAW_MEDIA

python3 - "$PROMPT_TEMPLATE" "$PROMPT_FILE" <<PYEOF
import os, sys
src, dst = sys.argv[1], sys.argv[2]
with open(src, 'r', encoding='utf-8') as f:
    tpl = f.read()
out = (tpl
    .replace('{{TODAY}}', os.environ['TODAY'])
    .replace('{{NOW_ISO}}', os.environ['NOW_ISO'])
    .replace('{{EXISTING}}', os.environ['EXISTING'])
    .replace('{{RAW_SESSIONS}}', os.environ['RAW_SESSIONS'])
    .replace('{{RAW_MEDIA}}', os.environ['RAW_MEDIA']))
with open(dst, 'w', encoding='utf-8') as f:
    f.write(out)
PYEOF

OUT=$(claude -p --dangerously-skip-permissions < "$PROMPT_FILE" 2>>"$LOG_DIR/diary-sync.err" || true)
rm -f "$PROMPT_FILE"
if [[ -n "$OUT" ]]; then
  printf '%s\n' "$OUT" > "$TARGET"
  log "merged $TARGET ($(wc -l <"$TARGET") lines)"
else
  log "warn: claude output empty, keeping existing $TARGET"
fi

CUTOFF=$(date -v-7d +%F)
for f in "$DIARY_DIR"/*.md; do
  [[ -f "$f" ]] || continue
  fname=$(basename "$f" .md)
  if [[ "$fname" < "$CUTOFF" ]]; then
    git rm -q "$f" 2>/dev/null || rm -f "$f"
    log "pruned $fname (older than $CUTOFF)"
  fi
done

git add -A
if ! git diff --cached --quiet; then
  git commit -m "diary: auto-sync $(date +'%Y-%m-%d %H:%M')" >/dev/null
  push_once() {
    git pull --rebase --quiet origin main 2>/dev/null && git push --quiet origin main 2>/dev/null
  }
  if retry push_once; then
    log "pushed"
  else
    log "error: push failed after retries, will retry next run"
  fi
else
  log "no changes"
fi

exit 0
