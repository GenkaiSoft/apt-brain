import std/[strutils , streams]
import zippy/ziparchives
import ../../common

proc installZip*(package:Package) {.inline.} =
  let fileName = package.url.substr(package.url.rfind("/") + 1)
  var strm :Stream
  try:
    strm = openFileStream(fileName)
  except OSError:
    showExc("Unable to open file" & fileName.quote)
  strm.write(package.url.connect) 
  strm.close()
  try:
    let reader = openZipArchive(fileName)
    for file in 0..package.input.len:
      try:
        strm = openFileStream(package.output[file])
      except OSError:
        showExc("Failed to open file" & package.output[file].quote)
      strm.write(reader.extractFile(package.output[file]))
      strm.close()
  except ZippyError:
    showExc("zipfile" & fileName.quote & "is broken")