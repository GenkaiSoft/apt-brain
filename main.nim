import puppy
import strutils

const url = "https://777shuang.web.fc2.com/apt-brain/list.csv"
echo("Connecting to \"" & url & "\" ...")
let req = Request(url: parseUrl(url) , verb: "get")
let res = fetch(req)
let lines = split(res.body , "\n\r")
for line in lines:
  let tmp = split(line , ",")
  echo(tmp[0])
