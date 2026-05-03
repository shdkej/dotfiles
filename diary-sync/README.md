# diary-sync — 30분마다 세션/시청 기록을 GitHub diary로 자동 동기화

## 동작

- 30분마다 `daily-sessions.py` + Chrome 히스토리 수집
- `claude -p`로 정제해 `agent-wiki/diary/YYYY-MM-DD.md`에 merge
- `git add/commit/push` (변경 없으면 skip)
- 7일 경과 파일은 자동 삭제 commit

## 구성 파일

| 파일 | 역할 |
|------|------|
| `~/workspace/dotfiles/diary-sync/diary-sync.sh` | 본체 스크립트 |
| `~/workspace/dotfiles/diary-sync/com.shdkej.diary-sync.plist` | LaunchAgent 원본 (symlink 대상) |
| `~/Library/LaunchAgents/com.shdkej.diary-sync.plist` | 위 plist를 가리키는 symlink |
| `~/workspace/prompt-archive/prompts/diary-sync.prompt.md` | Claude 정제 프롬프트 (placeholder 치환) |
| `~/workspace/prompt-archive/scripts/daily-sessions.py` | 세션 raw 수집기 |
| `~/workspace/agent-wiki/diary/` | 출력 저장소 (`shdkej/agent-wiki` GitHub) |
| `~/.claude/logs/diary-sync.log` / `.err` | 실행 로그 |

## 새 컴퓨터 세팅

### 1. Prerequisites

```bash
# 필수 CLI
asdf install nodejs 24.3.0          # claude CLI가 이 경로를 씀
brew install git python sqlite

# Claude CLI 설치 (Node 경로에 설치됨)
npm install -g @anthropic-ai/claude-code

# Claude 인증
claude login
```

### 2. 저장소 clone

```bash
mkdir -p ~/workspace
git clone git@github.com:shdkej/agent-wiki.git ~/workspace/agent-wiki
git clone git@github.com:shdkej/prompt-archive.git ~/workspace/prompt-archive
```

### 3. GitHub push 인증

SSH key 등록 또는 HTTPS + PAT:

```bash
ssh-keygen -t ed25519 -C "shdkej@gmail.com"
cat ~/.ssh/id_ed25519.pub   # GitHub Settings > SSH keys에 등록
ssh -T git@github.com
```

### 4. PATH 확인 및 plist 수정

`which claude`, `which git`, `which python3` 결과를 plist의 `EnvironmentVariables > PATH`에 반영:

```bash
# plist 파일에서 아래 경로를 현재 머신 값으로 교체
# - ProgramArguments 내 스크립트 절대경로
# - EnvironmentVariables > PATH
# - EnvironmentVariables > HOME
# - StandardOutPath / StandardErrorPath
ln -sf ~/workspace/dotfiles/diary-sync/com.shdkej.diary-sync.plist \
       ~/Library/LaunchAgents/com.shdkej.diary-sync.plist
```

### 5. launchd 등록

```bash
chmod +x ~/workspace/dotfiles/diary-sync/diary-sync.sh
launchctl load ~/Library/LaunchAgents/com.shdkej.diary-sync.plist
launchctl list | grep diary-sync      # PID가 보이면 성공
```

### 6. 동작 확인

```bash
tail -f ~/.claude/logs/diary-sync.log   # 실시간 로그
bash ~/workspace/dotfiles/diary-sync/diary-sync.sh   # 수동 1회 실행
```

## 일반 Linux 서버에서 cron으로 돌리는 경우

macOS가 아닌 경우 `launchd` 대신 `cron` 사용:

```bash
crontab -e
# 아래 한 줄 추가
*/30 * * * * /home/USER/workspace/dotfiles/diary-sync/diary-sync.sh >> /home/USER/.claude/logs/diary-sync.log 2>> /home/USER/.claude/logs/diary-sync.err
```

단, Chrome 히스토리는 macOS 경로(`~/Library/Application Support/...`) 기준이므로 Linux에서는 해당 블록을 Chrome/Chromium Linux 경로(`~/.config/google-chrome/Default/History`)로 바꾸거나, 서버에 브라우저가 없으면 그 부분을 제거해야 함.

## 해제 / 재시작

```bash
launchctl unload ~/Library/LaunchAgents/com.shdkej.diary-sync.plist
launchctl load ~/Library/LaunchAgents/com.shdkej.diary-sync.plist
```

## 튜닝 포인트

- 주기 변경: plist `StartInterval` 값 (초 단위)
- 보존 기간: 스크립트의 `date -v-7d` → 원하는 일수로
- 정제 프롬프트: `~/workspace/prompt-archive/prompts/diary-sync.prompt.md` 수정 (placeholder: `{{TODAY}}`, `{{NOW_ISO}}`, `{{EXISTING}}`, `{{RAW_SESSIONS}}`, `{{RAW_MEDIA}}`)
