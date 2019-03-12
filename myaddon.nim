import addonlib/lowlevel

proc testMethod(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  var
    greeting: napi_value
    status: napi_status
  status = napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, greeting.unsafeAddr);
  if status != napi_ok:
    return
  result = greeting

proc init(env: napi_env, exports: napi_value):napi_value {.exportc.} =
  var
    status: napi_status
    fn: napi_value
  status = napi_create_function(env, "", 0, testMethod, nil, fn.unsafeAddr)
  if status != napi_ok:
    return
  status = napi_set_named_property(env, exports, "hello", fn)
  if status != napi_ok:
    return
  result = exports

NapiModule("myaddon", "init")
