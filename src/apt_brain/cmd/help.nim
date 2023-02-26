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
    "version":[["" , "Show version."] , null] ,
    "show":[["" , "Show all packages"] , ["[package]" , "Show about [package]."]] ,
    "download":[["" , "download package file to current directory"] , ["[--dir|-d] {directory}" , "download package file to {directory}"]] ,
    "edit":[["" , "add a package to `package.json`"] , ["[filename]" , "add a package to `[filename].json`"]]
  }.toTable
  const space = " : "
  if cmdParamCount == 1:
    for key , help in helps:
      for value in help:
        if value != null:
          printInfo(quote(key & " " & value[0]) & space & value[1])
  else:
    for i in 1..(cmdParamCount - 1):
      var exist = false
      for key , help in helps:
        if key == cmdParams[i].toLower:
          exist = true
          for value in help:
            if value != null:
              printInfo(quote(key & " " & value[0]) & space & value[1])
          break
      if not exist:
        printErr("command" & cmdParams[i].quote & "isn't find")
