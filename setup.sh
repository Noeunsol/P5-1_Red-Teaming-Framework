#!/usr/bin/env bash
# Red-Teaming Framework 1회성 환경 세팅 스크립트
# - garak 0.15.0부터 openai>=2.0을 지원하면서 PyRIT와 의존성이 호환됨
# - 따라서 redteam 단일 env로 1_garak / 2_pyrit / 3_promptfoo 모두 실행
# - 각 env에 ipykernel만 설치하고 Jupyter 커널로 등록
# - 나머지 의존성(garak, pyrit, nodeenv, python-dotenv 등)은 각 노트북 첫 셀이 자동 설치

set -e

if ! command -v conda >/dev/null 2>&1; then
  echo "❌ conda 명령을 찾지 못했습니다. Anaconda/Miniconda를 먼저 설치하세요." >&2
  echo "   (각 노트북의 '0) Miniconda 설치' 섹션 참고)" >&2
  exit 1
fi

ENV_NAME="redteam"

echo "=== conda env '${ENV_NAME}' 생성 ==="

if conda env list | awk '{print $1}' | grep -qx "${ENV_NAME}"; then
  echo "ℹ️  '${ENV_NAME}' env가 이미 존재합니다 — 재생성을 건너뜁니다."
  echo "   완전히 새로 만들고 싶다면: conda env remove -n ${ENV_NAME} -y"
else
  conda create -n "${ENV_NAME}" python=3.11 -y
fi

echo ""
echo "[1/2] ipykernel 설치 중..."
conda run -n "${ENV_NAME}" pip install -q ipykernel

echo ""
echo "[2/2] Jupyter 커널 등록 중..."
conda run -n "${ENV_NAME}" python -m ipykernel install --user \
  --name "${ENV_NAME}" --display-name "${ENV_NAME}"

echo ""
echo "✅ 완료. VSCode에서 노트북을 열고 우상단 'Select Kernel'에서 '${ENV_NAME}' 를 선택하세요."
echo "   - 1_garak / 2_pyrit / 3_promptfoo 모두 동일한 '${ENV_NAME}' env에서 실행"
echo ""
echo "각 노트북의 첫 코드 셀이 그 env에 garak/pyrit/promptfoo 등 나머지 의존성을 자동 설치합니다."
