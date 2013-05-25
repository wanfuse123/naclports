#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#

# nacl-dreadthread.sh
#
# usage:  nacl-dreadthread.sh
#
# this script builds dreadthread for Native Client
#

readonly PACKAGE_NAME=dreadthread

source pkg_info
source ../../build_tools/common.sh


CustomBuildStep() {
  Banner "Building ${PACKAGE_NAME}"
  export PACKAGE_DIR="${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}"
  MakeDir ${PACKAGE_DIR}
  ChangeDir ${PACKAGE_DIR}
  ${NACLCC} -c ${START_DIR}/dread.c -o dread.o
  ${NACLCC} -c ${START_DIR}/dread_chain.c -o dread_chain.o
  ${NACLAR} rcs libdreadthread.a \
      dread.o \
      dread_chain.o
  ${NACLRANLIB} libdreadthread.a
}

CustomInstallStep() {
  Banner "Installing ${PACKAGE_NAME}"
  export PACKAGE_DIR="${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}"
  cp ${PACKAGE_DIR}/libdreadthread.a ${NACLPORTS_LIBDIR}
  cp ${START_DIR}/dreadthread.h ${NACLPORTS_INCLUDE}
  cp ${START_DIR}/dreadthread_ctxt.h ${NACLPORTS_INCLUDE}
  cp ${START_DIR}/dreadthread_chain.h ${NACLPORTS_INCLUDE}
}

CustomPackageInstall() {
  DefaultPreInstallStep
  CustomBuildStep
  CustomInstallStep
  DefaultCleanUpStep
}

CustomPackageInstall
exit 0
