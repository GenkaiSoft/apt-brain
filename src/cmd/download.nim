import std/[strutils , streams]
from os import `/`
import ../common

proc cmdDownload*(package:Package , dir:string):string {.inline.} =
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