import strutils
import puppy
import os
import osproc
import system
import times
import streams
import console

proc showFailed() = showLog("-> failed")
proc showDone() = showLog("-> done")

proc connect(url:string):string =
  showLog("Connecting to \"" & url & "\" ...")
  let req = Request(url: parseUrl(url) , verb: "get")
  let res = fetch(req)
  showLog("  code = " & res.code.intToStr)
  if res.code == 200: showDone()
  else:
    showFailed()
    showErr("unable to connect to " & url)
    quit(1)
  return res.body

const url = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
if paramCount() == 0:
  showLog(""" ___              _                  _   _""")
  showLog("""|   \ _____ _____| |___ _ __  ___ __| | | |__ _  _""")
  showLog("""| |) / -_) V / -_) / _ \ '_ \/ -_) _` | | '_ \ || |""")
  showLog("""|___/\___|\_/\___|_\___/ .__/\___\__,_| |_.__/\_, |""")
  showLog("""                       |_|                    |__/""")
  showLog("""  ____            _         _ ____         __ _     /\  /\    __________""")
  showLog(""" / ___| ___ _ __ | | ____ _(_) ___|  ___  / _| |_  /------\  /          |""")
  showLog("""| |  _ / _ \ '_ \| |/ / _` | \___ \ / _ \| |_| __| | *  * | < Genkaiya! |""")
  showLog("""| |_| |  __/ | | |   < (_| | |___) | (_) |  _| |_  |= __ =|  \__________|""")
  showLog(""" \____|\___|_| |_|_|\_\__,_|_|____/ \___/|_|  \__| \______/""")
  showInfo("Copyright (c) 2022 GenkaiSoft. All Rights Reserved.")
  showInfo("`apt-brain help' to get help")
elif commandLineParams()[0] == "help":
  showInfo("apt-brain [command]")
  showInfo("  help : show help")
  showInfo("  help [command] : show help about [command]")
  showInfo("  install [package] : install [package]")
  showInfo("  ping")
  showInfo("  show : show all packeages")
  showInfo("  show [packeage] : show about [package]")
elif commandLineParams()[0] == "ping":
  let start = cpuTime()
  discard connect(url)
  showInfo("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")
elif commandLineParams()[0] == "install":
  if paramCount() == 2:
    let lines = split(connect(url) , "\n")
    for line in lines:
      let tmp = split(line , ",")
      if tmp[0] == commandLineParams()[1]:
        showInfo("package \"" & tmp[0] & "\" exist.")
        let fileName = tmp[2].substr(tmp[2].rfind("/") + 1)
        showLog("opening file : \"" & fileName)
        let strm = newFileStream(fileName , fmWrite)
        if isNil(strm):
          showFailed()
          showErr("unable to open " & fileName)
        else:
          showDone()
          strm.write(connect(tmp[2]))
          strm.close()
        if tmp[1] == "exe":
          showInfo("type : .exe installer")
          when defined(windows):
            var p:Process
            try: p = startProcess(fileName)
            except OSError:
              showErr("unable to start process : " & filename)
            showInfo("Process ID : " & p.processID.intToStr)
            var line:string
            while p.outputStream.readLine(line): showLog("installer : " & line)
            discard p.waitForExit()
            showLog("close process")
            p.close()
          else:
            showInfo("Your OS isn't Windows.")
            discard execShellCmd("wine " & fileName)
        break
  else:
    showErr("Too many arguments")
