/*
    @Title: BrowserTricks
    @Desc: expand and adapt browser functions
*/


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


; -----------------------------------CLOSE  ON HOLD------------------------------------
<^w::
	KeyWait, w, T0.4      
	If ErrorLevel
		SendInput !{F4}
	Else        
		SendInput ^w
	KeyWait,w
Return


; -----------------------------------Ergonomic easier *Open last closed tab*------------------------------------
<^n::
	KeyWait, n, T0.3                       	 ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
	If ErrorLevel   								; Delete function
		SendInput ^+t
	else
		SendInput ^n
	KeyWait, n
Return 


/*
;new combined with new tab translate
; #remember It is all about timing! So add more sleep if it does not work.
*/
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

; ---------------------------Opening new tab with currently marked text-------------------------------------
/*
;Closed: Better do it with ctrl + t, which is already used for opening new tab
<^c::
	cliptemp := clipboard
	SendInput ^c
	KeyWait, c, T0.3
    If ErrorLevel
	{
		;clipboard = https://www.google.de/search?q=%clipboard%
		Send ^l
		Sleep 100
		Send ^a^v!{Enter}
		
		Sleep 300  ;If hotkey still pressed translate it 
		If GetKeyState("c", "P"){   
			clipboard = https://translate.google.de/?source=osdd#en/de/%cliptemp%
			Send ^l
			Sleep 200
			Send ^v{ENTER}
		}
		
		Sleep 300 ;If hotkey still pressed translate it 
		If GetKeyState("c", "P"){   
			clipboard = https://www.vocabulary.com/search?q=%cliptemp% 
			Send ^l 
			Sleep 200
			Send ^v{ENTER}
		}
		
		clipboard := clipTemp
	}
	KeyWait,c,L
Return
*/

;------------------------Opening Bookmarks-bar to delete or save tab / URL-------------------------------------------------
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