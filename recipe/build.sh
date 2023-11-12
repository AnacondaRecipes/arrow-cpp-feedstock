#!/bin/bash

set -e
set -x

mkdir cpp/build
pushd cpp/build

cmake -GNinja \
    ${CMAKE_ARGS} \
    -DARROW_ACERO=OFF \
    -DARROW_BOOST_USE_SHARED=ON \
    -DARROW_BUILD_TESTS=ON \
    -DARROW_DEPENDENCY_SOURCE=SYSTEM \
    -DARROW_FLIGHT=ON \
    -DARROW_FLIGHT_REQUIRE_TLSCREDENTIALSOPTIONS=ON \
    -DARROW_HDFS=ON \
    -DARROW_JEMALLOC=ON \
    -DARROW_OPENSSL_USE_SHARED=ON \
    -DARROW_PACKAGE_PREFIX="${PREFIX}" \
    -DARROW_PROTOBUF_USE_SHARED=ON \
    -DARROW_SIMD_LEVEL=DEFAULT \
    -DARROW_S3=ON \
    -DARROW_UTF8PROC_USE_SHARED=ON \
    -DARROW_USE_GLOG=ON \
    -DCMAKE_PREFIX_PATH="${PREFIX}" \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR="${PREFIX}/lib" \
    -DPARQUET_REQUIRE_ENCRYPTION=ON \
    -DProtobuf_PROTOC_EXECUTABLE="${BUILD_PREFIX}/bin/protoc" \
    -DGTest_SOURCE=SYSTEM \
    -DGTestAlt_CXX_STANDARD_AVAILABLE=ON \
    .. --preset ninja-release-python

# jemalloc doesn't know about apple M1, fix this here.
if [[ "${target_platform}" == "osx-arm64" ]]; then
    ninja \
        jemalloc_ep-prefix/src/jemalloc_ep-stamp/jemalloc_ep-patch \
        mimalloc_ep-prefix/src/mimalloc_ep-stamp/mimalloc_ep-patch
    # Update the config.guess and config.sub scripts
    cp "${BUILD_PREFIX}/share/gnuconfig/"config.* jemalloc_ep-prefix/src/jemalloc_ep/build-aux/
fi

ninja -v install

popd

. ${RECIPE_DIR}/run_gtest.sh