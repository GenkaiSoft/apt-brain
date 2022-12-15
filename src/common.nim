import std/[strutils , terminal , json]
import puppy
import time/ctime

const
  jsonUrl* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/package.json"
  appDir* = "アプリ"

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
proc showProcess*(str:string , p:proc():string) =
  showProcess(str)
  let msg = p()
  if msg == "":
    showDone()
  else:
    showFailed()
    showErr(msg)

proc showArgs(str:string) = showErr("Too " & str & " arguments")
proc showFew*() = showArgs("few")
proc showMany*() = showArgs("many")

proc connect*(url:string):string =
  showProcess("Connecting to" & url.quote)
  let res = fetch(Request(url:parseUrl(url) , verb:"GET"))
  if res.code == 200:
    showDone()
  else:
    showFailed()
    showErr("Unable to connect to " & url.quote)
    showInfo("Would you use" & "https://web.archive.org".quote & "? (Yes/No) >")
    let input = readLine(stdin).toLower
    if input == "y" or input == "yes":
      echo "DEBUG"
  showLog("Response code is \'" & res.code.intToStr & "\'")
  return res.body

type Package = object
  gen:seq[int]
  url:string
  dependencies:seq[string]
  input:seq[string]
  output:seq[string]
  AppMain_cfg:bool

proc getJson*():JsonNode =
  try:
    return parseJson(connect(jsonUrl))
  except JsonParsingError:
    showExc("Unable to parse json" & jsonUrl.quote)

proc getObject*():seq[Package] =
  return to(getJson() , seq[Package])