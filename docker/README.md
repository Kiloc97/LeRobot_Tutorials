# Docker Environment 🐳

Docker를 사용한 LeRobot 개발 환경 구성 파일들입니다.

## 포함된 파일

### 🐋 Dockerfile

**GPU 지원 Docker 환경** - NVIDIA GPU와 CUDA를 지원하는 완전한 개발 환경

**특징:**

- CUDA 11.8 기반
- GPU 가속 PyTorch 지원
- 완전한 LeRobot 설치
- Jupyter Notebook 및 개발 도구 포함
- 한국어 환경 지원

### 💻 Dockerfile.cpu

**CPU 전용 Docker 환경** - GPU가 없는 환경을 위한 최적화된 환경

**특징:**

- Ubuntu 22.04 기반
- CPU 최적화 PyTorch
- 메모리 효율성 개선
- 동일한 개발 도구 포함

### 📋 docker-compose.yml

**Docker Compose 설정** - 복잡한 환경 관리를 위한 설정 파일

**서비스:**

- `lerobot` (GPU 지원)
- `lerobot-cpu` (CPU 전용)

**포트 매핑:**

- 8888: Jupyter Notebook (GPU)
- 8889: Jupyter Notebook (CPU)
- 6006: TensorBoard (GPU)
- 6007: TensorBoard (CPU)

**볼륨 마운트:**

- `./data`: 데이터셋 및 모델 저장
- `./outputs`: 학습 결과 및 로그
- 호스트 디렉토리 연동

### 🎛️ run-docker.sh

**Docker 환경 관리 스크립트** - 복잡한 Docker 명령어를 간단하게 실행

**명령어:**

```bash
./run-docker.sh gpu      # GPU 환경 시작
./run-docker.sh cpu      # CPU 환경 시작
./run-docker.sh stop     # 모든 컨테이너 중지
./run-docker.sh clean    # 환경 완전 정리
./run-docker.sh status   # 현재 상태 확인
```

## 사용 방법

### 1. 기본 실행

```bash
# GPU 환경 (권장)
./run-docker.sh gpu

# CPU 환경
./run-docker.sh cpu
```

### 2. 컨테이너 접속

```bash
# GPU 환경 컨테이너 접속
docker exec -it lerobot-dev bash

# CPU 환경 컨테이너 접속
docker exec -it lerobot-cpu-dev bash
```

### 3. 서비스 접속

- **Jupyter Notebook**: http://localhost:8888 (GPU) / http://localhost:8889 (CPU)
- **TensorBoard**: http://localhost:6006 (GPU) / http://localhost:6007 (CPU)

### 4. 파일 공유

```bash
# 호스트 → 컨테이너
cp my_script.py ./data/
# 컨테이너에서 /workspace/data/my_script.py로 접근 가능

# 컨테이너 → 호스트
# 컨테이너에서 /workspace/outputs/에 저장하면
# 호스트의 ./outputs/에서 확인 가능
```

## 환경 구성

### GPU 환경 사전 요구사항

```bash
# NVIDIA Container Toolkit 설치
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### 디렉토리 구조

```
LeRobot_Tutorials/
├── docker/
│   ├── Dockerfile
│   ├── Dockerfile.cpu
│   ├── docker-compose.yml
│   └── run-docker.sh
├── data/              # 데이터셋 (자동 생성)
└── outputs/           # 결과물 (자동 생성)
```

## 고급 사용법

### 1. 커스텀 환경 변수

```bash
# docker-compose.yml에서 환경 변수 수정
environment:
  - CUDA_VISIBLE_DEVICES=0,1  # 특정 GPU만 사용
  - WANDB_API_KEY=your_key    # Weights & Biases API 키
```

### 2. 추가 패키지 설치

```bash
# 컨테이너 내에서
pip install additional_package

# 또는 Dockerfile 수정하여 영구 적용
RUN pip install additional_package
```

### 3. 포트 변경

```bash
# docker-compose.yml에서 포트 수정
ports:
  - "9999:8888"  # 호스트 9999 포트 사용
```

### 4. 메모리 제한

```bash
# docker-compose.yml에서 리소스 제한
deploy:
  resources:
    limits:
      memory: 8G
      cpus: '4'
```

## 문제 해결

### GPU 인식 문제

```bash
# 컨테이너에서 GPU 확인
nvidia-smi
python -c "import torch; print(torch.cuda.is_available())"
```

### 메모리 부족

```bash
# 스왑 메모리 생성
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### 포트 충돌

```bash
# 사용 중인 포트 확인
netstat -tulpn | grep :8888

# docker-compose.yml에서 다른 포트로 변경
```

### 권한 문제

```bash
# 파일 권한 수정
sudo chown -R $USER:$USER ./data ./outputs
```

## 성능 최적화

### 1. 이미지 캐시 활용

```bash
# 빌드 시 캐시 사용
docker-compose build --parallel
```

### 2. 볼륨 최적화

```bash
# 로컬 볼륨 사용으로 I/O 성능 개선
# docker-compose.yml에서 볼륨 설정 조정
```

### 3. 네트워크 최적화

```bash
# 호스트 네트워크 모드 사용 (Linux)
network_mode: "host"
```

Docker 환경은 시스템 환경에 관계없이 일관된 개발 환경을 제공하며, 특히 의존성 충돌이나 시스템 설정 문제를 완전히 해결해줍니다.
