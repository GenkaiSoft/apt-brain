import liblim/logging
import ../common

proc cmdShow*() {.inline.} =
  proc printPackage(package:Package) =
    printInfo(package.name & " : " & package.description)
  let packages = getObject()
  if cmdParamCount == 1:
    for package in packages:
      package.printPackage()
  else:
    findPackage(cmdParams[1]).printPackage