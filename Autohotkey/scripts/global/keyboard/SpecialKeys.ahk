/*
    @Title: SpecialKeys
    @Desc: fundamental changes of special keys, concerning mapping and behavior
    #Maturity:7
*/
SpecialKeys_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime

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
        AHI.SendKeyEvent(kbdId, rCtrlSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, rCtrlSc, 0)
    }
}

RCtrlEvent(state) {
   if(state) {
        AHI.SendKeyEvent(kbdId, lWinSc, 1)
    } else {
        AHI.SendKeyEvent(kbdId, lWinSc, 0)
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
SpaceShiftEvent(state) {
    static blockSpaceRepeats := false, lastSpaceTime
    if(state) {
        if(!blockSpaceRepeats) { ; to only react to the initial press; not the auto key repeats
            AHI.SendKeyEvent(kbdId, lShiftSc, 1)
            ; AHI.SendKeyEvent(kbdId, lShiftSc, 1) ; #Alt1.1
            lastSpaceTime := A_TickCount
            blockSpaceRepeats := true
        }
    } else {
        AHI.SendKeyEvent(kbdId, lShiftSc, 0)
        pressDuration := A_TickCount - lastSpaceTime ;
        Sleep 1 ; #Alt1.2 =fix wait so it recognizes the LShift up event
        if(A_PriorKey = "LShift" && pressDuration < 150) {
            AHI.SendKeyEvent(kbdId, spaceSc, 1)
            AHI.SendKeyEvent(kbdId, spaceSc, 0)
        }
        blockSpaceRepeats := false ; release auto-repeat lock
    }
}

/*
    @Title: SpaceErase
    @Desc: Because of it superior position it should be usable like Ctrl to erase whole words
    #note use send instead of SendInput so that Input commands are able to detect it
*/
<+Del::
	SendInput ^{Del}
return

<+BS::
	SendInput ^{Bs}
return