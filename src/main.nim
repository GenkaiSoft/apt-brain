import std/strutils
from std/times import cputime
from std/exitprocs import addExitProc
from std/terminal import resetAttributes
import liblim/logging
import apt_brain/common
import apt_brain/cmd/[help , show , install , download , edit , add]

exitprocs.addExitProc(resetAttributes)

proc printHelp() =
  printInfo("Get help with" & quote(appName & " help"))
proc printVer() =
  const NimblePkgVersion {.strdefine.}:string = "0.0.0(DEBUG_BUILD)"
  when not defined(release) or not defined(NimblePkgVersion):
    printWarn("It's not release build!")
  printInfo(appName & " v" & NimblePkgVersion)
  printInfo("https://github.com/GenkaiSoft/" & appName)
  printInfo("Copylight (c) 2022 777shuang. All Rights Reserved.")

if cmdParamCount == 0:
  printLog(""" ___              _                  _   _""")
  printLog("""|   \ _____ _____| |___ _ __  ___ __| | | |__ _  _""")
  printLog("""| |) / -_) V / -_) / _ \ '_ \/ -_) _` | | '_ \ || |""")
  printLog("""|___/\___|\_/\___|_\___/ .__/\___\__,_| |_.__/\_, |""")
  printLog("""                       |_|                    |__/""")
  printLog("""  ____            _         _ ____         __ _     /\  /\    __________""")
  printLog(""" / ___| ___ _ __ | | ____ _(_) ___|  ___  / _| |_  /------\  /          |""")
  printLog("""| |  _ / _ \ '_ \| |/ / _` | \___ \ / _ \| |_| __| | *  * | < Genkaiya! |""")
  printLog("""| |_| |  __/ | | |   < (_| | |___) | (_) |  _| |_  |= __ =|  \__________|""")
  printLog(""" \____|\___|_| |_|_|\_\__,_|_|____/ \___/|_|  \__| \______/""")
  printVer()
  printHelp()
else:
  case cmdParams[0].toLower
  of "help":
    cmdHelp()
  of "ping":
    if cmdParamCount != 1:
      printMany()
    let start = cpuTime()
    discard connect(jsonUrl)
    printInfo("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")
  of "download":
    cmdDownload()
  of "install":
    cmdInstall()
  of "show":
    cmdShow()
  of "edit":
    cmdEdit()
  of "add":
    cmdAdd()
  of "version":
    if cmdParamCount != 1:
      printMany()
    printVer()
  else:
    printErr("Unknown option")
    printHelp()