import std/[strutils , streams , os]
import zippy/ziparchives
import ../../common

proc installZip*(listUrl , zipFileName:string) =
  let list = connect(listUrl)
  if list != "":
    let reader = openZipArchive(zipFileName)
    for files in split(list , "\n"):
      for path in split(files , ","):
        var dir:string = appDir
        for subDir in split(path , "/"):
          dir = dir / subDir
          createDir(dir)
          let fileName = dir / path.substr(path.rfind("/") + 1)
          showProcess("Opening file \"" & fileName & "\"")
          var strm:Stream
          try:
            strm = openFileStream(fileName)
          except IOError:
            showFailed()
            showExc("Unable to open file \"" & fileName & "\"")
          showDone()
          showProcess("Writing file \"" & fileName & "\"")
          try:
            strm.write(reader.extractFile(path))
          except ZippyError:
            showFailed()
            showExc("Unable to extract file \"" & path[0] & "\"")