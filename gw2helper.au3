#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=logo.ico
#AutoIt3Wrapper_Outfile=gw2helper.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=GW2 Helper
#AutoIt3Wrapper_Res_LegalCopyright=Simon Knittel (gw2helper@simonknittel.de)
#AutoIt3Wrapper_Res_Icon_Add=logo.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <ComboConstants.au3>
; *** End added by AutoIt3Wrapper ***

#include <Misc.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <Array.au3>
#include <GuiComboBox.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
#include <IE.au3>

; ########## Update check ##########
Global $local_version = 3
Global $remote_ini = InetGet("http://gw2helper.simonknittel.de/version.ini", @TempDir & "\version.ini", 1)
FileDelete(@ScriptDir & "\updater.exe")
FileDelete(@ScriptDir & "\update.ini")
If $remote_ini <> 0 Then
	$remote_version = IniRead(@TempDir & "\version.ini", "latest", "version", "0")
	If $local_version < $remote_version Then
		$do_update = MsgBox(4, "GW2 Helper", "Es ist eine neue Version verfügbar. Wollen Sie diese jetzt herunterladen und installieren?")
		If $do_update == 6 Then ; update.exe herunterladen
			$updater_download = IniRead(@TempDir & "\version.ini", "latest", "updater", "")
			$download = InetGet($updater_download, @ScriptDir & "\updater.exe", 1)
			$latest_download = IniRead(@TempDir & "\version.ini", "latest", "download", "")
			If $download <> 0 And $latest_download <> "" Then
				InetClose($download)
				IniWrite(@ScriptDir & "\update.ini", "new", "download", $latest_download)
				IniWrite(@ScriptDir & "\update.ini", "exe", "filename", "gw2helper.exe")
				IniWrite(@ScriptDir & "\update.ini", "file1", "filename", "gw2helper.au3")
				IniWrite(@ScriptDir & "\update.ini", "file1", "directory", "au3_files")
				IniWrite(@ScriptDir & "\update.ini", "file2", "filename", "updater.au3")
				IniWrite(@ScriptDir & "\update.ini", "file2", "directory", "au3_files")
				Run('"' & @ScriptDir & '\updater.exe"', "", @SW_MAXIMIZE)
				Exit
			Else
				MsgBox(Default, "GW2 Helper", "Beim Herunterladen der neuen Version ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut, oder laden Sie diese manuell unter " & $latest_download & ".zip herunter. (Fehler: 3)")
			EndIf
		EndIf
	EndIf
EndIf
; ########## Update check end ##########

Global $target_window_name = IniRead("config.ini", "target", "window_name", "Guild Wars 2")
Global $gui_left = IniRead("config.ini", "gw2helper", "left", 0)
Global $gui_top = IniRead("config.ini", "gw2helper", "top", 0)

;If WinExists($target_window_name) == 0 Then
	;MsgBox(48, "GW2 Helper", "Guild Wars 2 läuft nicht.")
;EndIf

TraySetIcon(@ScriptFullPath, 201)

TraySetClick(8) ; Rechtsklick aufs Trayicon
AutoItSetOption("TrayMenuMode", 3)
AutoItSetOption("TrayOnEventMode", 1)

TrayCreateItem("Set Hotkeys")
TrayItemSetOnEvent(-1, "SetHotkeys")

TrayCreateItem("")

TrayCreateItem("Help")
TrayItemSetOnEvent(-1, "Help")
TrayCreateItem("About")
TrayItemSetOnEvent(-1, "About")
TrayCreateItem("Close")
TrayItemSetOnEvent(-1, "Close")

TraySetOnEvent(-7, "Help") ; Linksklick aufs Trayicon

Global $hotkey_list[22]
$hotkey_list[0] = "{NUMPAD0}"
$hotkey_list[1] = "{NUMPAD1}"
$hotkey_list[2] = "{NUMPAD2}"
$hotkey_list[3] = "{NUMPAD3}"
$hotkey_list[4] = "{NUMPAD4}"
$hotkey_list[5] = "{NUMPAD5}"
$hotkey_list[6] = "{NUMPAD6}"
$hotkey_list[7] = "{NUMPAD7}"
$hotkey_list[8] = "{NUMPAD8}"
$hotkey_list[9] = "{NUMPAD9}"
$hotkey_list[10] = "{F1}"
$hotkey_list[11] = "{F2}"
$hotkey_list[12] = "{F3}"
$hotkey_list[13] = "{F4}"
$hotkey_list[14] = "{F5}"
$hotkey_list[15] = "{F6}"
$hotkey_list[16] = "{F7}"
$hotkey_list[17] = "{F8}"
$hotkey_list[18] = "{F9}"
$hotkey_list[19] = "{F10}"
$hotkey_list[20] = "{F11}"
$hotkey_list[21] = "{F12}"

