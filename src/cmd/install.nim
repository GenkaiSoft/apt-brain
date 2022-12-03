import std/[os , strutils , streams]
import zippy/ziparchives
import ../common

proc cmdInstall*() {.inline.} =
  if cmdLineParamCount == 2:
    let res = connect(url)
    if res != "":
      let lines = split(res , "\n")
      var
        exist = false
        fileName:string
      for line in lines:
        let package = split(line , ",")
        if package[0].toLower == cmdLineParams[1].toLower:
          showInfo("Package \"" & package[0] & "\" exists.")
          exist = true
          fileName = package[1].substr(package[1].rfind("/") + 1)
          showLog("Opening file \"" & fileName & "\" ...")
          let strm = newFileStream(fileName , fmWrite)
          if isNil(strm):
            showFailed()
            showErr("Unable to open file \"" & fileName &  "\"")
          else:
            showDone()
            let res = connect(package[1])
            strm.write(res)
            strm.close()
            if res == "":
              break
            else:
              showLog("File \"" & fileName & "\" closed.")
              showLog("File \"" & fileName & "\" downloaded.")
              const appDir = "アプリ"
              try:
                if existsOrCreateDir(appDir):
                  showInfo("Directory \"" & appDir & "\" does not exist.")
              except OSError:
                showExc("Unable to create directory \"" & appDir & "\"")
              let extension = package[1].substr(package[1].rfind(".") + 1)
              case extension
              of "zip":
                showLog("Extracting zip file \"" & fileName & "\" ...")
                var error = false
                try: extractAll(fileName , appDir / package[0])
                except ZippyError:
                  showFailed()
                  showExc("Unable to extract zip file \"" & fileName & "\"")
                  error = true
                if not error:
                  showDone()
              of "exe":
                showInfo("Type : .exe installer")
                when defined(windows):
                  try:
                    let p = startProcess(fileName)
                    showInfo("Process ID : " & p.processID.intToStr)
                    var line:string
                    while p.outputStream.readLine(line): showLog("Installer log : \"" & line & "\"")
                    discard p.waitForExit()
                    showLog("Closing process")
                    p.close()
                  except OSError:
                    showExc("Unable to start process \"" & filename & "\"")
                else:
                  showInfo("Your OS isn't Windows.")
                  let command = "wine " & fileName
                  showLog("Calling command \"" & command & "\" ...")
                  let code = execShellCmd(command)
                  showDone()
                  showLog("Exit code is \'" & code.intToStr & "\'")
                  if code != 0:
                    showErr("Unable to call command \"" & command & "\"")
                    showInfo("Did you install wine ?")
              else:
                showErr("Unknown extension \"." & extension & "\"")
          break
      if not exist:
        showErr("Package \"" & cmdLineParams[1] & "\" doesn't exist.")
      showLog("Removing file \"" & fileName & "\" ...")
      try:
        removeFile(fileName)
      except OSError:
        showFailed()
        showExc("Unable to remove file \"" & fileName & "\"")
      showDone()
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
