import os
import nake


task "functest", "Run the functional tests":
  withDir("examples"/"lowlevel"):
    direShell "nake", "test"