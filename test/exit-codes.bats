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

@test "pass exit code onto caller" {
  run -42 denv exit 42
}

@test "call a simple executable non-interactively" {
  mkdir -p .local/bin
  echo "echo world" > .local/bin/hello
  chmod +x .local/bin/hello
  echo "export PATH=\"\${PATH}:\${HOME}/.local/bin\"" > .profile
  run denv hello
  assert_success
  assert_container_output "world"
}

# not running this test because alpine has ash by
# default and ash does not (as far as I can tell)
# have a RC file that is only read in interactive
#
# keeping the code around in case I am informed
# of another way to test this
#@test "by-pass broken .bashrc if non-interactive" {
#  echo "exit 6" >> .bashrc
#  run -6 denv
#  run -0 denv true
#}
