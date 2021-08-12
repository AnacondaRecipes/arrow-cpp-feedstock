#!/bin/bash

set -e
set -x

mkdir cpp/build
pushd cpp/build

EXTRA_CMAKE_ARGS=""

# Include g++'s system headers
if [ "$(uname)" == "Linux" ]; then
  SYSTEM_INCLUDES=$(echo | ${CXX} -E -Wp,-v -xc++ - 2>&1 | grep '^ ' | awk '{print "-isystem;" substr($1, 1)}' | tr '\n' ';')
  EXTRA_CMAKE_ARGS=" -DARROW_GANDIVA_PC_CXX_FLAGS=${SYSTEM_INCLUDES}"
fi

# we don't provide right now CUDA variant
EXTRA_CMAKE_ARGS=" ${EXTRA_CMAKE_ARGS} -DARROW_CUDA=OFF"

if [[ "${target_platform}" == "osx-arm64" ]]; then
    # We need llvm 11+ support in Arrow for this
    EXTRA_CMAKE_ARGS=" ${EXTRA_CMAKE_ARGS} -DARROW_GANDIVA=OFF"
    sed -ie "s;protoc-gen-grpc.*$;protoc-gen-grpc=${BUILD_PREFIX}/bin/grpc_cpp_plugin\";g" ../src/arrow/flight/CMakeLists.txt
    sed -ie 's;"--with-jemalloc-prefix\=je_arrow_";"--with-jemalloc-prefix\=je_arrow_" "--with-lg-page\=14";g' ../cmake_modules/ThirdpartyToolchain.cmake
else
    EXTRA_CMAKE_ARGS=" ${EXTRA_CMAKE_ARGS} -DARROW_GANDIVA=OFF"
fi

export BOOST_ROOT="${LIBRARY_PREFIX}"
export Boost_ROOT="${LIBRARY_PREFIX}"

cmake \
    -DARROW_BOOST_USE_SHARED=ON \
    -DARROW_BUILD_BENCHMARKS=OFF \
    -DARROW_BUILD_STATIC=OFF \
    -DARROW_BUILD_TESTS=OFF \
    -DARROW_BUILD_UTILITIES=OFF \
    -DBUILD_SHARED_LIBS=ON \
    -DARROW_SSE42=OFF \
    -DCMAKE_BUILD_TYPE=release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DLLVM_TOOLS_BINARY_DIR=$PREFIX/bin \
    -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib \
    -DARROW_DEPENDENCY_SOURCE=SYSTEM \
    -DARROW_PACKAGE_PREFIX=$PREFIX \
    -DPYTHON_EXECUTABLE=$PYTHON \
    -DPython3_EXECUTABLE=$PYTHON \
    -DARROW_DATASETS=ON \
    -DARROW_JEMALLOC=ON \
    -DARROW_MIMALLOC=ON \
    -DARROW_HDFS=ON \
    -DARROW_FLIGHT=ON \
    -DARROW_FLIGHT_REQUIRE_TLSCREDENTIALSOPTIONS=ON \
    -DARROW_PLASMA=ON \
    -DARROW_PYTHON=ON \
    -DARROW_PARQUET=ON \
    -DARROW_ORC=ON \
    -DARROW_S3=ON \
    -DARROW_WITH_BROTLI=ON \
    -DARROW_WITH_BZ2=ON \
    -DARROW_WITH_LZ4=ON \
    -DARROW_WITH_SNAPPY=ON \
    -DARROW_WITH_ZLIB=ON \
    -DARROW_WITH_ZSTD=ON \
    -DCMAKE_AR=${AR} \
    -DCMAKE_RANLIB=${RANLIB} \
    -DPython3_EXECUTABLE=${PYTHON} \
    -DProtobuf_PROTOC_EXECUTABLE=$BUILD_PREFIX/bin/protoc \
    -GNinja \
    ${EXTRA_CMAKE_ARGS} \
    ..

if [[ "${target_platform}" == "osx-arm64" ]]; then
    ln -s $BUILD_PREFIX/bin/$HOST-ar $HOST-ar
    ln -s $BUILD_PREFIX/bin/$HOST-ranlib $HOST-ranlib
    ninja jemalloc_ep-prefix/src/jemalloc_ep-stamp/jemalloc_ep-patch mimalloc_ep-prefix/src/mimalloc_ep-stamp/mimalloc_ep-patch
    cp $BUILD_PREFIX/share/gnuconfig/config.* jemalloc_ep-prefix/src/jemalloc_ep/build-aux/
    sed -ie 's/list(APPEND mi_cflags -march=native)//g' mimalloc_ep-prefix/src/mimalloc_ep/CMakeLists.txt
fi

ninja install

popd
