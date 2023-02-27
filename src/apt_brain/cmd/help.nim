import std/[os , tables , strutils]
import liblim/logging
import ../common
import download , edit , install , ping , repo , show

proc cmdHelp*() {.inline.} =
  echo "DEBUG"

type Help* = object
  option*:string
  description*:string
proc newHelp*(option:string , description:string):Help {.inline.} =
  return Help(option:option , description:description)
type Command* = object
  cmd*:proc()
  str*:string
  help:seq[Help]
proc newCommand*(cmd:proc() , str:string , help:seq[Help]):Command {.inline.} =
  return Command(cmd:cmd , str:str , help:help)

let commands*:seq[Command] = @[
  newCommand(cmdDownload , "download" , @[newHelp("" , "Show helps") , newHelp("{command(s)}" , "Show help about {command(s)}")]) ,
  newCommand(cmdEdit , "edit" , @[newHelp("" , "add package to `current directory" / "package.json`") , newHelp("{filename}" , "add package to `{filename}.json`")])
]
