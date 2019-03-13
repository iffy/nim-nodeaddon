# Package

version       = "0.1.0"
author        = "Matt Haggard"
description   = "Library for making NodeJS addons in Nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["nodeaddon"]


# Dependencies

requires "nim >= 0.19.4"
