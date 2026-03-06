# 맥북 개발환경 정리 (2026-03-06)

## 현황 요약

| 구분 | 수량 |
|------|------|
| Formula (전체) | 193개 |
| Cask | 19개 |
| Top-level (leaves) | 51개 |
| 나머지 142개는 의존성 | 자동 설치됨 |

---

## 1. 자주 쓰는 패키지 (유지 권장)

### Formula - 최근 활발히 사용 (최근 3개월 내)

| 패키지 | 용도 |
|--------|------|
| **asdf** | 런타임 버전 관리 (node, java 등) |
| **fzf** | 퍼지 파인더 |
| **gh** | GitHub CLI |
| **git-delta** | git diff 하이라이팅 |
| **bat** | cat 대체 (구문 강조) |
| **neovim** | 에디터 |
| **fasd** | 디렉토리 빠른 이동 |
| **vim** | 에디터 |
| **rust** | Rust 툴체인 |
| **terraform** | IaC |
| **jq** | JSON 처리 |
| **argocd** | K8s GitOps |
| **aws-vault** | AWS 자격증명 관리 |
| **saml2aws** | AWS SAML 인증 |
| **the_silver_searcher** | ag (코드 검색) |
| **helm** | K8s 패키지 관리 |
| **kubectx** | K8s 컨텍스트 전환 |
| **pandoc** | 문서 변환 |
| **redis** | 캐시/DB |
| **k9s** | K8s 대시보드 |
| **minikube** | 로컬 K8s |
| **perl** | 스크립팅 |

### Cask - 유지 권장

| 패키지 | 용도 |
|--------|------|
| **aerospace** | 윈도우 매니저 |
| **docker / docker-desktop** | 컨테이너 |
| **iterm2** | 터미널 |
| **karabiner-elements** | 키 매핑 |
| **maccy** | 클립보드 관리 |
| **obsidian** | 노트 |
| **stats** | 시스템 모니터링 |
| **visual-studio-code** | 에디터 |
| **warp** | 터미널 |
| **font-hack-nerd-font** | 개발 폰트 |
| **font-nanum-gothic** | 한글 폰트 |
| **gcloud-cli** | GCP CLI |

---

## 2. 제거 대상 (확정)

### Formula 제거 (19개)

| 패키지 | 마지막 사용 | 이유 |
|--------|------------|------|
| **flyctl** | 2023-10 | Fly.io - 2년 이상 미사용 |
| **git-lfs** | 2023-04 | 3년 가까이 미사용 |
| **docutils** | 2023-10 | 2년 이상 미사용 |
| **cmake** | 2024-04 | C/C++ 빌드 안 하면 불필요 |
| **protobuf** | 2024-04 | 2년 가까이 미사용 |
| **gitlab-runner** | 2024-03 | 로컬 러너 불필요 |
| **python@3.9** | 2025-04 | asdf로 통합 |
| **python@3.10** | 2025-04 | asdf로 통합 |
| **python@3.11** | 2024-12 | asdf로 통합 |
| **pyenv** | 2025-07 | asdf로 대체 |
| **nvm** | - | asdf로 대체 |
| **poetry** | 2025-06 | asdf 통합 시 불필요 |
| **browsh** | 2025-07 | 텍스트 브라우저 (거의 안 씀) |
| **links** | 2025-07 | 텍스트 브라우저 중복 |
| **lynx** | 2025-07 | 텍스트 브라우저 중복 |
| **w3m** | 2025-07 | 텍스트 브라우저 중복 |
| **lsd** | 2025-04 | bat+ls로 대체 가능 |
| **colima** | 2025-06 | Docker Desktop 사용 중 |
| **qemu** | 2025-06 | colima 제거 시 함께 제거 |

### Cask 제거 (2개)

| 패키지 | 이유 |
|--------|------|
| **inkscape** | 디자인 작업 안 함 |
| **vagrant** | VM 사용 안 함 |

### 유지 확정 (간헐적 사용 포함)

awscli, ffmpeg, gnupg, glances, fink, awslogs, spectacle, codex, ngrok, microsoft-remote-desktop

---

## 3. 정리 실행 계획

```bash
# Step 1: Formula 제거
brew uninstall flyctl git-lfs docutils cmake protobuf gitlab-runner \
  python@3.9 python@3.10 python@3.11 pyenv nvm poetry \
  browsh links lynx w3m lsd colima qemu

# Step 2: Cask 제거
brew uninstall --cask inkscape vagrant

# Step 3: 의존성 정리 + 캐시 삭제
brew autoremove
brew cleanup --prune=all

# Step 4: 결과 확인
brew leaves | wc -l
du -sh /opt/homebrew
```

