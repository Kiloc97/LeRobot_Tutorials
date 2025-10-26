# 새로운 Windows 컴퓨터 완전 자동 설정 가이드 🪟

새로운 Windows 컴퓨터에서 LeRobot 개발 환경을 완전히 자동으로 구성하는 방법입니다.

## 🎯 원클릭 설치 방법

### PowerShell 스크립트 (권장)

```powershell
# PowerShell을 관리자 권한으로 실행 후 다음 명령어 복사/붙여넣기
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/windows-auto-setup.ps1'))
```

## 📋 단계별 설명

### 1단계: WSL 자동 설치 및 설정

- Windows Subsystem for Linux 기능 활성화
- WSL2로 기본 버전 설정
- Ubuntu 22.04 자동 설치
- 기본 사용자 계정 설정

### 2단계: 개발 도구 자동 설치

- VS Code 다운로드 및 설치
- 필수 VS Code 확장 자동 설치:
  - Remote - WSL
  - Python
  - Jupyter
  - Docker (선택사항)

### 3단계: WSL 내부 환경 구성

- 시스템 패키지 업데이트
- Python 3.12 및 개발 도구 설치
- Git 설정
- LeRobot 환경 완전 설치

### 4단계: VS Code 통합 설정

- WSL과 VS Code 연동 확인
- 개발 환경 설정 적용
- 확장 동기화 설정

## 🚀 수동 설치 방법

자동 스크립트를 사용할 수 없는 경우:

### Step 1: WSL 설치

```powershell
# PowerShell (관리자 권한으로 실행)
# 1. WSL 기능 활성화
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 2. 재부팅 후 WSL2 설정
wsl --set-default-version 2

# 3. Ubuntu 설치
wsl --install -d Ubuntu-22.04
```

### Step 2: VS Code 설치

1. [VS Code 다운로드](https://code.visualstudio.com/)
2. 설치 시 "Add to PATH" 옵션 선택
3. Remote - WSL 확장 설치

### Step 3: WSL에서 개발 환경 구성

```bash
# Ubuntu WSL에서 실행
# LeRobot 자동 설치 스크립트 실행
bash <(curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/auto-setup.sh)
```

### Step 4: VS Code에서 WSL 연결

1. VS Code 실행
2. `Ctrl + Shift + P`
3. "WSL: Connect to WSL" 선택
4. `/mnt/c/Programming/LeRobot_Tutorials` 폴더 열기

## 🔧 고급 설정

### Windows Terminal 자동 설정

```json
// settings.json에 추가할 설정
{
  "defaultProfile": "{Ubuntu Profile GUID}",
  "profiles": {
    "list": [
      {
        "name": "LeRobot Dev",
        "commandline": "wsl -d Ubuntu-22.04 -e bash -c 'cd /mnt/c/Programming/LeRobot_Tutorials && source .venv/bin/activate && bash'",
        "startingDirectory": "//wsl$/Ubuntu-22.04/mnt/c/Programming/LeRobot_Tutorials"
      }
    ]
  }
}
```

### 바탕화면 바로가기 생성

```powershell
# LeRobot 개발 환경 바로가기 생성
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\LeRobot Dev.lnk")
$Shortcut.TargetPath = "code"
$Shortcut.Arguments = "--remote wsl+Ubuntu-22.04 /mnt/c/Programming/LeRobot_Tutorials"
$Shortcut.Save()
```

## 📱 다중 컴퓨터 관리

### VS Code Settings Sync 활용

1. VS Code에서 Settings Sync 켜기 (`Ctrl + ,` → Sync 검색)
2. GitHub 계정으로 로그인
3. 확장, 설정, 키바인딩 자동 동기화

### 개발 환경 백업

```bash
# 설정 백업 (WSL에서)
cd /mnt/c/Programming/LeRobot_Tutorials
tar -czf lerobot-backup.tar.gz .venv/ setup-scripts/ korean-tutorials/

# 클라우드 저장소에 업로드 (OneDrive, Google Drive 등)
cp lerobot-backup.tar.gz /mnt/c/Users/$USERNAME/OneDrive/
```

### 환경 복원

```bash
# 새 컴퓨터에서 환경 복원
cd /mnt/c/Programming/LeRobot_Tutorials
tar -xzf lerobot-backup.tar.gz
source .venv/bin/activate
```

## 🔄 자동 동기화 설정

### Git 설정 동기화

```bash
# ~/.gitconfig 파일을 클라우드에 백업
cp ~/.gitconfig /mnt/c/Users/$USERNAME/OneDrive/dev-configs/

# 새 컴퓨터에서 복원
cp /mnt/c/Users/$USERNAME/OneDrive/dev-configs/.gitconfig ~/
```

### SSH 키 동기화 (보안 주의)

```bash
# SSH 키 백업 (보안 중요!)
cp -r ~/.ssh /mnt/c/Users/$USERNAME/OneDrive/dev-configs/ssh-backup/

# 새 컴퓨터에서 복원
cp -r /mnt/c/Users/$USERNAME/OneDrive/dev-configs/ssh-backup ~/.ssh
chmod 600 ~/.ssh/id_rsa
```

## ⚠️ 주의사항

### 보안

- SSH 키, API 키 등 민감한 정보는 안전하게 보관
- .env 파일은 별도로 관리
- 회사 컴퓨터의 경우 정책 확인

### 성능

- WSL2는 충분한 메모리 할당 필요 (최소 8GB 권장)
- SSD 사용 시 더 좋은 성능

### 호환성

- Windows 10 버전 2004 이상 필요
- Hyper-V 기능 활성화 필요

## 🎯 완전 자동화 체크리스트

새로운 컴퓨터에서 30분 내 완료 가능:

- [ ] PowerShell 자동 설치 스크립트 실행
- [ ] 재부팅 (WSL 설치 완료)
- [ ] Ubuntu 초기 설정 (사용자명, 비밀번호)
- [ ] VS Code Settings Sync 로그인
- [ ] LeRobot 개발 환경 확인
- [ ] 첫 번째 예제 실행 테스트

이 가이드를 따르면 새로운 Windows 컴퓨터에서도 빠르게 동일한 LeRobot 개발 환경을 구축할 수 있습니다!
