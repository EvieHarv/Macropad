#NoEnv
SendMode, Input
SetWorkingDir %A_ScriptDir%

#Include ZRazerListener.ahk
return

ZRazerA:
    setZState("test")
return

ZRazerATest:
    MsgBox, woah you actually did something
    ExitApp
return