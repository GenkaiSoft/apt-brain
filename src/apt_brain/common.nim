import std/[strutils , json , os , tables]
import puppy
import liblim/logging
const
  defaultJsonUrl = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/package.json"
  appDir* = "アプリ"
  appName* = "apt-brain"
let
  cmdParamCount* = paramCount()
  cmdParams* = commandLineParams()

proc quote*(str:string):string =
  return " \"" & str & "\" "

proc printExc*(str:string) =
  printErr(str)
  printErr("Error message is" & quote(getCurrentExceptionMsg()))
  quit()

proc printResult(str:string) = printLog("-> " & str)
proc printFailed*() = printResult("failed")
proc printDone*() = printResult("done")

proc printProcess*(str:string) = printLog(str & " ...")

proc printArgs(str:string) =
  printErr("Too " & str & " arguments")
  quit()
proc printFew*() = printArgs("few")
proc printMany*() = printArgs("many")

proc connect*(url:string):string =
  printProcess("Connecting to" & url.quote)
  let msg = "Unable to connect to " & url.quote
  var res:Response
  try:
    res = url.get()
  except PuppyError:
    printExc(msg)
    quit()
  printLog("Response code is \'" & res.code.intToStr & "\'")
  if res.code == 200:
    printDone()
  else:
    printFailed()
    printErr(msg)
    quit()
  return res.body

proc remDir*(path:string) =
  printProcess("Removing directory" & path.quote)
  try:
    removeDir(path)
  except OSError:
    printFailed()
    printExc("Unable to remove directory" & path.quote)
    quit()
  printDone()

proc openFile*(path:string , fileMode:FileMode = fmRead):File =
  printProcess("Opening file" & path.quote)
  var file:File
  try:
    file = open(path , fileMode)
  except IOError:
    printFailed()
    printExc("Unable to open file" & path.quote)
  printDone()
  return file

proc createAndWriteFile*(path , str:string , fileMode:FileMode = fmWrite) =
  let file = openFile(path , fileMode)
  file.write(str)
  file.close()

type
  Dir* = object
    input*:string
    output*:string
  Package* = object
    name*:string
    description*:string
    url*:string
    dir*:Dir
    delete*:seq[string]

proc parseJsonFile*(path:string):JsonNode =
  printProcess("Parsing json file" & path.quote)
  var jsonNode:JsonNode
  try:
     jsonNode = path.openFile.readAll.parseJson
  except JsonParsingError:
    printFailed()
    printExc("Unable to parse json file" & path.quote)
  printDone()
  return jsonNode

proc getJsonNode*(jsonUrl:string):JsonNode =
  let package = connect(jsonUrl)
  printProcess("Parsing json" & jsonUrl.quote)
  var jsonNode:JsonNode
  try:
    jsonNode = parseJson(package)
  except JsonParsingError:
    printFailed()
    printExc("Unable to parse json" & jsonUrl.quote)
    quit()
  printDone()
  return jsonNode

proc getPackages*(jsonUrl:string = defaultJsonUrl):seq[Package] =
  var fields:seq[Package] = @[]
  try:
    for key , value in jsonUrl.getJsonNode.getFields:
      fields.add(value.to(Package))
  except KeyError:
    printExc("package list" & jsonUrl.quote & "is broken")
  return fields

proc findPackage*(find:string , jsonUrl:string = defaultJsonUrl):Package =
  for package in jsonUrl.getPackages:
    if find.toLower == package.name:
      return package
  printErr("Package" & find.quote & "is not found")
  quit()
