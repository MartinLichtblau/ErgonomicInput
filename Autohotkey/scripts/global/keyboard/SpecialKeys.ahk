/*
    @Title: SpecialKeys
    @Desc: fundamental changes of special keys, concerning mapping and behavior
    #Maturity:7
*/
;#include %A_ScriptDir%\lib\AutoHotInterception\lib\AutoHotInterception.ahk

SpecialKeys_Setup:
    #SingleInstance force
    #Persistent

    ; Init Variables
    global spaceSc, tabSc, lShiftSc, capslockSc, lAltSc, lCtrlSc, lWinSc, printScreenSc, rAltSc, rCtrlSc, r2c1Sc, FnSc
        , escSc, enterSc, deleteSc, backspaceSc
    if(AHI == "")
        global AHI
        AHI := new AutoHotInterception()
    global kbdId = 1 ; use 1st/primary keyboard to intercept and also for output
    Gosub GetAllKeySc

    ; Subscribe to Keys
    AHI.SubscribeKey(kbdId, spaceSc, true, Func("SpaceShiftEvent"))
    AHI.SubscribeKey(kbdId, lShiftSc, true, Func("LShiftEvent"))
    AHI.SubscribeKey(kbdId, rShiftSc, true, Func("RShiftEvent"))
    AHI.SubscribeKey(kbdId, tabSc, true, Func("TabEvent"))
    AHI.SubscribeKey(kbdId, r2c1Sc, true, Func("KeyUnderEscEvent"))
    AHI.SubscribeKey(kbdId, capslockSc, true, Func("CapslockEvent"))
    AHI.SubscribeKey(kbdId, lAltSc, true, Func("LAltEvent"))
    AHI.SubscribeKey(kbdId, lCtrlSc, true, Func("LCtrlEvent"))
    AHI.SubscribeKey(kbdId, lWinSc, true, Func("LWinEvent"))
    AHI.SubscribeKey(kbdId, printScreenSc, true, Func("PrintScreenEvent"))
    AHI.SubscribeKey(kbdId, rAltSc, true, Func("RAltEvent"))
    AHI.SubscribeKey(kbdId, rCtrlSc, true, Func("RCtrlEvent"))
;    AHI.SubscribeKey(kbdId, FnSc, true, Func("FnEvent")) ; 355 = FN
    AHI.SubscribeKey(kbdId, GetKeySC("q"), true, Func("QEvent"))
    AHI.SubscribeKey(kbdId, GetKeySC("w"), true, Func("WEvent"))
    return

GetAllKeySc:
    spaceSc := GetKeySC("Space")
    tabSc := GetKeySC("Tab")
    lShiftSc := GetKeySC("LShift")
    rShiftSc := GetKeySC("RShift")
    capslockSc := GetKeySC("Capslock")
    lAltSc := GetKeySC("LAlt")
    lCtrlSc := GetKeySC("LCtrl")
    lWinSc := GetKeySC("LWin")
    printScreenSc := GetKeySC("PrintScreen")
    rAltSc := GetKeySC("RAlt")
    rCtrlSc := GetKeySC("RCtrl")
    r2c1Sc := GetKeySC("^")
    FnSc := 355
    escSc := GetKeySC("Esc")
    enterSc := GetKeySC("Enter")
    deleteSc := GetKeySC("Delete")
    backspaceSc := GetKeySC("Backspace")
    return

WEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, GetKeySC("q"), 1)
    } else {
        AHI.SendKeyEvent(kbdId, GetKeySC("q"), 0)
    }
}

QEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, GetKeySC("w"), 1)
    } else {
        AHI.SendKeyEvent(kbdId, GetKeySC("w"), 0)
    }
}

LShiftEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, tabSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, tabSc, 0)
    }
}

RShiftEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, tabSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, tabSc, 0)
    }
}

TabEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, backspaceSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, backspaceSc, 0)
    }
}

KeyUnderEscEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, deleteSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, deleteSc, 0)
    }
}

CapslockEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, enterSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, enterSc, 0)
    }
}

LAltEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, lCtrlSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, lCtrlSc, 0)
    }
}

LCtrlEvent(state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, lWinSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, lWinSc, 0)
    }
}

LWinEvent(state) {
   if(state) {
        AHI.SendKeyEvent(kbdId, lAltSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, lAltSc, 0)
    }
}

PrintScreenEvent(state) {
   if(state) {
        AHI.SendKeyEvent(kbdId, lAltSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, lAltSc, 0)
    }
}

RAltEvent(state) {
   if(state) {
        AHI.SendKeyEvent(kbdId, lCtrlSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, lCtrlSc, 0)
    }
}

