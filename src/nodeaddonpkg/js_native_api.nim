##  This file needs to be compatible with C compilers.

import ./js_native_api_types

##  Use INT_MAX, this should only be consumed by the pre-processor anyway.

const
  NAPI_VERSION_EXPERIMENTAL* = 2147483647

when not defined(NAPI_VERSION):
  when defined(NAPI_EXPERIMENTAL):
    const
      NAPI_VERSION* = NAPI_VERSION_EXPERIMENTAL
  else:
    ##  The baseline version for N-API.
    ##  The NAPI_VERSION controls which version will be used by default when
    ##  compilling a native addon. If the addon developer specifically wants to use
    ##  functions available in a new version of N-API that is not yet ported in all
    ##  LTS versions, they can set NAPI_VERSION knowing that they have specifically
    ##  depended on that version.
    const
      NAPI_VERSION* = 4
##  If you need __declspec(dllimport), either include <node_api.h> instead, or
##  define NAPI_EXTERN as __declspec(dllimport) on the compiler's command line.

when sizeof(int) == 4: # 32bit
  const
    NAPI_AUTO_LENGTH*: csize = 2147483647 # cast[uint32](-1).csize
else:
  const
    NAPI_AUTO_LENGTH*: csize = cast[uint64](-1).csize


proc napi_get_last_error_info*(env: napi_env;
                              result: ptr ptr napi_extended_error_info): napi_status {.
    importcpp: "napi_get_last_error_info(#, (const napi_extended_error_info **) #)", header: "node_api.h".}
##  Getters for defined singletons

