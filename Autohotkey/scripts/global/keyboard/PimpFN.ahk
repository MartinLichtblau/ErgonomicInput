/*
    @Title: PimpFN
    @Desc: customizing F-key functions, by mixing their default functions with custom ones
    @Requirements: set F-Keys to default F1-12 in Bios or OS, not the computer specific functions
    #Maturity:5
*/

;--------------------------------------------F1 - F4
$F1::LongPressCommand("F1", "{Volume_Mute}", "{F1}")

$F2::LongPressCommand("F2", "{Volume_Down 4}", "{F2}")

$F3::LongPressCommand("F3", "{Volume_Up 4}", "{F3}")

$F4::LongPressCommand("F4", "gosub MuteTabsToggle", "{F4}")

;--------------------------------------------F5 - F8
$F5::LongPressCommand("F5", "{F5}", "{Media_Prev}")

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

Insert:: DllCall("LockWorkStation")

;--------------------------------------------Specific Functions