import nake
import os
import sequtils
import strformat

task defaultTask, "Build the native addon":
  runTask "build"

task "build", "Build the native addon":
  direShell findExe"nim", "cpp", "--compileOnly", "--gc:regions", "--nimcache:"&"native"/"csrc", "--header", "native"/"main.nim"
  copyFile("native"/"nimbase.h", "native"/"csrc"/"nimbase.h")
  direShell findExe"node-gyp", "rebuild"
  let node_files = toSeq(walkDir("build"/"Release")).mapIt(it.path).filterIt(it.endsWith(".node"))
  for node_file in node_files:
    copyFile(node_file, "native"/(node_file.extractFilename))
  # js_files = ts_files.mapIt(it.replace(".ts", ".js").replace("jssrc"/"", "dist"/""))
  # copyFile("build"/"Release"/"index.node", "native"/"index.node")

task "clean", "Remove all built files":
  removeDir "build"
  removeDir "native"/"csrc"
  let node_files = toSeq(walkDir("native")).mapIt(it.path).filterIt(it.endsWith(".node"))
  for node_file in node_files:
    removeFile(node_file)

task "test", "Test the native addon":
  runTask "build"
  direShell findExe"node", "tests"/"test.js"