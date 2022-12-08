import std/[strutils , os , terminal]
import puppy
import time/ctime

proc quote(str:string):string = return " \"" & str & "\""
proc show(f:File , msgType , str:string , color:ForegroundColor) =
  f.styledWrite(
    fgMagenta ,
    "[" &
    getYear().intToStr &
    "/" &
    getMonth().intToStr &
    "/" &
    getDay().intToStr &
    " " &
    getHour().intToStr &
    ":" &
    getMinute().intToStr &
    ":" & getSecond().intToStr &
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
proc showProcess*(str:string) = showLog(str & " ...")

proc showResult(str:string) = showLog("-> " & str)
proc showFailed*() = showResult("failed")
proc showDone*() = showResult("done")

proc showArgs(str:string) = showErr("Too " & str & " arguments")
proc showFew*() = showArgs("few")
proc showMany*() = showArgs("many")

proc connect*(url:string):string =
  showProcess("Connecting to" & quote(url))
  let res = fetch(Request(url: parseUrl(url) , verb: "get"))
  if res.code == 200:
    showDone()
  else:
    showFailed()
    let msg = "Unable to connect to" & quote(url)
    showErr(msg)
    raise newException(OSError , msg)
  showLog("Response code is \'" & res.code.intToStr & "\'")
  return res.body

const
  url* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
  appDir* = "アプリ"
let
  cmdLineParamCount* = paramCount()
  cmdLineParams* = commandLineParams()