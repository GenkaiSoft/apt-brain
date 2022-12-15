import std/[strutils , streams , os , tables , json]
import ../../common
import zip
when defined(windows):
  import osproc

proc cmdInstall*() {.inline.} =
  if paramCount() == 2:
    let fields = getJson().getFields()
    var
      exist = false
      count = 0
    for key , value in fields:
      if key.toLower == commandLineParams()[1].toLower:
        exist = true
        let
          jsonObj = getObject()
          extension = jsonObj[count].url.substr(jsonObj.[count].url.rfind(".") + 1)
        
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
