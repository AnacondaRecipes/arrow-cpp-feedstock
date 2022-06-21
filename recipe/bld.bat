mkdir "%SRC_DIR%"\cpp\build
pushd "%SRC_DIR%"\cpp\build

rem we don't support CUDA for now
set "EXTRA_CMAKE_ARGS=-DARROW_CUDA=OFF"

set BOOST_ROOT="%LIBRARY_PREFIX%"
set Boost_ROOT="%LIBRARY_PREFIX%"
cmake -G "Ninja" ^
      -DCMAKE_BUILD_TYPE=release ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DARROW_DEPENDENCY_SOURCE=SYSTEM ^
      -DARROW_PACKAGE_PREFIX="%LIBRARY_PREFIX%" ^
      -DPYTHON_EXECUTABLE="%PYTHON%" ^
      -DPython3_EXECUTABLE="%PYTHON%" ^
      -DARROW_BOOST_USE_SHARED:BOOL=ON ^
      -DARROW_BUILD_TESTS:BOOL=OFF ^
      -DARROW_BUILD_UTILITIES:BOOL=OFF ^
      -DARROW_BUILD_STATIC:BOOL=OFF ^
      -DARROW_SSE42:BOOL=OFF ^
      -DARROW_PYTHON:BOOL=ON ^
      -DARROW_MIMALLOC:BOOL=OFF ^
      -DARROW_DATASET:BOOL=ON ^
      -DARROW_FLIGHT:BOOL=ON ^
      -DARROW_HDFS:BOOL=ON ^
      -DARROW_PARQUET:BOOL=ON ^
      -DARROW_GANDIVA:BOOL=OFF ^
      -DARROW_ORC:BOOL=ON ^
      -DARROW_S3:BOOL=ON ^
      -DARROW_WITH_BZ2:BOOL=ON ^
      -DARROW_WITH_LZ4=ON ^
      -DARROW_WITH_ZLIB:BOOL=ON ^
      -DARROW_WITH_ZSTD:BOOL=ON ^
      -DBoost_NO_BOOST_CMAKE=ON ^
      -DCMAKE_C_FLAGS="%CFLAGS% -D_WIN32_WINNT=0x600" ^
      -DCMAKE_CXX_FLAGS="%CXXFLAGS% -D_WIN32_WINNT=0x600" ^
      -DCMAKE_UNITY_BUILD=ON ^
      ..

cmake --build . --target install --config Release

popd
