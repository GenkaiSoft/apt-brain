import std/[strutils , terminal , json , os]
import puppy
import time/ctime

const
  jsonUrl* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/package.json"
  appDir* = "アプリ"
  appName* = "apt-brain"
let
  cmdParamCount* = paramCount()
  cmdParams* = commandLineParams()

proc quote*(str:string):string = return " \"" & str & "\" "

proc show(f:File , msgType , str:string , color:ForegroundColor) =
  f.styledWrite(
    fgMagenta ,
    "[",
    getYear().intToStr,
    "/",
    getMonth().intToStr,
    "/",
    getDay().intToStr,
    " ",
    getHour().intToStr,
    ":",
    getMinute().intToStr,
    ":",
    getSecond().intToStr,
    "] "
  )
  f.styledWrite(color , msgType)
  f.styledWrite(fgWhite , " > ")
  f.styledWrite(color , str)
  f.write("\n")
proc showErr*(str:string) = stderr.show("Error      " , str & " !\a" , fgRed)
proc showLog*(str:string) = stdout.show("Log        " , str , fgGreen)
proc showInfo*(str:string) = stdout.show("Information" , str , fgBlue)
proc showWarn*(str:string) = stdout.show("Warning    " , str & " !" , fgYellow)
proc showDbg*(str:string) = stdout.show("Debug      " , str , fgWhite)
proc showExc*(str:string) =
  showErr(str)
  showErr("Error message is" & quote(getCurrentExceptionMsg()))

proc showResult(str:string) = showLog("-> " & str)
proc showFailed*() = showResult("failed")
proc showDone*() = showResult("done")

proc showProcess*(str:string) = showLog(str & " ...")

proc showArgs(lamda:proc(str:string) , str:string) = lamda("Too " & str & " arguments")
proc showFew*(lamda:proc(str:string)) = lamda.showArgs("few")
proc showMany*(lamda:proc(str:string)) = lamda.showArgs("many")

proc connect*(url:string):string =
  showProcess("Connecting to" & url.quote)
  let
    msg = "Unable to connect to " & url.quote
    res = get(url)
  showLog("Response code is \'" & res.code.intToStr & "\'")
  if res.code == 200:
    showDone()
  else:
    showFailed()
    showErr(msg)
    showInfo("Would you use" & "https://web.archive.org".quote & "? (Yes/No) >")
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
  showProcess("Parsing" & jsonUrl.quote)
  var jsonNode:JsonNode
  try:
    jsonNode = parseJson(package)
  except JsonParsingError:
    showFailed()
    showExc("Unable to parse json" & jsonUrl.quote)
    quit()
  showDone()
  return jsonNode

proc getObject*():seq[Package] = return getJsonNode().to(Packages).packages

proc findPackage*(find:string):Package =
  for package in getObject():
    if find.toLower == package.name:
      return package
  showErr("Package" & find.quote & "is not found")
  quit()