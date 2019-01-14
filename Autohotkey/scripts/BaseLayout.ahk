/*
    @Title: BiSpace
    @Desc: fundamental changes of layout; e.g. language, space, backspace, ...
    @Requirements:
        - registry remap Space-key so it becomes LShift
*/
BaseLayout_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime

    if(AHI == "")
        Global AHI := new AutoHotInterception()
    AHI.SubscribeKey(1, GetKeySC("Space"), true, Func("SpaceShiftEvent"))
    AHI.SubscribeKey(1, GetKeySC("LShift"), true, Func("LShiftEvent"))
    AHI.SubscribeKey(1, GetKeySC("Tab"), true, Func("TabEvent"))
    AHI.SubscribeKey(1, GetKeySC("^"), true, Func("KeyUnderEscEvent"))
    AHI.SubscribeKey(1, GetKeySC("Capslock"), true, Func("CapslockEvent"))
    AHI.SubscribeKey(1, GetKeySC("LAlt"), true, Func("LAltEvent"))
    AHI.SubscribeKey(1, GetKeySC("LCtrl"), true, Func("LCtrlEvent"))
    AHI.SubscribeKey(1, GetKeySC("LWin"), true, Func("LWinEvent"))
    AHI.SubscribeKey(1, GetKeySC("PrintScreen"), true, Func("PrintScreenEvent"))
    AHI.SubscribeKey(1, GetKeySC("RAlt"), true, Func("RAltEvent"))
    AHI.SubscribeKey(1, GetKeySC("RCtrl"), true, Func("RCtrlEvent"))
    AHI.SubscribeKey(1, 355, true, Func("FnEvent")) ; 355 = FN
return

LShiftEvent(state) {
    if(state) {
        AHI.SendKeyEvent(1, GetKeySC("Tab"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("Tab"), 0)
    }
}

TabEvent(state) {
    if(state) {
        AHI.SendKeyEvent(1, GetKeySC("Backspace"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("Backspace"), 0)
    }
}

KeyUnderEscEvent(state) {
    if(state) {
        AHI.SendKeyEvent(1, GetKeySC("Delete"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("Delete"), 0)
    }
}

CapslockEvent(state) {
    if(state) {
        AHI.SendKeyEvent(1, GetKeySC("Enter"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("Enter"), 0)
    }
}

LAltEvent(state) {
    if(state) {
        AHI.SendKeyEvent(1, GetKeySC("LCtrl"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("LCtrl"), 0)
    }
}

LCtrlEvent(state) {
    if(state) {
        AHI.SendKeyEvent(1, GetKeySC("LWin"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("LWin"), 0)
    }
}

LWinEvent(state) {
   if(state) {
        AHI.SendKeyEvent(1, GetKeySC("LAlt"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("LAlt"), 0)
    }
}

PrintScreenEvent(state) {
   if(state) {
        AHI.SendKeyEvent(1, GetKeySC("LAlt"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("LAlt"), 0)
    }
}

RAltEvent(state) {
   if(state) {
        AHI.SendKeyEvent(1, GetKeySC("RCtrl"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("RCtrl"), 0)
    }
}

RCtrlEvent(state) {
   if(state) {
        AHI.SendKeyEvent(1, GetKeySC("RAlt"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("RAlt"), 0)
    }
}

FnEvent(state) {
   if(state) {
        AHI.SendKeyEvent(1, GetKeySC("Esc"), 1)
    } else {
        AHI.SendKeyEvent(1, GetKeySC("Esc"), 0)
    }
}

Global blockSpaceRepeats, lastSpaceTime
SpaceShiftEvent(state) {
    ;key := GetKeySC("Esc")
    ;Tooltip %key%
    ;Tooltip %state%
    if(state) {
        if(!blockSpaceRepeats) {
            AHI.SendKeyEvent(1, GetKeySC("LShift"), 1)
            ; AHI.SendKeyEvent(1, GetKeySC("LShift"), 1) ; option B (for A_PriorKey to work)
            lastSpaceTime := A_TickCount
            blockSpaceRepeats := true
        }
    } else {
        AHI.SendKeyEvent(1, GetKeySC("LShift"), 0)
        pressDuration := A_TickCount - lastSpaceTime
        ;gosub showKeyVars
        sleep 1 ; option A (for A_PriorKey to work)
        IF(A_PriorKey = "LShift" && pressDuration < 130) {
            AHI.SendKeyEvent(1, GetKeySC("Space"), 1)
            AHI.SendKeyEvent(1, GetKeySC("Space"), 0)
        }
        blockSpaceRepeats := false
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