const NAPI_VERSION {.intdefine.}: int = 4
import
  ./js_native_api_types

type
  napi_callback_scope* {.importcpp: "napi_callback_scope", header: "node_api.h" .} = pointer
  napi_async_context* {.importcpp: "napi_async_context", header: "node_api.h" .} = pointer
  napi_async_work* {.importcpp: "napi_async_work", header: "node_api.h" .} = pointer

when NAPI_VERSION >= 4:
  type
    napi_threadsafe_function* {.importcpp: "napi_threadsafe_function", header: "node_api.h" .} = pointer
when NAPI_VERSION >= 4:
  type
    napi_threadsafe_function_release_mode* {.size: sizeof(cint),
        importcpp: "napi_threadsafe_function_release_mode", header: "node_api.h".} = enum
      napi_tsfn_release, napi_tsfn_abort
    napi_threadsafe_function_call_mode* {.size: sizeof(cint),
        importcpp: "napi_threadsafe_function_call_mode", header: "node_api.h".} = enum
      napi_tsfn_nonblocking, napi_tsfn_blocking
type
  napi_async_execute_callback* = proc (env: napi_env; data: pointer)
  napi_async_complete_callback* = proc (env: napi_env; status: napi_status;
                                     data: pointer)

when NAPI_VERSION >= 4:
  type
    napi_threadsafe_function_call_js* = proc (env: napi_env; js_callback: napi_value;
        context: pointer; data: pointer)
type
  napi_node_version* {.importcpp: "napi_node_version", header: "node_api.h", bycopy.} = object
    major* {.importc: "major".}: uint32
    minor* {.importc: "minor".}: uint32
    patch* {.importc: "patch".}: uint32
    release* {.importc: "release".}: cstring

