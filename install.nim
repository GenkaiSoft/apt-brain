import os , strutils , streams , osproc
import zippy/ziparchives
import common

proc install*() =
  if paramCount() == 2:
    let lines = split(connect(url) , "\n")
    var exist = false
    for line in lines:
      let tmp = split(line , ",")
      if tmp[0] == commandLineParams()[1]:
        showInfo("Package \"" & tmp[0] & "\" is exist.")
        exist = true
        let fileName = tmp[1].substr(tmp[1].rfind("/") + 1)
        showLog("Opening file : \"" & fileName)
        let strm = newFileStream(fileName , fmWrite)
        if isNil(strm):
          showFailed()
          showErr("Unable to open " & fileName)
        else:
          showDone()
          strm.write(connect(tmp[1]))
          strm.close()
          let option = commandLineParams()[2] / "アプリ"
          case tmp[1].substr(tmp[1].rfind(".") + 1)
          of "zip":
            extractAll(fileName , "unzipped")
          of "exe":
            showInfo("Type : .exe installer")
            when defined(windows):
              var p:Process
              try: p = startProcess(fileName , option)
              except OSError: showErr("Unable to start process : " & filename)
              showInfo("Process ID : " & p.processID.intToStr)
              var line:string
              while p.outputStream.readLine(line): showLog("installer : " & line)
              discard p.waitForExit()
              showLog("Closing process")
              p.close()
            else:
              showInfo("Your OS isn't Windows.")
              let command = "wine " & fileName & " " & option
              showLog("Calling command : \"" & command & "\" ...")
              let code = execShellCmd(command)
              showDone()
              showLog("Code : " & code)
              if code != 0:
                showErr("Unable to call command : \"" & command & "\"")
                showInfo("Did you install wine ?")
        break
    if not exist: showErr("Package \"" & commandLineParams()[1] & "\" isn't exist.")
  elif paramCount() == 1: showFew()
  else:
    showMany()
