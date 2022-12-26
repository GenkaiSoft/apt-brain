import std/[strutils , streams , os]
import ../../common
import zip , cab

proc cmdInstall*(install:string) {.inline.} =
  if paramCount() == 2:
    var exist = false
    let packages = getObject()
    for package in packages:
      if package.name.toLower == install.toLower:
        exist = true
        let extension = package.url.substr(package.url.rfind(".") + 1)
        case extension
        of "zip":
          installZip(package)
        of "cab":
          installCab(package)
        else:
          showErr("Unknown extension" & extension.quote)
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
