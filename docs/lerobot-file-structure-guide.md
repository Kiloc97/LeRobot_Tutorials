# LeRobot 튜토리얼 파일 구성 📁

## 📂 전체 프로젝트 구조

```
LeRobot_Tutorials/
├── 📁 .git/                           # Git 버전 관리
├── 📁 .venv/                          # Python 가상환경
├── 📁 .vscode/                        # VS Code 설정
├── 📁 lerobot/                        # LeRobot 메인 소스코드 (서브모듈)
├── 📄 .gitignore                      # Git 제외 파일 목록
├── 📄 README.md                       # 프로젝트 개요
├── 📄 vscode-sync-guide.md           # VS Code 동기화 가이드
└── 📄 vscode-builtin-sync-guide.md   # VS Code 내장 동기화 가이드
```

---

## 🤖 LeRobot 서브모듈 구조 (`lerobot/`)

### 📋 설정 및 문서 파일

```
lerobot/
├── 📄 README.md                      # LeRobot 메인 문서
├── 📄 LICENSE                        # 라이선스 (Apache 2.0)
├── 📄 CONTRIBUTING.md                # 기여 가이드라인
├── 📄 CODE_OF_CONDUCT.md             # 행동 규칙
├── 📄 pyproject.toml                 # Python 프로젝트 설정
├── 📄 requirements-ubuntu.txt        # Ubuntu 의존성
├── 📄 requirements-macos.txt         # macOS 의존성
├── 📄 requirements.in                # 기본 의존성
└── 📄 Makefile                       # 빌드 스크립트
```

### 🏗️ 개발 환경 설정

```
├── 📄 .dockerignore                  # Docker 제외 파일
├── 📄 .gitignore                     # Git 제외 파일
├── 📄 .pre-commit-config.yaml        # 코드 품질 검사
├── 📁 .github/                       # GitHub Actions CI/CD
├── 📁 docker/                        # Docker 컨테이너 설정
└── 📁 docs/                          # 문서화
```

---

## 🧠 핵심 소스 코드 (`src/lerobot/`)

### 🔧 주요 모듈들

```
src/lerobot/
├── 📁 configs/                       # 설정 파일들
│   ├── default.py                   # 기본 설정
│   ├── eval.py                      # 평가 설정
│   └── train.py                     # 학습 설정
│
├── 📁 common/                        # 공통 유틸리티
│   ├── datasets/                    # 데이터셋 처리
│   ├── policies/                    # 정책 네트워크
│   ├── robot_devices/               # 로봇 하드웨어
│   └── utils/                       # 헬퍼 함수들
│
├── 📁 cameras/                       # 카메라 시스템
│   ├── opencv/                      # OpenCV 카메라
│   ├── realsense/                   # Intel RealSense
│   └── reachy2_camera/              # Reachy2 로봇 카메라
│
├── 📁 robots/                        # 로봇 제어
│   ├── manipulator/                 # 매니퓰레이터
│   └── mobile/                      # 모바일 로봇
│
└── 📁 async_inference/               # 비동기 추론
    ├── policy_server.py             # 정책 서버
    └── robot_client.py              # 로봇 클라이언트
```

---

## 📚 예제 및 튜토리얼 (`examples/`)

### 🎓 학습 자료

```
examples/
├── 📁 tutorial/                      # 알고리즘별 튜토리얼
│   ├── 📁 act/                      # ACT (Action Chunking Transformer)
│   ├── 📁 diffusion/                # Diffusion Policy
│   ├── 📁 pi0/                      # Pi0 (Pico-scale Imitation)
│   ├── 📁 smolvla/                  # Small Vision-Language-Action
│   ├── 📁 async-inf/                # 비동기 추론
│   └── 📁 rl/                       # 강화학습
│
├── 📁 training/                      # 실제 학습 스크립트
│   ├── train_policy.py              # 메인 정책 학습 (PushT 예제)
│   └── train_with_streaming.py      # 스트리밍 학습
│
├── 📁 dataset/                       # 데이터셋 예제
│   ├── record_episode.py            # 에피소드 기록
│   ├── visualize_dataset.py         # 데이터 시각화
│   └── convert_dataset.py           # 데이터 변환
│
└── 📁 lekiwi/                        # LeKiwi 로봇 예제
    ├── record.py                    # 데이터 수집
    └── replay.py                    # 정책 재생
```

### 🔄 하드웨어 통합 예제

```
├── 📁 phone_to_so100/                # 휴대폰 → SO-100 로봇
├── 📁 so100_to_so100_EE/             # SO-100 간 전이학습
├── 📁 port_datasets/                 # 데이터셋 포팅
└── 📁 backward_compatibility/         # 하위 호환성
```

---

## 🧪 테스트 및 벤치마크

### 🔍 품질 보증

```
├── 📁 tests/                         # 단위 테스트
│   ├── test_cameras.py              # 카메라 테스트
│   ├── test_datasets.py             # 데이터셋 테스트
│   ├── test_policies.py             # 정책 테스트
│   └── test_robots.py               # 로봇 테스트
│
└── 📁 benchmarks/                    # 성능 벤치마크
    ├── benchmark_inference.py       # 추론 속도
    └── benchmark_training.py        # 학습 속도
```

---

## 📖 문서화 (`docs/`)

### 📝 사용자 가이드

```
docs/
├── 📁 concepts/                      # 핵심 개념
├── 📁 getting_started/               # 시작 가이드
├── 📁 tutorials/                     # 상세 튜토리얼
├── 📁 api_reference/                 # API 문서
└── 📁 examples/                      # 예제 갤러리
```

---

## 🚀 시작하기 권장 순서

### 1️⃣ 환경 설정 확인

```bash
# 가상환경 활성화
source .venv/bin/activate

# LeRobot 설치 확인
python -c "import lerobot; print('LeRobot 버전:', lerobot.__version__)"
```

### 2️⃣ 기본 튜토리얼 실행

```bash
cd lerobot/examples/training/
python train_policy.py          # PushT 환경에서 Diffusion Policy 학습

# 알고리즘별 튜토리얼 탐색
cd lerobot/examples/tutorial/
ls -la */                       # ACT, Diffusion, Pi0, SmolVLA 등 확인
```

### 3️⃣ 데이터셋 다운로드 및 실험

```bash
cd lerobot/examples/dataset/
python visualize_dataset.py    # 데이터 시각화
python record_episode.py       # 새 데이터 수집
```

### 4️⃣ 고급 학습 실험

```bash
cd lerobot/examples/training/
python train_act.py            # ACT 모델
python train_diffusion.py      # Diffusion 모델
```

---

## 💡 주요 파일별 역할

| 파일/폴더            | 용도                 | 중요도 |
| -------------------- | -------------------- | ------ |
| `src/lerobot/`       | 핵심 라이브러리 코드 | ⭐⭐⭐ |
| `examples/tutorial/` | 기본 사용법 학습     | ⭐⭐⭐ |
| `examples/training/` | 모델 학습 예제       | ⭐⭐⭐ |
| `pyproject.toml`     | 프로젝트 설정        | ⭐⭐   |
| `README.md`          | 프로젝트 개요        | ⭐⭐   |
| `tests/`             | 코드 검증            | ⭐     |
| `benchmarks/`        | 성능 측정            | ⭐     |

이 구조를 통해 LeRobot의 전체적인 아키텍처를 이해하고 단계별로 학습할 수 있습니다! 🎯
