import std/[strutils , os , json , tables]
import ../common

proc cmdShow*() {.inline.} =
  let fields = getJson().getFields()
  if paramCount() == 1:
    for key , value in fields:
      showInfo(key)
  else:
    var exist = false
    for key , value in fields:
      if key.toLower == commandLineParams()[1].toLower:
        showInfo("Package" & key.quote & "exists.")
        exist = true
        break
    if not exist:
      showErr("Package" & commandLineParams()[1].quote & "does not exist")
