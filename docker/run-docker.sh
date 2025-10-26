#!/bin/bash

# LeRobot Docker 환경 자동 실행 스크립트
# 사용법: ./run-docker.sh [gpu|cpu|stop|clean]

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 로깅 함수
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

# Docker 설치 확인
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker가 설치되어 있지 않습니다. 설치 후 다시 시도하세요."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker 데몬이 실행되고 있지 않습니다. Docker를 시작하세요."
        exit 1
    fi
    
    log_success "Docker 확인 완료"
}

# Docker Compose 설치 확인
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose가 설치되어 있지 않습니다. 설치 후 다시 시도하세요."
        exit 1
    fi
    
    log_success "Docker Compose 확인 완료"
}

# GPU 지원 확인
check_gpu_support() {
    if command -v nvidia-smi &> /dev/null; then
        if nvidia-smi &> /dev/null; then
            log_success "NVIDIA GPU 감지됨"
            return 0
        else
            log_warning "nvidia-smi는 있지만 GPU에 접근할 수 없습니다"
        fi
    else
        log_warning "NVIDIA GPU 드라이버가 설치되어 있지 않습니다"
    fi
    
    # NVIDIA Container Runtime 확인
    if docker info 2>/dev/null | grep -q nvidia; then
        log_success "NVIDIA Container Runtime 확인됨"
        return 0
    else
        log_warning "NVIDIA Container Runtime이 설치되어 있지 않습니다"
        return 1
    fi
}

# 필요한 디렉토리 생성
create_directories() {
    log_info "필요한 디렉토리 생성 중..."
    mkdir -p data outputs
    mkdir -p data/.cache/huggingface
    mkdir -p outputs/wandb
    mkdir -p outputs/logs
    log_success "디렉토리 생성 완료"
}

# GPU 환경 실행
run_gpu() {
    log_info "GPU 지원 LeRobot 환경 실행 중..."
    
    if ! check_gpu_support; then
        log_error "GPU 지원을 사용할 수 없습니다. CPU 버전을 실행하시겠습니까? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            run_cpu
            return
        else
            exit 1
        fi
    fi
    
    create_directories
    
    # GPU 프로파일로 실행
    docker-compose --profile gpu up -d --build
    
    log_success "GPU 환경이 실행되었습니다!"
    log_info "컨테이너에 접속하려면: docker exec -it lerobot-dev bash"
    log_info "Jupyter Notebook: http://localhost:8888"
    log_info "TensorBoard: http://localhost:6006"
}

# CPU 환경 실행
run_cpu() {
    log_info "CPU 전용 LeRobot 환경 실행 중..."
    
    create_directories
    
    # CPU 프로파일로 실행
    docker-compose --profile cpu up -d --build
    
    log_success "CPU 환경이 실행되었습니다!"
    log_info "컨테이너에 접속하려면: docker exec -it lerobot-cpu-dev bash"
    log_info "Jupyter Notebook: http://localhost:8889"
    log_info "TensorBoard: http://localhost:6007"
}

# 환경 중지
stop_containers() {
    log_info "LeRobot 컨테이너 중지 중..."
    docker-compose down
    log_success "모든 컨테이너가 중지되었습니다"
}

# 환경 정리
clean_environment() {
    log_warning "이 작업은 모든 LeRobot Docker 이미지와 컨테이너를 삭제합니다"
    echo "계속하시겠습니까? (y/N)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        log_info "환경 정리 중..."
        
        # 컨테이너 중지 및 삭제
        docker-compose down --rmi all --volumes --remove-orphans 2>/dev/null || true
        
        # 관련 이미지 삭제
        docker images | grep -E "(lerobot|nvidia)" | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || true
        
        # 사용하지 않는 리소스 정리
        docker system prune -f
        
        log_success "환경 정리 완료"
    else
        log_info "취소되었습니다"
    fi
}

# 상태 확인
show_status() {
    log_info "LeRobot Docker 환경 상태:"
    echo
    
    # 실행 중인 컨테이너 확인
    if docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -q lerobot; then
        log_success "실행 중인 LeRobot 컨테이너:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep lerobot
        echo
        
        # 리소스 사용량 표시
        log_info "리소스 사용량:"
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" $(docker ps -q --filter "name=lerobot")
    else
        log_warning "실행 중인 LeRobot 컨테이너가 없습니다"
    fi
    
    echo
    
    # 디스크 사용량 확인
    log_info "Docker 디스크 사용량:"
    docker system df
}

# 도움말 표시
show_help() {
    echo "LeRobot Docker 환경 관리 스크립트"
    echo
    echo "사용법: $0 [옵션]"
    echo
    echo "옵션:"
    echo "  gpu     - GPU 지원 환경 실행 (기본값)"
    echo "  cpu     - CPU 전용 환경 실행"
    echo "  stop    - 모든 컨테이너 중지"
    echo "  clean   - 환경 정리 (이미지 및 컨테이너 삭제)"
    echo "  status  - 현재 상태 확인"
    echo "  help    - 이 도움말 표시"
    echo
    echo "예제:"
    echo "  $0 gpu          # GPU 환경 실행"
    echo "  $0 cpu          # CPU 환경 실행"
    echo "  $0 stop         # 환경 중지"
    echo "  $0 clean        # 환경 정리"
}

# 메인 실행 로직
main() {
    # 기본 확인
    check_docker
    check_docker_compose
    
    # 명령어 처리
    case "${1:-gpu}" in
        "gpu")
            run_gpu
            ;;
        "cpu")
            run_cpu
            ;;
        "stop")
            stop_containers
            ;;
        "clean")
            clean_environment
            ;;
        "status")
            show_status
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            log_error "알 수 없는 옵션: $1"
            show_help
            exit 1
            ;;
    esac
}

# 스크립트 실행
main "$@"