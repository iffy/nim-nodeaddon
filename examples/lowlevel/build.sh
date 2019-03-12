#!/bin/bash

set -e

[ -e "csrc" ] && rm -r csrc
nim cpp --compileOnly --gc:regions --nimcache:csrc --header myaddon.nim
cp nimbase.h csrc/
node-gyp clean configure rebuild

[ -e "native" ] && rm -r native
mkdir -p native
cp build/Release/*.node native/