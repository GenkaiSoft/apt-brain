import std/strutils
import ../../common
import zip , cab

proc cmdInstall*(install:string):bool {.inline.} =
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
  if not exist:
    showErr("Package" & install.quote & "isn't found")
    return false
  return true
