; Text expansions to aid date input in dynalist
; !tod = today, !tom=tomorrow !sat=next sunday
; !i2d = in 2 days, !nw = next sunday,  !i2w = sunday of the second week from today

; NOTE: Some shortcuts require date.exe from posix utils. If you have git for windows installed in the default location, the script will work. 

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;global gitpath := "C:/Software/git/usr/bin/date.exe"
global gitpath := "C:/Program Files/git/usr/bin/date.exe"

; today
::!tod::
FormatTime, CurrentDateTime, A_Now, {!}(yyyy-MM-dd){Space}
SendInput %CurrentDateTime%
Return

; tomorrow
::!tom::
vDate := DateAdd(A_Now, 1, "Days")
FormatTime, oDate, %vDate%, {!}(yyyy-MM-dd){Space}
SendInput %oDate%
Return

; in 2 days
::!i2d::
vDate := DateAdd(A_Now, 2, "Days")
FormatTime, oDate, %vDate%, {!}(yyyy-MM-dd){Space}
SendInput %oDate%
Return

; in 3 days
::!i3d::
vDate := DateAdd(A_Now, 3, "Days")
FormatTime, oDate, %vDate%, {!}(yyyy-MM-dd){Space}
SendInput %oDate%
Return

; in 4 days
::!i4d::
vDate := DateAdd(A_Now, 4, "Days")
FormatTime, oDate, %vDate%, {!}(yyyy-MM-dd){Space}
SendInput %oDate%
Return

; next week / in 1 week (Sunday)
::!nw::
::!i1w::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d sun") 
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; in 2 week (Sunday)
::!i2w::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d sun+7day")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; in 3 week (Sunday)
::!i3w::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d sun+14day")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next month / in 4 week (Sunday)
::!nm::
::!i4w::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d sun+21day")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next sunday
::!sun::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d sun")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next monday
::!mon::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d mon")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next tuesday
::!tue::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d tue")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next wednesday
::!wed::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d wed")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next thursday
::!thu::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d thu")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next friday
::!fri::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d fri")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return

; next saturday
::!sat::
vDate := StdoutToVar_CreateProcess(gitpath . " --rfc-3339=date -d sat")
vDate := Rtrim(vDate, "`n")
SendInput {!}(%vDate%){Space}
Return


;commands as functions (AHK v2 functions for AHK v1) - AutoHotkey Community
;https://autohotkey.com/boards/viewtopic.php?f=37&t=29689

DateAdd(DateTime, Time, TimeUnits)
{
	EnvAdd, DateTime, % Time, % TimeUnits
	return DateTime
}
DateDiff(DateTime1, DateTime2, TimeUnits)
{
	EnvSub, DateTime1, % DateTime2, % TimeUnits
	return DateTime1
}
FormatTime(YYYYMMDDHH24MISS:="", Format:="")
{
	local OutputVar
	FormatTime, OutputVar, % YYYYMMDDHH24MISS, % Format
	return OutputVar
}



; ----------------------------------------------------------------------------------------------------------------------
; Function .....: StdoutToVar_CreateProcess
; Description ..: Runs a command line program and returns its output.
; Parameters ...: sCmd      - Commandline to execute.
; ..............: sEncoding - Encoding used by the target process. Look at StrGet() for possible values.
; ..............: sDir      - Working directory.
; ..............: nExitCode - Process exit code, receive it as a byref parameter.
; Return .......: Command output as a string on success, empty string on error.
; AHK Version ..: AHK_L x32/64 Unicode/ANSI
; Author .......: Sean (http://goo.gl/o3VCO8), modified by nfl and by Cyruz
; License ......: WTFPL - http://www.wtfpl.net/txt/copying/
; Changelog ....: Feb. 20, 2007 - Sean version.
; ..............: Sep. 21, 2011 - nfl version.
; ..............: Nov. 27, 2013 - Cyruz version (code refactored and exit code).
; ..............: Mar. 09, 2014 - Removed input, doesn't seem reliable. Some code improvements.
; ..............: Mar. 16, 2014 - Added encoding parameter as pointed out by lexikos.
; ..............: Jun. 02, 2014 - Corrected exit code error.
; ..............: Nov. 02, 2016 - Fixed blocking behavior due to ReadFile thanks to PeekNamedPipe.
; ----------------------------------------------------------------------------------------------------------------------
StdoutToVar_CreateProcess(sCmd, sEncoding:="CP0", sDir:="", ByRef nExitCode:=0) {
    DllCall( "CreatePipe",           PtrP,hStdOutRd, PtrP,hStdOutWr, Ptr,0, UInt,0 )
    DllCall( "SetHandleInformation", Ptr,hStdOutWr, UInt,1, UInt,1                 )

            VarSetCapacity( pi, (A_PtrSize == 4) ? 16 : 24,  0 )
    siSz := VarSetCapacity( si, (A_PtrSize == 4) ? 68 : 104, 0 )
    NumPut( siSz,      si,  0,                          "UInt" )
    NumPut( 0x100,     si,  (A_PtrSize == 4) ? 44 : 60, "UInt" )
    NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 60 : 88, "Ptr"  )
    NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 64 : 96, "Ptr"  )

    If ( !DllCall( "CreateProcess", Ptr,0, Ptr,&sCmd, Ptr,0, Ptr,0, Int,True, UInt,0x08000000
                                  , Ptr,0, Ptr,sDir?&sDir:0, Ptr,&si, Ptr,&pi ) )
        Return ""
      , DllCall( "CloseHandle", Ptr,hStdOutWr )
      , DllCall( "CloseHandle", Ptr,hStdOutRd )

    DllCall( "CloseHandle", Ptr,hStdOutWr ) ; The write pipe must be closed before reading the stdout.
    While ( 1 )
    { ; Before reading, we check if the pipe has been written to, so we avoid freezings.
        If ( !DllCall( "PeekNamedPipe", Ptr,hStdOutRd, Ptr,0, UInt,0, Ptr,0, UIntP,nTot, Ptr,0 ) )
            Break
        If ( !nTot )
        { ; If the pipe buffer is empty, sleep and continue checking.
            Sleep, 100
            Continue
        } ; Pipe buffer is not empty, so we can read it.
        VarSetCapacity(sTemp, nTot+1)
        DllCall( "ReadFile", Ptr,hStdOutRd, Ptr,&sTemp, UInt,nTot, PtrP,nSize, Ptr,0 )
        sOutput .= StrGet(&sTemp, nSize, sEncoding)
    }
    
    ; * SKAN has managed the exit code through SetLastError.
    DllCall( "GetExitCodeProcess", Ptr,NumGet(pi,0), UIntP,nExitCode )
    DllCall( "CloseHandle",        Ptr,NumGet(pi,0)                  )
    DllCall( "CloseHandle",        Ptr,NumGet(pi,A_PtrSize)          )
    DllCall( "CloseHandle",        Ptr,hStdOutRd                     )
    Return sOutput
}