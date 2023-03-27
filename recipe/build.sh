#!/bin/bash

set -e
set -x

mkdir cpp/build
pushd cpp/build

cmake -GNinja \
    ${CMAKE_ARGS} \
    -DCMAKE_BUILD_TYPE=Release \
    -DARROW_BOOST_USE_SHARED=ON \
    -DARROW_BUILD_BENCHMARKS=OFF \
    -DARROW_BUILD_SHARED=ON \
    -DARROW_BUILD_STATIC=OFF \
    -DARROW_BUILD_TESTS=OFF \
    -DARROW_BUILD_UTILITIES=OFF \
    -DARROW_COMPUTE=ON \
    -DARROW_CSV=ON \
    -DARROW_CUDA=OFF \
    -DARROW_DATASET=ON \
    -DARROW_DEPENDENCY_SOURCE=SYSTEM \
    -DDARROW_DEPENDENCY_USE_SHARED=ON \
    -DARROW_FILESYSTEM=ON \
    -DARROW_FLIGHT=ON \
    -DARROW_FLIGHT_REQUIRE_TLSCREDENTIALSOPTIONS=ON \
    -DARROW_GANDIVA=OFF \
    -DARROW_HDFS=ON \
    -DARROW_JEMALLOC=ON \
    -DARROW_JSON=ON \
    -DARROW_MIMALLOC=ON \
    -DARROW_OPENSSL_USE_SHARED=ON \
    -DARROW_ORC=ON \
    -DARROW_PACKAGE_PREFIX="${PREFIX}" \
    -DARROW_PARQUET=ON \
    -DARROW_PLASMA=ON \
    -DARROW_PROTOBUF_USE_SHARED=ON \
    -DARROW_SIMD_LEVEL=DEFAULT \
    -DARROW_S3=ON \
    -DARROW_UTF8PROC_USE_SHARED=ON \
    -DARROW_WITH_BROTLI=ON \
    -DARROW_WITH_BZ2=ON \
    -DARROW_WITH_LZ4=ON \
    -DARROW_WITH_SNAPPY=ON \
    -DARROW_WITH_ZLIB=ON \
    -DARROW_WITH_ZSTD=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_PREFIX_PATH="${PREFIX}" \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR="${PREFIX}/lib" \
    -DCMAKE_CXX_STANDARD:STRING=17 \
    -DPYTHON_EXECUTABLE="${PYTHON}" \
    -DPython3_EXECUTABLE="${PYTHON}" \
    -DProtobuf_PROTOC_EXECUTABLE="${BUILD_PREFIX}/bin/protoc" \
    ..

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
