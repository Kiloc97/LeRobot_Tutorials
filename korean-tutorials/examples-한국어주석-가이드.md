# 📚 LeRobot 예제 코드 한국어 주석 가이드

## 🎯 생성된 한국어 주석 파일들

현재 examples 폴더의 주요 파일들에 상세한 한국어 주석을 추가했습니다:

### 1. **🏋️ 학습 예제들**

#### `train_policy_한국어주석.py` (PushT + Diffusion Policy)

```bash
cd lerobot/examples/training/
python train_policy_한국어주석.py
```

- **환경**: PushT 2D 블록 밀기 시뮬레이션
- **알고리즘**: Diffusion Policy (생성 모델 기반)
- **특징**: 노이즈에서 액션을 점진적으로 생성
- **학습 시간**: 약 10-20분 (5000 스텝)

#### `act_training_한국어주석.py` (실제 로봇 + ACT)

```bash
cd lerobot/examples/tutorial/act/
python act_training_한국어주석.py
```

- **환경**: SVLA SO-101 실제 로봇 데이터
- **알고리즘**: ACT (Action Chunking Transformer)
- **특징**: 한 번에 여러 액션 예측으로 부드러운 움직임
- **적용**: 실제 로봇 pick-and-place 작업

### 2. **🤖 실제 로봇 사용 예제**

#### `diffusion_using_간단버전_한국어주석.py`

```bash
cd lerobot/examples/tutorial/diffusion/
python diffusion_using_간단버전_한국어주석.py
```

- **목적**: 학습된 모델로 실제 로봇 제어
- **구성**: 카메라 설정, 로봇 연결, 실시간 추론
- **안전**: 에피소드/스텝 제한, 비상 정지 고려

---

## 🔍 각 파일의 주요 학습 포인트

### 📖 공통 구조 (모든 예제)

```python
# 1. 환경 설정 (장치, 디렉토리)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
output_directory = Path("outputs/...")

# 2. 데이터셋 메타정보 로드
dataset_metadata = LeRobotDatasetMetadata("dataset_name")
features = dataset_to_policy_features(dataset_metadata.features)

# 3. 정책 설정 및 초기화
config = PolicyConfig(input_features=..., output_features=...)
policy = PolicyClass(config)

# 4. 데이터 처리기 설정
preprocessor, postprocessor = make_pre_post_processors(...)

# 5. 시간적 데이터 구성
delta_timestamps = {...}  # 어떤 시점의 데이터를 사용할지

# 6. 데이터셋 로딩
dataset = LeRobotDataset(dataset_id, delta_timestamps=delta_timestamps)

# 7. 학습 루프
for batch in dataloader:
    batch = preprocessor(batch)
    loss, _ = policy.forward(batch)
    loss.backward()
    optimizer.step()
```

### 🧠 알고리즘별 특징

#### **Diffusion Policy**

- **핵심 아이디어**: 노이즈 → 액션 생성
- **장점**: 복잡한 멀티모달 액션 분포 학습 가능
- **시간 설정**: 과거 관찰 + 미래 액션 시퀀스
- **적용 분야**: 복잡한 조작 작업, 불확실한 환경

#### **ACT (Action Chunking Transformer)**

- **핵심 아이디어**: 액션 청킹으로 부드러운 움직임
- **장점**: 시간적 일관성, 실제 로봇에서 검증됨
- **시간 설정**: 현재 관찰 → 미래 여러 액션 예측
- **적용 분야**: 정밀 조작, 실제 로봇 제어

---

## 🚀 실행 순서 권장사항

### 1단계: 기본 이해 (시뮬레이션)

```bash
# PushT 환경에서 빠른 실험
cd lerobot/examples/training/
python train_policy_한국어주석.py
```

### 2단계: 실제 로봇 데이터 학습

```bash
# 실제 로봇 데이터로 학습
cd lerobot/examples/tutorial/act/
python act_training_한국어주석.py
```

### 3단계: 실제 로봇 제어 (하드웨어 필요)

```bash
# 학습된 모델로 실제 로봇 제어
cd lerobot/examples/tutorial/diffusion/
python diffusion_using_간단버전_한국어주석.py
```

---

## 💡 핵심 개념 설명

### 🕐 Delta Timestamps

각 알고리즘이 어떤 시점의 데이터를 사용하는지 정의:

```python
delta_timestamps = {
    "observation.image": [-0.1, 0.0],        # 과거 1프레임 + 현재
    "action": [0.0, 0.1, 0.2, ..., 1.5]      # 현재부터 미래 15프레임
}
```

### 🔄 전처리/후처리

```python
# 전처리: 원시 데이터 → 모델 입력 (정규화 등)
preprocessor = make_preprocessor(dataset_stats)
batch = preprocessor(raw_batch)

# 후처리: 모델 출력 → 실제 액션 (비정규화 등)
postprocessor = make_postprocessor(dataset_stats)
action = postprocessor(model_output)
```

### 🎯 Action Chunking (ACT)

한 번에 여러 액션을 예측하여 시간적 일관성 확보:

```python
# 일반적인 방법: 한 번에 하나씩
action_t = policy(observation_t)

# ACT 방법: 한 번에 여러 개
actions_t_to_t+k = act_policy(observation_t)  # k개 액션 예측
```

---

## ⚠️ 실제 사용 시 주의사항

### 🤖 실제 로봇 제어

1. **안전 우선**: 비상 정지, 작업 공간 확보
2. **단계적 접근**: 시뮬레이션 → 느린 속도 → 정상 속도
3. **모니터링**: 로봇 상태, 카메라 피드 실시간 확인

### 📷 카메라 설정

```python
# 학습 시와 정확히 같아야 함!
camera_config = {
    "side": OpenCVCameraConfig(width=640, height=480),  # 해상도 일치
    "up": OpenCVCameraConfig(width=640, height=480),
}
```

### 🔧 하드웨어 요구사항

- **로봇**: 칼리브레이션된 로봇 팔 (SO-100 등)
- **카메라**: 2대 이상의 USB 카메라
- **연결**: USB 시리얼 포트 (`lerobot-find-port`로 확인)
- **환경**: 안전한 작업 공간

---

## 📈 성능 향상 팁

### 1. **데이터 품질**

- 다양한 상황의 데이터 수집
- 일관된 카메라 각도와 조명
- 충분한 양의 성공 사례

### 2. **모델 튜닝**

- 학습률 조정 (1e-4 → 1e-5)
- 배치 크기 최적화
- 정규화 기법 적용

### 3. **실시간 성능**

- GPU 사용 (`device="cuda"`)
- 배치 추론 활용
- 모델 경량화 고려

---

## 🎓 다음 학습 단계

1. **알고리즘 비교**: Diffusion vs ACT vs 다른 방법들
2. **전이 학습**: 다른 로봇이나 작업으로 확장
3. **멀티모달**: 언어 명령과 로봇 제어 결합
4. **강화 학습**: 환경과의 상호작용을 통한 개선

각 파일의 주석을 따라가며 단계별로 학습하시면 LeRobot의 전체 워크플로우를 이해할 수 있습니다! 🚀
