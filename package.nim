import src/common
import std/[strutils , json , streams]

proc prompt(str:string):string =
    echo(str & " > ")
    return stdin.readLine()
proc prompt(str , def:string):string =
    let result = prompt(str & "[\"" & def & "\"]")
    if result == "":
        return def
    else:
        return result

let
    name = prompt("package name").toLower
    description = prompt("description" , "")
    gen = prompt("gen" , "1 2 3 4")
    url = prompt("url")
    input = prompt("dir.input")
    output = prompt("dir.output")
    delete = prompt("delete" , "NULL")

let
    jsonRootObj = parseFile("package.json")
    jsonObj = jsonRootObj{"packages"}

let file = newFileStream("package.json" , fmWrite)
file.write(jsonRootObj.pretty)
file.close()