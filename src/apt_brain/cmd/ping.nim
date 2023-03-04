from strutils import intToStr
from std/times import cpuTime
from liblim/logging import printLog
import ../common

proc cmdPing*() =
  for url in getRepositries():
    let start = cpuTime()
    discard url.connect
    printLog("Ping : " & int((cpuTime() - start) * 1000).intToStr & " ms")