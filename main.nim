import puppy
import strutils
import os
import system
import ctime

proc show(title:string , str:string) =
  echo(
    "[" &
    getYear().intToStr & "/" &
    getMonth().intToStr & "/" &
    getDay().intToStr & "/" &
    getHour().intToStr & "/" &
    getMinute().intToStr & "/" &
    getSecond().intToStr & "] " &
    title & " : " & str
  )
proc showError(str:string) = show("Err" , str)
proc showLog(str:string) = show("Log" , str)
proc showInfo(str:string) = show("Info" , str)
proc showWrning(str:string) = show("Warn" , str)

if paramCount() == 0:
  echo(
    """
 ___              _                  _   _
|   \ _____ _____| |___ _ __  ___ __| | | |__ _  _
| |) / -_) V / -_) / _ \ '_ \/ -_) _` | | '_ \ || |
|___/\___|\_/\___|_\___/ .__/\___\__,_| |_.__/\_, |
                       |_|                    |__/
  ____            _         _ ____         __ _      ∧  ∧
 / ___| ___ _ __ | | ____ _(_) ___|  ___  / _| |_  ／￣￣￣＼
| |  _ / _ \ '_ \| |/ / _` | \___ \ / _ \| |_| __| | ＊  ＊ |
| |_| |  __/ | | |   < (_| | |___) | (_) |  _| |_  |＝ __ ＝|
 \____|\___|_| |_|_|\_\__,_|_|____/ \___/|_|  \__| ＼______／

Copyright (c) 2022 777shuang, GenkaiSoft. All Rights Reserved.
    """
  )
  showInfo("`apt-brain help' to get help")
elif commandLineParams()[0] == "help":
  showInfo("apt-brain [command]")
  showInfo("  help : show help")
  showInfo("  help [command] : show help about [command]")
  showInfo("  install [package] : install [package]")
  showInfo("  ping")
  showInfo("  show : show packeages")
  showInfo("  show [packeage] : show [package]")
elif  commandLineParams()[0] == "install":
  if paramCount() == 2:
    const url = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
    echo("Connecting to \"" & url & "\" ...")
    let req = Request(url: parseUrl(url) , verb: "get")
    let res = fetch(req)
    echo("  code : " & res.code.intToStr)
    if res.code == 200:
      echo("-> done")
      let lines = split(res.body , "\n\r")
      for line in lines:
        let tmp = split(line , ",")
        if tmp[0] == commandLineParams()[1]:
          echo(tmp[0])
          break
    else :
      echo("-> faild")
      showError("cannot send request to \"" & url & "\"")
  else:
    showError("Too many arguments")
