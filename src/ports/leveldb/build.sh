#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

source pkg_info
source ../../build_tools/common.sh

BuildStep() {
  export TARGET_OS=NaCl
  LogExecute make clean
  LogExecute make -j${OS_JOBS}
  LogExecute make -j${OS_JOBS} tests programs
}

InstallStep() {
  LogExecute cp libleveldb.a ${NACLPORTS_LIBDIR}
  LogExecute cp -r include/leveldb ${NACLPORTS_LIBDIR}
}

TestStep() {
  Banner "Testing ${PACKAGE_NAME}"

  if [ "${NACL_ARCH}" = "pnacl" ]; then
    return
  fi

  # All these tests rely on mkdir() working, and currently
  # neither newlib or glibc has mkdir plumbed through to the
  # IRT.
    #autocompact_test
    #c_test
    #corruption_test
    #db_test
    #issue178_test
    #issue200_test
    #table_test
  local TESTS="\
    arena_test \
    bloom_test \
    cache_test \
    coding_test \
    crc32c_test \
    dbformat_test \
    env_test \
    filename_test \
    filter_block_test \
    log_test \
    memenv_test \
    skiplist_test \
    version_edit_test \
    version_set_test \
    write_batch_test"
  for test_binary in $TESTS; do
    WriteSelLdrScript $test_binary.sh $test_binary
  done
  for test_binary in $TESTS; do
    echo "***** Running $test_binary.sh"i
    ./$test_binary.sh
  done
}

PackageInstall
exit 0
