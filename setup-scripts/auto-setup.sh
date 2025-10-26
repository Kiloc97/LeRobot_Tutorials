#!/bin/bash
# =============================================================================
# LeRobot 완전 자동 설치 스크립트
# =============================================================================
# 이 스크립트는 새로운 Ubuntu/WSL 환경에서 LeRobot을 완전히 자동으로 
# 설치하고 환경을 구성합니다.
#
# 지원 환경: Ubuntu 20.04+, WSL2
# 
# 사용법:
# curl -sSL https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/auto-setup.sh | bash
# 또는
# wget -O- https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main/auto-setup.sh | bash
# =============================================================================

set -e  # 오류 발생 시 스크립트 중단

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 로그 함수들
log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# 시스템 정보 확인
detect_system() {
    log_step "시스템 환경 확인"
    
    # OS 확인
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -q Microsoft /proc/version 2>/dev/null; then
            SYSTEM="WSL"
            log_info "WSL (Windows Subsystem for Linux) 환경 감지"
        else
            SYSTEM="Linux"
            log_info "Linux 환경 감지"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        SYSTEM="macOS"
        log_info "macOS 환경 감지"
    else
        log_error "지원되지 않는 OS입니다: $OSTYPE"
        exit 1
    fi
    
    # 아키텍처 확인
    ARCH=$(uname -m)
    log_info "아키텍처: $ARCH"
    
    # Python 버전 확인
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        log_info "Python 버전: $PYTHON_VERSION"
    else
        log_warning "Python3가 설치되지 않았습니다. 설치를 진행합니다."
    fi
}

# 프로젝트 디렉토리 설정
setup_project_directory() {
    log_step "프로젝트 디렉토리 설정"
    
    # 기본 프로젝트 경로 설정
    if [[ "$SYSTEM" == "WSL" ]]; then
        # WSL 환경에서는 Windows 드라이브 사용
        DEFAULT_PROJECT_PATH="/mnt/c/Programming/LeRobot_Tutorials"
    else
        # Linux/macOS에서는 홈 디렉토리 사용
        DEFAULT_PROJECT_PATH="$HOME/LeRobot_Tutorials"
    fi
    
    # 사용자 입력 받기 (30초 타임아웃)
    echo -e "${YELLOW}프로젝트 경로를 입력하세요 (기본값: $DEFAULT_PROJECT_PATH):${NC}"
    read -t 30 -p "> " PROJECT_PATH || PROJECT_PATH=""
    
    if [[ -z "$PROJECT_PATH" ]]; then
        PROJECT_PATH="$DEFAULT_PROJECT_PATH"
    fi
    
    log_info "프로젝트 경로: $PROJECT_PATH"
    
    # 디렉토리 생성
    mkdir -p "$PROJECT_PATH"
    cd "$PROJECT_PATH"
    
    # 환경 변수로 설정
    export LEROBOT_PROJECT_ROOT="$PROJECT_PATH"
    export LEROBOT_SOURCE_DIR="$PROJECT_PATH/lerobot"
    export LEROBOT_VENV_DIR="$PROJECT_PATH/.venv"
}

# 시스템 패키지 설치
install_system_packages() {
    log_step "시스템 패키지 설치"
    
    if [[ "$SYSTEM" == "Linux" ]] || [[ "$SYSTEM" == "WSL" ]]; then
        log_info "APT 패키지 목록 업데이트..."
        sudo apt update -qq
        
        log_info "필수 패키지 설치..."
        sudo apt install -y \
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
            libatlas-base-dev \
            python3-numpy
            
    elif [[ "$SYSTEM" == "macOS" ]]; then
        log_info "Homebrew 확인 및 설치..."
        if ! command -v brew &> /dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        
        log_info "필수 패키지 설치..."
        brew install python3 git cmake
    fi
    
    log_success "시스템 패키지 설치 완료"
}

# Git 설정
setup_git() {
    log_step "Git 설정"
    
    # Git 사용자 정보 확인
    if ! git config --global user.name &> /dev/null; then
        echo -e "${YELLOW}Git 사용자 이름을 입력하세요:${NC}"
        read -p "> " GIT_NAME
        git config --global user.name "$GIT_NAME"
    fi
    
    if ! git config --global user.email &> /dev/null; then
        echo -e "${YELLOW}Git 이메일을 입력하세요:${NC}"
        read -p "> " GIT_EMAIL
        git config --global user.email "$GIT_EMAIL"
    fi
    
    log_success "Git 설정 완료"
}

