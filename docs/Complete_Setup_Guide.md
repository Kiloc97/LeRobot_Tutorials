# 새로운 컴퓨터에 LeRobot 환경 자동 구성 가이드

## 개요

이 가이드는 새로운 컴퓨터에서 LeRobot 개발 환경을 완전히 자동으로 설정하는 방법을 제공합니다.
세 가지 방법 중 본인의 환경과 선호도에 맞는 방법을 선택할 수 있습니다.

## 🚀 방법 1: 완전 자동화 스크립트 (권장)

### 특징

- ✅ 모든 의존성 자동 설치
- ✅ Git 설정 및 저장소 클론
- ✅ Python 가상환경 자동 구성
- ✅ VS Code 설정 동기화
- ✅ 한번의 명령으로 완료

### 사용 방법

```bash
# 1단계: 스크립트 다운로드 및 실행
curl -fsSL https://raw.githubusercontent.com/[YOUR_USERNAME]/LeRobot_Tutorials/main/auto-setup.sh -o auto-setup.sh
chmod +x auto-setup.sh
./auto-setup.sh

# 또는 원라이너로:
bash <(curl -fsSL https://raw.githubusercontent.com/[YOUR_USERNAME]/LeRobot_Tutorials/main/auto-setup.sh)
```

### 스크립트가 수행하는 작업

1. **시스템 요구사항 확인 및 설치**

   - Ubuntu/Debian 패키지 업데이트
   - Python 3.12, pip, git, curl 설치
   - 개발 도구 (build-essential, cmake 등) 설치

2. **Git 환경 설정**

   - Git 전역 설정 (사용자명, 이메일)
   - SSH 키 생성 및 설정 (선택사항)
   - GitHub 저장소 클론

3. **Python 개발 환경 구성**

   - 가상환경 (.venv) 생성
   - pip 업그레이드 및 최적화
   - LeRobot 및 모든 의존성 설치

4. **개발 도구 설정**

   - VS Code 설치 (Linux용)
   - bashrc 자동화 설정
   - 유용한 별칭 및 함수 추가

5. **환경 검증 및 테스트**
   - 설치 상태 확인
   - 간단한 LeRobot 예제 실행
   - 문제 진단 및 해결책 제시

## 🐳 방법 2: Docker 기반 환경 (추천)

### 특징

- ✅ 시스템 의존성 문제 완전 해결
- ✅ 일관된 환경 보장
- ✅ GPU 지원 포함
- ✅ 쉬운 정리 및 재설치

### 사전 요구사항

```bash
# Docker 설치 (Ubuntu/Linux)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker

# GPU 지원을 위한 NVIDIA Container Toolkit (선택사항)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### 사용 방법

```bash
# 1단계: 프로젝트 클론
git clone https://github.com/[YOUR_USERNAME]/LeRobot_Tutorials.git
cd LeRobot_Tutorials

# 2단계: 환경 실행
./run-docker.sh gpu    # GPU 환경
./run-docker.sh cpu    # CPU 전용 환경

# 3단계: 컨테이너 접속
docker exec -it lerobot-dev bash
```

### Docker 환경의 장점

- **격리된 환경**: 호스트 시스템에 영향 없음
- **재현 가능성**: 어떤 시스템에서도 동일한 환경
- **쉬운 정리**: `./run-docker.sh clean`으로 완전 제거
- **버전 관리**: 다양한 환경 버전 동시 사용 가능

## 💻 방법 3: 수동 설치 (고급 사용자)

### 특징

- ✅ 최대 제어권
- ✅ 커스터마이징 가능
- ✅ 학습 목적에 적합

### 단계별 설치

```bash
# 1단계: 시스템 패키지 설치
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv git curl build-essential

# 2단계: 프로젝트 설정
mkdir -p ~/LeRobot_Development
cd ~/LeRobot_Development
git clone https://github.com/huggingface/lerobot.git

# 3단계: Python 환경 구성
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip

# 4단계: LeRobot 설치
cd lerobot
pip install -e .
pip install -e ".[pusht]"

# 5단계: 개발 도구 설치
pip install jupyter notebook black flake8 pytest
```

## 🔧 환경별 최적화 설정

### Windows (WSL2 사용시)

```bash
# WSL2에서 GPU 지원 활성화
echo 'export CUDA_VISIBLE_DEVICES=0' >> ~/.bashrc

