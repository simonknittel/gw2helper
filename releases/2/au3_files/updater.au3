#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=updater.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Updater
#AutoIt3Wrapper_Res_LegalCopyright=Simon Knittel (gw2helper@simonknittel.de)
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
$download = IniRead(@ScriptDir & "\update.ini", "new", "download", "")
$target_exe = IniRead(@ScriptDir & "\update.ini", "exe", "filename", "")
$target_file1 = IniRead(@ScriptDir & "\update.ini", "file1", "filename", "")
$target_file1_dir = IniRead(@ScriptDir & "\update.ini", "file1", "directory", "")
$target_file2 = IniRead(@ScriptDir & "\update.ini", "file2", "filename", "")
$target_file2_dir = IniRead(@ScriptDir & "\update.ini", "file2", "directory", "")

If $target_exe <> "" And $target_file1 <> "" And $target_file2 <> "" And $download <> "" Then
	$downloaded_exe = InetGet($download & $target_exe, @ScriptDir & "\_" & $target_exe, 1)
	DirCreate(@ScriptDir & "\" & $target_file1_dir)
	$downloaded_file1 = InetGet($download & $target_file1_dir & "/" & $target_file1, @ScriptDir & "\" & $target_file1_dir & "\_" & $target_file1, 1)
	DirCreate(@ScriptDir & "\" & $target_file2_dir)
	$downloaded_file2 = InetGet($download & $target_file2_dir & "/" & $target_file2, @ScriptDir & "\" & $target_file2_dir & "\_" & $target_file2, 1)
	If $downloaded_exe <> 0 And $downloaded_file1 <> 0 And $downloaded_file2 <> 0 Then
		FileDelete(@ScriptDir & "\" & $target_exe)
		FileDelete(@ScriptDir & "\" & $target_file1)
		FileDelete(@ScriptDir & "\" & $target_file2)
		FileMove(@ScriptDir & "\_" & $target_exe, @ScriptDir & "\" & $target_exe, 8)
		FileMove(@ScriptDir & "\" & $target_file1_dir & "\_" & $target_file1, @ScriptDir & "\" & $target_file1_dir & "\" & $target_file1, 8)
		FileMove(@ScriptDir & "\" & $target_file2_dir & "\_" & $target_file2, @ScriptDir & "\" & $target_file2_dir & "\" & $target_file2, 8)

		InetClose($downloaded_exe)
		InetClose($downloaded_file1)
		InetClose($downloaded_file2)
		Run(@ScriptDir & "\" & $target_exe, "", @SW_MAXIMIZE)
	Else
		MsgBox(Default, "GW2 Helper", "Beim Herunterladen der neuen Version ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut. (Fehler: 1)")
		Run(@ScriptDir & "\" & $target_exe, "", @SW_MAXIMIZE)
	EndIf
Else
	MsgBox(Default, "GW2 Helper", "Beim Herunterladen der neuen Version ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut. (Fehler: 2)")
EndIf