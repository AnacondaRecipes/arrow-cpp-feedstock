#!/bin/bash

exclude=(   arrow-acero-plan-test, 
            arrow-array-test, 
            arrow-dataset-discovery-test, 
            arrow-dataset-file-ipc-test, 
            arrow-dataset-file-parquet-test, 
            arrow-dataset-file-test, 
            arrow-dataset-partition-test,
            arrow-flight-test,
            arrow-ipc-read-write-test,
            arrow-s3fs-narrative-test,
            arrow-s3fs-test,
            arrow-substrait-substrait-test,
            arrow-table-test,
            arrow-utility-test
            my-test)

for filepath in ${SRC_DIR}/cpp/build/release/*-test; do
    
    filename=`basename $filepath`
    
    if [[ ${exclude[*]} =~ $filename ]]; then
        echo "skipping $filename"
        continue
    fi

    echo "starting $filename test"
    $filepath
    status=$?

    if test $status -ne 0; then
        echo "failed test: $filename"
        exit 1
    fi
done
