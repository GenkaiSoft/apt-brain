import std/[strutils , os]
import puppy
import time/ctime

const url* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
let
  cmdLineParamCount* = paramCount()
  cmdLineParams* = commandLineParams()

proc show(title , str:string) =
  echo(
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
proc showErr*(str:string) = show("Error      " , str)
proc showLog*(str:string) = show("Log        " , str)
proc showInfo*(str:string) = show("Information" , str)
proc showWarn*(str:string) = show("Warning    " , str)
proc showDbg*(str:string) = show("Debug      " , str)
proc showExc*(str:string) =
  showErr(str)
  showErr("Error message is \"" & getCurrentExceptionMsg() & "\"")

proc showFailed*() = showLog("-> failed")
proc showDone*() = showLog("-> done")
proc showFew*() = showErr("Too few arguments")
proc showMany*() = showErr("Too many argumetns")

proc connect*(url:string):string =
  showLog("Connecting to \"" & url & "\" ...")
  let res = fetch(Request(url: parseUrl(url) , verb: "get"))
  if res.code == 200:
    showDone()
  else:
    showFailed()
    showErr("Unable to connect to \"" & url & "\"")
  showLog("Response code is \'" & res.code.intToStr & "\'")
  return res.body
