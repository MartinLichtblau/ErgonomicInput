/*
    @Title: MouseArrow
    @Desc: hold key to move caret by moving mouse>cursor
*/
#SingleInstance force
#Persistent
;Process,priority,,Realtime
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey

Global mouseId, xSum, ySum, MA_runflag, clickStride, i
    , waitForMovementPause, MA_moveDistThreshold, pauseTimeThreshold
return

Setup_MouseArrow(mId) {
    ;Tooltip Setup_MouseScroll
    InitVars_MouseArrow(mId)
    ;ExitOnInput_MouseArrow
}

InitVars_MouseArrow(mId) {
    MA_runflag := false
    mouseId := mId
    MA_moveDistThreshold := 9
    pauseTimeThreshold := 80
    ResetRuntimeVars()
}

ResetRuntimeVars() {
    clickStride := 0
    waitForMovementPause := false
    gosub ResetXY_MouseArrow
}

Start_MouseArrow() {
    ;Tooltip Start_MouseArrow
    SetSystemCursor("",0,0)
    MA_runflag := true
    waitForMovementPause := false
    AHI.SubscribeMouseMoveRelative(mouseId, true, Func("MouseEvent"))
}

Stop_MouseArrow() {
    ;Tooltip Stop_MouseArrow
    MA_runflag := false
    AHI.SubscribeMouseMoveRelative(mouseId, false, Func("MouseEvent"))
    restoreCursors()
}

ResetXY_MouseArrow:
    xSum := 0
    ySum := 0
    return

; @Desc: run in parallel since it's a function
ExitOnInput_MouseArrow() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    if(ErrorLevel)
        Stop_MouseArrow()
}

/*
    @Title: FreePlaneScroll
    @Desc: scrolls in any direction, i.e. not bound to straight axis movements.
    #note some apps don't allow such movements and will only respond to axial scrolls in a row, e.g. gChrome
*/
MouseEvent(x, y){
    static timeOfLastMouseEvent
    if(!MA_runflag)
        Exit

    ; if user paused mouse movement for T then reset XY, so it starts fresh and not with e.g. x=29.
    timeDiffBetweenMoves  := A_TickCount-timeOfLastMouseEvent
    timeOfLastMouseEvent := A_TickCount ; timeOfLastMouseEvent becomes time of current MouseEvent
    if(timeDiffBetweenMoves > pauseTimeThreshold)
        movementPaused := true
    else
        movementPaused := false

    if(!movementPaused) {
        if(!waitForMovementPause) {
            ProcessMovement(x, y)
        } else {
            ; did not pause && since waitForMovementPause=true return. For @SendHomeEndCom
            ;Tooltip waitForMovementPause
            Exit ; #note return statement causes immense delay and breaking hence breaking timers
        }
    } else { ; movement pause / no mouse input since
        ResetRuntimeVars() ; @TODO all dirty, this even more
        ;Tooltip %timeDiffBetweenMoves%
    }
    ; @TODO think in terms of key presses, whereby the up event equals a break of duration T without mouse movement
    ; if sum movement distance > distance-click-threshold, then press key and start timer for break duration.
        ; if no new movement during that time, then release key. To send a single event
        ; Means: timeframes without movment symbolize/represent release of key.
}

ProcessMovement(x, y){
    global xSum := xSum + x
    global ySum := ySum + y
    abs_xSum := abs(xSum)
    abs_ySum := abs(ySum)

    if(abs_xSum > MA_moveDistThreshold || abs_ySum > MA_moveDistThreshold) {
        if(abs_ySum >= abs_xSum) { ; up/down
            if (ySum > 0) {
                SendStrideMode("Down")
            } else {
                SendStrideMode("Up")
            }
        } else { ; right/left
            if (xSum > 0) {
                SendStrideMode("Right")
            } else {
                SendStrideMode("Left")
            }
        }
    }
    ;Tooltip i=%i% | x: %x%  y: %y% | xSum: %xSum% ;top left is minus for x and y
    i++
}

SendStrideMode(keyName) {
    static repeatStrideThreshold := 4
    ;Tooltip clickStride: %clickStride%
    if(clickStride = 0) { ; initial send mode
        ; send one click
        SendArrowKey(keyName)
    } else if(clickStride > repeatStrideThreshold) { ; @TODO time based seems better to grasp.
        ; if it's bigger switch to other mode like in windows the keyboard auto repeat inertia t
        ; send further clicks if above stride_threshold
        if(i < 2 ) { ; reached threshold fast
            SendHomeEndCom(keyName)
        } else { ; reached threshold normal
            SendArrowKey(keyName)
        }
    } else {
        gosub ResetXY
    }
    clickStride++
}

;right := GetKeySc("Right") ; 333
;left := GetKeySc("left") ; 331
;up := GetKeySc("up") ; 328
;down := GetKeySc("down") ; 336
; #note sends per deful
SendArrowKey(keyName){
    ; Send {blind}{%keyName%} ; should work, but isn't recognized by A_PriorKey in Mbutton
    if(keyName = "Right") {
        AHI.SendKeyEvent(1, 333, 1)
        AHI.SendKeyEvent(1, 333, 0)
    } else if(keyName = "Left") {
        AHI.SendKeyEvent(1, 331, 1)
        AHI.SendKeyEvent(1, 331, 0)
    } else if(keyName = "Down") {
        AHI.SendKeyEvent(1, 336, 1)
        AHI.SendKeyEvent(1, 336, 0)
    } else if(keyName = "Up") {
        AHI.SendKeyEvent(1, 328, 1)
        AHI.SendKeyEvent(1, 328, 0)
    }
    i := 0
    gosub ResetXY
}

;home := GetKeySc("home") ; 327
;end := GetKeySc("end") ; 335
SendHomeEndCom(keyName) {
    if(keyName = "Right") {
        SendInput {blind}{End}
    } else if(keyName = "Left") {
        SendInput {blind}{Home}
    } else if(keyName = "Down") {
        SendInput {blind}{LCtrl down}{End}{LCtrl up}
    } else if(keyName = "Up") {
        SendInput {blind}{LCtrl down}{Home}{LCtrl up}
    }
    i := 0
    gosub ResetXY
    clickStride := 0
    ; enforce break, not reacting to new input. until mouse event stop for stride timeframe
    waitForMovementPause := true
}