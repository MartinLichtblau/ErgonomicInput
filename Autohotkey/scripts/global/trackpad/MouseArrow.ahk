/*
    @Title: MouseArrow
    @Desc: hold key to move caret by moving mouse>cursor
    @TODO it's an ugly piece of code, esp. the mapping of mouse movements to key commands.
*/
#SingleInstance force
#Persistent

#Include %A_ScriptDir%\lib\Functions.ahk
Global mouseId, ma_xSum, ma_ySum, ma_abs_xSum, ma_abs_ySum, ma_runflag, ma_clickStride, ma_waitForMovementPause, ma_moveDistThreshold, ma_HomeEndThreshold, ma_pauseTimeThreshold, ma_mouseMoveCount
return

Setup_MouseArrow(mId) {
    ;Tooltip Setup_MouseScroll
    ma_InitVars_MouseArrow(mId)
    ;ExitOnInput_MouseArrow
}

ma_InitVars_MouseArrow(mId) {
    ma_runflag := false
    mouseId := mId
    ma_moveDistThreshold := 16 ; @TODO CONFIG VAR ! MOST important user config !! Def: Movement is accumulated and this is the threshold when arrows are send
    ma_HomeEndThreshold := 2*ma_moveDistThreshold ; @TODO CONFIG VAR
    ma_pauseTimeThreshold := 100
}

ma_ResetRuntimeVars() {
    ma_clickStride := 0
    ma_waitForMovementPause := false
    gosub ma_ResetXY
    ma_mouseMoveCount := 0
}

Start_MouseArrow(mId) {
    ;Tooltip Start_MouseArrow
    ; SetSystemCursor("IDC_IBEAM")
    Setup_MouseArrow(mId)
    ma_runflag := true
    ma_ResetRuntimeVars()
    AHI.SubscribeMouseMoveRelative(mouseId, true, Func("MouseArrowEvent"))
}

Stop_MouseArrow() {
    ;Tooltip Stop_MouseArrow
    ma_runflag := false
    ;AHI.SubscribeMouseMoveRelative(mouseId, false, Func("MouseArrowEvent"))
    AHI.UnsubscribeMouseMoveRelative(mouseId)
    ma_ResetRuntimeVars()
    ; setTimer RestoreCursors, -100
}

ma_ResetXY:
    ma_xSum := 0
    ma_ySum := 0
    ma_abs_xSum := 0
    ma_abs_ySum := 0
    return

; @Desc: run in parallel since it's a function
ExitOnInput_MouseArrow() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    if(ErrorLevel)d
        Stop_MouseArrow()
}

; @TODO represent like this: continous mouse movement events are a movement stream
    ; this stream can be continous without pauses and is called flow or a sprint which is sourrounded by pauses.
    ; a @flow which has a @flowDistance and a @flowDuration.
    ; + make it all time-based. So make identify breaks based on the time passed, not the movement sum.
    ; #note using the trackpoint has various advantages itself. So just making it time-based, bacause that's how it
        ; has ever been is naive and such thinking won't lead to innovation. Trackpad has: VELOCITY, DISTANCE/FORCE per time
        ; DIRECTION and more
MouseArrowEvent(x, y){
    ;Tooltip MouseArrowEvent
    static timeOfLastMouseEvent
    if(!ma_runflag)
        return ; Exit

    ; if user paused mouse movement for T then reset XY, so it starts fresh and not with e.g. x=29.
    timeDiffBetweenMoves  := A_TickCount-timeOfLastMouseEvent
    timeOfLastMouseEvent := A_TickCount ; timeOfLastMouseEvent becomes time of current MouseEvent
    if(timeDiffBetweenMoves > ma_pauseTimeThreshold) {
        movementPaused := true
        ma_ResetRuntimeVars() ; @TODO all dirty, this even more
        ma_mouseMoveCount := 0
    } else {
        movementPaused := false
    }

    if(!movementPaused) {
        if(!ma_waitForMovementPause) {
            ma_ProcessMovement(x, y)
        } else {
            ; did not pause && since ma_waitForMovementPause=true return. For @ma_SendHomeEndCom
            ;Tooltip ma_waitForMovementPause
            return ; Exit ; #note return statement causes immense delay and breaking hence breaking timers
        }
    }
    ; @TODO think in terms of key presses, whereby the up event equals a break of duration T without mouse movement
    ; if sum movement distance > distance-click-threshold, then press key and start timer for break duration.
        ; if no new movement during that time, then release key. To send a single event
        ; Means: timeframes without movment symbolize/represent release of key.
}

ma_ProcessMovement(x, y){
    ; @TODO don't work with negative numbers at all, instead ste a flag xNeg, yNeg
    ma_xSum := ma_xSum + x ; multipled by a factor to boost right/left movements so they are as sensitive as up/down
    ma_ySum := ma_ySum + y * 0.7
    ma_abs_xSum := abs(ma_xSum)
    ma_abs_ySum := abs(ma_ySum)
    ma_mouseMoveCount++
    ;Tooltip %ma_mouseMoveCount% %ma_abs_xSum% %ma_abs_ySum%

    if(ma_abs_xSum > ma_moveDistThreshold || ma_abs_ySum > ma_moveDistThreshold) {
        if(ma_abs_ySum >= ma_abs_xSum) { ; up/down
            if (ma_ySum > 0) {
                ma_SendStrideMode("Down")
            } else {
                ma_SendStrideMode("Up")
            }
        } else { ; right/left
            if (ma_xSum > 0) {
                ma_SendStrideMode("Right")
            } else {
                ma_SendStrideMode("Left")
            }
        }
    }
    ;Tooltip i=%i% | x: %x%  y: %y% | ma_xSum: %ma_xSum% ;top left is minus for x and y
}

ma_SendStrideMode(keyName) {
    ;Tooltip, ma_clickStride: %ma_clickStride% %i%,,1000,2

        ; if it's bigger switch to other mode like in windows the keyboard auto repeat inertia t
        ; send further clicks if above stride_threshold
        ;Tooltip %ma_abs_ySum%
        if((ma_abs_ySum > ma_HomeEndThreshold || ma_abs_xSum > ma_HomeEndThreshold) && !GetKeyState("Ctrl", "P")) { ; reached threshold fast
            ;@TODO link factors to other values and make them static/global
                ; #idea increase responsivness by using X/Y of this one movement and not the sum
            ma_SendHomeEndCom(keyName)
        } else { ; reached threshold normal
            ma_SendArrowKey(keyName)
        }
    ma_clickStride++
}

;right := GetKeySc("Right") ; 333
;left := GetKeySc("left") ; 331
;up := GetKeySc("up") ; 328
;down := GetKeySc("down") ; 336
; #note sends per deful
ma_SendArrowKey(keyName){
    ; Send {blind}{%keyName%} ; should work, but isn't recognized by A_PriorKey in Mbutton
    SendArrowKey(keyName)
    gosub ma_ResetXY
}

;home := GetKeySc("home") ; 327
;end := GetKeySc("end") ; 335
ma_SendHomeEndCom(keyName) {
    if(keyName = "Right") {
        Send {blind}{End}
    } else if(keyName = "Left") {
        Send {blind}{Home}
    } else if(keyName = "Down") {
        Send {blind}{LCtrl down}{End}{LCtrl up}
    } else if(keyName = "Up") {
        Send {blind}{LCtrl down}{Home}{LCtrl up}
    }
    gosub ma_ResetXY
    ma_clickStride := 0
    ; enforce break, not reacting to new input. until mouse event stop for stride timeframe
    ma_waitForMovementPause := true
}