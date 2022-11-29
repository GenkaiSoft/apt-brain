import std/[os , strutils , streams , osproc]
import zippy/ziparchives
import ../common

proc cmdInstall*() {.inline.} =
  if cmdLineParamCount == 2:
    let lines = split(connect(url) , "\n")
    var
      exist = false
      fileName:string
    for line in lines:
      let tmp = split(line , ",")
      if tmp[0].toLower == cmdLineParams[1].toLower:
        showInfo("Package : \"" & tmp[0] & "\" is exist.")
        exist = true
        fileName = tmp[1].substr(tmp[1].rfind("/") + 1)
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
          if res == "": break
          else:
            showLog("File : \"" & fileName & "\" Closed.")
            showLog("File : \"" & fileName & "\" Downloaded.")
            const appDir = "アプリ"
            try:
              if existsOrCreateDir(appDir): showInfo("Directory : \"" & appDir & "\" isn't exist.")
            except OSError: showExc("Unable to create directory : " & appDir & "\"")
            let extension = tmp[1].substr(tmp[1].rfind(".") + 1)
            case extension
            of "zip":
              showLog("Extracting zip file : \"" & fileName & "\" ...")
              var error = false
              try: extractAll(fileName , appDir / tmp[0])
              except ZippyError:
                showFailed()
                showExc("Unable to extract zip file : \"" & fileName & "\"")
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
                  showExc("Unable to start process : \"" & filename & "\"")
              else:
                showInfo("Your OS isn't Windows.")
                let command = "wine " & fileName
                showLog("Calling command : \"" & command & "\" ...")
                let code = execShellCmd(command)
                showDone()
                showLog("Code : " & code.intToStr)
                if code != 0:
                  showErr("Unable to call command : \"" & command & "\"")
                  showInfo("Did you install wine ?")
            else:
              showErr("Unknown extension : " & extension)
        break
    if not exist:
      showErr("Package \"" & commandLineParams()[1] & "\" isn't exist.")
    showLog("Removing file : \"" & fileName & "\" ...")
    try:
      removeFile(fileName)
    except OSError:
      showFailed()
      showExc("Unable to remove file : \"" & fileName & "\"")
    showDone()
  elif paramCount() == 1:
    showFew()
  else:
    showMany()
