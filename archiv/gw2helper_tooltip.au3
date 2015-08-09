#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=logo.ico
#AutoIt3Wrapper_Outfile=gw2helper.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=GW2 Helper
#AutoIt3Wrapper_Res_Fileversion=0.0.0.18
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Simon Knittel ( www.simonknittel.de)
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

TraySetIcon(@ScriptFullPath, 201)

TraySetClick(8) ; Rechtsklick aufs Trayicon
AutoItSetOption("TrayMenuMode", 3)
AutoItSetOption("TrayOnEventMode", 1)

TrayCreateItem("Set Hotkeys")
TrayItemSetOnEvent(-1, "SetHotkeys")

TrayCreateItem("")

TrayCreateItem("Help")
TrayItemSetOnEvent(-1, "Help")
TrayCreateItem("Close")
TrayItemSetOnEvent(-1, "Close")

TraySetOnEvent(-7, "Help") ; Linksklick aufs Trayicon

Global $target_window_name = IniRead("config.ini", "target", "window_name", "Guild Wars 2")
Global $gui_left = IniRead("config.ini", "gw2helper", "left", 350)
Global $gui_top = IniRead("config.ini", "gw2helper", "top", 5)

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

; Loot bot
Global $loot_bot_running = 0
Global $loot_key = "{F9}"
; Loot bot end

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

ShowTooltip()

While 1
   Sleep(1000)
WEnd

Func SetHotkeys()
   $dropdown_list = ""
   For $i = 0 To UBound($hotkey_list,1) -1
	   $dropdown_list &= "|" & $hotkey_list[$i]
   Next

   $gui = GUICreate("Set Hotkeys - GW2 Helper", 185, 275)
   $gui_close_button = GUICtrlCreateButton("Close", 50, 225, 85, 25)

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

   GUICtrlCreateLabel("Loot Bot", 50, 175)
   $gui_combo3 = GUICtrlCreateCombo("", 50, 190, 85, 25, $CBS_DROPDOWNLIST)
   GUICtrlSetData($gui_combo3, $dropdown_list)
   _GUICtrlComboBox_SelectString($gui_combo3, $selected_hotkeys[3])

   GUISetState(@SW_SHOW, $gui)

   While 1
	  Switch GUIGetMsg()
		 Case $gui_combo0
			HotKeySet($selected_hotkeys[0])
			$selected_hotkeys[0] = GUICtrlRead($gui_combo0)
			HotKeySet($selected_hotkeys[0], "Close")
			IniWrite("config.ini", "hotkeys", "close", $selected_hotkeys[0])
			ShowTooltip()
		 Case $gui_combo1
			HotKeySet($selected_hotkeys[1])
			$selected_hotkeys[1] = GUICtrlRead($gui_combo1)
			HotKeySet($selected_hotkeys[1], "AFKToggle")
			IniWrite("config.ini", "hotkeys", "afk_bot", $selected_hotkeys[1])
			ShowTooltip()
		 Case $gui_combo2
			HotKeySet($selected_hotkeys[2])
			$selected_hotkeys[2] = GUICtrlRead($gui_combo2)
			HotKeySet($selected_hotkeys[2], "CLICKToggle")
			IniWrite("config.ini", "hotkeys", "speed_clicker", $selected_hotkeys[2])
			ShowTooltip()
		 Case $gui_combo3
			HotKeySet($selected_hotkeys[3])
			$selected_hotkeys[3] = GUICtrlRead($gui_combo3)
			HotKeySet($selected_hotkeys[3], "LOOTBOTToggle")
			IniWrite("config.ini", "hotkeys", "loot_bot", $selected_hotkeys[3])
			ShowTooltip()

		 Case $GUI_EVENT_CLOSE, $gui_close_button
			ExitLoop
	  EndSwitch
   WEnd

   GUIDelete($gui)
EndFunc

