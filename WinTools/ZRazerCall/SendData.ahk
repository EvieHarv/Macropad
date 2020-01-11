SendData(wParam, lParam) ; http://www.autohotkey.com/board/topic/77796-senddata-sending-data-between-scripts-with-sendmessage/ - May 3, 2013
{ ; wParam = which script; lParam = data in CSV format
	Global
	Static Label
	Local UseError := False
	Local a, b, c, Ptr := A_PtrSize = "" ? "UInt" : "Ptr", Psz := A_PtrSize = "" ? 4 : A_PtrSize
	If (wParam = True) {
		OnMessage(0x4a, A_ThisFunc)
		If lParam and !IsLabel(Label := lParam)
			MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, Label "%Label%" does not exist.
	} Else If (wParam = False) {
		c := A_IsUnicode ? "W" : "A", a := NumGet(lParam + 0, 2 * Psz, Ptr), VarSetCapacity(b, DllCall("lstrlen" c, Ptr, a) << (c = "W")), DllCall("lstrcpy" c, "Str", b, Ptr, a)
		Loop, Parse, b, CSV
			If (A_Index = 1) and !Label
				a := A_LoopField
			Else If (1 & A_Index) ^ !Label
				b := A_LoopField
			Else
				%b% := A_LoopField
		If Label or IsLabel(a)
			SetTimer, % Label ? Label : a, -1
		Else
			MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, Label "%a%" does not exist.
		Return True
	} Else {
		a := A_DetectHiddenWindows, b := A_TitleMatchMode
		DetectHiddenWindows, On
		SetTitleMatchMode, Regex
		VarSetCapacity(c, 3 * Psz, 0), NumPut((StrLen(lParam) + 1) * (A_IsUnicode ? 2 : 1), c, Psz), NumPut(&lParam, c, 2 * Psz)
		SendMessage, 0x4a, 0, &c, , i)\\\Q%wParam%\E(\.(ahk|exe))? ahk_class AutoHotkey ; edit this regular expression to your liking
		If (ErrorLevel <> True) and UseError
			MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, % "ErrorLevel:`t" ErrorLevel "`n" ErrorLevel ? "Script """ wParam """ did not receive the message; the script may not exist." : "Message sent but the target window responded with 0, which may mean it ignored it."
		DetectHiddenWindows, %a%
		SetTitleMatchMode, %b%
	}
}