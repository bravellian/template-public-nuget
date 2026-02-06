#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)
ARTIFACTS_DIR="$REPO_ROOT/artifacts/codex"
REPORT="$ARTIFACTS_DIR/format-report.txt"
TARGET=${DOTNET_FORMAT_TARGET:-}
EXTRA_ARGS=("$@")

mkdir -p "$ARTIFACTS_DIR"

if [[ -z "$TARGET" ]]; then
  shopt -s nullglob
  slnx=("$REPO_ROOT"/*.slnx)
  sln=("$REPO_ROOT"/*.sln)
  shopt -u nullglob

  if [[ ${#slnx[@]} -gt 0 ]]; then
    TARGET="${slnx[0]}"
  elif [[ ${#sln[@]} -gt 0 ]]; then
    TARGET="${sln[0]}"
  else
    echo "No .slnx or .sln file found at repo root. Set DOTNET_FORMAT_TARGET explicitly." >&2
    exit 1
  fi
fi

if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
  ARGS_DISPLAY="${EXTRA_ARGS[*]}"
else
  ARGS_DISPLAY="(none)"
fi

{
  echo "dotnet format verification report"
  echo "Target: $TARGET"
  echo "Args: $ARGS_DISPLAY"
  echo
  echo "== dotnet format (verify-no-changes) =="
} > "$REPORT"

set +e
(dotnet format "$TARGET" --verify-no-changes "${EXTRA_ARGS[@]}") >> "$REPORT" 2>&1
FORMAT_STATUS=$?

{
  echo
  echo "== dotnet format analyzers (verify-no-changes) =="
} >> "$REPORT"

(dotnet format analyzers "$TARGET" --verify-no-changes "${EXTRA_ARGS[@]}") >> "$REPORT" 2>&1
ANALYZER_STATUS=$?
set -e

if [[ $FORMAT_STATUS -ne 0 || $ANALYZER_STATUS -ne 0 ]]; then
  echo "One or more checks failed. See $REPORT for details." >&2
  exit 1
fi

echo "All format/analyzer checks passed. Report: $REPORT"
