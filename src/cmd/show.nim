import std/strutils
import ../common

proc cmdShow*() {.inline.} =
  if cmdLineParamCount == 1:
    for key in fields.keys:
      showInfo(key)
  else:
    for key in fields.keys:
      if key.toLower == cmdLineParams[1].toLower:
        showInfo("Package \"" & key & "\" exists.")
        exist = true
        break
    if not exist:
      showErr("Package \"" & cmdLineParams[1] & "\" does not exist")
