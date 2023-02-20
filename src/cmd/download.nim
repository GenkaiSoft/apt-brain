import std/[strutils , streams , os]
import ../common

proc dlPkg*(package:Package , dir:string):string =
  let fileName = dir / package.url.substr(package.url.rfind("/") + 1)
  showProcess("Opening file" & fileName.quote)
  var strm:Stream
  try:
    strm = openFileStream(fileName , fmWrite)
  except IOError:
    showFailed()
    showExc("Unable to open file" & fileName.quote)
    quit()
  showDone()
  strm.write(connect(package.url))
  strm.close()
  return fileName

proc cmdDownload*() {.inline.} =
  var
    dlDir:string
    pkgName:string
  case cmdParamCount
  of 1:
    showErr.showFew()
    quit()
  of 2:
    dlDir = getCurrentDir()
    pkgName = cmdParams[1]
  of 4:
    if cmdParams[1] == "-d" or cmdParams[1] == "--dir":
      dlDir = cmdParams[2]
      pkgName = cmdParams[3]
    else:
      showErr.showMany
      quit()
  else:
    showErr.showMany()
    quit()

  discard dlPkg(findPackage(pkgName) , dlDir)