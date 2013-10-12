#!/bin/bash
# Copyright (c) 2011 The Native Client Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

source pkg_info
source ../../build_tools/common.sh

# MAKEFLAGS=VERBOSE=1

RunSelLdrTests() {
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}/${NACL_BUILD_SUBDIR}
  pushd UnitTests/BulletUnitTests
  RunSelLdrCommand AppBulletUnitTests
  popd

  pushd Demos/HelloWorld
  RunSelLdrCommand AppHelloWorld
  popd
}


ConfigureStep() {
  Banner "Configuring ${PACKAGE_NAME}"
  ChangeDir ${NACL_PACKAGES_REPOSITORY}/${PACKAGE_NAME}
  Remove ${NACL_BUILD_SUBDIR}
  MakeDir ${NACL_BUILD_SUBDIR}
  cd ${NACL_BUILD_SUBDIR}
  echo "Directory: $(pwd)"

  CC="${NACLCC}" CXX="${NACLCXX}" cmake .. \
           -DCMAKE_TOOLCHAIN_FILE=../XCompile-nacl.txt \
           -DNACLAR=${NACLAR} \
           -DNACL_CROSS_PREFIX=${NACL_CROSS_PREFIX} \
           -DNACL_SDK_ROOT=${NACL_SDK_ROOT} \
           -DCMAKE_INSTALL_PREFIX=${NACLPORTS_PREFIX} \
           -DBUILD_UNIT_TESTS=on
}

PackageInstall() {
  DefaultPackageInstall
  RunSelLdrTests
}

PackageInstall
exit 0