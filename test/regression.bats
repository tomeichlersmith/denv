#!/usr/bin/env bats

setup_file() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
  wget -q -O - \
    https://github.com/tomeichlersmith/denv/archive/refs/tags/v1.0.0.tar.gz |\
    tar xzf -
  # use whatever default choice is determined from v1.0.0
  # can't use parent definition of DENV_RUNNER because v1.0.0
  # doesn't support the same runners under test
  env -u DENV_RUNNER ./denv-1.0.0/denv init alpine:latest
}

@test "able to run denv created with v1.0.0" {
  run -0 denv true
}

@test "able to configure denv created with v1.0.0" {
  run -0 denv config image alpine:3.19
  run -0 denv true
}
