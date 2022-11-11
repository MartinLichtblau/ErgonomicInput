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


;GroupAdd, BrowserGroup, ahk_exe Chrome.exe
;GroupAdd, BrowserGroup, ahk_exe vivaldi.exe
;#IfWinActive ahk_group BrowserGroup
#If (!trackpadRButtonDown && !trackpadMButtonDown) && (WinActive("ahk_exe Chrome.exe") || WinActive("ahk_exe vivaldi.exe") || WinActive("ahk_exe msedge.exe")) ; start of IfWinActive condition, for me it didn't work with ahk_class so i changed it to ahk_exe
; Copy link of notion block, making it globally accessible and enabling transclusion
+^g::
    SendInput {/}copy
    Sleep 100
    SendInput {Enter}
    Sleep 400
    StringGetPos, pos, clipboard, #
    nplink := SubStr(clipboard, pos +2)
    blockLink = https://www.notion.so/%nplink%
    clipboard = %blockLink%
    SendInput {Space}{U+1F310} ; 🌐
    return

; -----------------------------------Two translation modes------------------------------------
$!t::ChangeTranslateModeOnLongPress("t")

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
    If ErrorLevel {
		cliptemp := clipboard
		SendInput ^c

		;Open content in new tab
		SendInput ^l
		Sleep 300
		SendInput ^v!{Enter} ;SendInput ^a^v!{Enter}


		;If hotkey still pressed translate it
		Sleep 1000
		If(GetKeyState("t", "P")) {
			clipboard=https://translate.google.de/?source=osdd#en/de/%clipboard%
			ClipWait
			SendInput ^l
			Sleep 400
			SendInput ^v
			SendInput {ENTER}
		}
		clipboard := clipTemp
	} else {
		SendInput ^t
	}
	KeyWait,t, ;not L, since that means logical. Physical is default!
return

; RELEVANT ;------------------------Opening Bookmarks-bar to delete or save tab / URL-------------------------------------------------
^d::
	KeyWait, d, T0.3
    If ErrorLevel {
		Send ^d
		KeyWait, d, L
		Sleep 100
		Send {Tab}{Tab}{Tab}{Tab}{Enter} ;Delete Bookmark
	} else {
		SendInput !1  ;Open bookmark extension to add website
	}
	KeyWait, d,
return
;---------------------------------Text-Website-URL Copy---------------------------------------------------------
^+c::
    clipboard = ; Empty clipboard
    Send ^c
    ClipWait, 0.1
    if(ErrorLevel) { ; if nothing copied, nothing was selected, means: copy only URL
        Send ^l
    	Sleep 50 ; wait until address bar is focused
    	clipboard = ; Empty clipboard
        Send ^c
    	Send {Esc}
    	return
    }

    cliptxt := clipboard
	Send ^l
	Sleep 100 ; wait until address bar is focused
	clipboard = ; Empty clipboard
    Send ^c
    ClipWait, 0.5
    clipurl := clipboard
	Send {Esc}
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
	;WinClip.Clear()
	;WinClip.SetHTML("<i>" cliptxt " <a href=" clipurl ">(" title ")</a></i>")
	clipboard = *%cliptxt%* ([%title%](%clipurl%))
    return

;---------------------------------Text-Website-URL Copy---------------------------------------------------------
^+k::
    clipboard = ; Empty clipboard
    SendInput ^c
    ClipWait, 0.5
    if(ErrorLevel) { ; if nothing copied, nothing was selected, means: copy only URL
      cliptxt := 0
    } else {
      cliptxt := clipboard
    }

    SendInput ^l
    Sleep 100 ; wait until address bar is focused
    clipboard = ; Empty clipboard
    SendInput ^c
    ClipWait, 0.5
    clipurl := clipboard
    SendInput {Esc} ;{f6}{f6}

    if(cliptxt = 0) {
      cliptxt = %clipurl%
    }

    prunedCliptxt := RegExReplace(cliptxt, "\s*(\n|\r\n)", A_Space)
    clipboard = [%prunedCliptxt%](%clipurl%)
    return

#IfWinActive ;; end of condition IfWinActive