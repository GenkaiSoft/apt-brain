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

  var jsonObj:JsonNode
  if fileExists(jsonFileName):
    jsonObj = parseJson(jsonFileName)
  else:
    jsonObj = %*{
      "packages":
        [
          {
            "name":name ,
            "description":description ,
            "url":url ,
            "dir":{
              "input":input ,
              "output":output,
            },
            "delete":delete.split()
          }
        ]
    }