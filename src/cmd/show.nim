import std/[strutils , os]
import ../common

proc cmdShow*() {.inline.} =
  proc showPack(package:Package) =
    showInfo(package.name & " : " & package.description)
  let packages = getObject()
  if paramCount() == 1:
    for package in packages:
      package.showPack()
  else:
    var exist = false
    let show = commandLineParams()[1]
    for package in packages:
      if show.toLower == package.name.toLower:
        exist = true
        package.showPack()
    if not exist:
      showErr("package" & show.quote & "wasn't found")