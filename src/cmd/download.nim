import std/strutils
from os import `/`
import ../common

proc cmdDownload*(package:Package , dir:string):string {.inline.} =
  let fileName = dir / package.url.substr(package.url.rfind("/") + 1)
  createFileAndWrite(fileName , connect(package.url))
  return fileName