Func ShowTooltip()
   If ($click_running == 0 and $afk_running == 0 and $loot_bot_running == 0) Then
	  ToolTip("Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker (experimental)." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Bot (AoE loot key: F9)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.", $gui_left, $gui_top, "GW2 Helper", 1)

   ElseIf ($afk_running == 1) Then
	  ToolTip("The AFK Bot is running.", $gui_left, $gui_top, "GW2 Helper", 2)

   ElseIf ($click_running == 1) Then
	  ToolTip("The Speed Clicker is running.", $gui_left, $gui_top, "GW2 Helper", 2)

   ElseIf ($loot_bot_running == 1) Then
	  ToolTip("The Loot Bot is running.", $gui_left, $gui_top, "GW2 Helper", 2)

   EndIf
EndFunc

Func StopAll()
   AFKStop()
   CLICKStop()
   LOOTBOTStop()
EndFunc

Func Help()
   TrayTip("Help", "Press " & $selected_hotkeys[1] & " to toggle the AFK Bot." & @CRLF & "Press " & $selected_hotkeys[2] & " to toggle the Speed Clicker (experimental)." & @CRLF & "Press " & $selected_hotkeys[3] & " to toggle the Loot Bot (AoE loot key: F9)." & @CRLF & "Press " & $selected_hotkeys[0] & " to close the GW2 Helper.", 30, 1)
EndFunc

Func Close()
   StopAll()
   Exit
EndFunc

; Loot bot
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
   ToolTip("The Loot Bot is running.", $gui_left, $gui_top, "GW2 Helper", 2)

   LOOTBOTLoop()
EndFunc

Func LOOTBOTStop()
   $loot_bot_running = 0
   ShowTooltip()
EndFunc

Func LOOTBOTLoop()
   While $loot_bot_running == 1
	  ToolTip("The Loot Bot is running." & @CRLF & "Looting ...", $gui_left, $gui_top, "GW2 Helper", 2)

	  ControlSend("Guild Wars 2", "", "", $loot_key)
	  ToolTip("The Loot Bot is running.", $gui_left, $gui_top, "GW2 Helper", 2)

	  Sleep(2000)
   WEnd
EndFunc
; Loot bot end

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
   ToolTip("The Speed Clicker is running." & @CRLF & "Clicking ...", $gui_left, $gui_top, "GW2 Helper", 2)
   CLICKLoop()
EndFunc

Func CLICKStop()
   $click_running = 0
   ShowTooltip()
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
   ToolTip("The AFK Bot is running.", $gui_left, $gui_top, "GW2 Helper", 2)
   AFKLoop()
EndFunc

Func AFKStop ()
   $afk_running = 0
   ControlSend($target_window_name, "", "", $Keys2[0])
   ControlSend($target_window_name, "", "", $Keys2[1])
   ControlSend($target_window_name, "", "", $Keys2[2])
   ControlSend($target_window_name, "", "", $Keys2[3])

   ShowTooltip()
EndFunc

Func AFKLoop ()
   While $afk_running == 1
	  $rand_key = Random(0,3,1)
	  ControlSend($target_window_name, "", "", $Keys[$rand_key])
	  ToolTip("The AFK Bot is running." & @CRLF & "Moving ...", $gui_left, $gui_top, "GW2 Helper", 2)
	  Sleep(1000)
	  If ($afk_running == 1) Then
		 ControlSend($target_window_name, "", "", $Keys2[$rand_key])
		 ToolTip("The AFK Bot is running.", $gui_left, $gui_top, "GW2 Helper", 2)

		 $rand = Random(240000, 300000, 1)
		 ;$rand = Random(1000, 5000, 1) ;For testing
		 $seconds = Ceiling($rand / 1000)
		 For $i = 1 To $seconds Step 1
			If ($afk_running == 1) Then
			   ToolTip("The AFK Bot is running." & @CRLF & "Next move in " & $seconds & " seconds ...", $gui_left, $gui_top, "GW2 Helper", 2)
			   Sleep(1000)
			   $seconds -= 1
			EndIf
		 Next
	  EndIf
   WEnd
EndFunc
; AFK script end