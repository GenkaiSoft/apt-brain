# Add a package to package.json

import std/[strutils , json , streams]

proc prompt(str:string):string =
    echo(str & " > ")
    return stdin.readLine()

let
    name = prompt("package name").toLower
    description = prompt("description")
    url = prompt("url")
    input = prompt("dir.input")
    output = prompt("dir.output")
    delete = prompt("delete")

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