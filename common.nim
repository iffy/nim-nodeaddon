
type
  NapiStatus* = enum
    ok,
    invalid_arg,
    object_expected,
    string_expected,
    name_expected,
    function_expected,
    number_expected,
    boolean_expected,
    array_expected,
    generic_failure,
    pending_exception,
    cancelled,
    escape_called_twice,
    handle_scope_mismatch,
    callback_scope_mismatch,
    queue_full,
    closing,
    bigint_expected,
    date_expected,


type
  NapiEnv* {.importc: "napi_env", header: "js_native_api_types.h" .} = pointer
  NapiValue* {.importc: "napi_value", header: "js_native_api_types.h" .} = pointer
  NapiCallback* = pointer

proc napi_create_object*(env:NapiEnv, res:ref NapiValue):NapiStatus {.importc: "napi_create_object", header: "js_native_api.h" .}

proc napi_create_function*(env:NapiEnv, utf8name:cstring, length:csize, cb:NapiCallback, data:pointer, result: ref NapiValue): NapiStatus {.importc: "napi_create_function", header: "js_native_api.h" .}
