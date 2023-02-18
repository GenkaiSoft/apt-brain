import std/os
import zippy/ziparchives
import ../../common

proc installZip*(package:Package , tmpDir , fileName:string) {.inline.} =
  let tmp = tmpDir / package.name
  showProcess("Extracting zip file" & fileName & "to" & tmp)
  try:
    extractAll(fileName , tmp)
  except ZippyError:
    showFailed()
    showExc("Unable to extract zip file" & fileName & "to" & tmp)
    quit()
  showDone()

  for delete in package.delete:
    let del = tmp / delete
    if delete.substr(delete.len - 1) == "/":
      removeDir(del)
    else:
      removeFile(del)
  let
    source = tmp / package.dir.input
    dest = appDir / package.dir.output
  showProcess("Moving directory" & source & "to" & dest.quote)
  try:
    moveDir(source , dest)
  except OSError:
    showFailed()
    showExc("Unable to move directory" & source.quote & "to" & dest.quote)
  showDone()