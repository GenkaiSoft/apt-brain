import strutils
import puppy
import os
import system
import times
import console

proc connect():string =
  const url = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
  showLog("Connecting to \"" & url & "\" ...")
  let req = Request(url: parseUrl(url) , verb: "get")
  let res = fetch(req)
  showLog("  code = " & res.code.intToStr)
  if res.code == 200: showLog("-> done")
  else: showErr("-> failed")
  return res.body

if paramCount() == 0:
  showLog(""" ___              _                  _   _""")
  showLog("""|   \ _____ _____| |___ _ __  ___ __| | | |__ _  _""")
  showLog("""| |) / -_) V / -_) / _ \ '_ \/ -_) _` | | '_ \ || |""")
  showLog("""|___/\___|\_/\___|_\___/ .__/\___\__,_| |_.__/\_, |""")
  showLog("""                       |_|                    |__/""")
  showLog("""  ____            _         _ ____         __ _      ∧  ∧""")
  showLog(""" / ___| ___ _ __ | | ____ _(_) ___|  ___  / _| |_  ／￣￣￣＼""")
  showLog("""| |  _ / _ \ '_ \| |/ / _` | \___ \ / _ \| |_| __| | ＊  ＊ |""")
  showLog("""| |_| |  __/ | | |   < (_| | |___) | (_) |  _| |_  |＝ __ ＝|""")
  showLog(""" \____|\___|_| |_|_|\_\__,_|_|____/ \___/|_|  \__| ＼______／""")
  showInfo("Copyright (c) 2022 GenkaiSoft. All Rights Reserved.")
  showInfo("`apt-brain help' to get help")
elif commandLineParams()[0] == "help":
  showInfo("apt-brain [command]")
  showInfo("  help : show help")
  showInfo("  help [command] : show help about [command]")
  showInfo("  install [package] : install [package]")
  showInfo("  ping")
  showInfo("  show : show packeages")
  showInfo("  show [packeage] : show [package]")
elif commandLineParams()[0] == "ping":
  let start = cpuTime()
  discard connect()
  showLog("Ping = " & int(cpuTime() - start).intToStr & " ms")
elif commandLineParams()[0] == "install":
  if paramCount() == 2:
    let lines = split(connect() , "\n\r")
    for line in lines:
      let tmp = split(line , ",")
      if tmp[0] == commandLineParams()[1]:
        echo(tmp[0])
        break
  else:
    showErr("Too many arguments")
