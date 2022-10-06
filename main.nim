import httpclient
import strutils

const url = "https://777shuang.web.fc2.com/apt-brain/list.csv"
echo("Connecting to " + url + " ...")
let client = newHttpClient()
let response = client.get(url)
let lines = split(response.body , "\n\r")
for line in lines:
  let tmp = split(line , ",")
