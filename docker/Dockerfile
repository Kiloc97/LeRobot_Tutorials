# LeRobot Docker Environment
# GPU 지원이 포함된 완전한 LeRobot 개발 환경

FROM nvidia/cuda:11.8-devel-ubuntu22.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LEROBOT_PROJECT_ROOT="/workspace/lerobot"

# 시스템 패키지 업데이트 및 설치
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    git \
    curl \
    wget \
    build-essential \
    cmake \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    libjpeg-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    python3-numpy \
    vim \
    nano \
    htop \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Python을 기본 python으로 설정
RUN ln -s /usr/bin/python3 /usr/bin/python

# 작업 디렉토리 설정
WORKDIR /workspace

# LeRobot 저장소 클론
RUN git clone https://github.com/huggingface/lerobot.git

# Python 가상환경 설정
RUN python -m venv .venv
ENV PATH="/workspace/.venv/bin:$PATH"

# pip 업그레이드
RUN pip install --upgrade pip setuptools wheel

# LeRobot 설치
WORKDIR /workspace/lerobot
RUN pip install -e .
RUN pip install -e ".[pusht]"

# 추가 개발 도구 설치
RUN pip install jupyter notebook ipython black flake8 pytest wandb tensorboard

# Jupyter 설정
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py

# 환경 변수 설정
ENV LEROBOT_SOURCE_DIR="/workspace/lerobot"
ENV LEROBOT_VENV_DIR="/workspace/.venv"

# 유용한 별칭 설정
RUN echo 'alias ll="ls -la"' >> ~/.bashrc
RUN echo 'alias lr-examples="cd /workspace/lerobot/examples"' >> ~/.bashrc
RUN echo 'alias lr-tutorial="cd /workspace/lerobot/examples/tutorial"' >> ~/.bashrc
RUN echo 'alias lr-training="cd /workspace/lerobot/examples/training"' >> ~/.bashrc
RUN echo 'alias lr-train-pusht="cd /workspace/lerobot/examples/training && python train_policy.py"' >> ~/.bashrc

# 포트 노출 (Jupyter, TensorBoard 등)
EXPOSE 8888 6006

# 작업 디렉토리를 루트로 설정
WORKDIR /workspace

# 시작 명령어
CMD ["/bin/bash"]