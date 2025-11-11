#!/usr/bin/env bash
set -euo pipefail

VENV_DIR=".venv"
declare -a PYTHON_CMD=()

choose_python() {
  if [ -n "${PYTHON_BIN:-}" ]; then
    if command -v "$PYTHON_BIN" >/dev/null 2>&1; then
      PYTHON_CMD=("$PYTHON_BIN")
      return
    fi
    if [ -x "$PYTHON_BIN" ]; then
      PYTHON_CMD=("$PYTHON_BIN")
      return
    fi
  fi

  if command -v py >/dev/null 2>&1; then
    if py -3 -c "import sys" >/dev/null 2>&1; then
      PYTHON_CMD=("py" "-3")
      return
    fi
    PYTHON_CMD=("py")
    return
  fi

  for candidate in python3 python python.exe; do
    if command -v "$candidate" >/dev/null 2>&1; then
      PYTHON_CMD=("$candidate")
      return
    fi
  done

  if command -v where >/dev/null 2>&1; then
    local path
    path="$( (where python 2>/dev/null || true) | tr -d '\r' | head -n 1 )"
    if [ -n "$path" ] && [ -x "$path" ]; then
      PYTHON_CMD=("$path")
      return
    fi
  fi

  echo "Python executable not found. Install Python or set PYTHON_BIN to a valid interpreter path." >&2
  exit 1
}

choose_python

if [ ! -d "$VENV_DIR" ]; then
  "${PYTHON_CMD[@]}" -m venv "$VENV_DIR"
fi

if [ -f "$VENV_DIR/Scripts/activate" ]; then
  # Windows virtualenv layout
  # shellcheck disable=SC1091
  source "$VENV_DIR/Scripts/activate"
elif [ -f "$VENV_DIR/bin/activate" ]; then
  # POSIX virtualenv layout
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
else
  echo "Unable to locate activation script inside $VENV_DIR." >&2
  exit 1
fi

REQ_FILE="${1:-requirements.txt}"
if [ -f "$REQ_FILE" ]; then
  python -m pip install -r "$REQ_FILE"
else
  echo "No requirements file at $REQ_FILE. Skipping dependency installation."
fi
