#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup

  go_to_tmp_work
  export denv_src="${OLDPWD}"
}

teardown() {
  clean_tmp_work
}

@test "run minimal shebang requiring readable workspace" {
  mkdir workspace runspace
  denv init alpine:latest workspace/
  
  {
    echo "#!/usr/bin/env -S denv shebang";
    echo "#!denv_workspace=${PWD}/workspace";
    echo "#!/bin/sh";
    echo "cat /etc/os-release"
  } > runspace/minimal

  chmod +x runspace/minimal
  run ./runspace/minimal
  assert_success
  assert_output --partial 'Alpine Linux'
}

@test "pass arguments to the script" {
  mkdir workspace runspace
  denv init alpine:latest workspace/
  {
    echo "#!/usr/bin/env -S denv shebang";
    echo "#!denv_workspace=${PWD}/workspace";
    echo "#!/bin/sh";
    echo "echo \$\@"
  } > runspace/minimal

  chmod +x runspace/minimal
  run ./runspace/minimal hello world
  echo 'hello world' | assert_container_output
  assert_success
}

@test "shebang with neither requirements met errors out" {
  {
    echo "#!/usr/bin/env -S denv shebang";
    echo "#!/bin/sh";
    echo "exit 0"
  } > should_error
  chmod +x should_error
  run -1 ./should_error
}

prep_image() {
  case "${DENV_RUNNER}" in
    singularity|apptainer)
      ${DENV_RUNNER} build image.sif docker://${1}
      echo "$(pwd -P)/image.sif"
      ;;
    *)
      echo "${1}"
      ;;
  esac
}

@test "minimal shebang without readable workspace" {
  {
    echo "#!/usr/bin/env -S denv shebang";
    echo "#!denv_image=$(prep_image python:3)";
    echo "#!python";
    echo "print('Hello World!')";
  } > minimal
  chmod +x minimal
  run ./minimal
  assert_success
  echo 'Hello World!' | assert_container_output
}
