# Package

version       = "0.1.0"
author        = "Matt Haggard"
description   = "Makes making node addons nicer"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["nodeaddon"]


# Dependencies

requires "nim >= 0.19.4"
