import os , strutils , streams , osproc
import zippy/ziparchives
import common

proc install*() =
  if paramCount() == 2:
    let lines = split(connect(url) , "\n")
    var exist = false
    for line in lines:
      let tmp = split(line , ",")
      if tmp[0].toLower == commandLineParams()[1].toLower:
        showInfo("Package : \"" & tmp[0] & "\" is exist.")
        exist = true
        let fileName = tmp[1].substr(tmp[1].rfind("/") + 1)
        showLog("Opening file : \"" & fileName & "\" ...")
        let strm = newFileStream(fileName , fmWrite)
        if isNil(strm):
          showFailed()
          showErr("Unable to open " & fileName)
        else:
          showDone()
          let res = connect(tmp[1])
          strm.write(res)
          strm.close()
          if res == "":
            removeFile(fileName)
            break
          else:
            showLog("File : \"" & fileName & "\" Closed.")
            showLog("File : \"" & fileName & "\" Downloaded.")
            let extension = tmp[1].substr(tmp[1].rfind(".") + 1)
            case extension
            of "zip":
              showLog("Extracting zip file : \"" & fileName & "\" ...")
              try : extractAll(fileName , "アプリ" / tmp[0])
              except ZippyError:
                showErr("Unable to extract zip file : \"" & fileName & "\"")
                showExc()
              showDone()
            of "exe":
              showInfo("Type : .exe installer")
              when defined(windows):
                var p:Process
                try: p = startProcess(fileName)
                except OSError:
                  showErr("Unable to start process : " & filename)
                  showExc()
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
            else: showErr("Unknown extension : " & extension)
        break
    if not exist: showErr("Package \"" & commandLineParams()[1] & "\" isn't exist.")
  elif paramCount() == 1: showFew()
  else:
    showMany()
