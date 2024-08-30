#!/usr/bin/env bats

setup() {
  load "test_helper/denv"
  common_setup
  
  go_to_tmp_work
  denv init alpine:latest
}

teardown() {
  clean_tmp_work
}

@test "denv name available in denv" {
  run denv printenv DENV_NAME
  assert_success
  assert_container_output "$(basename ${PWD})"
}

@test "we can share host environment variables" {
  export foo=bar
  run denv printenv foo
  assert_success
  assert_container_output "bar"
}

@test "we can prevent sharing of host env vars" {
  export foo=bar
  denv config env all no
  run denv printenv foo
  assert_failure
  refute_output
}

@test "we can copy specific env vars" {
  export foo=bar
  export baz=buz
  denv config env all no
  denv config env copy baz
  run denv printenv foo baz  
  assert_failure
  assert_container_output "buz"
}

@test "we can set (and override) env vars" {
  export foo=bar
  denv config env all no
  denv config env copy foo=buz myfoo=baz
  run denv printenv foo myfoo
  assert_success
  assert_output --partial "buz"
  assert_output --partial "baz"
}