Global $ini_hotkeys[4]
$ini_hotkeys[0] = IniRead("config.ini", "hotkeys", "close", $hotkey_list[0])
$ini_hotkeys[1] = IniRead("config.ini", "hotkeys", "afk_bot", $hotkey_list[1])
$ini_hotkeys[2] = IniRead("config.ini", "hotkeys", "speed_clicker", $hotkey_list[2])
$ini_hotkeys[3] = IniRead("config.ini", "hotkeys", "loot_bot", $hotkey_list[3])

Global $selected_hotkeys[4]
$selected_hotkeys[0] = $ini_hotkeys[0]
$selected_hotkeys[1] = $ini_hotkeys[1]
$selected_hotkeys[2] = $ini_hotkeys[2]
$selected_hotkeys[3] = $ini_hotkeys[3]

HotKeySet($selected_hotkeys[0], "Close")
HotKeySet($selected_hotkeys[1], "AFKToggle")
HotKeySet($selected_hotkeys[2], "CLICKToggle")
HotKeySet($selected_hotkeys[3], "LOOTBOTToggle")

; Loot Machine
Global $loot_bot_running = 0
Global $loot_key = IniRead("config.ini", "loot_bot", "aoe_loot_key", $hotkey_list[18])
; Loot Machine end

; Click script
Global $click_running = 0
; Click script end

; AFK script
Global $Keys[4]
$Keys[0] = "{UP down}"
$Keys[1] = "{LEFT down}"
$Keys[3] = "{RIGHT down}"
$Keys[2] = "{DOWN down}"

Global $Keys2[4]
$Keys2[0] = "{UP up}"
$Keys2[1] = "{LEFT up}"
$Keys2[2] = "{DOWN up}"
$Keys2[3] = "{RIGHT up}"

Global $afk_running = 0
; AFK script end

AutoItSetOption("GUIResizeMode", 802)
;Global $sMain = "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper."

Global $fMain = GUICreate("GW2 Helper", 420, 90, $gui_left, $gui_top, $WS_POPUPWINDOW, $WS_EX_TOPMOST, WinGetHandle(AutoItWinGetTitle()))
GUISetBkColor($COLOR_WHITE)
GUICtrlSetDefColor(0x404040)

Global $gui_transparency = IniRead("config.ini", "gw2helper", "transparency", 255)
WinSetTrans($fMain, "", $gui_transparency)

