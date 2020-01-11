;#NoEnv
;SendMode, Input
;SetWorkingDir %A_ScriptDir%

#SingleInstance
OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA
FileCreateDir, C:\ProgramData\ZRazer\Macropad ; Ensure path exists for call name to be placed in
file := FileOpen("C:\ProgramData\ZRazer\Macropad\callName.rz", "w") ; Place call name
file.Write(A_ScriptName)
file.Close()
return

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.

    MsgBox, %A_ScriptName%`nReceived the following string:`n%CopyOfData% ; TODO: Change to label callback structure
}
Return

ZRazerCallback(name)
{
    if IsLabel(name)
        Gosub %name%
}