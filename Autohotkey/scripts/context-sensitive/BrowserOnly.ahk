/*
    @Title: BrowserTricks
    @Desc: expand and adapt functions only present in browsers
    @Maturity:3
*/
#Include %A_WorkingDir%\lib\WinClipAPI.ahk
#Include %A_WorkingDir%\lib\WinClip.ahk
wc := new WinClip

BrowserTricks_Setup:
    #SingleInstance force
    #Persistent
    #Include %A_WorkingDir%\lib\Commands.ahk
    return



#IfWinActive, ahk_exe Chrome.exe ;; start of IfWinActive condition, for me it didn't work with ahk_class so i changed it to ahk_exe

; -----------------------------------Two translation modes------------------------------------
$!t::ChangeTranslateModeOnLongPress("t")

; -----------------------------------Combine: Add to Keep && Highlight------------------------------------
$!c::
    SendInput !c
    ;SendInput !2 ; use +Super_Simple_Highlighter
    SendInput h ; use +Memex
    return

;---------------------------------Chrome: Print to Article---------------------------------------------------------
; $^p:: PrintInChromeToFolder("C:\Users\marti\Google Drive\Diary\Professional Life\Academic\General Literature\Read Literature")

; -----------------------------------Open link in same tab------------------------------------
/*
; #note: intended for google Keep to open keep links quickly from within current keep tab/session
<^q::
	KeyWait, q,
	cliptemp := clipboard
	Send ^c
	Send ^l
	Send ^v
	Send {Enter}
	clipboard := clipTemp
Return
*/

;RELEVANT ;---------------------------Opening new tab with currently marked text-------------------------------------
$<^t::
	KeyWait,t,T0.3
    If ErrorLevel
	{
		cliptemp := clipboard
		Send ^c

		;Open content in new tab
		Send ^l
		Sleep 100
		Send ^a^v!{Enter}

		;If hotkey still pressed translate it
		Sleep 400
		If(GetKeyState("t", "P"))
		{
			clipboard=https://translate.google.de/?source=osdd#en/de/%clipboard%
			ClipWait
			Send ^l
			Sleep 400
			Send ^v
			Send {ENTER}
		}

		clipboard := clipTemp
	}
	ELSE
	{
		SendInput ^t
	}
	KeyWait,t, ;not L, since that means logical. Physical is default!
Return

; RELEVANT ;------------------------Opening Bookmarks-bar to delete or save tab / URL-------------------------------------------------
<^d::
	KeyWait, d, T0.3                         	  
    If ErrorLevel {
		Send ^d
		KeyWait, d, L
		Sleep 100
		Send {Tab}{Tab}{Tab}{Tab}{Enter} ;Delete Bookmark
	} else {
		Send !+b  ;Open bookmark extension to add website
	}
	KeyWait, d,
return
;---------------------------------Text-Website-URL Copy---------------------------------------------------------
^+c::
    clipboard = ; Empty clipboard
    Send ^c
    ClipWait, 0.5
    if(ErrorLevel) { ; if nothing copied, nothing was selected, means: copy only URL
        Send ^l
    	Sleep 50 ; wait until address bar is focused
    	clipboard = ; Empty clipboard
        Send ^c
    	Send {f6}{f6}
    	return
    }

    cliptxt := clipboard
	Send ^l
	Sleep 100 ; wait until address bar is focused
	clipboard = ; Empty clipboard
    Send ^c
    ClipWait, 0.5
    clipurl := clipboard
	Send {f6}{f6}
	; IfInString, clipurl, metapdf
	; 	SendInput 1 ;Annotate

    if  (InStr(clipurl,"kamihq.com")) {
        word_array := StrSplit(clipurl, "%22")  ; Extract google drive Id of pdf
        ; Tooltip % word_array[4]
        clipurl := "https://drive.google.com/file/d/" word_array[4] "/view" ; create url to gDrive own viewer
        ; Tooltip % clipurl
    }

	WinClip.Clear()
	WinClip.SetHTML("<a href=" clipurl ">" cliptxt "</a>")
    return

;---------------------------------Quote Copy---------------------------------------------------------

^+q::
; if paperpile pdf viewer
    	;SendInput 1 ; to highlight in paperpile beta pdf
	;SendInput {LButton up}
	SendInput ^c
	Sleep 150
	cliptxt = "%clipboard%"

	Send ^l
	Sleep 200
	Send ^c
	Send {f6}{f6} ; only temporarily because of chrome bug
	clipurl := clipboard

/*
    pos := InStr(clipurl,"http")
    string := SubStr(clipurl, pos)
    msgbox, %string%
*/

	WinGetTitle, title, A     ; Could also be done with local PDF-tool like Drawboard, by using the window's title

    if  (InStr(clipurl,"kamihq.com")) {
        word_array := StrSplit(clipurl, "%22")  ; Extract google drive Id of pdf
        ; Tooltip % word_array[4]
        clipurl := "https://drive.google.com/file/d/" word_array[4] "/view" ; create url to gDrive own viewer
        ; Tooltip % clipurl
        word_array := StrSplit(title, "-", " ")  ; Use only author and year, not title, and remove whitespace
        title := word_array[1]
    } else {
        title := SubStr(title, 1, 20) ; Trim the title if it's too long
    }

    if (clipurl == "")
        Tooltip "clipurl is empty"
	WinClip.Clear()
	WinClip.SetHTML("<i>" cliptxt " <a href=" clipurl ">(" title ")</a></i>")
    return

;---------------------------------Text-Website-URL Copy---------------------------------------------------------
^+m::
    clipboard = ; Empty clipboard
    Send ^c
    ClipWait, 0.5
    if(ErrorLevel) { ; if nothing copied, nothing was selected, means: copy only URL
      cliptxt := 0
    } else {
      cliptxt := clipboard
    }

    Send ^l
    Sleep 100 ; wait until address bar is focused
    clipboard = ; Empty clipboard
    Send ^c
    ClipWait, 0.5
    clipurl := clipboard
    Send {f6}{f6}

    if(cliptxt = 0) {
      cliptxt = %clipurl%
    }

    prunedCliptxt := RegExReplace(cliptxt, "\s*(\n|\r\n)", A_Space)
    clipboard = [%prunedCliptxt%](%clipurl%)
    return

#IfWinActive ;; end of condition IfWinActive