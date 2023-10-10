/*
    @Title: PimpFN
    @Desc: customizing F-key functions, by mixing their default functions with custom ones
    @Requirements: set F-Keys to default F1-12 in Bios or OS, not the computer specific functions
    #Maturity:5
*/
PimpFN_setup:
    #SingleInstance force
    #Persistent
    #Include %A_ScriptDir%\lib\Commands.ahk
    #Include %A_ScriptDir%\lib\Functions.ahk
    return

;--------------------------------------------F1 - F4
$F1::LongPressCommand("F1", "{Volume_Mute}", "{F1}")

$F2::LongPressCommand("F2", "{Volume_Down 4}", "{F2}")

$F3::LongPressCommand("F3", "{Volume_Up 4}", "{F3}")

$F4::LongPressCommand("F4", "gosub MuteTabsToggle", "{F4}")

;--------------------------------------------F5 - F8
$F5::LongPressCommand("F5", "{Media_Prev}", "{F5}")

$F6::LongPressCommand("F6","{Media_Play_Pause}",  "{F6}")

$F7::LongPressCommand("F7", "{Media_Next}", "{F7}")

$F8::LongPressCommand("F8", "!l", "{F8}")

;--------------------------------------------F9 - F12
$F9::LongPressCommand("F9", "{F9}", "gosub Dictation")

$F10::LongPressCommand("F10", "{F10}", "gosub TogglePresentationMode")

$F11::LongPressCommand("F11", "{F11}", "gosub ReadMode")

$F12::LongPressCommand("F12", "{F12}", "#^c")

;--------------------------------------------Home - Insert
Home:: LongPressCommand("Home", "gosub ReadMode", "{Home}")

End::LongPressCommand("End", "#a", "{End}") ; open quick Windows quick settings
MoveCursorToLeft()

;MoveCursorToShow()
touchscreenId := AHI.GetMouseId(0x056A, 0x5146)
AHI.SendMouseButtonEvent(touchscraeenId, 1, 1)
AHI.SendMouseButtonEvent(touchscreenId, 1, 0)
;MouseMove, 1, 50,R
;DllCall("SetCursorPos", "int", 5, "int", 5)
;AHI.SendMouseMove(trackpadId, 5, 5)
Return

MoveCursorToShow() ;Run %A_ScriptDir%\lib\AutoHotInterception\Monitor.ahk ;LongPressCommand("End", "#a", "{End}") ; open quick Windows quick settings
; Run %A_ScriptDir%\lib\AutoHotInterception\Monitor.ahk
; LongPressCommand("End", "gosub OpenSoundSettings", "{End}")
; MouseSpy()
return

Insert:: DllCall("LockWorkStation")

;--------------------------------------------Specific Functions