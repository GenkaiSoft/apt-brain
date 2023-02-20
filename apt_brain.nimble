# Package

version          = "1.1.0"
author           = "777shuang"
description      = "apt for SHARP Brain"
license          = "GPL-3.0-or-later"
srcDir           = "src"
namedBin["main"] = "apt-brain"

# Dependencies

requires "nim >= 1.4.2"
requires "puppy >= 1.6.0"
requires "zippy >= 0.10.4"

# Skips
skipFiles = @["package.json"]
skipDirs = @["packages"]

# Tasks
task build_win , "Cross compile for windows":
  exec "nimble build -d:release -d:mingw --cpu:amd64"
  exec "zip apt-brain_windows_x64 apt-brain.exe"
  exec "nimble build -d:release -d:mingw --cpu:i386"
  exec "zip apt-brain_windows_x86 apt-brain.exe"
  exec "rm apt-brain.exe"