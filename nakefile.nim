import os
import nake


task "functest", "Run the functional tests":
  withDir("examples"/"lowlevel"):
    direShell "nake", "test"

const linuxbuildertag = "nimnodeaddon:builder"

task "dockerbuild", "Create a Travis-like docker image for testing linux":
  direShell "docker", "build", "--file", "linux.Dockerfile", "--tag", linuxbuildertag, "."

task "linuxtest", "Run tests in linux container":
  runTask "dockerbuild"
  direShell "docker", "run", "--rm", "-it", "-v", getCurrentDir() & ":/code", linuxbuildertag, "./runtests.sh"