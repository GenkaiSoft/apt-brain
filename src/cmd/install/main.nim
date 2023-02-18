import std/[strutils , os]
import ../../common
import ../download
import zip , cab

proc cmdInstall*() {.inline.} =
  let
    package = findPackage(commandLineParams()[1])
    fileName = package.cmdDownload(getTempDir())
    extension = fileName.substr(fileName.rfind(".") + 1)
  case extension
  of "zip":
    package.installZip(fileName)
  of "cab":
    package.installCab(fileName)
  else:
    showErr("Unknown extension" & extension.quote)