import std/[os , tables , strutils]
import liblim/logging
import ../common

proc cmdHelp*() {.inline.} =
  const null = ["" , ""]
  const helps = {
    "help":[["" , "Show help"] , ["{command(s)}" , "Show help about {command(s)}."]] ,
    "install":[
      ["{package(s)}" , "Install {package(s)} to \"{current directory}" / appDir / "{{package} name}\"."] ,
      ["[--dir|-d] {directory} {package(s)}" , "Install {packages(s)} to {directory}."]
    ] ,
    "ping":[["" , "Measure ping."] , null] ,
    "version":[["" , "Show version."] , null] ,
    "show":[["" , "Show all packages"] , ["show [package]" , "Show about [package]."]] ,
    "download":[["" , "download package file to current directory"] , ["[--dir|-d] {directory}" , "download package file to {directory}"]]
  }.toTable
  const space = " : "
  if cmdParamCount == 1:
    for key , help in helps:
      for value in help:
        if value != null:
          printInfo(quote(key & " " & value[0]) & space & value[1])
  else:
    for key , help in helps:
      if key == cmdParams[1].toLower:
        for value in help:
          if value != null:
            printInfo(quote(key & " " & value[0]) & space & value[1])
        break
