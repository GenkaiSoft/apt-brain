import strutils
import ctime

proc show(title , str:string) =
  echo("[" & getYear().intToStr & "/" & getMonth().intToStr & "/" & getDay().intToStr & " " & getHour().intToStr & ":" & getMinute().intToStr & ":" & getSecond().intToStr & "] " & title & " : " & str)
proc showErr*(str:string) = show("Err" , str)
proc showLog*(str:string) = show("Log" , str)
proc showInfo*(str:string) = show("Info" , str)
proc showWarn*(str:string) = show("Warn" , str)
proc showDbg*(str:string) = show("Dbg" , str)
