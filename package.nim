# Add a package to package.json

import std/[strutils , json , streams]

proc prompt(str:string):string =
    echo(str & " > ")
    return stdin.readLine()

let name = prompt("package name").toLower
let description = prompt("description")
var url = prompt("url")
let input = prompt("dir.input")
let output = prompt("dir.output")
let delete = prompt("delete")

if url.startsWith("https://drive.google.com/file/d/"):
    url = "https://drive.google.com/uc?id=" & url.split("/")[5]

var seqDelete:seq[string]
if delete != "":
    seqDelete = delete.split()

let jsonObj = parseFile("package.json")
jsonObj{"packages"}.add(%*{
    "name":name ,
    "description":description ,
    "url":url ,
    "dir":{
        "input":input ,
        "output":output
    },
    "delete":seqDelete
})

let file = newFileStream("package.json" , fmWrite)
file.write(jsonObj.pretty)
file.close()