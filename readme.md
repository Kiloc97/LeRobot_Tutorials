vscode + wsl 환경 

Install LeRobot 🤗
git clone https://github.com/huggingface/lerobot.git
cd lerobot

pip install -e .

#오류 발생 해결 방법
원인: wsl 환경에 pip 미설치
sudo apt install python3-pip
가상 환경 생성
sudo apt install python3-venv
가상 환경 활성화 및 패키지 설치
python3 -m venv lerobot_env
source lerobot_env/bin/activate
pip install -e .

Installation from PyPI(Python Package Index)
lerobot 개발에 필요한 필수 패키지 설치
pip install lerobot

pip install 'lerobot[all]'          # 모든 사용 가능한 기능
pip install 'lerobot[aloha,pusht]'  # 특정기능 (Aloha & Pusht)
pip install 'lerobot[feetech]'      # 피트테크 모터 지원
pip install 'lerobot[...]'          # ... 원하는 기능으로

전체 기능 목록 참고 사이트 
https://pypi.org/project/lerobot/

Lerobot 0.4.0의 경우, 리베로 또는 파이를 설치하려면 다음을 수행해
pip install "lerobot[pi,libero]@git+https://github.com/huggingface/lerobot.git"

