import liblim/logging
import ../common

proc cmdVer*() =
  const NimblePkgVersion {.strdefine.} = "0.0.0(DEBUG_BUILD)"
  when not defined(release) or not defined(NimblePkgVersion):
    printWarn("It's not release build!")
  printInfo(appName & " v" & NimblePkgVersion)
  printInfo("https://github.com/GenkaiSoft/" & appName)
  printInfo("Copylight (c) 2022-2023 777shuang. All Rights Reserved.")