# LeRobot 저장소 클론
clone_lerobot() {
    log_step "LeRobot 저장소 클론"
    
    # HuggingFace LeRobot 저장소 클론
    if [[ ! -d "lerobot" ]]; then
        log_info "LeRobot 저장소 클론 중..."
        git clone https://github.com/huggingface/lerobot.git
    else
        log_info "LeRobot 저장소가 이미 존재합니다. 업데이트 중..."
        cd lerobot
        git pull
        cd ..
    fi
    
    log_success "LeRobot 저장소 준비 완료"
}

# Python 가상환경 설정
setup_python_env() {
    log_step "Python 가상환경 설정"
    
    # 가상환경 생성
    if [[ ! -d ".venv" ]]; then
        log_info "Python 가상환경 생성 중..."
        python3 -m venv .venv
    else
        log_info "가상환경이 이미 존재합니다."
    fi
    
    # 가상환경 활성화
    log_info "가상환경 활성화..."
    source .venv/bin/activate
    
    # pip 업그레이드
    log_info "pip 업그레이드..."
    pip install --upgrade pip setuptools wheel
    
    log_success "Python 가상환경 설정 완료"
}

# LeRobot 설치
install_lerobot() {
    log_step "LeRobot 패키지 설치"
    
    cd lerobot
    
    # LeRobot 기본 설치
    log_info "LeRobot 기본 패키지 설치 중... (시간이 오래 걸릴 수 있습니다)"
    pip install -e .
    
    # PushT 환경 설치
    log_info "PushT 시뮬레이션 환경 설치 중..."
    pip install -e ".[pusht]"
    
    # 추가 유용한 패키지 설치
    log_info "추가 개발 도구 설치..."
    pip install jupyter notebook ipython black flake8 pytest
    
    cd ..
    
    log_success "LeRobot 설치 완료"
}

# CUDA 설치 (선택적)
setup_cuda() {
    log_step "CUDA 설정 (선택적)"
    
    if command -v nvidia-smi &> /dev/null; then
        log_info "NVIDIA GPU가 감지되었습니다."
        echo -e "${YELLOW}CUDA를 설치하시겠습니까? (y/N):${NC}"
        read -t 15 -p "> " INSTALL_CUDA || INSTALL_CUDA="n"
        
        if [[ "$INSTALL_CUDA" =~ ^[Yy]$ ]]; then
            log_info "PyTorch CUDA 버전 설치..."
            source .venv/bin/activate
            pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
            log_success "CUDA 설치 완료"
        else
            log_info "CPU 버전으로 계속 진행합니다."
        fi
    else
        log_info "NVIDIA GPU가 감지되지 않았습니다. CPU 버전으로 설치합니다."
    fi
}

# bashrc 설정
setup_bashrc() {
    log_step "Bash 환경 설정"
    
    # 백업 생성
    if [[ -f ~/.bashrc ]]; then
        cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
        log_info "기존 .bashrc 백업 완료"
    fi
    
    # LeRobot 설정 추가
    log_info "LeRobot 환경 설정 추가 중..."
    
    # 설정 파일 생성
    cat >> ~/.bashrc << EOF

# =============================================================================
# LeRobot 자동 설치된 환경 설정
# =============================================================================
export LEROBOT_PROJECT_ROOT="$PROJECT_PATH"
export LEROBOT_SOURCE_DIR="\$LEROBOT_PROJECT_ROOT/lerobot"
export LEROBOT_VENV_DIR="\$LEROBOT_PROJECT_ROOT/.venv"

# LeRobot 환경 활성화 함수
lerobot_activate() {
    echo "🤖 LeRobot 환경 활성화 중..."
    if [ -d "\$LEROBOT_PROJECT_ROOT" ]; then
        cd "\$LEROBOT_PROJECT_ROOT"
        if [ -f "\$LEROBOT_VENV_DIR/bin/activate" ]; then
            source "\$LEROBOT_VENV_DIR/bin/activate"
            echo "✅ LeRobot 환경 활성화 완료!"
        else
            echo "❌ 가상환경을 찾을 수 없습니다."
        fi
    else
        echo "❌ 프로젝트 디렉토리를 찾을 수 없습니다."
    fi
}

# 유용한 별칭들
alias lr-activate='lerobot_activate'
alias lr-cd='cd \$LEROBOT_PROJECT_ROOT'
alias lr-src='cd \$LEROBOT_SOURCE_DIR'
alias lr-examples='cd \$LEROBOT_SOURCE_DIR/examples'
alias lr-train='cd \$LEROBOT_SOURCE_DIR/examples/training && python train_policy.py'
alias lr-info='echo "📊 LeRobot 환경: \$LEROBOT_PROJECT_ROOT"'

# 자동 활성화 (선택적)
# lerobot_activate

echo "🤖 LeRobot 환경이 준비되었습니다! 'lr-activate'로 시작하세요."
EOF
    
    log_success "Bash 환경 설정 완료"
}

