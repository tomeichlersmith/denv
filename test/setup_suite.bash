#!/usr/bin/env bash
# setup entire test suite for bats

setup_suite() {
  bats_require_minimum_version 1.5.0
  if [ -z "${DENV_RUNNER:-}" ]; then
    echo "DENV_RUNNER is required to be defined for testing."
    exit 1
  fi

  repo_dir="$(cd "$(dirname "${BATS_TEST_FILENAME}")/../" > /dev/null 2>&1 && pwd)"
  export PATH="${repo_dir}:${PATH}"
}
