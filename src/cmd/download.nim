import std/[streams , os]
import liblim/logging
import ../common

proc dlPkg*(package:Package , dir:string):string =
  let fileName = dir / package.name & ".zip"
  printProcess("Opening file" & fileName.quote)
  var strm:Stream
  try:
    strm = openFileStream(fileName , fmWrite)
  except IOError:
    printFailed()
    printExc("Unable to open file" & fileName.quote)
    quit()
  printDone()
  strm.write(connect(package.url))
  strm.close()
  return fileName

proc cmdDownload*() {.inline.} =
  var
    dlDir:string
    pkgName:string
  case cmdParamCount
  of 1:
    printErr.printFew()
    quit()
  of 2:
    dlDir = getCurrentDir()
    pkgName = cmdParams[1]
  of 4:
    if cmdParams[1] == "-d" or cmdParams[1] == "--dir":
      dlDir = cmdParams[2]
      pkgName = cmdParams[3]
    else:
      printErr.printMany
      quit()
  else:
    printErr.printMany()
    quit()

  discard dlPkg(findPackage(pkgName) , dlDir)