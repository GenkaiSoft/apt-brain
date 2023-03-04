import std/strutils
from std/exitprocs import addExitProc
from std/terminal import resetAttributes
import liblim/logging
import apt_brain/common
import apt_brain/cmd/[help , ver]

exitprocs.addExitProc(resetAttributes)

proc printHelp() =
  printInfo("Get help with" & quote(appName & " help"))

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
  cmdVer()
  printHelp()
else:
  var exist = false
  let param = cmdParams[0].toLower
  for command in commands:
    if param == command.name:
      command.cmd()
      exist = true
  if not exist:
    printErr("command" & cmdParams[0].quote & "isn't found")