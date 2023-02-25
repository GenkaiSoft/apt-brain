import std/[strutils , json , os , streams]
import puppy
import liblim/logging
const
  jsonUrl* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/package.json"
  appDir* = "アプリ"
  appName* = "apt-brain"
let
  cmdParamCount* = paramCount()
  cmdParams* = commandLineParams()

proc quote*(str:string):string = return " \"" & str & "\" "

proc printExc*(str:string) =
  printErr(str)
  printErr("Error message is" & quote(getCurrentExceptionMsg()))

proc printResult(str:string) = printLog("-> " & str)
proc printFailed*() = printResult("failed")
proc printDone*() = printResult("done")

proc printProcess*(str:string) = printLog(str & " ...")

proc printArgs(lamda:proc(str:string) , str:string) = lamda("Too " & str & " arguments")
proc printFew*(lamda:proc(str:string)) = lamda.printArgs("few")
proc printMany*(lamda:proc(str:string)) = lamda.printArgs("many")

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
    printInfo("Would you use" & "https://web.archive.org".quote & "? (Yes/No) >")
    let input = readLine(stdin).toLower
    if input == "y" or input == "yes":
      echo "DEBUG"
  return res.body

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
  Packages = object
    packages:seq[Package]

proc getJsonNode*():JsonNode =
  let package = connect(jsonUrl)
  printProcess("Parsing" & jsonUrl.quote)
  var jsonNode:JsonNode
  try:
    jsonNode = parseJson(package)
  except JsonParsingError:
    printFailed()
    printExc("Unable to parse json" & jsonUrl.quote)
    quit()
  printDone()
  return jsonNode

proc getObject*():seq[Package] = return getJsonNode().to(Packages).packages

proc findPackage*(find:string):Package =
  for package in getObject():
    if find.toLower == package.name:
      return package
  printErr("Package" & find.quote & "is not found")
  quit()

proc writeFile*(fileName , str:string) =
  printProcess("Opening file" & fileName.quote)
  var strm:Stream
  try:
    strm = openFileStream(fileName , fmWrite)
  except IOError:
    printFailed()
    printErr("Unable to open file" & fileName.quote)
    quit()
  printDone()
  strm.write(str)
  strm.close()