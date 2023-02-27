import std/[os , json , strutils]
import liblim/logging
import ../common

proc cmdEdit*() =
  var
    jsonFileName:string
    repoName:string
  case cmdParamCount
  of 1:
    printFew()
  of 2:
    repoName = cmdParams[1]
    jsonFileName = "package.json"
  of 4:
    proc optionCheck(i:int):bool =
      return cmdParams[i] == "--out" or cmdParams[i] == "-o"
    if optionCheck(1):
      jsonFileName = cmdParams[2].toLower
      repoName = cmdParams[3].toLower
    elif optionCheck(2):
      jsonFileName = cmdParams[3].toLower
      repoName = cmdParams[1].toLower
    else:
      printMany()
  else:
    printMany()

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

  let jsonObj = %*{
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
  if jsonFileName.fileExists:
    jsonRootObj = jsonFileName.parseJsonFile
    jsonRootObj{repoNAme}.add(jsonObj)
  else:
    jsonRootObj = %*{repoName:[jsonObj]}
  jsonFileName.createAndWriteFile(jsonRootObj.pretty)