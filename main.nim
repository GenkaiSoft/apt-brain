import puppy
import strutils
import os

if paramCount() == 0:
  echo(
    """
 ___              _                  _   _
|   \ _____ _____| |___ _ __  ___ __| | | |__ _  _
| |) / -_) V / -_) / _ \ '_ \/ -_) _` | | '_ \ || |
|___/\___|\_/\___|_\___/ .__/\___\__,_| |_.__/\_, |
                       |_|                    |__/
  ____            _         _ ____         __ _      ∧  ∧
 / ___| ___ _ __ | | ____ _(_) ___|  ___  / _| |_  ／￣￣￣＼
| |  _ / _ \ '_ \| |/ / _` | \___ \ / _ \| |_| __| | ＊  ＊ |
| |_| |  __/ | | |   < (_| | |___) | (_) |  _| |_  |＝ __ ＝|
 \____|\___|_| |_|_|\_\__,_|_|____/ \___/|_|  \__| ＼______／

Copyright (c) 2022 777shuang, GenkaiSoft. All Rights Reserved.

`apt-brain help' to get help
    """
  )
elif commandLineParams()[0] == "help":
  if paramCount() != 1:
    echo("Warning : Too many arguments")
  echo("apt-brain [command]")
  echo("  help : show help")
  echo("  help [command] : show help about [command]")
  echo("  install [package] : install [package]")
  echo("  ping")
  echo("  show : show packeages")
  echo("  show [packeage] : show [package]")
elif  commandLineParams()[0] == "install":
  if paramCount() == 2:
    const url = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
    echo("Connecting to \"" & url & "\" ...")
    let req = Request(url: parseUrl(url) , verb: "get")
    let res = fetch(req)
    echo("  code : " & res.code.intToStr)
    if res.code == 200:
      echo("-> done")
      let lines = split(res.body , "\n\r")
      for line in lines:
        let tmp = split(line , ",")
        if tmp[0] == commandLineParams()[1]:
          echo(tmp[0])
          break
    else :
      echo("-> faild")
      echo("Error : cannot send request to \"" & url & "\"")
  else:
    echo("Error : Too many arguments")
