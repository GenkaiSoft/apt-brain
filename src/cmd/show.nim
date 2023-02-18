import std/os
import ../common

proc cmdShow*() {.inline.} =
  proc showPackage(package:Package) =
    showInfo(package.name & " : " & package.description)
  let packages = getObject()
  if paramCount() == 1:
    for package in packages:
      package.showPackage()
  else:
    findPackage(commandLineParams()[1]).showPackage