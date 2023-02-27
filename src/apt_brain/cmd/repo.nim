import std/[tables , json]
import liblim/logging
import ../common

proc cmdRepo*() {.inline.} =
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
      let
        file = openRepoFile(fmAppend)
      for i in 2..(cmdParamCount - 1):
        let jsonUrl = cmdParams[i]
        for package in jsonUrl.getPackages:
          printLog("Found package" & package.name.quote & "in" & jsonUrl.quote)
          file.write("\n")
          file.write(jsonUrl)
      file.close
    of "remove":
      echo "DEBUG"
    else:
      printErr("Unknown option" & cmdParams[1].quote)