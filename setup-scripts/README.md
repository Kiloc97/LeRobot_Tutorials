# Setup Scripts 📜

LeRobot 개발 환경을 자동으로 구성하기 위한 스크립트 모음입니다.

## 포함된 스크립트

### 🚀 auto-setup.sh

**완전 자동 설치 스크립트** - 새로운 컴퓨터에서 LeRobot 환경을 원클릭으로 설치

**기능:**

- 시스템 패키지 자동 설치 (Python, Git, 개발 도구)
- Git 설정 및 저장소 클론
- Python 가상환경 생성 및 활성화
- LeRobot 및 모든 의존성 설치
- VS Code 설정 및 bashrc 자동화
- 환경 검증 및 테스트

**사용법:**

```bash
# 로컬에서 실행
./auto-setup.sh

# 원격에서 직접 실행 (권장)
bash <(curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/auto-setup.sh)
```

### 📥 download-setup-files.sh

**설정 파일 일괄 다운로드** - 모든 설정 파일과 스크립트를 한 번에 다운로드

**기능:**

- 모든 Docker 파일 다운로드
- 문서 및 가이드 다운로드
- 스크립트 파일 다운로드 및 실행 권한 부여
- 다운로드 상태 확인 및 리포트

**사용법:**

```bash
# 로컬에서 실행
./download-setup-files.sh

# 원격에서 직접 실행
bash <(curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/download-setup-files.sh)
```

### 🪟 windows-auto-setup.ps1

**Windows 완전 자동 설치** - Windows에서 WSL, VS Code, LeRobot 환경을 원클릭으로 설치

**기능:**

- WSL2 및 Ubuntu 22.04 자동 설치
- VS Code 및 필수 확장 자동 설치
- Windows Terminal 설정 자동화
- LeRobot 환경 자동 구성
- 바탕화면 바로가기 생성

**사용법:**

```powershell
# PowerShell 관리자 권한으로 실행
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/windows-auto-setup.ps1'))

# 또는 로컬 파일로 실행
.\windows-auto-setup.ps1
```

### ⚙️ lerobot-bashrc-config.sh

**Bashrc 자동 설정** - 개발 편의성을 위한 bashrc 설정 자동화

**기능:**

- 유용한 별칭 추가 (ll, lr-\*, python 관련)
- LeRobot 관련 환경 변수 설정
- 가상환경 자동 활성화 설정
- Git 설정 및 프롬프트 개선
- 개발 도구 단축키 추가

**추가되는 별칭:**

```bash
# 디렉토리 이동
lr-home          # LeRobot 홈으로 이동
lr-examples      # examples 폴더로 이동
lr-training      # 학습 폴더로 이동

# 개발 도구
lr-jupyter       # Jupyter 노트북 실행
lr-tensorboard   # TensorBoard 실행
lr-train-pusht   # PushT 학습 실행

# 환경 관리
lr-env-info      # 환경 정보 표시
lr-gpu-check     # GPU 상태 확인
```

**사용법:**

```bash
# 단독 실행
./lerobot-bashrc-config.sh

# 설정 적용 후 bashrc 다시 로드
source ~/.bashrc
```

## 실행 순서 권장사항

### Windows 새로운 컴퓨터 (완전 자동화) 🪟

```powershell
# PowerShell 관리자 권한으로 실행
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/windows-auto-setup.ps1'))
```

### Linux/WSL 새로운 컴퓨터 (완전 자동화) 🐧

```bash
# 완전 자동 설치 (모든 것을 한 번에)
bash <(curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/auto-setup.sh)
```

### 기존 시스템 (부분 설정)

```bash
# 1. 파일 다운로드
./download-setup-files.sh

# 2. 필요한 부분만 선택적으로 실행
./lerobot-bashrc-config.sh
```

## 문제 해결

### 권한 오류

```bash
chmod +x *.sh
```

### 네트워크 오류

```bash
# 다운로드 실패시 수동으로 재시도
curl -fsSL [URL] -o [filename]
```

### 환경 충돌

```bash
# 가상환경 정리 후 재설치
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
```

모든 스크립트는 에러 처리와 로깅이 포함되어 있어 문제 발생시 상세한 정보를 제공합니다.
