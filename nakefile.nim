import os
import nake
import strformat
import sequtils
import re
import algorithm


task "functest", "Run the functional tests":
  withDir("examples"/"lowlevel"):
    direShell "nake", "test"

const linuxbuildertag = "nimnodeaddon:builder"

task "dockerbuild", "Create a Travis-like docker image for testing linux":
  direShell "docker", "build", "--file", "linux.Dockerfile", "--tag", linuxbuildertag, "."

task "linuxtest", "Run tests in linux container":
  runTask "dockerbuild"
  direShell "docker", "run", "--rm", "-it", "-v", getCurrentDir() & ":/code", linuxbuildertag, "./runtests.sh"

const headers = @["js_native_api", "js_native_api_types", "node_api", "node_api_types"]
const REPO_URL = "https://raw.githubusercontent.com/nodejs/node/master/src"

task "download", "Download the Node header files this lib is based on":
  for name in headers:
    let
      url = REPO_URL & "/" & name & ".h"
      dst = "orig"/name & ".h"
    echo &"downloading from {url} to {dst}"
    direShell "curl", url, "-o", dst

const prefix = """
#ifdef C2NIM
# def NAPI_EXTERN
# def EXTERN_C_START
# def EXTERN_C_END
# def EXTERN
# def NAPI_NO_RETURN
# def BUILDING_NODE_EXTENSION
# def NAPI_MODULE_EXPORT
#endif
"""

task "modify", "Modify the header files to be converted":
  withDir("orig"):
    for name in headers:
      let fname = name & ".h"
      echo &"Modifying {fname} ..."
      var lines:seq[string]
      var guts = readFile(fname)
      if not ("C2NIM" in guts):
        lines.add(prefix)
        echo "- Added c2nim prefix."
        lines.add(&"# header \"node_api.h\"")
      for line in guts.splitLines():
        lines.add(line)

      var toremove:seq[int]
      var removeuntil:string
      for i,line in lines:
        if "typedef uint16_t char16_t" in line:
          if lines[i-1].startsWith("#if"):
            toremove.add(i+1)
            toremove.add(i)
            toremove.add(i-1)
        if name == "node_api":
          if line.startsWith("#ifdef BUILDING_NODE_EXTENSION"):
            removeuntil = "#endif"
          elif line.startsWith("#ifdef __GNUC__"):
            removeuntil = "#endif"
          elif line.startsWith("#ifdef _WIN32"):
            removeuntil = "#endif"
          elif line.startsWith("#define NAPI_MODULE_VERSION  1"):
            toremove.add(i)
          elif line.startsWith("#if defined(_MSC_VER)"):
            removeuntil = "#endif"
          elif line.startsWith("#define NAPI_MODULE"):
            removeuntil = "EXTERN_C_START"

        if removeuntil != "":
          toremove.add(i)
          if line.startsWith(removeuntil):
            removeuntil = ""
        
      toremove.sort()
      toremove.reverse()
      for i in toremove:
        echo &"- Removing line: {i}: ", lines[i]
        lines.delete(i)
      writeFile(fname, lines.join("\n"))

task "convert", "Convert the header files to Nim files":
  runTask "modify"
  withDir("orig"):
    for name in headers:
      let src = &"{name}.h"
      echo &"\LConverting {src} ..."
      direShell(
        "c2nim",
        "--cpp",
        # "--assumedef:NAPI_EXTERN",
        # "--assumendef:_WIN32",
        # "--assumendef:__cplusplus",
        # "--assumendef:EXTERN_C_START",
        # "--skipinclude",
        "--header",
        # "--header:\"" & name & ".h\"",
        src
      )
      let nimfile = &"{name}.nim"
      var guts = readFile(nimfile)
      guts = guts.replace("uint32_t", "uint32").replace("int32_t", "int32").replace("int64_t", "int64").replace("char16_t", "Utf16Char").replace("uint64_t", "uint64")
      guts = guts.replace("const\n  NAPI_AUTO_LENGTH* = SIZE_MAX", """
when sizeof(int) == 4: # 32bit
  const
    NAPI_AUTO_LENGTH*: csize = 2147483647 # cast[uint32](-1).csize
else:
  const
    NAPI_AUTO_LENGTH*: csize = cast[uint64](-1).csize
""")
      var lines = guts.splitLines()
      for i,line in lines:
        if "napi_callback* = proc" in line:
          lines[i] = line & " {.closure,cdecl.}"
        elif "napi_finalize* = proc" in line:
          lines[i] = line & " {.closure,cdecl.}"
        elif line.endsWith("__") and "= ptr" in line:
          var varname = line.split("*")[0].strip()
          lines[i] = "  " & varname & "* {.importcpp: \"" & varname & "\", header: \"node_api.h\" .} = pointer"
        elif "napi_get_last_error_info(@)" in line:
          lines[i] = line.replace("@", "#, (const napi_extended_error_info **) #")
      writeFile(nimfile, lines.join("\n"))
  for name in headers:
    copyFile("orig" / &"{name}.nim", "src" / "nodeaddonpkg" / &"{name}.nim")
