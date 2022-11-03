import puppy
import strutils
import os

if paramCount() == 0:
  echo(
    """
     ____            _                         _    ∧  ∧
    | __ ) _ __ __ _(_)_ __   ___ ___  _ __ __| | ／￣￣￣＼
    |  _ \| '__/ _` | | '_ \ / __/ _ \| '__/ _` | | ＊  ＊ |
    | |_) | | | (_| | | | | | (_| (_) | | | (_| | |＝ __ ＝|
    |____/|_|  \__,_|_|_| |_|\___\___/|_|  \__,_| ＼______／
    """
  )
elif paramCount() == 2 and commandLineParams()[0] == "install":
  const url = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
  echo("Connecting to \"" & url & "\" ...")
  let req = Request(url: parseUrl(url) , verb: "get")
  let res = fetch(req)
  let lines = split(res.body , "\n\r")
  for line in lines:
    let tmp = split(line , ",")
    if tmp[0] == commandLineParams()[1]:
      echo(tmp[0])
      break
