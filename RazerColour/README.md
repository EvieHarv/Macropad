# RazerColor - A basic scripting language for chroma interfacing

Simply call the lightpack you wish to use by running `RazerColour.exe [lightpack location or name]`.
For some examples of how to use, see `/ExampleLightpacks/`.
Scripts must be placed into `C:\ProgramData\ZRazer\Lightpacks`, or lightpack location specified during application call.

General structure is

```rzl
; Comments denoted by a semicolon

rgb 000000 ; The below keys are changed to the RGB value 000000

key1
key2
key3 ; etc...

rgb ffffff ; Now all below keys will be the second value ffffff

key4
key5
key6 ; etc...
```

## Calling the program

---

```bash
razerColour [filepath]
    Script filepath can be absolute or relative to the program default folder (C:\ProgramData\ZRazer\Lightpacks). By default, a new script will entirely replace a previous one.

-A
    Add-strong. Adds the newly called script on top of previously called script, replacing the old one when necessary.

-a
    Add-weak. Same as above, except that the older script will take precedence.
```

## Dependencies

---

You must place Colore.dll in the same directory as RazerColor.

## All available keys and how to write them

---

```rzl
rgb 00FF00

; for all keys at once, just put ALL at the top of your script. Any keys specified BELOW it will still change color on top of that

Logo ; the device's razer logo

a ; All letters work (case insensitive)
b
c

Backspace    ; self explanatory
CapsLock
PrintScreen
Scroll
Pause
Insert
Home
PageUp
PageDown
Delete
Enter
LeftControl
LeftWindows
LeftAlt
LeftShift
RightShift
RightAlt
Function
RightMenu
RightControl
End
Tab
Space
NumLock
NumDivide
NumMultiply
NumSubtract
NumAdd
NumEnter
NumDecimal


Up    ; arrow keys
Down
Left
Right

OemTilde    ; Not my decision to make these all Oem-Something, but they're self explanatory
OemMinus
OemEquals
OemLeftBracket
OemRightBracket
OemBackslash
OemSemicolon
OemApostrophe
OemComma
OemPeriod
OemSlash

Num0
Num1
Num9 ; etc.. (Full-Sized numpad keys)

D0 ; top row of keyboard/regular numbers/"""!@#$%^&*()""" keys
D1
D9

F1 ; function keys
F2
F12

Macro1
Macro2
Macro3
Macro4
Macro5

JpnYen    ; honestly no clue, but Colore supports them so sure go ahead if you need these
JpnSlash
Jpn3
Jpn4
Jpn5
KorPipe
Kor2      ; you'd think we would have Kor1, but it appears not.
Kor3
Kor4
Kor5
Kor6
Kor7
EurPound
EurBackslash
```
