import liblim/logging
import ../common

proc cmdShow*() =
  proc printPackage(package:Package) =
    printInfo(package.name.quote & ":" & package.description.quote)
  if cmdParamCount == 1:
    for package in getPackages():
      package.printPackage
  else:
    for i in 1..(cmdParamCount - 1):
      findPackage(cmdParams[i]).printPackage