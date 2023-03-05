from std/sequtils import toSeq
from std/os import fileExists
import std/[tables , json , strutils]
import liblim/logging
import ../common

proc cmdRepo*() =
  if cmdParamCount == 1:
    var table:Table[string , string]
    for url in getRepositries():
      let fields = url.getJsonNode.getFields
      for key , jsonObj in fields:
        table[key] = url
    for key , value in table:
      printInfo(key.quote & ":" & value.quote)
  elif cmdParamCount != 2:
    case cmdParams[1]
    of "add":
      let file = fmAppend.openRepoFile
      for i in 2..(cmdParamCount - 1):
        let jsonUrl = cmdParams[i]
        for package in jsonUrl.getPackages:
          printLog("Found package" & package.name.quote & "in" & jsonUrl.quote)
          file.write("\n")
          file.write(jsonUrl)
      file.close
    of "remove":
      if not repoFilePath.fileExists:
        printErr("Nothing to remove")
      else:
        var repositries:OrderedTable[string , string] = initOrderedTable[string , string]()
        for url in getRepositries():
          for key in url.getJsonNode.getFields.keys:
            repositries[url] = key
        for i in 1..(cmdParamCount - 1):
          let param = cmdParams[1].toLower
          if param == "official":
            printErr("You can't remove official repositry")
            quit()
          var exist = false
          for key , value in repositries:
            if param == value:
              exist = true
              repositries.del(key)
          if not exist:
            printErr("Repositry" & cmdParams[i].quote & "isn't exist")
            quit()
        let file = fmWrite.openRepoFile
        file.write(repositries.values.toSeq.join("\n"))
        file.close
    else:
      printErr("Unknown option" & cmdParams[1].quote)