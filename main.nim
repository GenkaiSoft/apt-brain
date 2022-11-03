import puppy
import strutils

const url = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/list.csv"
echo("Connecting to \"" & url & "\" ...")
let req = Request(url: parseUrl(url) , verb: "get")
let res = fetch(req)
let lines = split(res.body , "\n\r")
for line in lines:
  let tmp = split(line , ",")
  echo(tmp[0])
