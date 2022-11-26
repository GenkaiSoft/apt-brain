import std/[os , times , strutils , tables]
import common , install

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
  showInfo("\"apt-brain help\" to get help")
else:
  case commandLineParams()[0]
  of "help":
    const null = ["" , ""]
    const helps = {
      "help":[["help" , "Show help"] , ["help {command(s)}" , "Show help about {command(s)}"]] ,
      "install":[
        ["install {package(s)}" , "Install {package(s)} to \"{current directory}" / "アプリ" / "{{package} name}\""] ,
        ["install [--dir|-d] {directory} {package(s)}" , "Install {packages(s)} to {directory}"]
      ] ,
      "ping":[["ping" , "Measure ping."] , null] ,
      "version":[["version" , "Show version."] , null] ,
      "show":[["show" , "Show all packages"] , ["show [package]" , "Show about [package]."]]
    }.toTable
    if paramCount() == 1:
      for key , help in helps:
        for value in help:
          if value != null:
            echo("\"" & value[0] & "\" : " & value[1])
    else:
      for key , help in helps:
        if key == commandLineParams()[1]:
          for value in help:
            echo("\"" & value[0] & "\" : " & value[1])
  of "ping":
    let start = cpuTime()
    discard connect(url)
    showInfo("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")
  of "install": install()
  of "show":
    var
      procShow: proc(package:seq[string])
      exist = false
    if paramCount() == 1:
      procShow = proc(package:seq[string]) = showInfo(package[0])
    else:
      procShow = proc(package:seq[string]) =
        if package[0].toLower == commandLineParams()[1].toLower:
          exist = true
          showInfo(package[0])
    let res = connect(url)
    if res != "":
      showLog("Show package(s)")
      for line in split(res , "\n"): procShow(split(line , ","))
      if not exist and paramCount() != 1: showErr("Package : \"" & commandLineParams()[1] & "\" isn't exist.")
  else: showErr("Unknown option")
