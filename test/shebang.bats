#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup

}

teardown() {
  clean_tmp_work
}

@test "run minimal denv shebang requiring readable workspace" {
  go_to_tmp_work
  mkdir workspace runspace
  denv init ubuntu:22.04 workspace/
  
  {
    echo "#!/usr/bin/env -S denv shebang";
    echo "#!denv_workspace=${PWD}/workspace";
    echo "#!/bin/bash";
    echo "cat /etc/os-release"
  } > runspace/minimal

  chmod +x runspace/minimal
  run ./runspace/minimal
  assert_success
}

@test "denv shebang without readable workspace" {
  run ./test/shebang-no-workspace
  assert_success
}
