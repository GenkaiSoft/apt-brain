import std/[os , times , strutils]
import common
import cmd/[install , help , show]

proc showVer() =
  showInfo("apt-brain BETA v2.1")
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
  showInfo("\"apt-brain help\" to get help")
else:
  case commandLineParams()[0]
  of "help":
    cmdHelp()
  of "ping":
    let start = cpuTime()
    discard connect(url)
    showInfo("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")
  of "install":
    cmdInstall()
  of "show":
    cmdShow()
  of "version":
    showVer()
  else:
    showErr("Unknown option")