# VS Code 설정 (선택적)
setup_vscode() {
    log_step "VS Code 설정 (선택적)"
    
    echo -e "${YELLOW}VS Code 설정을 생성하시겠습니까? (y/N):${NC}"
    read -t 15 -p "> " SETUP_VSCODE || SETUP_VSCODE="n"
    
    if [[ "$SETUP_VSCODE" =~ ^[Yy]$ ]]; then
        mkdir -p .vscode
        
        # settings.json 생성
        cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "./.venv/bin/python",
    "python.terminal.activateEnvironment": true,
    "files.exclude": {
        "**/__pycache__": true,
        "**/*.pyc": true,
        ".venv/": true
    },
    "terminal.integrated.defaultProfile.linux": "bash",
    "workbench.colorTheme": "Default Dark+"
}
EOF
        
        # extensions.json 생성
        cat > .vscode/extensions.json << 'EOF'
{
    "recommendations": [
        "ms-python.python",
        "ms-python.black-formatter",
        "ms-toolsai.jupyter",
        "github.copilot",
        "eamodio.gitlens"
    ]
}
EOF
        
        log_success "VS Code 설정 완료"
    fi
}

# 설치 검증
verify_installation() {
    log_step "설치 검증"
    
    # 가상환경 활성화
    source .venv/bin/activate
    
    # LeRobot 임포트 테스트
    if python -c "import lerobot; print(f'✅ LeRobot {lerobot.__version__} 설치 확인')" 2>/dev/null; then
        log_success "LeRobot 설치 검증 성공"
    else
        log_error "LeRobot 설치 검증 실패"
        return 1
    fi
    
    # PyTorch 확인
    if python -c "import torch; print(f'✅ PyTorch {torch.__version__} 설치 확인')" 2>/dev/null; then
        log_success "PyTorch 설치 검증 성공"
    else
        log_warning "PyTorch 설치 확인 실패"
    fi
    
    # 디렉토리 구조 확인
    log_info "프로젝트 구조:"
    tree -L 2 . 2>/dev/null || ls -la
}

# 사용법 안내
show_usage() {
    log_step "설치 완료 및 사용법 안내"
    
    echo -e "${GREEN}🎉 LeRobot 자동 설치가 완료되었습니다!${NC}"
    echo ""
    echo -e "${CYAN}📋 다음 단계:${NC}"
    echo "1. 새 터미널을 열거나 다음 명령어로 설정을 적용하세요:"
    echo "   source ~/.bashrc"
    echo ""
    echo "2. LeRobot 환경을 활성화하세요:"
    echo "   lr-activate"
    echo ""
    echo "3. 첫 번째 예제를 실행해보세요:"
    echo "   lr-train"
    echo ""
    echo -e "${CYAN}🔧 유용한 명령어들:${NC}"
    echo "  lr-activate  : LeRobot 환경 활성화"
    echo "  lr-cd        : 프로젝트 디렉토리로 이동"
    echo "  lr-examples  : 예제 폴더로 이동"
    echo "  lr-info      : 환경 정보 확인"
    echo ""
    echo -e "${CYAN}📁 프로젝트 위치:${NC} $PROJECT_PATH"
    echo ""
    echo -e "${YELLOW}💡 문제 발생 시:${NC}"
    echo "  - GitHub Issues: https://github.com/huggingface/lerobot/issues"
    echo "  - Discord: LeRobot 커뮤니티 참여"
    echo ""
}

# 메인 실행 함수
main() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║         🤖 LeRobot 자동 설치기           ║"
    echo "║                                           ║"
    echo "║  새로운 컴퓨터에 LeRobot 환경을          ║"
    echo "║  완전 자동으로 설치합니다                 ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # 사용자 확인
    echo -e "${YELLOW}설치를 시작하시겠습니까? (y/N):${NC}"
    read -t 10 -p "> " CONFIRM || CONFIRM="y"
    
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        log_info "설치가 취소되었습니다."
        exit 0
    fi
    
    # 설치 과정 실행
    detect_system
    setup_project_directory
    install_system_packages
    setup_git
    clone_lerobot
    setup_python_env
    install_lerobot
    setup_cuda
    setup_bashrc
    setup_vscode
    verify_installation
    show_usage
    
    log_success "모든 설치 과정이 완료되었습니다! 🚀"
}

# 오류 처리
trap 'log_error "설치 중 오류가 발생했습니다. 라인 $LINENO에서 실패"; exit 1' ERR

# 메인 함수 실행
main "$@"