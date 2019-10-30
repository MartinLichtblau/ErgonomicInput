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

$F4::LongPressCommand("F4", "{F4}", "gosub MuteTabsToggle")

;--------------------------------------------F5 - F8
$F5::LongPressCommand("F5", "{F5}", "{Media_Prev}")

$F6::LongPressCommand("F6","{F6}",  "{Media_Play_Pause}")

$F7::LongPressCommand("F7", "{F7}", "{Media_Next}")

$F8::LongPressCommand("F8", "{F8}", "!+l")

;--------------------------------------------F9 - F12
$F9:: LongPressCommand("F9", "{F9}", "gosub TogglePresentationMode")
      ; Run %A_WorkingDir%\lib\AutoHotInterception\Monitor.ahk

$F10::LongPressCommand("F10", "{F10}", "#h")

$F11:: LongPressCommand("F11", "{F11}", "gosub ReadMode")

$F12:: LongPressCommand("F12", "{F12}", "#^c")


;--------------------------------------------Home - Insert
Home::
    SetCursorIDC_SIZE()
    return
    SPI_SETCURSORS := 0x57
	v := DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
	Tooltip SPI_SETCURSORS %v%
	Sleep 1000
	Tooltip
	return


    SetSystemCursor("IDC_HAND")
    return




/*
RestoreCursors:
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
	return
*/

; *Insert::


;--------------------------------------------Specific Functions