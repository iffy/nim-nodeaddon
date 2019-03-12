## Notes


I created `js_native_api.nim` and `js_native_api_types.nim` using `c2nim` something like this:

```
c2nim --cpp --header js_native_api.h
```

But I had to modify each file to get them to work.
