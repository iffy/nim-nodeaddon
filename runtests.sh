#!/bin/bash

set -e
nimble refresh
nimble install -y
nimble test
[ -e nakefile ] && rm nakefile
nake functest