import
  ./js_native_api, ./node_api_types

discard "forward decl of uv_loop_s"

type
  uv_loop_s = object  
  napi_addon_register_func* = proc (env: napi_env; exports: napi_value): napi_value
  napi_module* {.importcpp: "napi_module", header: "node_api.h", bycopy.} = object
    nm_version* {.importc: "nm_version".}: cint
    nm_flags* {.importc: "nm_flags".}: cuint
    nm_filename* {.importc: "nm_filename".}: cstring
    nm_register_func* {.importc: "nm_register_func".}: napi_addon_register_func
    nm_modname* {.importc: "nm_modname".}: cstring
    nm_priv* {.importc: "nm_priv".}: pointer
    reserved* {.importc: "reserved".}: array[4, pointer]


proc napi_module_register*(`mod`: ptr napi_module) {.
    importcpp: "napi_module_register(@)", header: "node_api.h".}
proc napi_fatal_error*(location: cstring; location_len: csize; message: cstring;
                      message_len: csize) {.importcpp: "napi_fatal_error(@)",
    header: "node_api.h".}
##  Methods for custom handling of async operations

proc napi_async_init*(env: napi_env; async_resource: napi_value;
                     async_resource_name: napi_value;
                     result: ptr napi_async_context): napi_status {.
    importcpp: "napi_async_init(@)", header: "node_api.h".}
proc napi_async_destroy*(env: napi_env; async_context: napi_async_context): napi_status {.
    importcpp: "napi_async_destroy(@)", header: "node_api.h".}
proc napi_make_callback*(env: napi_env; async_context: napi_async_context;
                        recv: napi_value; `func`: napi_value; argc: csize;
                        argv: ptr napi_value; result: ptr napi_value): napi_status {.
    importcpp: "napi_make_callback(@)", header: "node_api.h".}
##  Methods to provide node::Buffer functionality with napi types

proc napi_create_buffer*(env: napi_env; length: csize; data: ptr pointer;
                        result: ptr napi_value): napi_status {.
    importcpp: "napi_create_buffer(@)", header: "node_api.h".}
proc napi_create_external_buffer*(env: napi_env; length: csize; data: pointer;
                                 finalize_cb: napi_finalize;
                                 finalize_hint: pointer; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_external_buffer(@)", header: "node_api.h".}
proc napi_create_buffer_copy*(env: napi_env; length: csize; data: pointer;
                             result_data: ptr pointer; result: ptr napi_value): napi_status {.
    importcpp: "napi_create_buffer_copy(@)", header: "node_api.h".}
proc napi_is_buffer*(env: napi_env; value: napi_value; result: ptr bool): napi_status {.
    importcpp: "napi_is_buffer(@)", header: "node_api.h".}
proc napi_get_buffer_info*(env: napi_env; value: napi_value; data: ptr pointer;
                          length: ptr csize): napi_status {.
    importcpp: "napi_get_buffer_info(@)", header: "node_api.h".}
##  Methods to manage simple async operations

proc napi_create_async_work*(env: napi_env; async_resource: napi_value;
                            async_resource_name: napi_value;
                            execute: napi_async_execute_callback;
                            complete: napi_async_complete_callback; data: pointer;
                            result: ptr napi_async_work): napi_status {.
    importcpp: "napi_create_async_work(@)", header: "node_api.h".}
proc napi_delete_async_work*(env: napi_env; work: napi_async_work): napi_status {.
    importcpp: "napi_delete_async_work(@)", header: "node_api.h".}
proc napi_queue_async_work*(env: napi_env; work: napi_async_work): napi_status {.
    importcpp: "napi_queue_async_work(@)", header: "node_api.h".}
proc napi_cancel_async_work*(env: napi_env; work: napi_async_work): napi_status {.
    importcpp: "napi_cancel_async_work(@)", header: "node_api.h".}
##  version management

proc napi_get_node_version*(env: napi_env; version: ptr ptr napi_node_version): napi_status {.
    importcpp: "napi_get_node_version(@)", header: "node_api.h".}
when NAPI_VERSION >= 2:
  ##  Return the current libuv event loop for a given environment
  proc napi_get_uv_event_loop*(env: napi_env; loop: ptr ptr uv_loop_s): napi_status {.
      importcpp: "napi_get_uv_event_loop(@)", header: "node_api.h".}
when NAPI_VERSION >= 3:
  proc napi_fatal_exception*(env: napi_env; err: napi_value): napi_status {.
      importcpp: "napi_fatal_exception(@)", header: "node_api.h".}
  proc napi_add_env_cleanup_hook*(env: napi_env; fun: proc (arg: pointer); arg: pointer): napi_status {.
      importcpp: "napi_add_env_cleanup_hook(@)", header: "node_api.h".}
  proc napi_remove_env_cleanup_hook*(env: napi_env; fun: proc (arg: pointer);
                                    arg: pointer): napi_status {.
      importcpp: "napi_remove_env_cleanup_hook(@)", header: "node_api.h".}
  proc napi_open_callback_scope*(env: napi_env; resource_object: napi_value;
                                context: napi_async_context;
                                result: ptr napi_callback_scope): napi_status {.
      importcpp: "napi_open_callback_scope(@)", header: "node_api.h".}
  proc napi_close_callback_scope*(env: napi_env; scope: napi_callback_scope): napi_status {.
      importcpp: "napi_close_callback_scope(@)", header: "node_api.h".}
when NAPI_VERSION >= 4:
  ##  Calling into JS from other threads
  proc napi_create_threadsafe_function*(env: napi_env; `func`: napi_value;
                                       async_resource: napi_value;
                                       async_resource_name: napi_value;
                                       max_queue_size: csize;
                                       initial_thread_count: csize;
                                       thread_finalize_data: pointer;
                                       thread_finalize_cb: napi_finalize;
                                       context: pointer; call_js_cb: napi_threadsafe_function_call_js;
                                       result: ptr napi_threadsafe_function): napi_status {.
      importcpp: "napi_create_threadsafe_function(@)", header: "node_api.h".}
  proc napi_get_threadsafe_function_context*(`func`: napi_threadsafe_function;
      result: ptr pointer): napi_status {.importcpp: "napi_get_threadsafe_function_context(@)",
                                      header: "node_api.h".}
  proc napi_call_threadsafe_function*(`func`: napi_threadsafe_function;
                                     data: pointer; is_blocking: napi_threadsafe_function_call_mode): napi_status {.
      importcpp: "napi_call_threadsafe_function(@)", header: "node_api.h".}
  proc napi_acquire_threadsafe_function*(`func`: napi_threadsafe_function): napi_status {.
      importcpp: "napi_acquire_threadsafe_function(@)", header: "node_api.h".}
  proc napi_release_threadsafe_function*(`func`: napi_threadsafe_function; mode: napi_threadsafe_function_release_mode): napi_status {.
      importcpp: "napi_release_threadsafe_function(@)", header: "node_api.h".}
  proc napi_unref_threadsafe_function*(env: napi_env;
                                      `func`: napi_threadsafe_function): napi_status {.
      importcpp: "napi_unref_threadsafe_function(@)", header: "node_api.h".}
  proc napi_ref_threadsafe_function*(env: napi_env;
                                    `func`: napi_threadsafe_function): napi_status {.
      importcpp: "napi_ref_threadsafe_function(@)", header: "node_api.h".}