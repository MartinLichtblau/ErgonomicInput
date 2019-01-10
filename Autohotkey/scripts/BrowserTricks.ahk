/*
    @Title: BrowserTricks
    @Desc: expand and adapt browser functions
*/
#SingleInstance force
#Persistent
;Process,priority,,Realtime




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

; #note belongs in @ErgoNav
; -----------------------------------CLOSE  ON HOLD------------------------------------
<^w::
	KeyWait, w, T0.4      
	If ErrorLevel
		SendInput !{F4}
	Else        
		SendInput ^w
	KeyWait,w
Return

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
$^d::
	KeyWait, d, T0.3                         	  
    If ErrorLevel {
		Send ^d
		KeyWait, d, L
		Sleep 100
		Send {Tab}{Tab}{Tab}{Tab}{Enter} ;Delete Bookmark
	} else {
		Send !d  ;Open bookmark extension to add website 
	}
	KeyWait, d,
return
;---------------------------------Text-Website-URL Copy---------------------------------------------------------
/*
^+c::
	Send ^c
	Sleep 200
	cliptxt := clipboard
	Send ^l
	Send ^c
	Send {f6}
	clipurl := clipboard
	IfInString, clipurl, metapdf
		SendInput 1 ;Annotate
	WinClip.Clear()
	WinClip.SetHTML("<a href=" clipurl ">" cliptxt "</a>")
Return
*/
;---------------------------------Quote Copy---------------------------------------------------------
/*
^+q::
	Send ^c
	Sleep 100
	cliptxt = "%clipboard%"
	Send ^l
	Sleep 50
	Send ^c
	Send {f6}
	clipurl := clipboard
	IfInString, clipurl, metapdf
		SendInput 1 ;Annotate
	WinGetTitle, title, A
	StringTrimRight, title, title, 16
	length := StrLen(title)
	if(length >= 30){
		title := SubStr(title,1, 27)
		title = %title%...
	}

	WinClip.Clear()
	WinClip.SetHTML("<i>" cliptxt " (<a href=" clipurl ">" title "</a>)</i>")
Return
*/