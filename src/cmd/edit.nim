import std/[os , json , strutils]
import liblim/logging
import ../common

proc cmdEdit*() =
  var jsonFileName:string
  case cmdParamCount
  of 1:
    jsonFileName = "package.json"
  of 2:
    jsonFileName = cmdParams[1]
  else:
    printErr.printMany()
    quit()

  let name = printPrompt("package name").toLower
  let description = printPrompt("description")
  var url = printPrompt("url")
  let input = printPrompt("dir.input")
  let output = printPrompt("dir.output")
  let delete = printPrompt("delete")

  if url.startsWith("https://drive.google.com/file/d/"):
    url = "https://drive.google.com/uc?id=" & url.split("/")[5]

  var seqDelete:seq[string]
  if delete != "":
    seqDelete = delete.split()

  let jsonObj = %*
  {
    "name":name ,
    "description":description ,
    "url":url ,
    "dir":{
      "input":input ,
      "output":output,
    },
    "delete":seqDelete
  }
  var jsonRootObj:JsonNode
  if fileExists(jsonFileName):
    jsonRootObj = parseJson(jsonFileName)
    jsonRootObj{"packages"}.add(jsonObj)
  else:
    jsonRootObj = %*{"packages":[jsonObj]}
  jsonFileName.writeFile(jsonRootObj.pretty)