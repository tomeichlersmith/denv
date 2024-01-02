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

@test "print config" {
  run denv config print
  assert_line --index 0 "denv_workspace=\"${PWD}\""
  assert_line --index 1 "denv_name=\"$(basename ${PWD})\""
  assert_line --index 2 'denv_image="ubuntu:22.04"'
}

@test "change image being used" {
  assert_file_contains .denv/config '^denv_image="ubuntu:22\.04"$'
  denv config image ubuntu:20.04
  assert_file_contains .denv/config '^denv_image="ubuntu:20\.04"$'
}

@test "add a new mount" {
  assert_file_contains .denv/config '^denv_mounts=""$'
  denv config mounts ${HOME}
  assert_file_contains .denv/config "^denv_mounts=\"${HOME} \"$"
}

@test "change shell program" {
  assert_file_contains .denv/config '^denv_shell="/bin/bash -i"$'
  denv config shell /bin/zsh
  assert_file_contains .denv/config '^denv_shell="/bin/zsh"$'
}
