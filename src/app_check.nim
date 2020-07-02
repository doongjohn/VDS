import os
import strutils
import strformat
import cli_text
import app_settings
import eh


type NoDataFolderFoundError = object of Defect


#----------------------------------------------------------------------------------
# Check vscode data folder exists
#----------------------------------------------------------------------------------
proc checkVscDataExists*(): bool =
  vscDataPath.existsDir()


proc noDataFolderFoundError*(): ref Exception =
  result = newException(NoDataFolderFoundError, &"Can't find \"{vscDataPath}\"!")
  returnException:
    createDir(vscDataPath)
    say &"Empty data folder has been created at \"{vscDataPath}\"."

#----------------------------------------------------------------------------------
# Check valid file name
#----------------------------------------------------------------------------------
proc checkValidFileName*(name: string): bool =
  result = not(name.contains("/") or name.contains("\\")) and name.isValidFilename()