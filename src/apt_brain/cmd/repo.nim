import std/[os , strutils , tables]
import liblim/logging
import ../common

proc parseOrCreateRepoFile*():seq[string] =
  let
    configDir = getConfigDir() / appName
    repoFilePath = configDir / "repo.txt"
  if repoFilePath.fileExists:
    let file = repoFilePath.openFile
    return file.readAll.split("\n")
  discard configDir.existsOrCreateDir
  let official = "https://raw.githubusercontent.com/GenkaiSoft/apt-brain/main/package.json"
  repoFilePath.createAndWriteFile(official)

proc cmdRepo*() {.inline.} =
  echo "DEBUG"