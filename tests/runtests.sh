#!/bin/bash

pushd $(dirname $0) > /dev/null; script_dir=$PWD; popd > /dev/null

PACTESTER=$script_dir/../src/pactester
PACFILE=$script_dir/proxy.pac
TESTDATA=$script_dir/testdata
export DYLD_LIBRARY_PATH=$script_dir/..
export LD_LIBRARY_PATH=$script_dir/..

while read line
  do
    echo "$line" | grep -q "^#" && continue
    PARAMS=$(echo "$line"|cut -d"|" -f1)
    EXPECTED_RESULT=$(echo $line|cut -d"|" -f2)
    RESULT=$($PACTESTER -p $PACFILE $PARAMS)
    [ $DEBUG ] && echo "Test line: $line"
    [ $DEBUG ] && echo "Params: $PARAMS"
    if [ "$RESULT" != "$EXPECTED_RESULT" ]; then
      echo "Test failed: got \"$RESULT\", expected \"$EXPECTED_RESULT\""
      exit 1;
    fi
  done < $TESTDATA

echo "All tests were successful."
