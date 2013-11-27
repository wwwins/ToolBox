; =============================================================================
; [Project Structure]
;  -bin
;  -lib
;  -svn
;   -flash
;   -xml
;  -assets
;  -templates
;  -src
; =============================================================================
; Running Flash IDE(you don't need to open the fla document).
; win + z
; 1) main flow
; 2) fb preview
;
; Auto deploy the application for testing on a server.
; win + x
;
; Testing in IE
; win + o
; =============================================================================

; Setting variables
global WWW = "http://flash.isobar.com.tw/hk/project/"
global SWF_PATH = "d:\Data\project\bin\"
global SVN_PATH = "d:\Data\project\svn\flash\"

#z::
IfWinExist Adobe Flash CS5
{
	InputBox myChoice, , 1) Main Flow  2) FB Preview
	if ErrorLevel
	{
		MsgBox, What is your choice?
		return
	}
	
	if myChoice = 1
	{
		; Displays a standard dialog that allows the user to open files
		FileSelectFile, SelectedFile, 3
		if SelectedFile =
		{
			MsgBox, Do you select a fla file?!
			return
		}
		clipboard = %SelectedFile%
		CompileSWF()
		SyncSWF()
	}
	else if myChoice = 2
	{
		Run Flash.exe "d:\Data\project\lib\fb_as.fla"
		WinWait fb_as.fla
		WinActivate
		Send ^{ENTER}
		; waiting for Exporting SWF Movie
		WinWait, Exporting SWF Movie
		WinWaitClose, Exporting SWF Movie
		Sleep 1000
		Send ^{w}
		Send ^{w}
		; run FlashDevelop
		Run "d:\Data\project\FbShareResult.as3proj.lnk"
		IfWinExist FbShareResult - FlashDevelop
		{
			WinActivate
			Send {F5}
		}
		else
		{
			WinWait FbShareResult - FlashDevelop
			WinActivate
			Send {F5}
		}
		WinWait, Adobe Flash Player 11
		WinActivate
		;WinWaitClose, Adobe Flash Player 11
		FileCopy %SWF_PATH%fb.swf, %SVN_PATH%fb.swf, 1
		Sleep 1000
		Send ^{q}
		MsgBox done - FB Preview
	}
}
return

; Adobe Flash CS5 export swf
CompileSWF()
{
	; Separates a file name - http://www.autohotkey.com/docs/commands/SplitPath.htm
	SplitPath, clipboard, name
	; run flash
	Run, Flash.exe "%clipboard%"
	WinWait %name%
	WinActivate
	Send ^{ENTER}
	; waiting for Exporting SWF Movie
	;WinWait, ahk_class Afx:00400000:b:00010005:00000006:3C521445
	WinWait, Exporting SWF Movie
	WinWaitClose, Exporting SWF Movie
	Sleep 1000
	; close
	Send ^{w}
	Send ^{w}
}

; Sync swf file
SyncSWF()
{
	SplitPath, clipboard, name,,,name_no_ext
	swfname = %name_no_ext%.swf
	FileCopy %SWF_PATH%%swfname%, %SVN_PATH%%swfname%, 1
	;MsgBox %SWF_PATH%%swfname% %SVN_PATH%%swfname%
	MsgBox done - Main flow
}

; Testing in IE
#o::
Run, iexplore.exe
WinWait Home - APAC Comms Portal - Windows Internet Explorer
Send ^+{DEL}
Sleep 500
Send D
Sleep 500
Send ^{o}
SetKeyDelay, 0
Send %www%{ENTER}
return

; SVN auto commit
#x::
Run, "d:\Data\project\AutoCommit.bat"
return

