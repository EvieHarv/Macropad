#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent         ; Keeps the script running permanently
#SingleInstance     ; Only allows one instance of the script

SetWinDelay,3 ; Winmover.ahk startup component.

CoordMode,Mouse ; Winmover.ahk startup component.

GLOBAL NumpadState = 0
switchLighting("NumpadBlank")
SetNumLockState, on
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Audio Devices (DKM4)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; DKM4 + Shift = Input Device
+F24::
	togglei:=!togglei
	if togglei
	{
		Run nircmd setdefaultsounddevice "Microphone"
		notifBox("Default Input: Microphone")
	}
	else
	{
		Run nircmd setdefaultsounddevice "Digital Audio Interface"
		notifBox("Default Input: Interface")
	} 
Return


; DKM4 = Output Device
F24::
	toggleo:=!toggleo
	if toggleo
	{
		Run nircmd setdefaultsounddevice "DualSpeakers"
		notifBox("Default Output: Speakers")
	}
	else
	{
		Run nircmd setdefaultsounddevice "Headset Earphone"
		notifBox("Default Output: Headset")
	}
	Run "C:\Program Files\Rainmeter\Rainmeter.exe" !RefreshApp
Return


; DMK4 + Control = VoiceChanger toggle. (I don't want to always have it running.)
^F24::
	togglev:=!togglev
	if togglev
	{
		Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Voicemod Desktop\Voicemod.lnk"
		Run nircmd setdefaultsounddevice "VMMicrophone"
		Run nircmd setdefaultsounddevice "VMMicrophone" 2
		notifBox("Turned VoiceMod on")
	}
	else
	{
		Run nircmd setdefaultsounddevice "Microphone"
		Run nircmd setdefaultsounddevice "Microphone" 2
		Process, Close, VoicemodDesktop.exe
		notifBox("TurnedVoiceMod off")
	}
	Run "C:\Program Files\Rainmeter\Rainmeter.exe" !RefreshApp
Return


F21:: ; M5;
	Reload
Return


;
;
;											BEGIN NUMPAD SECTION
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;		STATES		
;		
;		0 = None
;		1 = Switcher (Metastate)
;		2 = Youtube
;		3 = Discord
;		4 = VoiceMod
;		5 = AppSwap

switchState(state)
{
	if (state == -1)
	{
		; For special cases when you need to get outta there real fast.
		NumpadState = 0
		switchLighting("close")
		notifBox("Killed process RazerColour.exe")
		return
	}
	if (state == 0) ; Closed (Use NumpadBlank for instant re-lighting.)
	{
		NumpadState = 0
		switchLighting("NumpadBlank")
		return
	}
	if (state == 1) ; Switcher (Metastate)
	{
		NumpadState = 1
		switchLighting("NumpadSwitcher")
		return
	}
	if (state == 2) ; Youtube
	{
		NumpadState = 2
		switchLighting("NumpadRed")
		return
	}
	if (state == 3) ; Discord
	{
		NumpadState = 3
		switchLighting("NumpadDiscord")
		return
	}
	if (state == 4) ; VoiceMod
	{
		NumpadState = 4
		switchLighting("NumpadWhite")
		return
	}
	if (state == 5) ; AppSwap
	{
		NumpadState = 5
		switchLighting("NumpadSwap")
	}
}
return

NumLock::
NumpadSub::
F20:: ; M1
	switchState(1) ; Activate Switcher
Return

+F20::
	switchState(-1) ; Turn switcher off.
return

^F20::
	notifBox("Currently in Numpad State " + NumpadState)
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#If NumpadState != 0

Numpad0::
	state%NumpadState%(0)
return

Numpad1::
	state%NumpadState%(1)
return

Numpad2::
	state%NumpadState%(2)
return

Numpad3::
	state%NumpadState%(3)
return

Numpad4::
	state%NumpadState%(4)
return

Numpad5::
	state%NumpadState%(5)
return

Numpad6::
	state%NumpadState%(6)
return

Numpad7::
	state%NumpadState%(7)
return

Numpad8::
	state%NumpadState%(8)
return

Numpad9::
	state%NumpadState%(9)
return

NumpadDot::
	state%NumpadState%(10)
return

#If

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Dot/Del = 10

state1(num) ; Switcher
{
	if(num == 0)
	{
		switchState(0)
		return
	}
	if(num == 1)
	{
		switchState(3) ; Discord
		return
	}
	if(num == 2)
	{
		return
	}
	if(num == 3)
	{
		return
	}
	if(num == 4)
	{
		switchState(4) ; VoiceMod
		return
	}
	if(num == 5)
	{
		return
	}
	if(num == 6)
	{
		return
	}
	if(num == 7)
	{
		switchState(2) ; Youtube
		return
	}
	if(num == 8)
	{
		switchState(5) ; AppSwap
		return
	}
	if(num == 9)
	{
		return
	}
	if(num == 10)
	{
		switchState(0)
		return
	}
}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state2(num) ; Youtube
{
	; Heavily utilizes SoundFinder.js - see other file in project repo.
	if(num == 0)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{Up}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 1)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{4}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 2)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{8}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 3)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{3}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 4)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{6}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 5)
	{ 
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{0}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 6)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{5}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 7)
	{
		;Run, nircmd changeappvolume firefox.exe -.05
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{2}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 8)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{7}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 9)
	{
		;Run, nircmd changeappvolume firefox.exe .05
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{1}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}
	if(num == 10)
	{
		ControlSend,ahk_parent,{AltDown}{CtrlDown}{Down}{CtrlUp}{AltUp}, ahk_exe firefox.exe
		return
	}

}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state3(num) ; Discord
{
	ControlFocus,,ahk_exe DiscordCanary.exe
	if(num == 0)
	{
		ControlSend,ahk_parent,{CtrlDown}{Enter}{CtrlUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 1)
	{
		ControlSend,ahk_parent,{CtrlDown}{AltDown}{Down}{CtrlUp}{AltUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 2)
	{
		ControlSend,ahk_parent,{AltDown}{Down}{AltUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 3)
	{
		ControlSend,ahk_parent,{PgDn}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 4)
	{
		ControlSend,ahk_parent,{ShiftDown}{Esc}{ShiftUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 5)
	{
		ControlSend,ahk_parent,{Esc}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 6)
	{
		ControlSend,ahk_parent,{CtrlDown}{'}{CtrlUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 7)
	{
		ControlSend,ahk_parent,{CtrlDown}{AltDown}{Up}{CtrlUp}{AltUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 8)
	{
		ControlSend,ahk_parent,{AltDown}{Up}{AltUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 9)
	{
		ControlSend,ahk_parent,{PgUp}, ahk_exe DiscordCanary.exe
		return
	}
	if(num == 10)
	{
		ControlSend,ahk_parent,{Esc}, ahk_exe DiscordCanary.exe
		return
	}

}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
state4(num) ; VoiceMod
{
	if(num == 0)
	{
		Send, {F13 Down}{NumpadIns Down}{NumpadIns Up}{F13 Up}
		return
	}
	if(num == 1)
	{
		Send, {F13 Down}{NumpadEnd Down}{NumpadEnd Up}{F13 Up}
		return
	}
	if(num == 2)
	{
		Send, {F13 Down}{NumpadDown Down}{NumpadDown Up}{F13 Up}
		return
	}
	if(num == 3)
	{
		Send, {F13 Down}{NumpadPgdn Down}{NumpadPgdn Up}{F13 Up}
		return
	}
	if(num == 4)
	{
		Send, {F13 Down}{NumpadLeft Down}{NumpadLeft Up}{F13 Up}
		return
	}
	if(num == 5)
	{
		Send, {F13 Down}{NumpadClear Down}{NumpadClear Up}{F13 Up}
		return
	}
	if(num == 6)
	{
		Send, {F13 Down}{NumpadRight Down}{NumpadRight Up}{F13 Up}
		return
	}
	if(num == 7)
	{
		Send, {F13 Down}{NumpadHome Down}{NumpadHome Up}{F13 Up}
		return
	}
	if(num == 8)
	{
		Send, {F13 Down}{NumpadUp Down}{NumpadUp Up}{F13 Up}
		return
	}
	if(num == 9)
	{
		Send, {F13 Down}{NumpadPgup Down}{NumpadPgup Up}{F13 Up}
		return
	}
	if(num == 10)
	{
		Send, {F13 Down}{NumpadDel Down}{NumpadDel Up}{F13 Up}
		return
	}
}
return
state5(num) ; AppSwap
{
	if (num == 0)
	{
		
	}
	if (num == 1)
	{

	}
	if (num == 2)
	{

	}
	if (num == 3)
	{

	}
	if (num == 4)
	{

	}
	if (num == 5)
	{

	}
	if (num == 6)
	{

	}
	if (num == 7)
	{

	}
	if (num == 8)
	{

	}
	if (num == 9)
	{

	}
	if (num == 10)
	{

	}
}
return







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; Function calling RazerColour app 5 in order to switch lighting profile.
; Can also call it with "Close" to kill all app instances.
switchLighting(profile)
{
	if (profile == "close")
	{
		Process, Close, RazerColour.exe
		Sleep, 50 ; 50ms sleep to make sure it closes
		return
	}

	Run "C:\ProgramData\ZRazer\RazerColour.exe" %profile%,,Hide
	return
}
return



; Function to display sound toggle GUI
notifBox(message)
{
	IfWinExist, soundToggleWin
	{
		Gui, destroy
	}
	
	Gui, +ToolWindow -Caption +0x400000 +alwaysontop
	Gui, Add, text, x35 y8, %message%
	SysGet, screenx, 0
	SysGet, screeny, 1
	xpos:=screenx-275
	ypos:=screeny-100
	Gui, Show, NoActivate x%xpos% y%ypos% h30 w200, soundToggleWin
	
	SetTimer,soundToggleClose, 2000
}
soundToggleClose:
    SetTimer,soundToggleClose, off
    Gui, destroy
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Notes App (DKM3)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F23::
	Run "C:\Users\Zonee\AppData\Local\Programs\Microsoft VS Code\Code.exe" "C:\Users\Zonee\Documents\#Files\NOTES_MASTER\%A_YYYY%-%A_MM%-%A_MMM%\%A_DD%-%A_DDD%.nte" "C:\Users\Zonee\Documents\#Files\NOTES_MASTER"
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles Monitor Shutoff (DKM2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

F22::
	Run nircmd cmdwait 500 monitor off
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Handles WinMover.ahk (M4 + Mouse)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#IfWinActive, ahk_exe javaw.exe
XButton2::s
#IfWinActive

#IfWinNotActive, ahk_exe javaw.exe

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XButton2 & LButton::																						   ; Moves
	MouseGetPos,KDE_X1,KDE_Y1,KDE_id
	WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
	If KDE_Win
	    return
	; Get the initial window position.
	WinGetPos,KDE_WinX1,KDE_WinY1,,,ahk_id %KDE_id%
	Loop
	{
	    GetKeyState,KDE_Button,LButton,P ; Break if button has been released.
	    If KDE_Button = U
	        break
		GetKeyState,KDE_Focus_Second,XButton1,P
		If KDE_Focus_Second = D
			WinActivate,ahk_id %KDE_id%
	    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
	    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
	    KDE_Y2 -= KDE_Y1
	    KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
	    KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
	    WinMove,ahk_id %KDE_id%,,%KDE_WinX2%,%KDE_WinY2% ; Move the window to the new position.
	}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XButton2 & MButton::				   														        ; Toggle Maximized
	MouseGetPos,,,KDE_id
	; Toggle between maximized and restored state.
	WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
	If KDE_Win
	    WinRestore,ahk_id %KDE_id%
	Else
	    WinMaximize,ahk_id %KDE_id%
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XButton2 & RButton:: 																					   ; Re-sizing
	; Get the initial mouse position and window id, and
	; abort if the window is maximized.
	MouseGetPos,KDE_X1,KDE_Y1,KDE_id
	WinGet,KDE_Win,MinMax,ahk_id %KDE_id%
	If KDE_Win
	    return
	; Get the initial window position and size.
	WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
	; Define the window region the mouse is currently in.
	; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
	If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
	    KDE_WinLeft := 1
	Else
	    KDE_WinLeft := -1
	If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
	    KDE_WinUp := 1
	Else
	    KDE_WinUp := -1
	Loop
	{
	    GetKeyState,KDE_Button,RButton,P ; Break if button has been released.
	    If KDE_Button = U
	        break
	    MouseGetPos,KDE_X2,KDE_Y2 ; Get the current mouse position.
	    ; Get the current window position and size.
	    WinGetPos,KDE_WinX1,KDE_WinY1,KDE_WinW,KDE_WinH,ahk_id %KDE_id%
	    KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
	    KDE_Y2 -= KDE_Y1
	    ; Then, act according to the defined region.
	    WinMove,ahk_id %KDE_id%,, KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
	                            , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
	                            , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
	                            , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
	    KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
	    KDE_Y1 := (KDE_Y2 + KDE_Y1)
	}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XButton1 & MButton:: 								 	 	 	 	 	 	 	 	 	 	 		  	   ; Minimizes
    MouseGetPos,,,KDE_id
    PostMessage,0x112,0xf020,,,ahk_id %KDE_id%
return
