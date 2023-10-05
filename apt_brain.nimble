# Package

version = "1.5.3"
author = "777shuang"
description = "apt for SHARP Brain"
license = "GPL-3.0-or-later"
srcDir = "src"
namedBin["main"] = "apt-brain"

# Dependencies

requires "nim >= 1.4.2"
requires "puppy"
requires "zippy"
requires "https://github.com/777shuang/Lim == 0.2.0"

# Skips
skipFiles = @["package.json"]

# Tasks
task build_win , "Cross compile for windows":
  exec "nimble build -d:release -d:mingw --cpu:amd64"
  exec "zip apt-brain.windows.x86_64.zip apt-brain.exe LICENSE.txt"
  exec "nimble build -d:release -d:mingw --cpu:i386"
  exec "zip apt-brain.windows.i686.zip apt-brain.exe LICENSE.txt"
  exec "rm apt-brain.exe"