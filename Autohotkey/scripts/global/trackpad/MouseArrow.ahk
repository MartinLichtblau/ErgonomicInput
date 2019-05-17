/*
    @Title: MouseArrow
    @Desc: hold key to move caret by moving mouse>cursor
    @TODO it's an ugly piece of code, esp. the mapping of mouse movements to key commands.
*/
#SingleInstance force
#Persistent
;Process,priority,,High
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey

Global mouseId, xSum, ySum, abs_xSum, abs_ySum, MA_runflag, clickStride, waitForMovementPause, MA_moveDistThreshold, pauseTimeThreshold, mouseMoveCount
return

Setup_MouseArrow(mId) {
    ;Tooltip Setup_MouseScroll
    InitVars_MouseArrow(mId)
    ;ExitOnInput_MouseArrow
}

InitVars_MouseArrow(mId) {
    MA_runflag := false
    mouseId := mId
    MA_moveDistThreshold := 8 ; @TODO this is the tranformation factor, One send key equals Coordinate DELTA change
    pauseTimeThreshold := 90
}

ResetRuntimeVars() {
    clickStride := 0
    waitForMovementPause := false
    gosub ResetXY_MouseArrow
    mouseMoveCount := 0
}

Start_MouseArrow() {
    ;Tooltip Start_MouseArrow
    SetSystemCursor("",0,0)
    MA_runflag := true
    ResetRuntimeVars()
    AHI.SubscribeMouseMoveRelative(mouseId, true, Func("MouseArrowEvent"))
}

Stop_MouseArrow() {
    ;Tooltip Stop_MouseArrow
    MA_runflag := false
    ;AHI.SubscribeMouseMoveRelative(mouseId, false, Func("MouseArrowEvent"))
    AHI.UnsubscribeMouseMoveRelative(mouseId)
    ResetRuntimeVars()
    restoreCursors()
}

ResetXY_MouseArrow:
    xSum := 0
    ySum := 0
    abs_xSum := 0
    abs_ySum := 0
    return

; @Desc: run in parallel since it's a function
ExitOnInput_MouseArrow() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    if(ErrorLevel)
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
    static timeOfLastMouseEvent
    if(!MA_runflag)
        return ; Exit

    ; if user paused mouse movement for T then reset XY, so it starts fresh and not with e.g. x=29.
    timeDiffBetweenMoves  := A_TickCount-timeOfLastMouseEvent
    timeOfLastMouseEvent := A_TickCount ; timeOfLastMouseEvent becomes time of current MouseEvent
    if(timeDiffBetweenMoves > pauseTimeThreshold) {
        movementPaused := true
        ResetRuntimeVars() ; @TODO all dirty, this even more
        mouseMoveCount := 0
    } else {
        movementPaused := false
    }

    if(!movementPaused) {
        if(!waitForMovementPause) {
            ProcessMovement(x, y)
        } else {
            ; did not pause && since waitForMovementPause=true return. For @SendHomeEndCom
            ;Tooltip waitForMovementPause
            return ; Exit ; #note return statement causes immense delay and breaking hence breaking timers
        }
    }
    ; @TODO think in terms of key presses, whereby the up event equals a break of duration T without mouse movement
    ; if sum movement distance > distance-click-threshold, then press key and start timer for break duration.
        ; if no new movement during that time, then release key. To send a single event
        ; Means: timeframes without movment symbolize/represent release of key.
}

ProcessMovement(x, y){
    ; @TODO don't work with negative numbers at all, instead ste a flag xNeg, yNeg
    global xSum := xSum + x*1.5 ; multipled by a factor to boost right/left movements so they are as sensitive as up/down
    global ySum := ySum + y
    abs_xSum := abs(xSum)
    abs_ySum := abs(ySum)
    mouseMoveCount++
    ;Tooltip %mouseMoveCount% %abs_xSum% %abs_ySum%

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
}

SendStrideMode(keyName) {
    static repeatStrideThreshold := 7
    ;Tooltip clickStride: %clickStride% %i%

    if(clickStride = 0) { ; initial send mode
        ;Tooltip %mouseMoveCount% ; %abs_xSum% %abs_ySum%
        ; send one click
        ;if (mouseMoveCount >= 3) {
            SendArrowKey(keyName)
        ;} else {
         ;   SendHomeEndCom(keyName)
        ;}
    } else if(clickStride > repeatStrideThreshold) { ; @TODO time based seems better to grasp.
        ; if it's bigger switch to other mode like in windows the keyboard auto repeat inertia t
        ; send further clicks if above stride_threshold
        ;Tooltip %abs_ySum%
        if(!GetKeyState("Ctrl", "P") && (abs_ySum > 2*MA_moveDistThreshold || abs_xSum > 2*MA_moveDistThreshold)) { ; reached threshold fast
            ;@TODO link factors to other values and make them static/global
                ; #idea increase responsivness by using X/Y of this one movement and not the sum
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
        ;Send {blind}{Right}
    } else if(keyName = "Left") {
        AHI.SendKeyEvent(1, 331, 1)
        AHI.SendKeyEvent(1, 331, 0)
        ;Send {blind}{Left}
    } else if(keyName = "Down") {
        AHI.SendKeyEvent(1, 336, 1)
        AHI.SendKeyEvent(1, 336, 0)
        ;Send {blind}{Down}
    } else if(keyName = "Up") {
        AHI.SendKeyEvent(1, 328, 1)
        AHI.SendKeyEvent(1, 328, 0)
        ;Send {blind}{Up}
    }
    gosub ResetXY
}

;home := GetKeySc("home") ; 327
;end := GetKeySc("end") ; 335
SendHomeEndCom(keyName) {
    if(keyName = "Right") {
        Send {blind}{End}
    } else if(keyName = "Left") {
        Send {blind}{Home}
    } else if(keyName = "Down") {
        Send {blind}{LCtrl down}{End}{LCtrl up}
    } else if(keyName = "Up") {
        Send {blind}{LCtrl down}{Home}{LCtrl up}
    }
    gosub ResetXY
    clickStride := 0
    ; enforce break, not reacting to new input. until mouse event stop for stride timeframe
    waitForMovementPause := true
}