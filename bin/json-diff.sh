#!/bin/bash

#  Perform a DIFF on 2 json files after flattening them

set -ue

SCRIPT_DIR=`dirname "$0"`
FILE1="${1}"
FILE2="${2}"

set -x

diff --color=auto -u <("$SCRIPT_DIR/json-flatten.js" "$FILE1") <("$SCRIPT_DIR/json-flatten.js" "$FILE2")

