import ./js_native_api_types

import ./js_native_api_types
export js_native_api_types
import ./js_native_api
export js_native_api

template NapiModule*(name:string, initFunc:string):untyped =
  {.emit: ["NAPI_MODULE(", name, ", ", initFunc, ")"] .}
