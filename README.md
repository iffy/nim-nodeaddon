[![Build Status](https://travis-ci.org/iffy/nim-nodeaddon.svg?branch=master)](https://travis-ci.org/iffy/nim-nodeaddon)
[![Build status](https://ci.appveyor.com/api/projects/status/4bsvvhyb8woy9dxb/branch/master?svg=true)](https://ci.appveyor.com/project/iffy/nim-nodeaddon/branch/master)

## Generating these bindings

- Install c2nim with `nimble install c2nim`
- Download the header files: `nake download` (look in `orig/`)
- Turn them into Nim files: `nake convert` (they end up in `orig/` and in `src/nodeaddonpkg/`)
- Manually adjust the files in `src/nodeaddonpkg/`

## Tests

Run tests with `./runtests.sh`

