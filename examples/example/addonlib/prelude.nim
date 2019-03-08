import ./js_native_api_types

type
  # JSVM API types are all opaque pointers for ABI stability
  napi_env* = pointer
  napi_value* = pointer
  napi_ref* = pointer
  napi_handle_scope* = pointer
  napi_escapable_handle_scope* = pointer
  napi_callback_info* = pointer
  napi_deferred* = pointer

  napi_status* = enum
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

template NapiModule*(name:string, initFunc:string):untyped =
  {.emit: ["NAPI_MODULE(", name, ", ", initFunc, ")"] .}