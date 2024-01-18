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

@test "we can see other network devices besides loopback" {
  run denv ls /sys/class/net
  assert_success
  assert_container_output --partial "lo"
  num_devices="$(echo "${output}" | wc -w)"
  assert [ "$num_devices" -gt 1 ]
}

@test "we can disable network devices besides loopback" {
  export DENV_NETWORKLESS=1
  run denv ls /sys/class/net
  assert_success
  # no --partial => the only output is the 'lo' loopback
  assert_container_output "lo"
}
