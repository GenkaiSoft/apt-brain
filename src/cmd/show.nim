import ../common

proc cmdShow*() {.inline.} =
  proc showPackage(package:Package) =
    showInfo(package.name & " : " & package.description)
  let packages = getObject()
  if cmdParamCount == 1:
    for package in packages:
      package.showPackage()
  else:
    findPackage(cmdParams[1]).showPackage