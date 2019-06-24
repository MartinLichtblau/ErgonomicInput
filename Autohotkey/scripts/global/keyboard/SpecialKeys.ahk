/*
    @Title: SpecialKeys
    @Desc: fundamental changes of special keys, concerning mapping and behavior
    #Maturity:7
*/
SpecialKeys_Setup:
    #SingleInstance force
    #Persistent

    ; Init Variables
    global spaceSc, tabSc, lShiftSc, capslockSc, lAltSc, lCtrlSc, lWinSc, printScreenSc, rAltSc, rCtrlSc, r2c1Sc, FnSc
        , escSc, enterSc, deleteSc, backspaceSc
    if(AHI == "")
        global AHI := new AutoHotInterception()
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
    AHI.SubscribeKey(kbdId, FnSc, true, Func("FnEvent")) ; 355 = FN
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
        AHI.SendKeyEvent(kbdId, escSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, escSc, 0)
    }
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
            shiftSpaceDown := true
            timeOfInitDown := A_TickCount
        }
    } else {
        AHI.SendKeyEvent(kbdId, lShiftSc, 0)
        shiftSpaceDown := false
        pressDuration := A_TickCount - timeOfInitDown
        Sleep 1 ; #Alt1.2 =fix wait so it recognizes the LShift up event ; 0 or 1 ms seems to make a bigger difference
        ;Tooltip %A_TimeIdleKeyboard% %A_TimeIdlePhysical% %pressDuration% %A_PriorKey%
        if(A_PriorKey == "LShift" && pressDuration < 200) { ; A_TimeIdleKeyboard >= pressDuration && doesn't work since fast typing overlap
            AHI.SendKeyEvent(kbdId, spaceSc, 1)
            AHI.SendKeyEvent(kbdId, spaceSc, 0)
        }
    }
}

/*
    @Title: SpaceErase like Ctrl to erase whole words
    #note use send instead of SendInput so that Input commands are able to detect it
*/
<+Del::
    SendInput {LCtrl down}{Del}{LCtrl up}
    return

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
        Send {tab}
    }
    return