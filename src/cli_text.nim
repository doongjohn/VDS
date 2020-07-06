{.experimental: "codeReordering".}

import math
import streams
import strutils
import strformat
import terminal
import utils


var sayBuffer = newStringStream()


proc sayAdd*(msg: string) =
  sayBuffer.write(msg)


proc sayIt*(prefix: string = "| ", lineBreak = true, keepIndent = true) =
  say(sayBuffer.readAllAndClose(), prefix, lineBreak, keepIndent)
  sayBuffer = newStringStream()


proc say*(msg: string, prefix: string = "| ", lineBreak = true, keepIndent = true) =
  var indent = 0
  if keepIndent:
    for ch in msg:
      if ch != ' ': break
      indent.inc
  
  let prefixWIndent = if keepIndent: &"{prefix}{' '.repeat(indent)}" else: prefix
  let writeWidth = if keepIndent: terminalWidth() - prefixWIndent.len() else: terminalWidth() - prefix.len()
  
  proc lineWrap(line: string): string =
    if line.len <= writeWidth: return line
    let wrapped = newStringStream()
    let lineCount = (line.len.float / writeWidth.float).ceil.int
    var i = 0
    loop(i < lineCount, i.inc):
      if i != 0: wrapped.write(prefixWIndent)
      try:
        wrapped.write(line[i*writeWidth .. i*writeWidth+writeWidth-1])
        wrapped.write('\n')
      except:
        wrapped.write(line[i*writeWidth .. ^1])
    result = wrapped.readAllAndClose()
  
  let res = newStringStream()
  let splited = msg.split('\n')
  var i = 0
  loop(i < splited.len, i.inc):
    if i == 0:
      res.write(prefix)
    else:
      res.write('\n')
      res.write(prefixWIndent)
    res.write(splited[i].lineWrap())
  if lineBreak: res.write('\n')
  stdout.write(res.readAllAndClose())


proc showTitle*() =
  eraseScreen()
  setCursorPos(0, 0)
  say "<VSCode Data Swapper>"


proc showBasicInfo*() =
  say "Welcome back!"
  say "Enter \"help\" or \"?\" for help."


proc showExitText*() =
  say "See you soon!"