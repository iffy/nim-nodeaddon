[![Build Status](https://travis-ci.org/iffy/nim-nodeaddon.svg?branch=master)](https://travis-ci.org/iffy/nim-nodeaddon)
[![Build status](https://ci.appveyor.com/api/projects/status/4bsvvhyb8woy9dxb/branch/master?svg=true)](https://ci.appveyor.com/project/iffy/nim-nodeaddon/branch/master)

## Notes


I created `js_native_api.nim` and `js_native_api_types.nim` using `c2nim` something like this:

```
c2nim --cpp --header js_native_api.h
```

But I had to modify each file to get them to work.