RCtrlEvent(state) {
   if(state) {
        AHI.SendKeyEvent(kbdId, GetKeySC("AppsKey"), 1)
    } else {
        AHI.SendKeyEvent(kbdId, GetKeySC("AppsKey"), 0)
    }
}

FnEvent(state) {
   if(state) {
;         MouseClick,WheelDown,,,7,0,D,R
;        AHI.SendKeyEvent(kbdId, GetKeySC("Down"), 1)
    } else {
;        AHI.SendKeyEvent(kbdId, GetKeySC("Down"), 0)
;        SendInput {Home}
    }
}

; Fn Key Press
sc163:: Autoscroll()

Global Autoscroll := 0
Autoscroll() {
        ;MouseClick,WheelDown,,,3,0,D,R
        ;SendInput {Down}
        ; StartTime := A_TickCount
       ; KeyWait, sc163
        ;px_down := A_TickCount - StartTime
        move_distance := 80
        ;tooltip %px_down% %StartTime% %A_TickCount%
        ;MoveCursorToShow()

        CoordMode, Mouse, Screen
        MouseGetPos, X, Y
        MouseMove, 0, 0,, R ;DllCall("SetCursorPos", "int", X, "int", Y+1)
        Y -= move_distance ; move cursor 30px UP first
        DllCall("SetCursorPos", "int", X, "int", Y)
        SendInput {MButton}
        Sleep 100
        ; tooltip %A_Cursor% ; Arrow is normal pointer and middle scroll is unknown
        Y += move_distance ; move cursor 30px down to initiate slow down scroll
        DllCall("SetCursorPos", "int", X, "int", Y)
        if (A_Cursor == "Unknown") {
            Autoscroll := 1
        } else {
            Autoscroll := 0
        }
        ;tooltip : %Autoscroll% %A_Cursor%
        return
}

/*
    @Title: SpaceShift
    @Desc: use Space as both Shift and Space
    #note manual time calculation is just a #fix because internal A_TimeSince.. vars don't work (since AHI hides input)
    #note A_PriorKey needs some key event after down-event and it slow; hence various ways to deal with it:
        see: #Alt1.1, #Alt1.2
*/
global shiftSpaceDown := false
SpaceShiftEvent(state) {
    static timeOfInitDown
    if(state) {
        if(!shiftSpaceDown) {
            AHI.SendKeyEvent(kbdId, lShiftSc, 1)
            ; Send {LShift Down}
            shiftSpaceDown := true
            timeOfInitDown := A_TickCount
        }
    } else {
        AHI.SendKeyEvent(kbdId, lShiftSc, 0)
        ; Send {LShift Up}
        shiftSpaceDown := false
        ; pressDuration := A_TickCount - timeOfInitDown
        Sleep 1 ; #Alt1.2 =fix wait so it recognizes the LShift up event ; 0 or 1 ms seems to make a bigger difference
        ;Tooltip %A_TimeIdleKeyboard% %A_TimeIdlePhysical% %pressDuration% %A_PriorKey%
        if(A_PriorKey == "LShift" && (A_TickCount - timeOfInitDown) < 200) { ; A_TimeIdleKeyboard >= pressDuration && doesn't work since fast typing overlap
            AHI.SendKeyEvent(kbdId, spaceSc, 1)
            AHI.SendKeyEvent(kbdId, spaceSc, 0)
        }
    }
}

/*
    @Title: SpaceErase like Ctrl to erase whole words
    #note use send instead of SendInput so that Input commands are able to detect it
*/

/*<+Del::
    SendInput {LCtrl down}{Del}{LCtrl up}
    return
*/

<+BS::
    SendInput {LCtrl down}{BS}{LCtrl up}
    return
    /*
    AHI.SendKeyEvent(kbdId, lShiftSc, 0) ; up so only Ctrl
    @Desc: Because of it superior position it should be usable+Bs is pressed
    AHI.SendKeyEvent(kbdId, lCtrlSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 0)
    AHI.SendKeyEvent(kbdId, lCtrlSc, 0)
    AHI.SendKeyEvent(kbdId, lShiftSc, 1) ; set it to down as it was before. #risk: it could have been
        ; physically released while the hotkey was pressed, leaving it in an inconsistent state.
    return
    */


/*
    @Title: CtrlShift
*/
~LShift & ~LCtrl up::
~LCtrl & ~LShift up::
    if(A_PriorKey == "LControl" || A_PriorKey == "LShift") {
        SendInput {Enter}
    }
    return