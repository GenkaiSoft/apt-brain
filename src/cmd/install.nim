import std/os
import ../common
import download
import zippy/ziparchives

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
    tmp = tmpDir / package.name
  showProcess("Extracting zip file" & fileName & "to" & tmp)
  try:
    extractAll(fileName , tmp)
  except ZippyError:
    showFailed()
    showExc("Unable to extract zip file" & fileName & "to" & tmp)
    quit()
  showDone()

  for delete in package.delete:
    let del = tmp / package.dir.input / delete
    if delete.substr(delete.len - 1) == "/":
      removeDir(del)
    else:
      removeFile(del)
  let
    source = tmp / package.dir.input
    dest = insDir / package.dir.output
  showProcess("Moving directory" & source.quote & "to" & dest.quote)
  try:
    moveDir(source , dest)
  except OSError:
    showFailed()
    showExc("Unable to move directory" & source.quote & "to" & dest.quote)
  showDone()