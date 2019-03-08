type
  char16_t* = uint16_t

##  JSVM API types are all opaque pointers for ABI stability
##  typedef undefined structs instead of void* for compile time type safety

type                          ##  ES6 types (corresponds to typeof)
  napi_env* = ptr napi_env__
  napi_value* = ptr napi_value__
  napi_ref* = ptr napi_ref__
  napi_handle_scope* = ptr napi_handle_scope__
  napi_escapable_handle_scope* = ptr napi_escapable_handle_scope__
  napi_callback_info* = ptr napi_callback_info__
  napi_deferred* = ptr napi_deferred__
  napi_property_attributes* {.size: sizeof(cint),
                             importcpp: "napi_property_attributes",
                             header: "js_native_api_types.h".} = enum
    napi_default = 0, napi_writable = 1 shl 0, napi_enumerable = 1 shl 1, napi_configurable = 1 shl
        2, ##  Used with napi_define_class to distinguish static properties
          ##  from instance properties. Ignored by napi_define_properties.
    napi_static = 1 shl 10
  napi_valuetype* {.size: sizeof(cint), importcpp: "napi_valuetype",
                   header: "js_native_api_types.h".} = enum
    napi_undefined, napi_null, napi_boolean, napi_number, napi_string, napi_symbol,
    napi_object, napi_function, napi_external, napi_bigint
  napi_typedarray_type* {.size: sizeof(cint), importcpp: "napi_typedarray_type",
                         header: "js_native_api_types.h".} = enum
    napi_int8_array, napi_uint8_array, napi_uint8_clamped_array, napi_int16_array,
    napi_uint16_array, napi_int32_array, napi_uint32_array, napi_float32_array,
    napi_float64_array, napi_bigint64_array, napi_biguint64_array
  napi_status* {.size: sizeof(cint), importcpp: "napi_status",
                header: "js_native_api_types.h".} = enum
    napi_ok, napi_invalid_arg, napi_object_expected, napi_string_expected,
    napi_name_expected, napi_function_expected, napi_number_expected,
    napi_boolean_expected, napi_array_expected, napi_generic_failure,
    napi_pending_exception, napi_cancelled, napi_escape_called_twice,
    napi_handle_scope_mismatch, napi_callback_scope_mismatch, napi_queue_full,
    napi_closing, napi_bigint_expected, napi_date_expected
  napi_callback* = proc (env: napi_env; info: napi_callback_info): napi_value
  napi_finalize* = proc (env: napi_env; finalize_data: pointer; finalize_hint: pointer)
  napi_property_descriptor* {.importcpp: "napi_property_descriptor",
                             header: "js_native_api_types.h", bycopy.} = object
    utf8name* {.importc: "utf8name".}: cstring ##  One of utf8name or name should be NULL.
    name* {.importc: "name".}: napi_value
    `method`* {.importc: "method".}: napi_callback
    getter* {.importc: "getter".}: napi_callback
    setter* {.importc: "setter".}: napi_callback
    value* {.importc: "value".}: napi_value
    attributes* {.importc: "attributes".}: napi_property_attributes
    data* {.importc: "data".}: pointer

  napi_extended_error_info* {.importcpp: "napi_extended_error_info",
                             header: "js_native_api_types.h", bycopy.} = object
    error_message* {.importc: "error_message".}: cstring
    engine_reserved* {.importc: "engine_reserved".}: pointer
    engine_error_code* {.importc: "engine_error_code".}: uint32_t
    error_code* {.importc: "error_code".}: napi_status





