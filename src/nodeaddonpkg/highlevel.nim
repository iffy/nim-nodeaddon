import ./lowlevel
export lowlevel

# type
#   ValueKind* = enum
#     Undefined,
#     Null,
#     Boolean,
#     Number,
#     String,
#     Symbol,
#     Object,
#     Function,
#     External,
#     BigInt,
  
#   JsValue* =
#     env: napi_env


template NapiModule*(name:string, initFunc:string):untyped =
  {.emit: "#include <node_api.h>" .}
  {.emit: ["NAPI_MODULE(", name, ", ", initFunc, ")"] .}
