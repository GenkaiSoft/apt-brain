import std/[strutils , os]
import zippy/ziparchives
import ../../common

proc installZip*(package:Package , fileName:string) {.inline.} =
  try:
    extractAll(fileName , appDir)
  except ZippyError:
    showExc("zipfile" & fileName.quote & "is broken")
  for delete in package.delete:
    let del = appDir / delete
    if delete.substr(delete.len - 1) == "/":
      removeDir(del)
    else:
      removeFile(del)