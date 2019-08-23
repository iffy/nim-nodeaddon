import strutils
import strformat
import nodeaddonpkg/lowlevel

template throw(env: napi_env, x:string):untyped =
  discard napi_throw_error(env, nil, x)
  return

template throw(env: napi_env): untyped =
  env.throw "Error"

template ok(status: napi_status, env: napi_env): untyped =
  if status != napi_ok:
    var errinfo: ptr napi_extended_error_info
    if napi_get_last_error_info(env, errinfo.unsafeAddr) != napi_ok:
      env.throw "Error encountered while getting error message"
    env.throw($cast[cstring](errinfo.error_message))

proc doGreeting(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, result.unsafeAddr).ok(env)

proc throwError(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  discard napi_throw_error(env, nil, "Error from Nim")

proc utf8Value*(env: napi_env, val:napi_value):string =
  ## Convert napi_value to utf8 string
  # get the size
  var size:csize = 0
  napi_get_value_string_utf8(env, val, nil, 0, size.unsafeAddr).ok(env)
  if size == 0:
    return ""
  # get the string
  result = newString(size)
  napi_get_value_string_utf8(env, val, result[0].unsafeAddr, size+1, size.unsafeAddr).ok(env)
  


proc showArgs(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  ## Demonstrates retrieving arguments
  var
    argc: csize = 6
    argv: array[0 .. 6, napi_value]
    this: napi_value
  napi_get_cb_info(env, args, argc.unsafeAddr, argv[0].unsafeAddr, this.unsafeAddr, nil).ok(env)
  napi_create_array(env, result.unsafeAddr).ok(env)
  for i in 0..<(argc.int):
    var
      valtype: napi_valuetype
      js_typename: napi_value
      obj: napi_value
    napi_create_object(env, obj.unsafeAddr).ok(env)
    # value:
    napi_set_named_property(env, result, $i, obj).ok(env)
    napi_set_named_property(env, obj, "value", argv[i]).ok(env)
    # type: 
    napi_typeof(env, argv[i], valtype.unsafeAddr).ok(env)
    napi_create_string_utf8(env, $valtype, NAPI_AUTO_LENGTH, js_typename.unsafeAddr).ok(env)
    napi_set_named_property(env, obj, "type", js_typename).ok(env)

proc complexObject(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  # object
  napi_create_object(env, result.unsafeAddr).ok(env)
  
  # string
  var js_string: napi_value
  napi_create_string_utf8(env, "Hello, 世界", NAPI_AUTO_LENGTH, js_string.unsafeAddr).ok(env)
  napi_set_named_property(env, result, "string", js_string).ok(env)
  
  # double
  var js_double: napi_value
  napi_create_double(env, 23.4, js_double.unsafeAddr).ok(env)
  napi_set_named_property(env, result, "double", js_double).ok(env)
  
  # boolean
  var js_bool: napi_value
  napi_get_boolean(env, true, js_bool.unsafeAddr).ok(env)
  napi_set_named_property(env, result, "bool", js_bool).ok(env)
  
  # array
  var js_array: napi_value
  napi_create_array(env, js_array.unsafeAddr).ok(env)
  var thing1, thing2: napi_value
  napi_create_double(env, 12.65, thing1.unsafeAddr).ok(env)
  napi_create_string_utf8(env, "Hello there!", NAPI_AUTO_LENGTH, thing2.unsafeAddr).ok(env)
  napi_set_named_property(env, js_array, "0", thing1).ok(env)
  napi_set_named_property(env, js_array, "1", thing2).ok(env)
  napi_set_named_property(env, result, "array", js_array).ok(env)

  # undefined
  var js_undefined: napi_value
  napi_get_undefined(env, js_undefined.unsafeAddr).ok(env)
  napi_set_named_property(env, result, "undef", js_undefined).ok(env)

  # null
  var js_null: napi_value
  napi_get_null(env, js_null.unsafeAddr).ok(env)
  napi_set_named_property(env, result, "nil", js_null).ok(env)

  # symbol
  var js_symbol: napi_value
  var js_symbol_name: napi_value
  napi_create_string_utf8(env, "Symbolo", NAPI_AUTO_LENGTH, js_symbol_name.unsafeAddr).ok(env)
  napi_create_symbol(env, js_symbol_name, js_symbol.unsafeAddr).ok(env)
  napi_set_named_property(env, result, "symb", js_symbol).ok(env)

  # buffer
  # function
  # external
  # bigint
  # date
  # dataview



type
  AsyncEchoData = ref object
    deferred*: napi_deferred
    inval*: string
    retval*: string

proc asyncEcho_execute(env: napi_env, data: pointer) {.cdecl.} =
  var data = cast[AsyncEchoData](data)
  data.retval = data.inval & " echo"

proc asyncEcho_complete(env: napi_env, status: napi_status, data: pointer) {.cdecl.} =
  let data = cast[AsyncEchoData](data)
  if status == napi_ok:
    var retval: napi_value
    env.napi_create_string_utf8(data.retval, NAPI_AUTO_LENGTH, retval.unsafeAddr).ok(env)
    env.napi_resolve_deferred(data.deferred, retval).ok(env)
    

proc asyncEcho(env: napi_env, args: napi_callback_info): napi_value {.exportc, cdecl.} =
  var
    async_resource_name: napi_value
    res: napi_async_work
    deferred: napi_deferred
    dataptr: pointer
  var
    argc: csize = 6
    argv: array[0 .. 6, napi_value]
    this: napi_value
  napi_get_cb_info(env, args, argc.unsafeAddr, argv[0].unsafeAddr, this.unsafeAddr, dataptr.unsafeAddr).ok(env)
  var data = cast[AsyncEchoData](dataptr)

  env.napi_create_promise(deferred.unsafeAddr, result.unsafeAddr).ok(env)
  data.deferred = deferred
  data.retval = ""
  data.inval = env.utf8Value(argv[0])

  env.napi_create_string_utf8("asyncEcho work", NAPI_AUTO_LENGTH, async_resource_name.unsafeAddr).ok(env)

  env.napi_create_async_work(
    nil,
    async_resource_name,
    asyncEcho_execute,
    asyncEcho_complete,
    dataptr,
    res.unsafeAddr,
  ).ok(env)

  env.napi_queue_async_work(res).ok(env)

proc init(env: napi_env, exports: napi_value):napi_value {.exportc.} =
  var
    fn: napi_value

  napi_create_function(env, "", 0, doGreeting, nil, fn.unsafeAddr).ok(env)
  napi_set_named_property(env, exports, "doGreeting", fn).ok(env)
  
  napi_create_function(env, "", 0, throwError, nil, fn.unsafeAddr).ok(env)
  napi_set_named_property(env, exports, "throwError", fn).ok(env)
  
  napi_create_function(env, "", 0, showArgs, nil, fn.unsafeAddr).ok(env)
  napi_set_named_property(env, exports, "showArgs", fn).ok(env)

  napi_create_function(env, "", 0, complexObject, nil, fn.unsafeAddr).ok(env)
  napi_set_named_property(env, exports, "complexObject", fn).ok(env)

  var async_echo_data: AsyncEchoData
  new(async_echo_data)
  GC_ref(async_echo_data)
  napi_create_function(env, "", 0, asyncEcho, cast[pointer](async_echo_data), fn.unsafeAddr).ok(env)

  napi_set_named_property(env, exports, "asyncEcho", fn).ok(env)
  napi_wrap(env,
    exports,
    async_echo_data.unsafeAddr,
    proc(env:napi_env, data: pointer, hint: pointer) {.cdecl.} =
      var data = cast[AsyncEchoData](data)
      GC_unref(data)
    ,
    nil,
    nil
  ).ok(env)

  result = exports

NapiModule("myaddon", "init")
