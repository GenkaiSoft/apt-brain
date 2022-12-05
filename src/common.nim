import std/[strutils , os , terminal]
import puppy
import time/ctime

const url* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
let
  cmdLineParamCount* = paramCount()
  cmdLineParams* = commandLineParams()

proc show(title , str:string , color:ForegroundColor) =
  stdout.styledWriteLine(
    color ,
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
    "] " &
    title &
    " > " &
    str
  )
proc showErr*(str:string) = show("Error      " , str & " !" , fgRed)
proc showLog*(str:string) = show("Log        " , str , fgGreen)
proc showInfo*(str:string) = show("Information" , str , fgBlue)
proc showWarn*(str:string) = show("Warning    " , str & " !" , fgYellow)
proc showDbg*(str:string) = show("Debug      " , str , fgWhite)
proc showExc*(str:string) =
  showErr(str)
  showErr("Error message is \"" & getCurrentExceptionMsg() & "\"")
proc showProcess*(str:string) = showLog(str & " ...")

proc showResult(str:string) = showLog("-> " & str)
proc showFailed*() = showResult("failed")
proc showDone*() = showResult("done")

proc showArgs(str:string) = showErr("Too " & str & " arguments")
proc showFew*() = showArgs("few")
proc showMany*() = showArgs("many")

proc connect*(url:string):string =
  showProcess("Connecting to \"" & url & "\" ...")
  let res = fetch(Request(url: parseUrl(url) , verb: "get"))
  if res.code == 200:
    showDone()
  else:
    showFailed()
    showErr("Unable to connect to \"" & url & "\"")
  showLog("Response code is \'" & res.code.intToStr & "\'")
  return res.body
