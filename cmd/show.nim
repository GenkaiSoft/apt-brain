import strutils , os
import ../common

proc cmdShow*() {.inline.} =
  var
    procShow: proc(package:seq[string])
    exist = false
  if paramCount() == 1:
    procShow = proc(package:seq[string]) = showInfo(package[0])
  else:
    procShow = proc(package:seq[string]) =
      if package[0].toLower == commandLineParams()[1].toLower:
        exist = true
        showInfo(package[0])
  let res = connect(url)
  if res != "":
    showLog("Show package(s)")
    for line in split(res , "\n"):
      procShow(split(line , ","))
    if not exist and paramCount() != 1:
      showErr("Package : \"" & commandLineParams()[1] & "\" isn't exist.")
