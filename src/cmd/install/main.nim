import std/[strutils , streams , os]
import ../../common
import zip
when defined(windows):
  import osproc

proc cmdInstall*() {.inline.} =
  if cmdLineParamCount == 2:
    
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
