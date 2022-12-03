import std/strutils
import ../common

proc cmdShow*() {.inline.} =
  let res = connect(url)
  if res != "":
    showLog("Show package(s)")
    let lines = split(res , "\n")
    var exist = false
    if cmdLineParamCount == 1:
      for line in lines:
        showInfo(split(line , ",")[0])
    else:
      for line in lines:
        let value = split(line , ",")[0]
        if value.toLower == cmdLineParams[1].toLower:
          showInfo("Package \"" & value & "\" exists.")
          exist = true
          break
    if not exist and cmdLineParamCount != 1:
      showErr("Package \"" & cmdLineParams[1] & "\" does not exist")
