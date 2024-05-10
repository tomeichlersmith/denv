#!/usr/bin/env bats

setup_file() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
  denv init python
  cp ${OLDPWD}/test/internet-access.py .
}

setup() {
  load "test_helper/denv"
  common_setup
}

teardown_file() {
  clean_tmp_work
}

@test "we can connect a socket to a Google public DNS server" {
  run denv python3 internet-access.py
  assert_success
  refute_output
}

@test "we can disable network devices" {
  denv config network off
  run -1 denv python3 internet-access.py
  assert_output
}
