import strutils , os
import ../common

proc cmdShow*() {.inline.} =
  let res = connect(url)
  if res != "":
    showLog("Show package(s)")
    let lines = split(res , "\n")
    var exist = false
    if paramCount() == 1:
      for line in lines:
        showInfo(split(line , ",")[0])
    else:
      for line in lines:
        let value = split(line , ",")[0]
        if value.toLower == commandLineParams()[1].toLower:
          showInfo("Package : \"" & value & "\" is exist.")
          exist = true
          break
    if not exist and paramCount() != 1:
      showErr("Package : \"" & commandLineParams()[1] & "\" isn't exist.")