Global $lDrag = GUICtrlCreateLabel("", 30, 0, 390, 90, -1, $GUI_WS_EX_PARENTDRAG)
Global $iState = GUICtrlCreateIcon("shell32.dll", 16783, 5, 5, 20, 20)
Global $lHeader = GUICtrlCreateLabel("GW2 Helper", 30, 7, 300, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
Global $lText = GUICtrlCreateLabel("", 30, 30, 500, 100)
Global $sTransparency = GUICtrlCreateSlider(5, 25, 20, 65, $TBS_VERT)
GUICtrlSetLimit($sTransparency, 255, 25)
GUICtrLSetData($sTransparency, $gui_transparency)

GUISetState(@SW_SHOW)
ChangeGUI()

TrayTip("GW2 Helper", "Hier unten findest du die Einstellungen und noch weiteres.", 30, 1)

$api_url = "https://api.guildwars2.com/v1/build.json"
$api = InetRead($api_url)
$build = BinaryToString($api, 4)
While 1
	Sleep(100)
	$gui_transparency = GUICtrlRead($sTransparency)
	WinSetTrans($fMain, "", $gui_transparency)
WEnd

Func ChangeGUI()
	If ($click_running == 0 and $afk_running == 0 and $loot_bot_running == 0) Then
	  GUICtrlSetData($lText, "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.")
	  WinMove($fMain, "", Default, Default, 420, 90)
	  GUICtrlSetImage($iState, "shell32.dll", 16783)
	  GUICtrlSetState($sTransparency, $GUI_SHOW)
	ElseIf ($afk_running == 1) Then
	  GUICtrlSetData($lText, "The AFK Bot is running.")
	  WinMove($fMain, "", Default, Default, 200, 65)
	  GUICtrlSetImage($iState, "shell32.dll", 161)
	  GUICtrlSetState($sTransparency, $GUI_HIDE)
	ElseIf ($click_running == 1) Then
	  GUICtrlSetData($lText, "The Speed Clicker is running.")
	  WinMove($fMain, "", Default, Default, 200, 65)
	  GUICtrlSetImage($iState, "shell32.dll", 161)
	  GUICtrlSetState($sTransparency, $GUI_HIDE)
	ElseIf ($loot_bot_running == 1) Then
	  GUICtrlSetData($lText, "The Loot Machine is running.")
	  WinMove($fMain, "", Default, Default, 200, 65)
	  GUICtrlSetImage($iState, "shell32.dll", 161)
	  GUICtrlSetState($sTransparency, $GUI_HIDE)
	EndIf
EndFunc

Func SetHotkeys()
   $dropdown_list = ""
   For $i = 0 To UBound($hotkey_list,1) -1
	   $dropdown_list &= "|" & $hotkey_list[$i]
   Next

   $gui = GUICreate("Set Hotkeys - GW2 Helper", 185, 325)
   $gui_close_button = GUICtrlCreateButton("Close", 50, 275, 85, 25)

   GUICtrlCreateLabel("Close", 50, 25)
   $gui_combo0 = GUICtrlCreateCombo("", 50, 40, 85, 25, $CBS_DROPDOWNLIST)
   GUICtrlSetData($gui_combo0, $dropdown_list)
   _GUICtrlComboBox_SelectString($gui_combo0, $selected_hotkeys[0])

   GUICtrlCreateLabel("AFK Bot", 50, 75)
   $gui_combo1 = GUICtrlCreateCombo("", 50, 90, 85, 25, $CBS_DROPDOWNLIST)
   GUICtrlSetData($gui_combo1, $dropdown_list)
   _GUICtrlComboBox_SelectString($gui_combo1, $selected_hotkeys[1])

   GUICtrlCreateLabel("Speed Clicker", 50, 125)
   $gui_combo2 = GUICtrlCreateCombo("", 50, 140, 85, 25, $CBS_DROPDOWNLIST)
   GUICtrlSetData($gui_combo2, $dropdown_list)
   _GUICtrlComboBox_SelectString($gui_combo2, $selected_hotkeys[2])

   GUICtrlCreateLabel("Loot Machine", 50, 175)
   $gui_combo3 = GUICtrlCreateCombo("", 50, 190, 85, 25, $CBS_DROPDOWNLIST)
   GUICtrlSetData($gui_combo3, $dropdown_list)
   _GUICtrlComboBox_SelectString($gui_combo3, $selected_hotkeys[3])

   GUICtrlCreateLabel("AoE Loot Key", 50, 225)
   $gui_combo4 = GUICtrlCreateCombo("", 50, 240, 85, 25, $CBS_DROPDOWNLIST)
   GUICtrlSetData($gui_combo4, $dropdown_list)
   _GUICtrlComboBox_SelectString($gui_combo4, $loot_key)

   GUISetState(@SW_SHOW, $gui)

   While 1
	  Switch GUIGetMsg()
		 Case $gui_combo0
			HotKeySet($selected_hotkeys[0])
			$selected_hotkeys[0] = GUICtrlRead($gui_combo0)
			HotKeySet($selected_hotkeys[0], "Close")
			GUICtrlSetData($lText, "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.")
		 Case $gui_combo1
			HotKeySet($selected_hotkeys[1])
			$selected_hotkeys[1] = GUICtrlRead($gui_combo1)
			HotKeySet($selected_hotkeys[1], "AFKToggle")
			GUICtrlSetData($lText, "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.")
		 Case $gui_combo2
			HotKeySet($selected_hotkeys[2])
			$selected_hotkeys[2] = GUICtrlRead($gui_combo2)
			HotKeySet($selected_hotkeys[2], "CLICKToggle")
			GUICtrlSetData($lText, "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.")
		 Case $gui_combo3
			HotKeySet($selected_hotkeys[3])
			$selected_hotkeys[3] = GUICtrlRead($gui_combo3)
			HotKeySet($selected_hotkeys[3], "LOOTBOTToggle")
			GUICtrlSetData($lText, "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.")
		 Case $gui_combo4
			$loot_key = GUICtrlRead($gui_combo4)
			GUICtrlSetData($lText, "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.")

		 Case $GUI_EVENT_CLOSE, $gui_close_button
			ExitLoop
	  EndSwitch
   WEnd

   GUIDelete($gui)
EndFunc

Func StopAll()
   AFKStop()
   CLICKStop()
   LOOTBOTStop()
EndFunc

Func Help()
   TrayTip("Help", "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Machine (aoe loot: " & $loot_key & ") (experimental)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.", 30, 1)
EndFunc

Func About()
	TrayTip("About", "Copyright by Simon Knittel (gw2helper@simonknittel.de)" & @CRLF & "Version " & $local_version, 30, 1)
EndFunc

Func Close()
   StopAll()
   $gui_pos = WinGetPos($fMain)
   IniWrite("config.ini", "hotkeys", "close", $selected_hotkeys[0])
   IniWrite("config.ini", "hotkeys", "afk_bot", $selected_hotkeys[1])
   IniWrite("config.ini", "hotkeys", "speed_clicker", $selected_hotkeys[2])
   IniWrite("config.ini", "hotkeys", "loot_bot", $selected_hotkeys[3])
   IniWrite("config.ini", "gw2helper", "left", $gui_pos[0])
   IniWrite("config.ini", "gw2helper", "top", $gui_pos[1])
   IniWrite("config.ini", "gw2helper", "transparency", $gui_transparency)
   IniWrite("config.ini", "loot_bot", "aoe_loot_key", $loot_key)
   Exit
EndFunc

; Loot Machine
Func LOOTBOTToggle()
   If ($loot_bot_running == 0) Then
	  LOOTBOTStart()
   ElseIf ($loot_bot_running == 1) Then
	  LOOTBOTStop()
   EndIf
EndFunc

Func LOOTBOTStart()
   StopAll()
   $loot_bot_running = 1
   GUICtrlSetData($lText, "The Loot Machine is running.")
   WinMove($fMain, "", Default, Default, 200, 65)
   GUICtrlSetImage($iState, "shell32.dll", 161)
   GUICtrlSetState($sTransparency, $GUI_HIDE)

   LOOTBOTLoop()
EndFunc

Func LOOTBOTStop()
   $loot_bot_running = 0
   ChangeGUI()
EndFunc

Func LOOTBOTLoop()
   While $loot_bot_running == 1
	  GUICtrlSetData($lText, "The Loot Machine is running." & @CRLF & "Looting ...")
	  ControlSend("Guild Wars 2", "", "", $loot_key)
	  GUICtrlSetData($lText, "The Loot Machine is running.")

	  Sleep(2000)
   WEnd
EndFunc
; Loot Machine end

; Click script
Func CLICKToggle()
   If ($click_running == 0) Then
	  CLICKStart()
   ElseIf ($click_running == 1) Then
	  CLICKStop()
   EndIf
EndFunc

Func CLICKStart()
   StopAll()
   $click_running = 1
   GUICtrlSetData($lText, "The Speed Clicker is running." & @CRLF & "Clicking ...")
   WinMove($fMain, "", Default, Default, 200, 65)
   GUICtrlSetImage($iState, "shell32.dll", 161)
   GUICtrlSetState($sTransparency, $GUI_HIDE)

   CLICKLoop()
EndFunc

Func CLICKStop()
   $click_running = 0
   ChangeGUI()
EndFunc

Func CLICKLoop()
   While $click_running == 1
	   MouseClick("")
	  ;ControlClick($target_window_name, "", "")
   WEnd
EndFunc
; Click script end

; AFK script
Func AFKToggle()
   If ($afk_running == 0) Then
	  AFKStart()
   ElseIf ($afk_running == 1) Then
	  AFKStop()
   EndIf
EndFunc

Func AFKStart ()
	StopAll()
	$afk_running = 1
	GUICtrlSetData($lText, "The AFK Bot is running.")
	WinMove($fMain, "", Default, Default, 200, 65)
	GUICtrlSetImage($iState, "shell32.dll", 161)
    GUICtrlSetState($sTransparency, $GUI_HIDE)

	AFKLoop()
EndFunc

Func AFKStop ()
   $afk_running = 0
   ControlSend($target_window_name, "", "", $Keys2[0])
   ControlSend($target_window_name, "", "", $Keys2[1])
   ControlSend($target_window_name, "", "", $Keys2[2])
   ControlSend($target_window_name, "", "", $Keys2[3])

   ChangeGUI()
EndFunc

Func AFKLoop ()
   While $afk_running == 1
	  $rand_key = Random(0,3,1)
	  ControlSend($target_window_name, "", "", $Keys[$rand_key])
	  GUICtrlSetData($lText, "The AFK Bot is running." & @CRLF & "Moving ...")

	  Sleep(1000)
	  If ($afk_running == 1) Then
		 ControlSend($target_window_name, "", "", $Keys2[$rand_key])
		 GUICtrlSetData($lText, "The AFK Bot is running.")

		 $rand = Random(240000, 300000, 1)
		 ;$rand = Random(1000, 5000, 1) ;For testing
		 $seconds = Ceiling($rand / 1000)
		 For $i = 1 To $seconds Step 1
			If ($afk_running == 1) Then
			   GUICtrlSetData($lText, "The AFK Bot is running." & @CRLF & "Next move in " & $seconds & " seconds ...")
			   Sleep(1000)
			   $seconds -= 1
			EndIf
		 Next
	  EndIf
   WEnd
EndFunc
; AFK script end