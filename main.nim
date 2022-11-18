import strutils
import puppy
import os
import osproc
import times
import streams
import console

proc showFailed() = showLog("-> failed")
proc showDone() = showLog("-> done")
proc showFew() = showErr("Too few arguments")
proc showMany() = showErr("Too many argumetns")

proc connect(url:string):string =
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
  showInfo("  help : Show help")
  showInfo("  help [command] : Show help about [command]")
  showInfo("  install [package] [drive] : Install [package] to [drive]")
  showInfo("  ping")
  showInfo("  show : Show all packeages")
  showInfo("  show [packeage] : Show about [package]")
elif commandLineParams()[0] == "ping":
  let start = cpuTime()
  discard connect(url)
  showInfo("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")
elif commandLineParams()[0] == "install":
  if paramCount() == 3:
    let lines = split(connect(url) , "\n")
    for line in lines:
      let tmp = split(line , ",")
      if tmp[0] == commandLineParams()[1]:
        showInfo("Package \"" & tmp[0] & "\" exist.")
        let fileName = tmp[1].substr(tmp[1].rfind("/") + 1)
        showLog("Opening file : \"" & fileName)
        let strm = newFileStream(fileName , fmWrite)
        if isNil(strm):
          showFailed()
          showErr("Unable to open " & fileName)
        else:
          showDone()
          strm.write(connect(tmp[1]))
          strm.close()
          let option = commandLineParams()[2] / "アプリ"
          if tmp[1].substr(tmp[1].rfind(".") + 1) == "exe":
            showInfo("Type : .exe installer")
            when defined(windows):
              var p:Process
              try: p = startProcess(fileName , option)
              except OSError: showErr("Unable to start process : " & filename)
              showInfo("Process ID : " & p.processID.intToStr)
              var line:string
              while p.outputStream.readLine(line): showLog("installer : " & line)
              discard p.waitForExit()
              showLog("Closing process")
              p.close()
            else:
              showInfo("Your OS isn't Windows.")
              let command = "wine " & fileName & " " & option
              showLog("Calling command : \"" & command & "\" ...")
              let code = execShellCmd(command)
              showDone()
              showLog("Code : " & code)
              if code != 0:
                showErr("Unable to call command : \"" & command & "\"")
                showInfo("Did you install wine ?")
        break
  elif paramCount() == 1: showFew()
  else: showMany()
else: showErr("Unknown option")
