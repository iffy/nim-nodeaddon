import ./lowlevel



template NapiModule*(name:string, initFunc:string):untyped =
  {.emit: "#include <node_api.h>" .}
  {.emit: ["NAPI_MODULE(", name, ", ", initFunc, ")"] .}