---

## 4. 검증

- `brew leaves`로 남은 패키지 수 확인 (51개 → 약 32개 예상)
- `du -sh /opt/homebrew`로 절약된 디스크 공간 확인 (10GB → 약 7~8GB 예상)
- 주요 도구 동작 확인: `asdf`, `fzf`, `gh`, `jq`, `kubectl`
- asdf에 python, nodejs 플러그인 설정 확인: `asdf plugin list`

---

# Brew 외 설치 항목 정리

## 디스크 사용량 (캐시 포함)

| 항목 | 크기 | 비고 |
|------|------|------|
| **~/.npm** | **22GB** | npm 캐시 - 정리 1순위 |
| **~/.asdf** | 3.8GB | 런타임 버전 11개 |
| **~/Library/Caches/pip** | 2.9GB | pip 캐시 |
| **~/Library/Caches/Homebrew** | 1.1GB | brew 캐시 |
| **~/.cargo** | 568MB | Rust (cargo-sqlx, sqlx만 설치) |
| **합계** | **~30GB** | |

---

## 5. /Applications (brew 외 설치 앱)

brew cask로 관리되지 않는 앱 목록:

### 업무/개발
| 앱 | 용도 |
|----|------|
| Adobe Creative Cloud / Illustrator | 디자인 |
| IntelliJ IDEA / JetBrains Toolbox | Java IDE |
| Cursor | AI 에디터 |
| DBeaver | DB 클라이언트 |
| Postman | API 테스트 |
| Figma | 디자인 협업 |
| Lens | K8s IDE |
| Xcode | Apple 개발 |
| Slack | 메신저 |
| Microsoft Teams | 메신저 |

### 보안/네트워크
| 앱 | 용도 |
|----|------|
| ESET Endpoint Security | 보안 (회사) |
| Genians | NAC (회사) |
| OpenVPN Connect | VPN |
| Tailscale | 메시 VPN |

### 유틸리티
| 앱 | 용도 |
|----|------|
| Raycast | 런처 |
| Hammerspoon | 자동화 |
| Hidden Bar | 메뉴바 정리 |
| AppCleaner | 앱 제거 |
| Keka | 압축 |
| Scroll Reverser | 마우스 스크롤 반전 |
| Cyberduck | FTP/S3 클라이언트 |
| Amphetamine | 잠자기 방지 |
| flow | 타이머 |
| Folder Hub | 폴더 관리 |

### 기타
| 앱 | 용도 |
|----|------|
| Claude | AI 어시스턴트 |
| Amazon Q | AWS AI |
| Beeper Desktop | 통합 메신저 |
| VNC Viewer | 원격 접속 |
| Vrew | 영상 편집 |
| Paint X | 간단 이미지 편집 |
| Pencil | 디자인 |
| Hancom Office HWP Viewer | HWP 뷰어 |

---

## 6. npm 전역 패키지 (6개)

| 패키지 | 용도 |
|--------|------|
| @google/gemini-cli | Gemini CLI |
| @pnp/cli-microsoft365-mcp-server | M365 MCP 서버 |
| @pnp/cli-microsoft365 | M365 CLI |
| playwriter | Playwright 관련 |
| corepack, npm | 기본 포함 |

---

## 7. pip 전역 패키지 (77개)

주요 패키지: pandas, numpy, openpyxl, beautifulsoup4, httpx, google-genai, magika, markitdown, pillow, plotly, lxml, jinja2

---

## 8. asdf 버전 관리

| 런타임 | 설치 버전 | 현재 | 제거 후보 |
|--------|----------|------|----------|
| **nodejs** | 12.18.2, 14.17.5, 16.8.0, 16.18.0, 18.20.8, 20.15.1, 22.14.0, 22.18.0, 22.21.1, 24.0.0, 24.3.0 | 24.3.0 | 12, 14, 16 (EOL) |
| **java** | openjdk-17.0.2, zulu-8.52.0.23 | zulu-8 | 유지 |
| **yarn** | 1.22.11, 1.22.22 | 1.22.11 | 1.22.22 제거 |

---

## 9. Cargo (Rust)

설치 바이너리: cargo-sqlx, sqlx — 사용 중이면 유지

---

## 10. Brew 외 정리 실행 계획

