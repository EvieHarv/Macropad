;#NoEnv
;SendMode, Input
;SetWorkingDir %A_ScriptDir%

#SingleInstance
OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA
FileCreateDir, C:\ProgramData\ZRazer\Macropad ; Ensure path exists for call name to be placed in
file := FileOpen("C:\ProgramData\ZRazer\Macropad\callName.rz", "w") ; Place call name
file.Write(A_ScriptName)
file.Close()

global ZRazerState = ""
return

setZState(state)
{
    ZRazerState := state
}

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
    name = ZRazer%CopyOfData% ; ZRazer[key]
    if IsLabel(name)
    {
        Gosub %name%
    }
    name = ZRazer%CopyOfData%%ZRazerState% ; ZRazer[key][state]
    if IsLabel(name)
    {
        Gosub %name%
    }
}
Return