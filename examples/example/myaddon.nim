import addonlib/prelude

proc method2(env: napi_env, args: napi_callback_info):napi_value {.exportc.} =
  discard

{.emit: """
#include <node_api.h>

napi_value Method(napi_env env, napi_callback_info args) {
  napi_value greeting;
  napi_status status;

  status = napi_create_string_utf8(env, "hello", NAPI_AUTO_LENGTH, &greeting);
  if (status != napi_ok) return nullptr;
  return greeting;
}

/*
napi_value init(napi_env env, napi_value exports) {
  napi_status status;
  napi_value fn;

  status = napi_create_function(env, nullptr, 0, Method, nullptr, &fn);
  if (status != napi_ok) return nullptr;

  status = napi_set_named_property(env, exports, "hello", fn);
  if (status != napi_ok) return nullptr;
  return exports;
}
*/

""".}

proc init(env: napi_env, exports: napi_value):napi_value {.exportc.} =
  var
    status: napi_status
    fn: napi_value
  {.emit: """
  status = napi_create_function(env, nullptr, 0, Method, nullptr, &fn);
  if (status != napi_ok) return nullptr;

  status = napi_set_named_property(env, exports, "hello", fn);
  if (status != napi_ok) return nullptr;
  return exports;
  """.}

NapiModule("myaddon", "init")
