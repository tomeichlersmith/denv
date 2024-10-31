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

# bats file_tags=apptainer

@test "normal running works" {
  run -0 denv true
}

@test "can invalidate cache and then run" {
  case "${DENV_RUNNER}" in
    apptainer)
      cache=${APPTAINER_CACHEDIR:-${HOME}/.apptainer/cache}
      ;;
    singularity)
      cache=${SINGULARITY_CACHEDIR:-${HOME}/.singularity/cache}
      ;;
    *)
      echo "This test is only designed for apptainer/singularity, not ${DENV_RUNNER}."
      echo "Re-run with '--filter-tags !apptainer' to test ${DENV_RUNNER}"
      false
      ;;
  esac
  rm -r ${cache}
  run -0 denv true
}
