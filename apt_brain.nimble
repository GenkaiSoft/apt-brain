# Package

version = "1.3.2"
author = "777shuang"
description = "apt for SHARP Brain"
license = "GPL-3.0-or-later"
srcDir = "src"
namedBin["main"] = "apt-brain"

# Dependencies

requires "nim >= 1.4.2"
requires "puppy >= 1.6.0"
requires "zippy >= 0.10.4"
requires "https://github.com/777shuang/Lim"

# Skips
skipFiles = @["package.json" , "package.nim"]

# Tasks
task build_win , "Cross compile for windows":
  exec "nimble build -d:release -d:mingw --cpu:amd64"
  exec "zip apt-brain.windows.x86_64.zip apt-brain.exe LICENSE.txt"
  exec "nimble build -d:release -d:mingw --cpu:i386"
  exec "zip apt-brain.windows.i686.zip apt-brain.exe LICENSE.txt"
  exec "rm apt-brain.exe"