proc napi_get_undefined*(env: napi_env; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_undefined(@)", header: "node_api.h".}
proc napi_get_null*(env: napi_env; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_null(@)", header: "node_api.h".}
proc napi_get_global*(env: napi_env; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_global(@)", header: "node_api.h".}
proc napi_get_boolean*(env: napi_env; value: bool; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_boolean(@)", header: "node_api.h".}
##  Methods to create Primitive types/Objects

proc napi_create_object*(env: napi_env; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_object(@)", header: "node_api.h".}
proc napi_create_array*(env: napi_env; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_array(@)", header: "node_api.h".}
proc napi_create_array_with_length*(env: napi_env; length: csize;
                                   result: ptr napi_value): napi_status {.
    importcpp: "napi_create_array_with_length(@)", header: "node_api.h".}
proc napi_create_double*(env: napi_env; value: cdouble; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_double(@)", header: "node_api.h".}
proc napi_create_int32*(env: napi_env; value: int32; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_int32(@)", header: "node_api.h".}
proc napi_create_uint32*(env: napi_env; value: uint32; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_uint32(@)", header: "node_api.h".}
proc napi_create_int64*(env: napi_env; value: int64; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_int64(@)", header: "node_api.h".}
proc napi_create_string_latin1*(env: napi_env; str: cstring; length: csize;
                               result: ptr napi_value): napi_status {.
    importcpp: "napi_create_string_latin1(@)", header: "node_api.h".}
proc napi_create_string_utf8*(env: napi_env; str: cstring; length: csize;
                             result: ptr napi_value): napi_status {.
    importcpp: "napi_create_string_utf8(@)", header: "node_api.h".}
proc napi_create_string_utf16*(env: napi_env; str: ptr Utf16Char; length: csize;
                              result: ptr napi_value): napi_status {.
    importcpp: "napi_create_string_utf16(@)", header: "node_api.h".}
proc napi_create_symbol*(env: napi_env; description: napi_value;
                        result: ptr napi_value): napi_status {.
    importcpp: "napi_create_symbol(@)", header: "node_api.h".}
proc napi_create_function*(env: napi_env; utf8name: cstring; length: csize;
                          cb: napi_callback; data: pointer; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_function(@)", header: "node_api.h".}
proc napi_create_error*(env: napi_env; code: napi_value; msg: napi_value;
                       result: ptr napi_value): napi_status {.
    importcpp: "napi_create_error(@)", header: "node_api.h".}
proc napi_create_type_error*(env: napi_env; code: napi_value; msg: napi_value;
                            result: ptr napi_value): napi_status {.
    importcpp: "napi_create_type_error(@)", header: "node_api.h".}
proc napi_create_range_error*(env: napi_env; code: napi_value; msg: napi_value;
                             result: ptr napi_value): napi_status {.
    importcpp: "napi_create_range_error(@)", header: "node_api.h".}
##  Methods to get the native napi_value from Primitive type

proc napi_typeof*(env: napi_env; value: napi_value; result: ptr napi_valuetype): napi_status {.
    importcpp: "napi_typeof(@)", header: "node_api.h".}
proc napi_get_value_double*(env: napi_env; value: napi_value; result: ptr cdouble): napi_status {.
    importcpp: "napi_get_value_double(@)", header: "node_api.h".}
proc napi_get_value_int32*(env: napi_env; value: napi_value; result: ptr int32): napi_status {.
    importcpp: "napi_get_value_int32(@)", header: "node_api.h".}
proc napi_get_value_uint32*(env: napi_env; value: napi_value; result: ptr uint32): napi_status {.
    importcpp: "napi_get_value_uint32(@)", header: "node_api.h".}
proc napi_get_value_int64*(env: napi_env; value: napi_value; result: ptr int64): napi_status {.
    importcpp: "napi_get_value_int64(@)", header: "node_api.h".}
proc napi_get_value_bool*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_get_value_bool(@)", header: "node_api.h".}
##  Copies LATIN-1 encoded bytes from a string into a buffer.

proc napi_get_value_string_latin1*(env: napi_env; value: napi_value; buf: cstring;
                                  bufsize: csize; result: ptr csize): napi_status {.
    importcpp: "napi_get_value_string_latin1(@)", header: "node_api.h".}
##  Copies UTF-8 encoded bytes from a string into a buffer.

proc napi_get_value_string_utf8*(env: napi_env; value: napi_value; buf: cstring;
                                bufsize: csize; result: ptr csize): napi_status {.
    importcpp: "napi_get_value_string_utf8(@)", header: "node_api.h".}
##  Copies UTF-16 encoded bytes from a string into a buffer.

proc napi_get_value_string_utf16*(env: napi_env; value: napi_value;
                                 buf: ptr Utf16Char; bufsize: csize; result: ptr csize): napi_status {.
    importcpp: "napi_get_value_string_utf16(@)", header: "node_api.h".}
##  Methods to coerce values
##  These APIs may execute user scripts

proc napi_coerce_to_bool*(env: napi_env; value: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_coerce_to_bool(@)", header: "node_api.h".}
proc napi_coerce_to_number*(env: napi_env; value: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_coerce_to_number(@)", header: "node_api.h".}
proc napi_coerce_to_object*(env: napi_env; value: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_coerce_to_object(@)", header: "node_api.h".}
proc napi_coerce_to_string*(env: napi_env; value: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_coerce_to_string(@)", header: "node_api.h".}
##  Methods to work with Objects

proc napi_get_prototype*(env: napi_env; `object`: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_prototype(@)", header: "node_api.h".}
proc napi_get_property_names*(env: napi_env; `object`: napi_value;
                             result: ptr napi_value): napi_status {.
    importcpp: "napi_get_property_names(@)", header: "node_api.h".}
proc napi_set_property*(env: napi_env; `object`: napi_value; key: napi_value;
                       value: napi_value): napi_status {.
    importcpp: "napi_set_property(@)", header: "node_api.h".}
proc napi_has_property*(env: napi_env; `object`: napi_value; key: napi_value;
                       result: ptr bool): napi_status {.
    importcpp: "napi_has_property(@)", header: "node_api.h".}
proc napi_get_property*(env: napi_env; `object`: napi_value; key: napi_value;
                       result: ptr napi_value): napi_status {.
    importcpp: "napi_get_property(@)", header: "node_api.h".}
proc napi_delete_property*(env: napi_env; `object`: napi_value; key: napi_value;
                          result: ptr bool): napi_status {.
    importcpp: "napi_delete_property(@)", header: "node_api.h".}
proc napi_has_own_property*(env: napi_env; `object`: napi_value; key: napi_value;
                           result: ptr bool): napi_status {.
    importcpp: "napi_has_own_property(@)", header: "node_api.h".}
proc napi_set_named_property*(env: napi_env; `object`: napi_value; utf8name: cstring;
                             value: napi_value): napi_status {.
    importcpp: "napi_set_named_property(@)", header: "node_api.h".}
proc napi_has_named_property*(env: napi_env; `object`: napi_value; utf8name: cstring;
                             result: ptr bool): napi_status {.
    importcpp: "napi_has_named_property(@)", header: "node_api.h".}
proc napi_get_named_property*(env: napi_env; `object`: napi_value; utf8name: cstring;
                             result: ptr napi_value): napi_status {.
    importcpp: "napi_get_named_property(@)", header: "node_api.h".}
proc napi_set_element*(env: napi_env; `object`: napi_value; index: uint32;
                      value: napi_value): napi_status {.
    importcpp: "napi_set_element(@)", header: "node_api.h".}
proc napi_has_element*(env: napi_env; `object`: napi_value; index: uint32;
                      result: ptr bool): napi_status {.
    importcpp: "napi_has_element(@)", header: "node_api.h".}
proc napi_get_element*(env: napi_env; `object`: napi_value; index: uint32;
                      result: ptr napi_value): napi_status {.
    importcpp: "napi_get_element(@)", header: "node_api.h".}
proc napi_delete_element*(env: napi_env; `object`: napi_value; index: uint32;
                         result: ptr bool): napi_status {.
    importcpp: "napi_delete_element(@)", header: "node_api.h".}
proc napi_define_properties*(env: napi_env; `object`: napi_value;
                            property_count: csize;
                            properties: ptr napi_property_descriptor): napi_status {.
    importcpp: "napi_define_properties(@)", header: "node_api.h".}
##  Methods to work with Arrays

proc napi_is_array*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_is_array(@)", header: "node_api.h".}
proc napi_get_array_length*(env: napi_env; value: napi_value; result: ptr uint32): napi_status {.
    importcpp: "napi_get_array_length(@)", header: "node_api.h".}
##  Methods to compare values

proc napi_strict_equals*(env: napi_env; lhs: napi_value; rhs: napi_value;
                        result: ptr bool): napi_status {.
    importcpp: "napi_strict_equals(@)", header: "node_api.h".}
##  Methods to work with Functions

proc napi_call_function*(env: napi_env; recv: napi_value; `func`: napi_value;
                        argc: csize; argv: ptr napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_call_function(@)", header: "node_api.h".}
proc napi_new_instance*(env: napi_env; constructor: napi_value; argc: csize;
                       argv: ptr napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_new_instance(@)", header: "node_api.h".}
proc napi_instanceof*(env: napi_env; `object`: napi_value; constructor: napi_value;
                     result: ptr bool): napi_status {.
    importcpp: "napi_instanceof(@)", header: "node_api.h".}
##  Methods to work with napi_callbacks
##  Gets all callback info in a single call. (Ugly, but faster.)

proc napi_get_cb_info*(env: napi_env; cbinfo: napi_callback_info; argc: ptr csize;
                      argv: ptr napi_value; this_arg: ptr napi_value;
                      data: ptr pointer): napi_status {.
    importcpp: "napi_get_cb_info(@)", header: "node_api.h".}
  ##  [in] NAPI environment handle
  ##  [in] Opaque callback-info handle
  ##  [in-out] Specifies the size of the provided argv array
  ##  and receives the actual count of args.
  ##  [out] Array of values
  ##  [out] Receives the JS 'this' arg for the call
##  [out] Receives the data pointer for the callback.

proc napi_get_new_target*(env: napi_env; cbinfo: napi_callback_info;
                         result: ptr napi_value): napi_status {.
    importcpp: "napi_get_new_target(@)", header: "node_api.h".}
proc napi_define_class*(env: napi_env; utf8name: cstring; length: csize;
                       constructor: napi_callback; data: pointer;
                       property_count: csize;
                       properties: ptr napi_property_descriptor;
                       result: ptr napi_value): napi_status {.
    importcpp: "napi_define_class(@)", header: "node_api.h".}
##  Methods to work with external data objects

proc napi_wrap*(env: napi_env; js_object: napi_value; native_object: pointer;
               finalize_cb: napi_finalize; finalize_hint: pointer;
               result: ptr napi_ref): napi_status {.importcpp: "napi_wrap(@)",
    header: "node_api.h".}
proc napi_unwrap*(env: napi_env; js_object: napi_value; result: ptr pointer): napi_status {.
    importcpp: "napi_unwrap(@)", header: "node_api.h".}
proc napi_remove_wrap*(env: napi_env; js_object: napi_value; result: ptr pointer): napi_status {.
    importcpp: "napi_remove_wrap(@)", header: "node_api.h".}
proc napi_create_external*(env: napi_env; data: pointer; finalize_cb: napi_finalize;
                          finalize_hint: pointer; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_external(@)", header: "node_api.h".}
proc napi_get_value_external*(env: napi_env; value: napi_value; result: ptr pointer): napi_status {.
    importcpp: "napi_get_value_external(@)", header: "node_api.h".}
##  Methods to control object lifespan
##  Set initial_refcount to 0 for a weak reference, >0 for a strong reference.

proc napi_create_reference*(env: napi_env; value: napi_value;
                           initial_refcount: uint32; result: ptr napi_ref): napi_status {.
    importcpp: "napi_create_reference(@)", header: "node_api.h".}
##  Deletes a reference. The referenced value is released, and may
##  be GC'd unless there are other references to it.

proc napi_delete_reference*(env: napi_env; `ref`: napi_ref): napi_status {.
    importcpp: "napi_delete_reference(@)", header: "node_api.h".}
##  Increments the reference count, optionally returning the resulting count.
##  After this call the  reference will be a strong reference because its
##  refcount is >0, and the referenced object is effectively "pinned".
##  Calling this when the refcount is 0 and the object is unavailable
##  results in an error.

proc napi_reference_ref*(env: napi_env; `ref`: napi_ref; result: ptr uint32): napi_status {.
    importcpp: "napi_reference_ref(@)", header: "node_api.h".}
##  Decrements the reference count, optionally returning the resulting count.
##  If the result is 0 the reference is now weak and the object may be GC'd
##  at any time if there are no other references. Calling this when the
##  refcount is already 0 results in an error.

proc napi_reference_unref*(env: napi_env; `ref`: napi_ref; result: ptr uint32): napi_status {.
    importcpp: "napi_reference_unref(@)", header: "node_api.h".}
##  Attempts to get a referenced value. If the reference is weak,
##  the value might no longer be available, in that case the call
##  is still successful but the result is NULL.

proc napi_get_reference_value*(env: napi_env; `ref`: napi_ref; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_reference_value(@)", header: "node_api.h".}
proc napi_open_handle_scope*(env: napi_env; result: ptr napi_handle_scope): napi_status {.
    importcpp: "napi_open_handle_scope(@)", header: "node_api.h".}
proc napi_close_handle_scope*(env: napi_env; scope: napi_handle_scope): napi_status {.
    importcpp: "napi_close_handle_scope(@)", header: "node_api.h".}
proc napi_open_escapable_handle_scope*(env: napi_env;
                                      result: ptr napi_escapable_handle_scope): napi_status {.
    importcpp: "napi_open_escapable_handle_scope(@)", header: "node_api.h".}
proc napi_close_escapable_handle_scope*(env: napi_env;
                                       scope: napi_escapable_handle_scope): napi_status {.
    importcpp: "napi_close_escapable_handle_scope(@)", header: "node_api.h".}
proc napi_escape_handle*(env: napi_env; scope: napi_escapable_handle_scope;
                        escapee: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_escape_handle(@)", header: "node_api.h".}
##  Methods to support error handling

proc napi_throw*(env: napi_env; error: napi_value): napi_status {.
    importcpp: "napi_throw(@)", header: "node_api.h".}
proc napi_throw_error*(env: napi_env; code: cstring; msg: cstring): napi_status {.
    importcpp: "napi_throw_error(@)", header: "node_api.h".}
proc napi_throw_type_error*(env: napi_env; code: cstring; msg: cstring): napi_status {.
    importcpp: "napi_throw_type_error(@)", header: "node_api.h".}
proc napi_throw_range_error*(env: napi_env; code: cstring; msg: cstring): napi_status {.
    importcpp: "napi_throw_range_error(@)", header: "node_api.h".}
proc napi_is_error*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_is_error(@)", header: "node_api.h".}
##  Methods to support catching exceptions

proc napi_is_exception_pending*(env: napi_env; result: ptr bool): napi_status {.
    importcpp: "napi_is_exception_pending(@)", header: "node_api.h".}
proc napi_get_and_clear_last_exception*(env: napi_env; result: ptr napi_value): napi_status {.
    importcpp: "napi_get_and_clear_last_exception(@)", header: "node_api.h".}
##  Methods to work with array buffers and typed arrays

proc napi_is_arraybuffer*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_is_arraybuffer(@)", header: "node_api.h".}
proc napi_create_arraybuffer*(env: napi_env; byte_length: csize; data: ptr pointer;
                             result: ptr napi_value): napi_status {.
    importcpp: "napi_create_arraybuffer(@)", header: "node_api.h".}
proc napi_create_external_arraybuffer*(env: napi_env; external_data: pointer;
                                      byte_length: csize;
                                      finalize_cb: napi_finalize;
                                      finalize_hint: pointer;
                                      result: ptr napi_value): napi_status {.
    importcpp: "napi_create_external_arraybuffer(@)", header: "node_api.h".}
proc napi_get_arraybuffer_info*(env: napi_env; arraybuffer: napi_value;
                               data: ptr pointer; byte_length: ptr csize): napi_status {.
    importcpp: "napi_get_arraybuffer_info(@)", header: "node_api.h".}
proc napi_is_typedarray*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_is_typedarray(@)", header: "node_api.h".}
proc napi_create_typedarray*(env: napi_env; `type`: napi_typedarray_type;
                            length: csize; arraybuffer: napi_value;
                            byte_offset: csize; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_typedarray(@)", header: "node_api.h".}
proc napi_get_typedarray_info*(env: napi_env; typedarray: napi_value;
                              `type`: ptr napi_typedarray_type; length: ptr csize;
                              data: ptr pointer; arraybuffer: ptr napi_value;
                              byte_offset: ptr csize): napi_status {.
    importcpp: "napi_get_typedarray_info(@)", header: "node_api.h".}
proc napi_create_dataview*(env: napi_env; length: csize; arraybuffer: napi_value;
                          byte_offset: csize; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_dataview(@)", header: "node_api.h".}
proc napi_is_dataview*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_is_dataview(@)", header: "node_api.h".}
proc napi_get_dataview_info*(env: napi_env; dataview: napi_value;
                            bytelength: ptr csize; data: ptr pointer;
                            arraybuffer: ptr napi_value; byte_offset: ptr csize): napi_status {.
    importcpp: "napi_get_dataview_info(@)", header: "node_api.h".}
##  version management

proc napi_get_version*(env: napi_env; result: ptr uint32): napi_status {.
    importcpp: "napi_get_version(@)", header: "node_api.h".}
##  Promises

proc napi_create_promise*(env: napi_env; deferred: ptr napi_deferred;
                         promise: ptr napi_value): napi_status {.
    importcpp: "napi_create_promise(@)", header: "node_api.h".}
proc napi_resolve_deferred*(env: napi_env; deferred: napi_deferred;
                           resolution: napi_value): napi_status {.
    importcpp: "napi_resolve_deferred(@)", header: "node_api.h".}
proc napi_reject_deferred*(env: napi_env; deferred: napi_deferred;
                          rejection: napi_value): napi_status {.
    importcpp: "napi_reject_deferred(@)", header: "node_api.h".}
proc napi_is_promise*(env: napi_env; promise: napi_value; is_promise: ptr bool): napi_status {.
    importcpp: "napi_is_promise(@)", header: "node_api.h".}
##  Running a script

proc napi_run_script*(env: napi_env; script: napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_run_script(@)", header: "node_api.h".}
##  Memory management

proc napi_adjust_external_memory*(env: napi_env; change_in_bytes: int64;
                                 adjusted_value: ptr int64): napi_status {.
    importcpp: "napi_adjust_external_memory(@)", header: "node_api.h".}
when defined(NAPI_EXPERIMENTAL):
  ##  Dates
  proc napi_create_date*(env: napi_env; time: cdouble; result: ptr napi_value): napi_status {.
      importcpp: "napi_create_date(@)", header: "node_api.h".}
  proc napi_is_date*(env: napi_env; value: napi_value; is_date: ptr bool): napi_status {.
      importcpp: "napi_is_date(@)", header: "node_api.h".}
  proc napi_get_date_value*(env: napi_env; value: napi_value; result: ptr cdouble): napi_status {.
      importcpp: "napi_get_date_value(@)", header: "node_api.h".}
  ##  BigInt
  proc napi_create_bigint_int64*(env: napi_env; value: int64;
                                result: ptr napi_value): napi_status {.
      importcpp: "napi_create_bigint_int64(@)", header: "node_api.h".}
  proc napi_create_bigint_uint64*(env: napi_env; value: uint64;
                                 result: ptr napi_value): napi_status {.
      importcpp: "napi_create_bigint_uint64(@)", header: "node_api.h".}
  proc napi_create_bigint_words*(env: napi_env; sign_bit: cint; word_count: csize;
                                words: ptr uint64; result: ptr napi_value): napi_status {.
      importcpp: "napi_create_bigint_words(@)", header: "node_api.h".}
  proc napi_get_value_bigint_int64*(env: napi_env; value: napi_value;
                                   result: ptr int64; lossless: ptr bool): napi_status {.
      importcpp: "napi_get_value_bigint_int64(@)", header: "node_api.h".}
  proc napi_get_value_bigint_uint64*(env: napi_env; value: napi_value;
                                    result: ptr uint64; lossless: ptr bool): napi_status {.
      importcpp: "napi_get_value_bigint_uint64(@)", header: "node_api.h".}
  proc napi_get_value_bigint_words*(env: napi_env; value: napi_value;
                                   sign_bit: ptr cint; word_count: ptr csize;
                                   words: ptr uint64): napi_status {.
      importcpp: "napi_get_value_bigint_words(@)", header: "node_api.h".}
  proc napi_add_finalizer*(env: napi_env; js_object: napi_value;
                          native_object: pointer; finalize_cb: napi_finalize;
                          finalize_hint: pointer; result: ptr napi_ref): napi_status {.
      importcpp: "napi_add_finalizer(@)", header: "node_api.h".}
  ##  Instance data
  proc napi_set_instance_data*(env: napi_env; data: pointer;
                              finalize_cb: napi_finalize; finalize_hint: pointer): napi_status {.
      importcpp: "napi_set_instance_data(@)", header: "node_api.h".}
  proc napi_get_instance_data*(env: napi_env; data: ptr pointer): napi_status {.
      importcpp: "napi_get_instance_data(@)", header: "node_api.h".}