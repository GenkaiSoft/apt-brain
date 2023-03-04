import std/[os , strutils]
import liblim/logging
import ../common
import download , edit , install , ping , repo , show , ver

proc cmdHelp*()

type Help = object
  option:string
  description:string
proc newHelp*(option:string , description:string):Help {.inline.} =
  return Help(option:option , description:description)
type Command* = object
  cmd*:proc()
  name*:string
  helps:seq[Help]
proc newCommand*(cmd:proc() , name:string , helps:seq[Help]):Command {.inline.} =
  return Command(cmd:cmd , name:name , helps:helps)

let commands*:seq[Command] = @[
  newCommand(
    cmdDownload ,
    "download" ,
    @[newHelp("" , "Show helps") , newHelp("{command(s)}" , "Show help about {command(s)}")]
  ) ,
  newCommand(
    cmdEdit ,
    "edit" ,
    @[
      newHelp("" , "add package to `current directory" / "package.json`") ,
      newHelp("{filename}" , "add package to `{filename}.json`")
    ]
  ) ,
  newCommand(
    cmdHelp ,
    "help" ,
    @[
      newHelp("" , "Show help") ,
      newHelp("{command(s)}" , "Show help about {command(s)}")
    ]
  ) ,
  newCommand(
    cmdInstall ,
    "install" ,
    @[
      newHelp("{package(s)}" , "Install {package(s)} to \"{current directory}" / appDir / "{{package} name}\"") ,
      newHelp("[--dir|-d] {directory} {package(s)}" , "Install {packages(s)} to {directory}")
    ]
  ) ,
  newCommand(cmdPing , "ping" , @[newHelp("" , "pong")]) ,
  newCommand(
    cmdRepo ,
    "repo" ,
    @[
      newHelp("" , "Show repositries") ,
      newHelp("add {repositries}" , "Add {repositries}") ,
      newHelp("rem {repositries}" , "Remove {repositries}")
    ]
  ) ,
  newCommand(
    cmdShow ,
    "show" ,
    @[
      newHelp("" , "Show all packages") ,
      newHelp("{package(s)}" , "Show about {package(s)}")
    ]
  ) ,
  newCommand(cmdVer , "version" , @[newHelp("" , "Show " & appName & "'s version")])
]

proc cmdHelp*() =
  if cmdParamCount == 1:
    for command in commands:
      for help in command.helps:
        printInfo(quote(command.name & " " & help.option) & ":" & help.description.quote)
  else:
    for i in 1..(cmdParamCount - 1):
      var exist = false
      for command in commands:
        if cmdParams[i].toLower == command.name:
          exist = true
          for help in command.helps:
            printInfo(quote(command.name & " " & help.option) & ":" & help.description.quote) 
      if not exist:
        printErr("command" & cmdParams[i] & "isn't found")