import nake
import os
import sequtils
import strformat

task defaultTask, "Build the native addon":
  runTask "build"

task "build", "Build the native addon":
  var compile_args:seq[string]
  compile_args.add([findExe"nim", "cpp", "--compileOnly", "--gc:regions", "--nimcache:"&"native"/"csrc", "--header"])
  when defined(windows):
    compile_args.add(["--cc:vcc", "--verbosity:2"])
  compile_args.add("native"/"main.nim")
  direShell(compile_args)

  copyFile("native"/"nimbase.h", "native"/"csrc"/"nimbase.h")
  direShell "node-gyp", "rebuild"
  let node_files = toSeq(walkDir("build"/"Release")).mapIt(it.path).filterIt(it.endsWith(".node"))
  for node_file in node_files:
    copyFile(node_file, "native"/(node_file.extractFilename))

task "clean", "Remove all built files":
  removeDir "build"
  removeDir "native"/"csrc"
  let node_files = toSeq(walkDir("native")).mapIt(it.path).filterIt(it.endsWith(".node"))
  for node_file in node_files:
    removeFile(node_file)

task "test", "Test the native addon":
  runTask "build"
  direShell "node", "tests"/"test.js"