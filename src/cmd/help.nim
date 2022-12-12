import ../common
import std/[os , tables]
from std/os import `/`

proc cmdHelp*() {.inline.} =
  const null = ["" , ""]
  const helps = {
    "help":[["help" , "Show help"] , ["help {command(s)}" , "Show help about {command(s)}."]] ,
    "install":[
      ["install {package(s)}" , "Install {package(s)} to \"{current directory}" / appDir / "{{package} name}\"."] ,
      ["install [--dir|-d] {directory} {package(s)}" , "Install {packages(s)} to {directory}."]
    ] ,
    "ping":[["ping" , "Measure ping."] , null] ,
    "version":[["version" , "Show version."] , null] ,
    "show":[["show" , "Show all packages"] , ["show [package]" , "Show about [package]."]]
  }.toTable
  const space = " : "
  if paramCount() == 1:
    for key , help in helps:
      for value in help:
        if value != null:
          showInfo(value[0].quote & space & value[1])
  else:
    for key , help in helps:
      if key == commandLineParams()[1]:
        for value in help:
          if value != null:
            showInfo(value[0].quote & space & value[1])
        break
