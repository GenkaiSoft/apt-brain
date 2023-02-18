import std/[strutils , os , json , tables]
import ../common

proc cmdShow*() {.inline.} =
  for package in getObject():
    showInfo(package.name & " : " & package.description)