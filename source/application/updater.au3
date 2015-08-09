#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=updater.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=GW2 Helper - Updater
#AutoIt3Wrapper_Res_LegalCopyright=Simon Knittel (gw2helper@simonknittel.de)
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

$download = IniRead(@ScriptDir & "\update.ini", "new", "download", "")
$target_exe = IniRead(@ScriptDir & "\update.ini", "exe", "filename", "")

If $target_exe <> "" And $download <> "" Then
    $downloaded_exe = InetGet($download & $target_exe, @ScriptDir & "\_" & $target_exe, 1)
    If $downloaded_exe <> 0 Then
        InetClose($downloaded_exe)

        FileDelete(@ScriptDir & "\" & $target_exe)
        FileMove(@ScriptDir & "\_" & $target_exe, @ScriptDir & "\" & $target_exe, 8)

        Run(@ScriptDir & "\" & $target_exe, "", @SW_MAXIMIZE)
    Else
        MsgBox(Default, "GW2 Helper", "Beim Herunterladen der neuen Version ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut. (Fehler: 1)")
        Run(@ScriptDir & "\" & $target_exe, "", @SW_MAXIMIZE)
    EndIf
Else
    MsgBox(Default, "GW2 Helper", "Beim Herunterladen der neuen Version ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut. (Fehler: 2)")
EndIf