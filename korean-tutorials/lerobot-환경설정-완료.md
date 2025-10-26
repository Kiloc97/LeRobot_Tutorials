# 🤖 LeRobot 자동 환경 구성 완료!

## ✅ 설정된 기능들

### 📋 새로 추가된 명령어들

```bash
# 환경 관리
lr-activate     # LeRobot 환경 활성화
lr-deactivate   # 가상환경 비활성화
lr-info         # 환경 정보 확인
lr-help         # 도움말 표시

# 디렉토리 이동
lr-cd           # 프로젝트 루트로 이동
lr-src          # LeRobot 소스로 이동
lr-examples     # 예제 폴더로 이동
lr-tutorial     # 튜토리얼 폴더로 이동
lr-training     # 학습 예제로 이동

# 빠른 실행
lr-train-pusht  # PushT 학습 시작
lr-train-act    # ACT 학습 시작

# 설치 관리
lr-install      # LeRobot 재설치
lr-install-pusht # PushT 기능 설치
```

## 🚀 사용법

### 1. 새 터미널에서 바로 시작

```bash
# 터미널 열기 → 자동으로 LeRobot 설정 로드됨
lr-activate  # 환경 활성화
lr-info      # 설정 확인
```

### 2. 빠른 학습 실행

```bash
lr-activate           # 환경 활성화
lr-train-pusht        # PushT 학습 바로 시작
```

### 3. 개발 작업

```bash
lr-activate           # 환경 활성화
lr-examples          # 예제 폴더로 이동
code .               # VS Code에서 열기
```

## ⚙️ 자동 활성화 설정 (선택사항)

터미널을 열 때마다 자동으로 LeRobot 환경을 활성화하려면:

1. **bashrc 편집**:

```bash
nano ~/.bashrc
```

2. **파일 끝에서 다음 줄을 찾아서**:

```bash
# lerobot_activate
```

3. **주석을 제거**:

```bash
lerobot_activate
```

이렇게 하면 터미널을 열 때마다 자동으로 LeRobot 환경이 활성화됩니다.

## 🔧 환경 변수 설정

다음 환경 변수들이 자동으로 설정됩니다:

```bash
LEROBOT_PROJECT_ROOT="/mnt/c/Programming/LeRobot_Tutorials"
LEROBOT_SOURCE_DIR="$LEROBOT_PROJECT_ROOT/lerobot"
LEROBOT_VENV_DIR="$LEROBOT_PROJECT_ROOT/.venv"
```

## 💡 유용한 팁

### 빠른 작업 시작

```bash
# 한 번에 환경 활성화 + 학습 시작
lr-activate && lr-train-pusht
```

### 여러 터미널 창 사용

```bash
# 터미널 1: 학습
lr-activate && lr-train-pusht

# 터미널 2: 코드 편집
lr-activate && lr-src && code .

# 터미널 3: 모니터링
lr-activate && watch -n 1 nvidia-smi
```

### 환경 문제 해결

```bash
lr-info                    # 현재 상태 확인
lr-install                 # 재설치
source ~/.bashrc          # 설정 다시 로드
```

## 🆘 문제 해결

### 환경이 활성화되지 않는 경우

```bash
# 1. 경로 확인
ls -la /mnt/c/Programming/LeRobot_Tutorials/.venv/

# 2. 수동 활성화
source /mnt/c/Programming/LeRobot_Tutorials/.venv/bin/activate

# 3. bashrc 다시 로드
source ~/.bashrc
```

### 명령어가 작동하지 않는 경우

```bash
# 1. 새 터미널 열기
# 2. bashrc 다시 적용
source ~/.bashrc

# 3. 도움말 확인
lr-help
```

## 📝 백업된 파일

원본 `.bashrc` 파일은 다음 위치에 백업되었습니다:

```bash
~/.bashrc.backup.YYYYMMDD_HHMMSS
```

필요시 복원할 수 있습니다:

```bash
cp ~/.bashrc.backup.YYYYMMDD_HHMMSS ~/.bashrc
```

## 🎯 다음 단계

1. **`lr-activate`로 환경 활성화**
2. **`lr-train-pusht`로 첫 학습 시작**
3. **`lr-examples`에서 다른 예제들 탐색**
4. **VS Code와 연동하여 개발 시작**

이제 터미널에서 LeRobot 작업이 훨씬 편리해졌습니다! 🚀
