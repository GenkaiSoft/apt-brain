# Package

version          = "0.2.2"
author           = "777shuang"
description      = "apt for SHARP Brain"
license          = "GPL-3.0-or-later"
srcDir           = "src"
namedBin["main"] = "apt-brain"

# Dependencies

requires "nim >= 1.6.8"
requires "puppy >= 1.6.0"
requires "zippy >= 0.10.4"

# Skipes
skipDirs  = "packages"
skipFile = "list.csv"
