# =============================================================================
# LeRobot 개발 환경 자동 구성 스크립트
# =============================================================================
# 이 스크립트를 ~/.bashrc 파일의 끝에 추가하면 터미널 시작 시 자동으로 
# LeRobot 개발 환경이 설정됩니다.
#
# 사용법:
# 1. 이 파일의 내용을 ~/.bashrc 끝에 복사
# 2. 새 터미널 열기 또는 source ~/.bashrc 실행
# =============================================================================

# -----------------------------------------------------------------------------
# 🎯 LeRobot 프로젝트 경로 설정
# -----------------------------------------------------------------------------
export LEROBOT_PROJECT_ROOT="/mnt/c/Programming/LeRobot_Tutorials"
export LEROBOT_SOURCE_DIR="$LEROBOT_PROJECT_ROOT/lerobot"
export LEROBOT_VENV_DIR="$LEROBOT_PROJECT_ROOT/.venv"

# -----------------------------------------------------------------------------
# 🤖 LeRobot 환경 자동 활성화 함수
# -----------------------------------------------------------------------------
lerobot_activate() {
    echo "🤖 LeRobot 환경 활성화 중..."
    
    # 프로젝트 디렉토리로 이동
    if [ -d "$LEROBOT_PROJECT_ROOT" ]; then
        cd "$LEROBOT_PROJECT_ROOT"
        echo "📁 프로젝트 디렉토리: $LEROBOT_PROJECT_ROOT"
    else
        echo "❌ 프로젝트 디렉토리를 찾을 수 없습니다: $LEROBOT_PROJECT_ROOT"
        return 1
    fi
    
    # 가상환경 활성화
    if [ -f "$LEROBOT_VENV_DIR/bin/activate" ]; then
        source "$LEROBOT_VENV_DIR/bin/activate"
        echo "✅ 가상환경 활성화: $LEROBOT_VENV_DIR"
    else
        echo "❌ 가상환경을 찾을 수 없습니다: $LEROBOT_VENV_DIR"
        return 1
    fi
    
    # LeRobot 설치 확인
    if python -c "import lerobot" 2>/dev/null; then
        LEROBOT_VERSION=$(python -c "import lerobot; print(lerobot.__version__)" 2>/dev/null)
        echo "🚀 LeRobot $LEROBOT_VERSION 준비 완료!"
    else
        echo "⚠️  LeRobot이 설치되지 않았습니다. 설치를 진행하세요."
    fi
}

# -----------------------------------------------------------------------------
# 📚 LeRobot 유용한 별칭(Aliases) 정의
# -----------------------------------------------------------------------------
alias lr-activate='lerobot_activate'
alias lr-cd='cd $LEROBOT_PROJECT_ROOT'
alias lr-src='cd $LEROBOT_SOURCE_DIR'
alias lr-examples='cd $LEROBOT_SOURCE_DIR/examples'
alias lr-tutorial='cd $LEROBOT_SOURCE_DIR/examples/tutorial'
alias lr-training='cd $LEROBOT_SOURCE_DIR/examples/training'

# 환경 정보 확인
alias lr-info='echo "📊 LeRobot 환경 정보:"; echo "프로젝트: $LEROBOT_PROJECT_ROOT"; echo "소스: $LEROBOT_SOURCE_DIR"; echo "가상환경: $LEROBOT_VENV_DIR"; python -c "import lerobot; print(f\"버전: {lerobot.__version__}\")" 2>/dev/null || echo "LeRobot 미설치"'

# 빠른 학습 실행
alias lr-train-pusht='cd $LEROBOT_SOURCE_DIR/examples/training && python train_policy_한국어주석.py'
alias lr-train-act='cd $LEROBOT_SOURCE_DIR/examples/tutorial/act && python act_training_한국어주석.py'

# 가상환경 관리
alias lr-deactivate='deactivate'
alias lr-install='cd $LEROBOT_SOURCE_DIR && pip install -e .'
alias lr-install-pusht='cd $LEROBOT_SOURCE_DIR && pip install -e ".[pusht]"'

# -----------------------------------------------------------------------------
# 🔧 개발 도구 설정
# -----------------------------------------------------------------------------
# CUDA 경로 (NVIDIA GPU 사용 시)
if [ -d "/usr/local/cuda" ]; then
    export CUDA_HOME="/usr/local/cuda"
    export PATH="$CUDA_HOME/bin:$PATH"
    export LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"
fi

# Python 경로 최적화
export PYTHONPATH="$LEROBOT_SOURCE_DIR:$PYTHONPATH"

# -----------------------------------------------------------------------------
# 🚀 자동 시작 설정 (선택적)
# -----------------------------------------------------------------------------
# 주석을 해제하면 터미널 시작 시 자동으로 LeRobot 환경이 활성화됩니다
# lerobot_activate

# -----------------------------------------------------------------------------
# 🎨 LeRobot 프롬프트 사용자화
# -----------------------------------------------------------------------------
lerobot_prompt() {
    if [[ "$VIRTUAL_ENV" == *"lerobot"* ]] || [[ "$VIRTUAL_ENV" == *".venv"* ]]; then
        echo "🤖"
    fi
}

# 기존 PS1에 LeRobot 아이콘 추가 (선택적)
# export PS1="$(lerobot_prompt)$PS1"

# -----------------------------------------------------------------------------
# 📋 LeRobot 도움말 함수
# -----------------------------------------------------------------------------
lr-help() {
    echo "🤖 LeRobot 개발 환경 명령어 도움말"
    echo "=================================="
    echo ""
    echo "📁 디렉토리 이동:"
    echo "  lr-cd        : 프로젝트 루트로 이동"
    echo "  lr-src       : LeRobot 소스 디렉토리로 이동"  
    echo "  lr-examples  : 예제 디렉토리로 이동"
    echo "  lr-tutorial  : 튜토리얼 디렉토리로 이동"
    echo "  lr-training  : 학습 예제 디렉토리로 이동"
    echo ""
    echo "🚀 환경 관리:"
    echo "  lr-activate    : LeRobot 환경 활성화"
    echo "  lr-deactivate  : 가상환경 비활성화"
    echo "  lr-info        : 환경 정보 확인"
    echo ""
    echo "📦 설치 및 업데이트:"
    echo "  lr-install        : LeRobot 기본 설치"
    echo "  lr-install-pusht  : PushT 기능 포함 설치"
    echo ""
    echo "🎯 빠른 학습 실행:"
    echo "  lr-train-pusht : PushT Diffusion Policy 학습"
    echo "  lr-train-act   : ACT 정책 학습"
    echo ""
    echo "❓ 도움말:"
    echo "  lr-help : 이 도움말 표시"
    echo ""
    echo "💡 팁: 'lr-activate'로 환경을 활성화한 후 작업을 시작하세요!"
}

# -----------------------------------------------------------------------------
# 🎉 환경 설정 완료 메시지
# -----------------------------------------------------------------------------
echo "🤖 LeRobot 개발 환경 설정이 로드되었습니다!"
echo "💡 'lr-help' 명령어로 사용법을 확인하세요."
echo "🚀 'lr-activate' 명령어로 LeRobot 환경을 활성화하세요."