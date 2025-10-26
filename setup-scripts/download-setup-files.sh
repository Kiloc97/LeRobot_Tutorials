#!/bin/bash

# LeRobot 환경 설정 파일 다운로드 스크립트
# 사용법: ./download-setup-files.sh

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

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# GitHub 저장소 URL
REPO_URL="https://raw.githubusercontent.com/Kiloc97/LeRobot_Tutorials/main"

# 다운로드할 파일 목록 (폴더 구조 반영)
FILES=(
    "setup-scripts/auto-setup.sh:자동 설치 스크립트"
    "setup-scripts/lerobot-bashrc-config.sh:Bashrc 자동 설정"
    "docker/run-docker.sh:Docker 실행 스크립트"
    "docker/Dockerfile:Docker 설정 파일"
    "docker/Dockerfile.cpu:CPU 전용 Docker 파일"
    "docker/docker-compose.yml:Docker Compose 설정"
    "docs/Complete_Setup_Guide.md:완전 설정 가이드"
    "docs/Docker_Setup_Guide.md:Docker 설정 가이드"
    "docs/lerobot-file-structure-guide.md:파일 구조 가이드"
    "korean-tutorials/examples-한국어주석-가이드.md:한국어 예제 가이드"
    "korean-tutorials/lerobot-환경설정-완료.md:환경설정 완료 가이드"
)

# 파일 다운로드 함수
download_file() {
    local file_path=$1
    local description=$2
    local url="${REPO_URL}/${file_path}"
    local local_file=$(basename "$file_path")
    local local_dir=$(dirname "$file_path")
    
    # 필요한 디렉토리 생성
    if [[ "$local_dir" != "." ]]; then
        mkdir -p "$local_dir"
    fi
    
    log_info "다운로드 중: ${description} (${file_path})"
    
    if curl -fsSL "$url" -o "$file_path"; then
        log_success "${file_path} 다운로드 완료"
        
        # 실행 파일인 경우 권한 부여
        if [[ "$file_path" == *.sh ]]; then
            chmod +x "$file_path"
            log_info "${file_path}에 실행 권한 부여됨"
        fi
    else
        log_error "${file_path} 다운로드 실패"
        return 1
    fi
}

# 메인 함수
main() {
    log_info "LeRobot 환경 설정 파일 다운로드를 시작합니다..."
    echo
    
    # 현재 디렉토리 확인
    log_info "현재 디렉토리: $(pwd)"
    echo
    
    # 다운로드 진행
    local success_count=0
    local total_count=${#FILES[@]}
    
    for item in "${FILES[@]}"; do
        IFS=':' read -r file_path description <<< "$item"
        
        if download_file "$file_path" "$description"; then
            ((success_count++))
        fi
        echo
    done
    
    # 결과 요약
    echo "=================================================="
    log_success "다운로드 완료: ${success_count}/${total_count} 파일"
    
    if [[ $success_count -eq $total_count ]]; then
        echo
        log_success "모든 파일이 성공적으로 다운로드되었습니다!"
        echo
        log_info "다음 단계:"
        echo "1. 자동 설치: ./setup-scripts/auto-setup.sh"
        echo "2. Docker 환경: ./docker/run-docker.sh gpu"
        echo "3. 설정 가이드: cat docs/Complete_Setup_Guide.md"
    else
        log_error "일부 파일 다운로드에 실패했습니다."
        echo "수동으로 다시 시도하거나 네트워크 연결을 확인하세요."
    fi
}

# 도움말
show_help() {
    echo "LeRobot 환경 설정 파일 다운로드 스크립트"
    echo
    echo "이 스크립트는 LeRobot 개발 환경 구성에 필요한 모든 파일을 다운로드합니다."
    echo
    echo "사용법:"
    echo "  $0              # 모든 설정 파일 다운로드"
    echo "  $0 --help       # 도움말 표시"
    echo
    echo "다운로드되는 파일:"
    for item in "${FILES[@]}"; do
        IFS=':' read -r file_path description <<< "$item"
        echo "  - $file_path: $description"
    done
    echo
    echo "참고:"
    echo "- 인터넷 연결이 필요합니다"
    echo "- 현재 디렉토리에 파일이 저장됩니다"
    echo "- 실행 스크립트(.sh)에는 자동으로 실행 권한이 부여됩니다"
}

# 스크립트 실행
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
else
    main
fi