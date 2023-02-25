import liblim/logging
import ../common

proc cmdShow*() {.inline.} =
  proc printPackage(package:Package) =
    printInfo(package.name & " : " & package.description)
  if cmdParamCount == 1:
    for package in getPackages():
      package.printPackage()
  else:
    findPackage(cmdParams[1]).printPackage