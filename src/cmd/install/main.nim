import std/[strutils , os]
import ../../common
import ../download
import zip , cab

proc cmdInstall*() {.inline.} =
  let tmpDir = getTempDir() / appName
  if dirExists(tmpDir):
    removeDir(tmpDir)
  discard existsOrCreateDir(tmpDir)
  discard existsOrCreateDir(appDir)

  let
    package = findPackage(commandLineParams()[1])
    fileName = package.cmdDownload(tmpDir)
    extension = fileName.substr(fileName.rfind(".") + 1)
  case extension
  of "zip":
    package.installZip(tmpDir , fileName)
  of "cab":
    package.installCab(fileName)
  else:
    showErr("Unknown extension" & extension.quote)