```bash
# Step 1: npm 캐시 정리 (22GB 절약 예상)
npm cache clean --force

# Step 2: pip 캐시 정리 (2.9GB 절약 예상)
pip cache purge

# Step 3: asdf 오래된 nodejs 버전 제거
asdf uninstall nodejs 12.18.2
asdf uninstall nodejs 14.17.5
asdf uninstall nodejs 16.8.0
asdf uninstall nodejs 16.18.0

# Step 4: yarn 중복 제거
asdf uninstall yarn 1.22.22

# Step 5: 결과 확인
du -sh ~/.npm ~/.asdf ~/Library/Caches/pip
```

---

## 전체 정리 예상 절약량

| 항목 | 절약 예상 |
|------|----------|
| Brew formula/cask 제거 | ~2GB |
| Brew 캐시 정리 | ~1.1GB |
| npm 캐시 정리 | ~22GB |
| pip 캐시 정리 | ~2.9GB |
| asdf 구버전 제거 | ~1.5GB |
| **합계** | **~29.5GB** |

---

# 새 맥북 세팅 명령어

정리 후 유지 목록 기준, 새 맥북에서 처음부터 설치하거나 현재 환경을 복원할 때 사용하는 명령어

## 1. Homebrew 설치

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Formula 일괄 설치 (핵심 도구)

```bash
# 런타임/버전 관리
brew install asdf

# 에디터
brew install neovim vim

# CLI 도구
brew install fzf bat jq gh git-delta fasd the_silver_searcher pandoc

# AWS
brew install awscli aws-vault saml2aws awslogs

# K8s
brew install argocd helm kubectx k9s minikube

# 인프라/언어
brew install terraform rust redis perl

# 미디어/보안/기타
brew install ffmpeg gnupg glances ngrok
```

### 한 줄로 실행

```bash
brew install asdf neovim vim fzf bat jq gh git-delta fasd \
  the_silver_searcher pandoc awscli aws-vault saml2aws awslogs \
  argocd helm kubectx k9s minikube terraform rust redis perl \
  ffmpeg gnupg glances ngrok
```

## 3. Cask 일괄 설치 (GUI 앱)

```bash
brew install --cask aerospace docker iterm2 karabiner-elements \
  maccy obsidian stats visual-studio-code warp spectacle \
  font-hack-nerd-font font-nanum-gothic gcloud-cli \
  microsoft-remote-desktop
```

## 4. asdf 런타임 설치

```bash
# 플러그인 추가
asdf plugin add nodejs
asdf plugin add java
asdf plugin add yarn

# 버전 설치
asdf install nodejs 24.3.0
asdf install nodejs 22.21.1
asdf install nodejs 20.15.1
asdf install nodejs 18.20.8
asdf install java zulu-8.52.0.23
asdf install java openjdk-17.0.2
asdf install yarn 1.22.11

# 기본 버전 설정
asdf global nodejs 24.3.0
asdf global java zulu-8.52.0.23
asdf global yarn 1.22.11
```

## 5. npm 전역 패키지

```bash
npm install -g @google/gemini-cli @pnp/cli-microsoft365 \
  @pnp/cli-microsoft365-mcp-server playwriter
```

## 6. pip 주요 패키지

```bash
pip install pandas numpy openpyxl beautifulsoup4 httpx \
  google-genai magika markitdown pillow plotly lxml jinja2
```

## 7. Cargo (Rust)

```bash
cargo install cargo-sqlx sqlx-cli
```

---

# 전체 업데이트 명령어

정기적으로 실행하여 모든 패키지를 최신 상태로 유지

```bash
# Homebrew 업데이트 (formula + cask)
brew update && brew upgrade && brew upgrade --cask && brew cleanup

# npm 전역 패키지 업데이트
npm update -g

# pip 전체 업데이트
pip install --upgrade pip
pip list --outdated --format=json | python3 -c "import sys,json; [print(p['name']) for p in json.load(sys.stdin)]" | xargs -n1 pip install -U

# asdf 플러그인 업데이트
asdf plugin update --all

# Rust 업데이트
rustup update
cargo install-update -a 2>/dev/null || echo "cargo-update 미설치 - cargo install cargo-update 로 설치"
```

### 간편 업데이트 alias (zshrc에 추가)

```bash
alias update-all='echo "=== Brew ===" && brew update && brew upgrade && brew upgrade --cask && brew cleanup && echo "=== npm ===" && npm update -g && echo "=== pip ===" && pip install --upgrade pip && echo "=== asdf ===" && asdf plugin update --all && echo "=== Rust ===" && rustup update && echo "=== Done ==="'
```
