import addonlib/lowlevel

proc doGreeting(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  if napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, result.unsafeAddr) != napi_ok:
    return

proc throwError(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  discard napi_throw_error(env, nil, "Error from Nim")

proc showArgs(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  ## Demonstrates retrieving arguments
  echo "[nim] showArgs"
  var
    argc: csize = 6
    argv: napi_value
    this: napi_value
    data: pointer
  echo "argc: ", argc
  echo "argv: ", argv.repr
  echo "this: ", this.repr
  echo "data: ", data.repr
  if napi_get_cb_info(env, args, argc.unsafeAddr, argv.unsafeAddr, this.unsafeAddr, data.unsafeAddr) != napi_ok:
    return
  echo "call succeeded"
  echo "argc: ", argc
  echo "argv: ", argv.repr
  echo "this: ", this.repr
  echo "data: ", data.repr

proc complexObject(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  # object
  if napi_create_object(env, result.unsafeAddr) != napi_ok:
    return
  
  # string
  var js_string: napi_value
  if napi_create_string_utf8(env, "Hello, 世界", NAPI_AUTO_LENGTH, js_string.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, result, "string", js_string) != napi_ok:
    return
  
  # double
  var js_double: napi_value
  if napi_create_double(env, 23.4, js_double.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, result, "double", js_double) != napi_ok:
    return
  
  # boolean
  var js_bool: napi_value
  if napi_get_boolean(env, true, js_bool.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, result, "bool", js_bool) != napi_ok:
      return
  
  # array
  var js_array: napi_value
  if napi_create_array(env, js_array.unsafeAddr) != napi_ok:
    return
  var thing1, thing2: napi_value
  if napi_create_double(env, 12.65, thing1.unsafeAddr) != napi_ok:
    return
  if napi_create_string_utf8(env, "Hello there!", NAPI_AUTO_LENGTH, thing2.unsafeAddr) != napi_ok:
    return  
  if napi_set_named_property(env, js_array, "0", thing1) != napi_ok:
    return
  if napi_set_named_property(env, js_array, "1", thing2) != napi_ok:
    return
  if napi_set_named_property(env, result, "array", js_array) != napi_ok:
    return
  

proc init(env: napi_env, exports: napi_value):napi_value {.exportc.} =
  var
    fn: napi_value
  if napi_create_function(env, "", 0, doGreeting, nil, fn.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, exports, "doGreeting", fn) != napi_ok:
    return
  
  if napi_create_function(env, "", 0, throwError, nil, fn.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, exports, "throwError", fn) != napi_ok:
    return
  
  if napi_create_function(env, "", 0, showArgs, nil, fn.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, exports, "showArgs", fn) != napi_ok:
    return

  if napi_create_function(env, "", 0, complexObject, nil, fn.unsafeAddr) != napi_ok:
    return
  if napi_set_named_property(env, exports, "complexObject", fn) != napi_ok:
    return
  result = exports

NapiModule("myaddon", "init")
