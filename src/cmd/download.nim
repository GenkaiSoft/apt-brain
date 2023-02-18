import std/[os , streams , strutils]
import ../common

proc cmdDownload*(package:Package , dir:string):string =
  let fileName = dir / package.url.substr(package.url.rfind("/") + 1)
  var strm:Stream
  try:
    strm = openFileStream(fileName , fmWrite)
  except IOError:
    showExc("Unable to open file" & fileName.quote)
    quit()
  strm.write(connect(package.url))
  strm.close()
  return fileName