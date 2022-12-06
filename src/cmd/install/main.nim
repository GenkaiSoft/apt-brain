import std/[strutils , streams , os]
import ../../common
import zip
when defined(windows):
  import osproc

proc cmdInstall*() {.inline.} =
  if cmdLineParamCount == 2:
    let res = connect(url)
    if res != "":
      let lines = split(res , "\n")
      var
        exist = false
        download:string
      for line in lines:
        let package = split(line , ",")
        if package[0].toLower == cmdLineParams[1].toLower:
          showInfo("Package \"" & package[0] & "\" exists.")
          exist = true
          download = package[1].substr(package[1].rfind("/") + 1)
          showProcess("Opening file \"" & download & "\"")
          var strm:Stream
          try:
            strm = openFileStream(download , fmWrite)
          except IOError:
            showFailed()
            showErr("Unable to open file \"" & download &  "\"")
          showDone()
          let res = connect(package[1])
          strm.write(res)
          strm.close()
          if res == "":
            break
          else:
            showLog("File \"" & download & "\" closed.")
            showLog("File \"" & download & "\" downloaded.")
            try:
              if existsOrCreateDir(appDir):
                showInfo("Directory \"" & appDir & "\" does not exist")
            except OSError:
              showExc("Unable to create directory \"" & appDir & "\"")
            let extension = package[1].substr(package[1].rfind(".") + 1)
            case extension
            of "zip":
              installZip(package[2] , download)
            of "exe":
              showInfo("Type : .exe installer")
              when defined(windows):
                var p:Process
                try:
                  p = startProcess(download)
                except OSError:
                  showExc("Unable to start process \"" & download & "\"")
                showInfo("Process ID : " & p.processID.intToStr)
                var line:string
                while p.outputStream.readLine(line): showLog("Installer log : \"" & line & "\"")
                discard p.waitForExit()
                showLog("Closing process")
                p.close()
              else:
                showInfo("Your OS isn't Windows.")
                let command = "wine " & download
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
        showErr("Package \"" & cmdLineParams[1] & "\" does not exist")
      showProcess("Removing file \"" & download & "\"")
      try:
        removeFile(download)
      except OSError:
        showFailed()
        showExc("Unable to remove file \"" & download & "\"")
      showDone()
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
