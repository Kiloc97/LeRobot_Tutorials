# Documentation 📚

LeRobot 개발 환경 구성을 위한 상세 문서 모음입니다.

## 포함된 문서

### 🎯 Complete_Setup_Guide.md

**종합 설정 가이드** - 새로운 컴퓨터에서 LeRobot 환경을 구성하는 모든 방법을 포함

**다루는 내용:**

- 3가지 설치 방법 비교 (자동화/Docker/수동)
- 환경별 최적화 설정 (Windows/macOS/Linux)
- 설치 후 검증 및 문제 해결
- 성능 최적화 팁

**대상 독자:**

- LeRobot을 처음 사용하는 사용자
- 새로운 컴퓨터에 환경을 구성하려는 사용자
- 다양한 설치 옵션을 비교하고 싶은 사용자

### 🐳 Docker_Setup_Guide.md

**Docker 설정 가이드** - Docker를 사용한 환경 구성 전문 가이드

**다루는 내용:**

- Docker 설치 및 설정
- GPU 지원 환경 구성
- 컨테이너 관리 및 사용법
- 볼륨 마운트 및 데이터 관리
- 성능 튜닝 및 문제 해결

**대상 독자:**

- Docker 기반 개발 환경을 선호하는 사용자
- 격리된 환경에서 작업하려는 사용자
- 시스템 의존성 문제를 피하고 싶은 사용자

### 🗂️ lerobot-file-structure-guide.md

**LeRobot 파일 구조 가이드** - LeRobot 프로젝트의 디렉토리 구조 상세 설명

**다루는 내용:**

- 전체 프로젝트 구조 개요
- 각 디렉토리의 역할과 목적
- 주요 파일들의 기능 설명
- 커스터마이징 포인트 안내

**대상 독자:**

- LeRobot 내부 구조를 이해하고 싶은 개발자
- 코드를 수정하거나 확장하려는 사용자
- 문제 해결을 위해 구조를 파악해야 하는 사용자

## 문서 사용 가이드

### 📖 읽는 순서 (추천)

#### 초보자

1. **Complete_Setup_Guide.md** - 전체 개요 파악
2. **Docker_Setup_Guide.md** - 안전한 환경 구성 (권장)
3. **lerobot-file-structure-guide.md** - 구조 이해

#### 중급자

1. **lerobot-file-structure-guide.md** - 구조 파악
2. **Complete_Setup_Guide.md** - 필요한 부분만 선택적 참고
3. **Docker_Setup_Guide.md** - 고급 설정 참고

#### 고급자

- 필요한 부분만 선택적으로 참고
- 문제 해결 섹션 중점 활용

### 🔍 빠른 참조

#### 설치 문제 해결

- **Complete_Setup_Guide.md** → "문제 해결 가이드" 섹션

#### Docker 관련 문제

- **Docker_Setup_Guide.md** → "문제 해결" 섹션

#### 파일 위치 찾기

- **lerobot-file-structure-guide.md** → 해당 디렉토리 설명

#### 성능 최적화

- **Complete_Setup_Guide.md** → "환경별 최적화 설정"
- **Docker_Setup_Guide.md** → "성능 최적화"

### 📝 문서 업데이트

이 문서들은 LeRobot의 업데이트와 함께 지속적으로 개선됩니다.

**최신 버전 확인:**

```bash
git pull origin main
```

**피드백 및 개선사항:**

- GitHub Issues를 통한 문제 보고
- Pull Request를 통한 개선사항 제안
- 실제 사용 경험을 바탕으로 한 업데이트

### 🎯 각 문서의 특징

| 문서                            | 길이 | 난이도 | 업데이트 빈도 | 주요 사용 시점 |
| ------------------------------- | ---- | ------ | ------------- | -------------- |
| Complete_Setup_Guide.md         | 상   | 하     | 높음          | 최초 설치시    |
| Docker_Setup_Guide.md           | 중   | 중     | 중간          | Docker 사용시  |
| lerobot-file-structure-guide.md | 중   | 중     | 낮음          | 개발 시작시    |

### 💡 활용 팁

#### 1. 오프라인 사용

모든 문서는 마크다운 형태로 제공되어 인터넷 연결 없이도 읽을 수 있습니다.

#### 2. 검색 활용

각 문서 내에서 `Ctrl+F`로 키워드 검색을 활용하세요.

#### 3. 북마크 활용

자주 참고하는 섹션은 브라우저 북마크나 에디터 북마크를 활용하세요.

#### 4. 인쇄용 버전

필요시 각 문서를 PDF로 변환하여 인쇄할 수 있습니다.

### 🔗 관련 링크

- [LeRobot 공식 문서](https://huggingface.co/docs/lerobot)
- [GitHub 저장소](https://github.com/huggingface/lerobot)
- [커뮤니티 토론](https://huggingface.co/lerobot-community)

이 문서들은 실제 사용 경험을 바탕으로 작성되었으며, 새로운 사용자가 빠르게 LeRobot 개발을 시작할 수 있도록 돕는 것을 목표로 합니다.
