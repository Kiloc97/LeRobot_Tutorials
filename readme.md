# LeRobot Tutorials & Development Environment 🤖

새로운 컴퓨터에서 LeRobot 개발 환경을 자동으로 구성하기 위한 종합 튜토리얼과 도구 모음입니다.

## 📁 프로젝트 구조

```
LeRobot_Tutorials/
├── 📁 setup-scripts/          # 환경 구성 자동화 스크립트
│   ├── auto-setup.sh          # 완전 자동 설치 스크립트 (원클릭)
│   ├── download-setup-files.sh # 모든 설정 파일 일괄 다운로드
│   └── lerobot-bashrc-config.sh # bashrc 자동 설정
├── 📁 docker/                 # Docker 기반 환경 구성
│   ├── Dockerfile             # GPU 지원 Docker 환경
│   ├── Dockerfile.cpu         # CPU 전용 Docker 환경
│   ├── docker-compose.yml     # Docker Compose 설정
│   └── run-docker.sh          # Docker 환경 관리 스크립트
├── 📁 docs/                   # 문서 및 가이드
│   ├── Complete_Setup_Guide.md # 종합 설정 가이드
│   ├── Docker_Setup_Guide.md  # Docker 전용 가이드
│   └── lerobot-file-structure-guide.md # LeRobot 파일 구조 설명
├── 📁 korean-tutorials/       # 한국어 튜토리얼
│   ├── examples-한국어주석-가이드.md # 예제 코드 한국어 주석
│   └── lerobot-환경설정-완료.md # 환경 설정 완료 가이드
├── 📁 lerobot/                # LeRobot 소스코드 (서브모듈)
└── README.md                  # 이 파일
```

## 🚀 빠른 시작 (새로운 컴퓨터)

### 방법 1: 원클릭 자동 설치 ⭐ (권장)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/auto-setup.sh)
```

### 방법 2: Docker 환경 🐳 (안전함)

```bash
git clone https://github.com/Kiloc97/LeRobot_Tutorials.git
cd LeRobot_Tutorials/docker
./run-docker.sh gpu    # GPU 환경
# 또는
./run-docker.sh cpu    # CPU 환경
```

### 방법 3: 수동 설치 🔧 (고급 사용자)

```bash
# 모든 설정 파일 다운로드
bash <(curl -fsSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/download-setup-files.sh)

# 가이드 문서 참고하여 단계별 설치
cat docs/Complete_Setup_Guide.md
```

## 📚 상세 가이드

- **[완전 설정 가이드](docs/Complete_Setup_Guide.md)** - 모든 방법을 포함한 종합 가이드
- **[Docker 설정 가이드](docs/Docker_Setup_Guide.md)** - Docker 기반 환경 구성
- **[파일 구조 가이드](docs/lerobot-file-structure-guide.md)** - LeRobot 프로젝트 구조 설명
- **[한국어 튜토리얼](korean-tutorials/)** - 한국어 주석과 설명이 포함된 튜토리얼

## 🛠 포함된 도구

### 자동화 스크립트

- **auto-setup.sh**: 모든 의존성과 환경을 자동으로 설치
- **lerobot-bashrc-config.sh**: 개발 편의를 위한 bashrc 설정 자동화
- **download-setup-files.sh**: 모든 설정 파일을 한 번에 다운로드

### Docker 환경

- **GPU 지원**: NVIDIA GPU와 CUDA 지원
- **CPU 전용**: GPU 없는 환경에서도 작동
- **완전 격리**: 호스트 시스템에 영향 없는 깨끗한 환경

### 개발 도구

- Python 가상환경 자동 설정
- VS Code 통합 및 설정 동기화
- Git 설정 자동화
- 유용한 별칭 및 함수 제공

## 🖥️ 다중 컴퓨터 관리

### Windows 새 컴퓨터 자동 설정 🪟

```powershell
# PowerShell 관리자 권한으로 실행
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/setup-scripts/windows-auto-setup.ps1'))
```

### VS Code 설정 동기화 ⚙️

- VS Code Settings Sync 활용으로 확장 및 설정 자동 동기화
- **주의**: WSL은 각 컴퓨터마다 별도 설치 필요

### 개발 환경 백업/복원 💾

```bash
# 환경 백업
tar -czf lerobot-env-backup.tar.gz .venv/ korean-tutorials/ docs/

# 새 컴퓨터에서 복원
tar -xzf lerobot-env-backup.tar.gz
```

**자세한 다중 컴퓨터 설정**: [Windows 다중 컴퓨터 가이드](docs/Windows_Multi_Computer_Setup.md)

## 🎯 지원 환경

- **OS**: Ubuntu 20.04+, WSL2, macOS
- **Python**: 3.8+
- **GPU**: NVIDIA GPU (선택사항)
- **Docker**: 20.10+ (Docker 방법 사용시)

## 🤝 기여하기

이 프로젝트는 LeRobot 학습과 개발을 더 쉽게 만들기 위한 오픈소스 프로젝트입니다.
개선 사항이나 문제점을 발견하시면 언제든지 Issue나 Pull Request를 보내주세요!

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 LICENSE 파일을 참고하세요.

## 🔗 관련 링크

- [LeRobot 공식 저장소](https://github.com/huggingface/lerobot)
- [LeRobot 문서](https://huggingface.co/docs/lerobot)
- [HuggingFace 커뮤니티](https://huggingface.co/lerobot-community)
