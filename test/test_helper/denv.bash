#!/usr/bin/env bash

common_setup() {
  load "test_helper/bats-support/load"
  load "test_helper/bats-assert/load"
  load "test_helper/bats-file/load"

  # disable prompt for these non-interactive tests
  export DENV_NOPROMPT=1

  # TODO use denv that is in code source directory
}

go_to_tmp_work() {
  working="$(mktemp -d)"
  cd "${working}"
}

go_to_tmp_denv() {
  go_to_tmp_work
  denv init ubuntu:22.04
}

clean_tmp_work() {
  cd
  rm -r "${working}"
}

# we need to wrap assert_output because the output
# gathered from a container runner after running the
# container may include an extra carriage return we
# should strip
assert_container_output() {
  # update the global variable used by bats
  output="$(echo "${output}" | tr -d '\r')"
  # call the normal bats assertion
  assert_output $@
}
