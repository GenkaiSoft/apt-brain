import std/[strutils , streams , os , tables , json]
import ../../common
import zip
when defined(windows):
  import osproc

proc cmdInstall*() {.inline.} =
  if paramCount() == 2:
    let fields = getJson().getFields()
    var exist = false
    for key , value in fields:
      if key.toLower == commandLineParams()[1].toLower:
        exist = true
        
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
