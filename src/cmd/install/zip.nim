import std/[strutils , streams , os]
import zippy
import ../../common

proc installZip*(package:Package) {.inline.} =
  let fileName = package.url.substr(package.url.rfind("/") + 1)
  var strm:Stream
  try:
    strm = openFileStream(fileName)
  except OSError:
    showExc("Unable to open file" & fileName.quote)
  strm.write(package.url.connect) 
  strm.close()
