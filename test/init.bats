#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  go_to_tmp_work
}

teardown() {
  clean_tmp_work
}

# bats file_tags=norunner

@test "no init denv should fail" {
  run denv
  assert_failure
  assert_output --partial "Unable to deduce a denv workspace"
}

@test "can print denv help without a denv" {
  run denv help
  assert_success
  assert_output
}

@test "can print denv init help without a denv" {
  run denv init help
  assert_success
  assert_output
}

@test "can print denv config help without a denv" {
  run denv config help
  assert_success
  assert_output
}

@test "can print denv config env help without a denv" {
  run denv config env help
  assert_success
  assert_output
}

@test "can init" {
  run denv init alpine:latest
  assert_success
  assert_file_contains .denv/config "^denv_name=\"$(basename ${PWD})\"$"
  assert_file_contains .denv/config '^denv_image="alpine:latest"$'
  assert_file_contains .denv/config '^denv_shell="/bin/bash -i"$'
  assert_file_contains .denv/config '^denv_mounts=""$'
  assert_file_contains .denv/config '^denv_env_var_copy_all="true"$'
  assert_file_contains .denv/config '^denv_env_var_copy=""$'
  assert_file_contains .denv/config '^denv_env_var_set=""$'
}

@test "should not init twice" {
  run denv init alpine:latest
  assert_success
  run -1 denv init alpine:latest
  assert_failure
}

@test "can init twice with force" {
  run denv init alpine:latest
  assert_success
  run denv init --force alpine:3.19
  assert_success
  assert_file_contains .denv/config '^denv_image="alpine:3.19"$'
  run denv init --over alpine:latest
  assert_success
  assert_file_contains .denv/config '^denv_image="alpine:latest"$'
}

@test "can skip double init without force" {
  run denv init alpine:latest
  assert_success
  run denv init --no-over alpine:3.19
  assert_success
  assert_file_contains .denv/config '^denv_image="alpine:latest"$'
}

@test "should not init inside another denv" {
  run denv init alpine:latest
  assert_success
  mkdir subdir
  cd subdir
  run -1 denv init alpine:latest
}

@test "can force init inside another denv" {
  run denv init alpine:latest
  assert_success
  mkdir subdir
  cd subdir
  run denv init --over alpine:latest
  assert_success
}

@test "will not create new directory by default" {
  run -1 denv init alpine:latest subdir
}

@test "can be told to create new directory by default" {
  run denv init --mkdir alpine:latest subdir
  assert_success
}

@test "fails to init if it cant meet override necessity #151" {
  run denv init alpine:3.19
  assert_success
  mkdir subdir
  cd subdir
  run -1 denv init --no-over alpine:latest
}

@test "can init and run with under score in workspace name #154" {
  run denv init --mkdir alpine:latest under_score
  cd under_score
  run -0 denv true
}

@test "refuse to init with name that has special characters #154" {
  run -2 denv init alpine:latest --name "one+two"
}

@test "refuse to init with directory that has special characters #154" {
  mkdir "one?two"
  cd "one?two"
  run -2 denv init alpine:latest
}

@test "refuse to init in host home directory #163" {
  # avoid permission issues and re-copying images
  # by symlinking the local directories here
  ln -st . ${HOME}/.cache ${HOME}/.config ${HOME}/.local
  export HOME=${PWD}
  run -2 denv init alpine:latest
}
