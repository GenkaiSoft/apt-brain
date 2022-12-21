import std/[strutils , streams , os]
import zippy/ziparchives
import ../../common

proc installZip*(zipFileName , dir:string) {.inline.} =
  echo "DEBUG"
