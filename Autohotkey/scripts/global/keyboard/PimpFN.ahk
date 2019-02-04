/*
    @Title: PimpFN
    @Desc: customizing F-key functions, by mixing their default functions with custom ones
    @Requirements: set F-Keys to default F1-12 in Bios or OS, not the computer specific functions
    #Maturity:6
*/
#Include %A_WorkingDir%\lib\Commands.ahk
#Include %A_WorkingDir%\lib\Functions.ahk


;------------------------------------- F1 - F4 -----------------------------
$F1::LongPressCommand("F1", "{Volume_Mute}", "{F1}")

$F2::LongPressCommand("F2", "{Volume_Down}", "{F2}")

$F3::LongPressCommand("F3", "{Volume_Up}", "{F3}")

$F4::LongPressCommand("F4", "{F2}", "{F4}") ; #idea MuteOtherTabsToggle

;------------------------------------- F5 - F8 -----------------------------
; F5 = F5

$F7::
    run %A_ScriptDir%/lib/AutoHotInterception/Monitor.ahk
return

$F8:: gosub ReadMode

;------------------------------------- F9 - F12 -----------------------------
$F9::LongPressCommand("F9", "{Media_Prev}", "{F9}")

$F10::LongPressCommand("F10", "{Media_Play_Pause}", "{F10}")

$F11::LongPressCommand("F11", "{Media_Next}", "{F11}")

$F12::LongPressCommand("F12", "{^+l}", "{F12}")