# Windows와 파일 시스템 연동
ln -s /mnt/c/Users/[USERNAME]/Documents/LeRobot ~/LeRobot_Windows
```

### macOS

```bash
# Homebrew 기반 설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install python git

# MPS (Apple Silicon GPU) 지원 확인
python -c "import torch; print('MPS available:', torch.backends.mps.is_available())"
```

### 서버 환경 (Headless)

```bash
# X11 포워딩 없이 Jupyter 사용
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888

# 원격 접속을 위한 터널링
ssh -L 8888:localhost:8888 user@server
```

## 📋 설치 후 검증 체크리스트

### 기본 환경 확인

```bash
# Python 및 패키지 버전 확인
python --version              # Python 3.8+ 필요
pip list | grep lerobot       # LeRobot 설치 확인
pip list | grep torch         # PyTorch 설치 확인

# GPU 지원 확인 (해당되는 경우)
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
python -c "import torch; print('GPU count:', torch.cuda.device_count())"
```

### LeRobot 기능 테스트

```bash
# 간단한 예제 실행
cd lerobot/examples
python -c "from lerobot.common.datasets.push_dataset_to_hub.huggingface_utils import push_dataset_to_hub_from_dir; print('LeRobot import successful!')"

# 데이터셋 다운로드 테스트 (작은 데이터셋)
python -c "import lerobot; print('LeRobot version:', lerobot.__version__)"
```

### 개발 도구 확인

```bash
# Jupyter 노트북 실행 테스트
jupyter notebook --version

# 코드 포맷터 테스트
echo "print('Hello World')" | black -

# Git 설정 확인
git config --list | grep user
```

## 🚨 문제 해결 가이드

### 일반적인 문제들

#### 1. pip 설치 오류

```bash
# 가상환경이 활성화되지 않은 경우
source .venv/bin/activate

# pip 캐시 정리
pip cache purge
pip install --upgrade pip setuptools wheel
```

#### 2. GPU 인식 안됨

```bash
# NVIDIA 드라이버 확인
nvidia-smi

# CUDA 설치 확인
nvcc --version

# PyTorch CUDA 버전 호환성 확인
python -c "import torch; print('PyTorch CUDA version:', torch.version.cuda)"
```

#### 3. 메모리 부족 오류

```bash
# 스왑 메모리 생성
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 영구 적용
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

#### 4. 권한 오류

```bash
# 사용자 디렉토리 권한 수정
sudo chown -R $USER:$USER ~/LeRobot_Development

# pip 사용자 설치 디렉토리 권한
mkdir -p ~/.local/lib/python3.*/site-packages
```

### 로그 및 디버깅

#### 자세한 설치 로그 보기

```bash
# pip 설치시 자세한 출력
pip install -v -e .

# 시스템 정보 수집
python -c "
import sys, torch, platform
print('Python:', sys.version)
print('Platform:', platform.platform())
print('PyTorch:', torch.__version__)
print('CUDA available:', torch.cuda.is_available())
"
```

## 📚 추가 리소스

### 학습 자료

- [LeRobot 공식 문서](https://huggingface.co/docs/lerobot)
- [PyTorch 튜토리얼](https://pytorch.org/tutorials/)
- [Jupyter Notebook 가이드](https://jupyter-notebook.readthedocs.io/)

### 커뮤니티 및 지원

- [LeRobot GitHub Issues](https://github.com/huggingface/lerobot/issues)
- [HuggingFace Discord](https://hf.co/join/discord)
- [PyTorch Forums](https://discuss.pytorch.org/)

### 유용한 도구

- **코드 에디터**: VS Code, PyCharm, Vim
- **터미널**: Terminator, Windows Terminal, iTerm2
- **버전 관리**: Git, GitHub Desktop
- **가상화**: Docker, Conda, Virtualenv

## 🎯 다음 단계

환경 설정 완료 후 다음 활동들을 시도해보세요:

1. **기본 튜토리얼 실행**

   ```bash
   cd lerobot/examples/tutorial
   jupyter notebook
   ```

2. **첫 번째 모델 학습**

   ```bash
   cd lerobot/examples/training
   python train_policy.py
   ```

3. **커스텀 데이터셋 만들기**

   ```bash
   # 자신의 데이터로 실험해보기
   ```

4. **결과 시각화**
   ```bash
   tensorboard --logdir ./outputs
   ```

이 가이드를 통해 어떤 새로운 컴퓨터에서도 LeRobot 개발 환경을 쉽고 빠르게 구성할 수 있습니다!
