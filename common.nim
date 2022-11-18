import strutils
import puppy
import ctime

const url* = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"

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
proc showErr*(str:string) = show("Err " , str)
proc showLog*(str:string) = show("Log " , str)
proc showInfo*(str:string) = show("Info" , str)
proc showWarn*(str:string) = show("Warn" , str)
proc showDbg*(str:string) = show("Dbg " , str)

proc showFailed*() = showLog("-> failed")
proc showDone*() = showLog("-> done")
proc showFew*() = showErr("Too few arguments")
proc showMany*() = showErr("Too many argumetns")

proc connect*(url:string):string =
  showLog("Connecting to \"" & url & "\" ...")
  let req = Request(url: parseUrl(url) , verb: "get")
  let res = fetch(req)
  showLog("  Code = " & res.code.intToStr)
  if res.code == 200: showDone()
  else:
    showFailed()
    showErr("Unable to connect to " & url)
    quit(1)
  return res.body
