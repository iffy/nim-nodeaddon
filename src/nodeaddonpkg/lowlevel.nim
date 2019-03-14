import ./js_native_api_types

import ./js_native_api_types
export js_native_api_types
import ./js_native_api
export js_native_api

type
  napi_value_array* = ptr napi_value

proc `$`*(t:napi_valuetype):string =
  case t
  of napi_undefined:
    "undefined"
  of napi_null:
    "null"
  of napi_boolean:
    "boolean"
  of napi_number:
    "number"
  of napi_string:
    "string"
  of napi_symbol:
    "symbol"
  of napi_object:
    "object"
  of napi_function:
    "function"
  of napi_external:
    "external"
  of napi_bigint:
    "bigint"

template NapiModule*(name:string, initFunc:string):untyped =
  {.emit: "#include <node_api.h>" .}
  {.emit: ["NAPI_MODULE(", name, ", ", initFunc, ")"] .}
