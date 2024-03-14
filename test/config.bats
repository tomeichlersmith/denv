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

# bats file_tags=norunner

@test "print version of denv" {
  run denv version
  assert_output
}

@test "print check help" {
  run denv check --help
  assert_output
}

@test "basic check run" {
  run denv check
  assert_output
}

@test "quiet check run" {
  run denv check --quiet
  refute_output
}

@test "check fails when using unsupported runner" {
  export DENV_RUNNER=dne
  run -3 denv check
  assert_output --partial "runner is not supported by denv"
}

@test "check that we are in a workspace" {
  run denv check --workspace
  assert_output --partial "Found denv_workspace"
}

@test "check that we are not in a workspace" {
  rm -r .denv
  run -4 denv check --workspace
  assert_output --partial "Unable to deduce a denv workspace"
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

@test "disable network connection" {
  assert_file_contains .denv/config '^denv_network="true"$'
  denv config network off
  assert_file_contains .denv/config '^denv_network="false"$'
}
