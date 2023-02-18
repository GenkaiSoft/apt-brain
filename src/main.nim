import std/[times , os , strutils]
import common
import cmd/[help , show , install/main , download]
from std/exitprocs import addExitProc
from std/terminal import resetAttributes

exitprocs.addExitProc(resetAttributes)

proc showHelp() =
  showInfo("Get help with \"apt-brain help\"")
proc showVer() =
  const NimblePkgVersion {.strdefine.}:string = "DEBUG_BUILD"
  when not defined(release) or not defined(NimblePkgVersion):
    showWarn("It's not release build!")
    showDbg("apt-brain " & NimblePkgVersion)
  else:
    showInfo("apt-brain v" & NimblePkgVersion)
  showInfo("https://github.com/GenkaiSoft/apt-brain")
  showInfo("Copylight (c) 2022 777shuang. All Rights Reserved.")

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
  showVer()
  showHelp()
else:
  case commandLineParams()[0].toLower
  of "help":
    cmdHelp()
  of "ping":
    if paramCount() != 1:
      showWarn.showMany()
    let start = cpuTime()
    discard connect(jsonUrl)
    showInfo("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")
  of "download":
    discard cmdDownload(findPackage(commandLineParams()[1]) , getCurrentDir())
  of "install":
    case paramCount()
    of 2:
      cmdInstall()
    of 1:
      showErr.showFew()
    else:
      showErr.showMany()
  of "show":
    cmdShow()
  of "version":
    if paramCount() != 1:
      showWarn.showMany()
    showVer()
  else:
    showErr("Unknown option")
    showHelp()
