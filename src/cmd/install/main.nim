import std/os
import ../../common
import ../download
import zip

proc cmdInstall*() {.inline.} =
  var
    insDir:string
    pkgName:string
  case cmdParamCount
  of 1:
    showErr.showFew()
    quit()
  of 2:
    insDir = appDir
    pkgName = cmdParams[1]
  of 4:
    if cmdParams[1] == "-d" or cmdParams[1] == "--dir":
      insDir = cmdParams[2]
      pkgName = cmdParams[3]
    else:
      showErr.showMany()
      quit()
  else:
    showErr.showMany()
    quit()

  let tmpDir = getTempDir() / appName
  if dirExists(tmpDir):
    removeDir(tmpDir)
  discard existsOrCreateDir(tmpDir)
  discard existsOrCreateDir(insDir)

  let
    package = findPackage(pkgName)
    fileName = package.dlPkg(tmpDir)
  package.installZip(tmpDir , insDir , fileName)