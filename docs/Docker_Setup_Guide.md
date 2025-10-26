# Docker를 사용한 LeRobot 환경 구성 가이드

## 개요

Docker를 사용하면 시스템 의존성 문제 없이 일관된 LeRobot 개발 환경을 구축할 수 있습니다.
이 방법은 특히 Windows 사용자나 복잡한 의존성 설정을 피하고 싶은 경우에 유용합니다.

## 사전 요구사항

### 1. Docker 설치

#### Windows/macOS

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) 다운로드 및 설치

#### Ubuntu/Linux

```bash
# Docker 설치
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 사용자를 docker 그룹에 추가
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Docker Compose 설치

```bash
# Docker Compose 설치 (최신 버전)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 3. NVIDIA GPU 지원 (선택적)

GPU를 사용하려면 NVIDIA Container Toolkit 설치:

```bash
# NVIDIA Container Toolkit 저장소 설정
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# NVIDIA Container Toolkit 설치
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

## 환경 구성 방법

### 1. 프로젝트 클론 및 디렉토리 구조 생성

```bash
# 프로젝트 디렉토리 생성
mkdir -p ~/LeRobot_Docker
cd ~/LeRobot_Docker

# 필요한 디렉토리 생성
mkdir -p data outputs

# Docker 파일들을 여기에 복사
# (Dockerfile, docker-compose.yml, Dockerfile.cpu)
```

### 2. GPU 환경 실행 (권장)

```bash
# GPU 지원 컨테이너 빌드 및 실행
docker-compose --profile gpu up -d

# 컨테이너에 접속
docker exec -it lerobot-dev bash
```

### 3. CPU 전용 환경 실행

```bash
# CPU 전용 컨테이너 빌드 및 실행
docker-compose --profile cpu up -d

# 컨테이너에 접속
docker exec -it lerobot-cpu-dev bash
```

## 사용 방법

### 컨테이너 내에서 작업

#### 기본 명령어

```bash
# LeRobot 예제 디렉토리로 이동
lr-examples

# 튜토리얼 디렉토리로 이동
lr-tutorial

# 학습 예제 실행
lr-train-pusht
```

#### Jupyter Notebook 사용

```bash
# Jupyter Notebook 실행
cd /workspace/lerobot
jupyter notebook

# 브라우저에서 접속: http://localhost:8888
# (CPU 버전은 http://localhost:8889)
```

#### TensorBoard 사용

```bash
# TensorBoard 실행
tensorboard --logdir /workspace/outputs/logs --host 0.0.0.0

# 브라우저에서 접속: http://localhost:6006
# (CPU 버전은 http://localhost:6007)
```

### 데이터 및 코드 공유

#### 호스트와 컨테이너 간 파일 공유

- `/workspace/host`: 호스트의 현재 디렉토리가 마운트됨
- `/workspace/data`: 데이터셋 및 모델 저장
- `/workspace/outputs`: 학습 결과 및 로그 저장

#### 예제: 로컬 코드를 컨테이너에서 실행

```bash
# 호스트에서 코드 작성
echo "print('Hello from host!')" > ~/LeRobot_Docker/my_script.py

# 컨테이너에서 실행
docker exec -it lerobot-dev python /workspace/host/my_script.py
```

## 유용한 Docker 명령어

### 컨테이너 관리

```bash
# 실행 중인 컨테이너 확인
docker ps

# 컨테이너 중지
docker-compose down

# 컨테이너 재시작
docker-compose restart

# 컨테이너 로그 확인
docker logs lerobot-dev

# 컨테이너 상태 모니터링
docker stats
```

### 이미지 관리

```bash
# 이미지 빌드 (캐시 사용 안 함)
docker-compose build --no-cache

# 사용하지 않는 이미지 정리
docker system prune -a

# 특정 이미지 삭제
docker rmi lerobot-tutorials_lerobot
```

## 환경 설정 팁

### 1. VS Code에서 Docker 컨테이너 연결

```bash
# VS Code에서 Remote-Containers 확장 설치 후
# Ctrl+Shift+P -> "Remote-Containers: Attach to Running Container"
# lerobot-dev 선택
```

### 2. 영구 데이터 저장

```bash
# Docker 볼륨 사용하여 데이터 영구 보존
docker volume create lerobot_persistent_data
docker run -v lerobot_persistent_data:/workspace/data ...
```

### 3. 포트 충돌 해결

```bash
# 다른 포트로 서비스 실행
docker run -p 8890:8888 lerobot-dev  # Jupyter를 8890 포트로
```

## 문제 해결

### GPU 관련 문제

```bash
# GPU 사용 가능 여부 확인
docker exec -it lerobot-dev nvidia-smi

# PyTorch에서 GPU 인식 확인
docker exec -it lerobot-dev python -c "import torch; print(torch.cuda.is_available())"
```

### 메모리 부족 문제

```bash
# Docker에 더 많은 메모리 할당
# Docker Desktop -> Settings -> Resources -> Memory 증가

# 스왑 메모리 사용
docker run --memory=8g --memory-swap=16g lerobot-dev
```

### 권한 문제

```bash
# 파일 권한 문제 해결
docker exec -it lerobot-dev chown -R $(id -u):$(id -g) /workspace/outputs
```

## 고급 설정

### 1. 사용자 정의 Dockerfile

```dockerfile
# 추가 패키지 설치
FROM lerobot-tutorials_lerobot:latest
RUN pip install opencv-python matplotlib seaborn
```

### 2. 멀티 스테이지 빌드

```dockerfile
# 빌드 단계와 실행 단계 분리로 이미지 크기 최적화
FROM ubuntu:22.04 as builder
# ... 빌드 과정 ...

FROM ubuntu:22.04 as runtime
COPY --from=builder /workspace /workspace
```

### 3. Docker Swarm을 사용한 클러스터 구성

```bash
# 여러 머신에서 분산 학습
docker swarm init
docker service create --name lerobot-cluster --replicas 3 lerobot-dev
```

이 Docker 환경을 사용하면 시스템 환경에 관계없이 일관된 LeRobot 개발 환경을 구축할 수 있습니다!
