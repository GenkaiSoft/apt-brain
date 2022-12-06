import std/[strutils , streams , os]
import zippy/ziparchives
import ../../common

proc installZip*(listUrl , zipFileName:string) {.inline.} =
  let list = connect(listUrl)
  if list != "":
    let reader = openZipArchive(zipFileName)
    for line in split(list , "\n"):
      let
        path = split(line , ",")
        inputFileName = appDir / path[0]
        outputFileName = appDir / path[1]
      try:
        showProcess("Opening file \"" & inputFileName & "\"")
        let strm = openFileStream(inputFileName)
        showDone()
        showProcess("Writing file \"" & outputFileName & "\"")
        strm.write(reader.extractFile(path[0]))
        strm.close()
      except IOError:
        showExc("Unable to open file \"" & inputFileName & "\"")
      except ZippyError:
