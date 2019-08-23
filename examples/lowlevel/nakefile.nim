import nake
import os
import sequtils
import strformat
import nodeaddonpkg/libutil

const
  nimbuildpath = "nimbuild"
  csrcpath = nimbuildpath/"csrc"
  deploypath = "native"
  mainsrc = "nimsrc"/"main.nim"

task defaultTask, "Build the native addon":
  runTask "build"

task "build", "Build the native addon":
  createDir(csrcpath)
  var compile_args:seq[string]
  compile_args.add([findExe"nim", "cpp",
    "--compileOnly",
    "--gc:regions",
    # "--threads:on",
    "--nimcache:"&csrcpath,
    "--header"])
  when defined(windows):
    compile_args.add(["--cc:vcc", "--verbosity:2"])
  compile_args.add(mainsrc)
  echo "compile_args: ", compile_args
  direShell(compile_args)

  if not existsFile(csrcpath/"nimbase.h"):
    writeFile(csrcpath/"nimbase.h", NIMBASE)
  direShell "node-gyp", "rebuild"
  let node_files = toSeq(walkDir("build"/"Release")).mapIt(it.path).filterIt(it.endsWith(".node"))
  createDir(deploypath)
  for node_file in node_files:
    copyFile(node_file, deploypath/(node_file.extractFilename))

task "clean", "Remove all built files":
  removeDir nimbuildpath
  removeDir deploypath
  removeDir "build"

task "test", "Test the native addon":
  runTask "build"
  direShell "node", "tests"/"test.js"
