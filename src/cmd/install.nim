import std/os
import liblim/logging
import ../common
import download
import zippy/ziparchives

proc cmdInstall*() {.inline.} =
  var
    insDir:string
    pkgName:string
  case cmdParamCount
  of 1:
    printErr.printFew()
    quit()
  of 2:
    insDir = appDir
    pkgName = cmdParams[1]
  of 4:
    if cmdParams[1] == "-d" or cmdParams[1] == "--dir":
      insDir = cmdParams[2]
      pkgName = cmdParams[3]
    else:
      printErr.printMany()
      quit()
  else:
    printErr.printMany()
    quit()

  let tmpDir = getTempDir() / appName
  if dirExists(tmpDir):
    printProcess("Removing directory" & tmpDir.quote)
    removeDir(tmpDir)
  discard existsOrCreateDir(tmpDir)
  discard existsOrCreateDir(insDir)

  let
    package = findPackage(pkgName)
    fileName = package.dlPkg(tmpDir)
    tmp = tmpDir / package.name
  printProcess("Extracting zip file" & fileName.quote & "to" & tmp)
  try:
    extractAll(fileName , tmp)
  except ZippyError:
    printFailed()
    printExc("Unable to extract zip file" & fileName.quote & "to" & tmp)
    quit()
  printDone()

  for delete in package.delete:
    let del = tmp / package.dir.input / delete
    if delete.substr(delete.len - 1) == "/":
      printProcess("Removing directory" & del.quote)
      try:
        removeDir(del)
      except OSError:
        printFailed()
        printExc("Unable to remove directory" & del.quote)
        quit()
      printDone()
    else:
      printProcess("Removing file" & del.quote)
      try:
        removeFile(del)
      except OSError:
        printFailed()
        printExc("Unable to remove file" & del.quote)
      printDone()
  let
    source = tmp / package.dir.input
    dest = insDir / package.dir.output
  printProcess("Moving directory" & source.quote & "to" & dest.quote)
  try:
    moveDir(source , dest)
  except OSError:
    printFailed()
    printExc("Unable to move directory" & source.quote & "to" & dest.quote)
  printDone()