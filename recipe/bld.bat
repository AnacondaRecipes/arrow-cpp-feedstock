mkdir "%SRC_DIR%"\cpp\build
pushd "%SRC_DIR%"\cpp\build

set BOOST_ROOT="%LIBRARY_PREFIX%"
set Boost_ROOT="%LIBRARY_PREFIX%"

cmake -G "Ninja" ^
      %CMAKE_ARGS% ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DARROW_BOOST_USE_SHARED=ON ^
      -DARROW_BUILD_BENCHMARKS=OFF ^
      -DARROW_BUILD_SHARED=ON ^
      -DARROW_BUILD_STATIC=OFF ^
      -DARROW_BUILD_TESTS=OFF ^
      -DARROW_BUILD_UTILITIES=OFF ^
      -DARROW_COMPUTE=ON ^
      -DARROW_CSV=ON ^
      -DARROW_CUDA=OFF ^
      -DARROW_DATASET=ON ^
      -DARROW_DEPENDENCY_SOURCE=SYSTEM ^
      -DARROW_FILESYSTEM=ON ^
      -DARROW_FLIGHT=ON ^
      -DARROW_FLIGHT_REQUIRE_TLSCREDENTIALSOPTIONS=ON ^
      -DARROW_GANDIVA=OFF ^
      -DARROW_HDFS=ON ^
      -DARROW_JSON=ON ^
      -DARROW_MIMALLOC=OFF ^
      -DARROW_OPENSSL_USE_SHARED=ON ^
      -DARROW_PYTHON=ON ^
      -DARROW_ORC=OFF ^
      -DARROW_PACKAGE_PREFIX="%LIBRARY_PREFIX%" ^
      -DARROW_PARQUET=ON ^
      -DARROW_PLASMA=ON ^
      -DARROW_PROTOBUF_USE_SHARED=ON ^
      -DARROW_SIMD_LEVEL=DEFAULT ^
      -DARROW_S3=ON ^
      -DARROW_WITH_BROTLI=ON ^
      -DARROW_WITH_BZ2=ON ^
      -DARROW_WITH_LZ4=ON ^
      -DARROW_WITH_SNAPPY=OFF ^
      -DARROW_WITH_ZLIB=ON ^
      -DARROW_WITH_ZSTD=ON ^
      -DARROW_UTF8PROC_USE_SHARED=ON ^
      -DARROW_DEPENDENCY_USE_SHARED=ON ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR="%LIBRARY_PREFIX%" ^
      -DCMAKE_PREFIX_PATH=%PREFIX% ^
      -DPYTHON_EXECUTABLE="%PYTHON%" ^
      -DPython3_EXECUTABLE="%PYTHON%" ^
      ..

cmake --build . --target install --config Release

popd
