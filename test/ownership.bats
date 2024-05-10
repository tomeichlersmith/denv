#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
  denv init ubuntu:22.04
}

teardown() {
  clean_tmp_work
}

@test "whoami matches inside and outside denv" {
  run denv whoami
  assert_success
  assert_container_output "$(whoami)"
}

@test "file created inside denv has id match" {
  run denv touch file-from-denv
  # `-c` is the short for --format for GNU coreutils
  # `-f` is the equivalent for BSD
  # we can detect which stat we are using by testing
  # for the GNU flag
  format_flag="-c"
  if ! stat ${format_flag} > /dev/null 2>&1; then
    format_flag="-f"
  fi
  assert_equal "$(stat ${format_flag} %u file-from-denv)" "$(id -u ${USER})"
  assert_equal "$(stat ${format_flag} %g file-from-denv)" "$(id -g ${USER})"
}
