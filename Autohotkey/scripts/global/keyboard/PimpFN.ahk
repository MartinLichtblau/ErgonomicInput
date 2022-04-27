/*
    @Title: PimpFN
    @Desc: customizing F-key functions, by mixing their default functions with custom ones
    @Requirements: set F-Keys to default F1-12 in Bios or OS, not the computer specific functions
    #Maturity:5
*/
PimpFN_setup:
    #SingleInstance force
    #Persistent
    #Include %A_WorkingDir%\lib\Commands.ahk
    #Include %A_WorkingDir%\lib\Functions.ahk
    return

;--------------------------------------------F1 - F4
$F1::LongPressCommand("F1", "{Volume_Mute}", "{F1}")

$F2::LongPressCommand("F2", "{Volume_Down}", "{F2}")

$F3::LongPressCommand("F3", "{Volume_Up}", "{F3}")

$F4::LongPressCommand("F4", "gosub MuteTabsToggle", "{F4}")

;--------------------------------------------F5 - F8
$F5::LongPressCommand("F5", "{Media_Prev}", "{F5}")

$F6::LongPressCommand("F6","{Media_Play_Pause}",  "{F6}")

$F7::LongPressCommand("F7", "{Media_Next}", "{F7}")

$F8::LongPressCommand("F8", "!+l", "{F8}")

;--------------------------------------------F9 - F12
$F9::LongPressCommand("F9", "gosub Dictation", "{F9}")

$F10::LongPressCommand("F10", "^l", "gosub TogglePresentationMode")

$F11::LongPressCommand("F11", "gosub ReadMode", "{F11}")

$F12::LongPressCommand("F12", "#^c", "{F12}")


;--------------------------------------------Home - Insert
Home::
    {
    DllCall("LockWorkStation")
    }
    return

End::
    ;Run %A_WorkingDir%\lib\AutoHotInterception\Monitor.ahk
    ; MouseSpy()
    SendInput #a
    return
Insert::
		run ms-settings:sound
		sleep, 1000
		;send {Tab 6}
		;send {Space}
		return



;--------------------------------------------Specific Functions