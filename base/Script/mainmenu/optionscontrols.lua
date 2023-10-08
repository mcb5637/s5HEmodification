----------------------------------------------------------------------------------------------------
-- 20: Control options screen
-- be careful, the key-names are inside the AS3D_MainFramework.cpp too
-- this file is loaded inside the local lua-state too 
----------------------------------------------------------------------------------------------------

OptionsControls_Menu = {}


----------------------------------------------------------------------------------------------------
-- Init 
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.Init( )	
	
	-- Default values
	OptionsControls_Menu.BorderSpeed = 50

	-- Try to load stored values from the GDB
	if GDB.IsKeyValid( "Config\\Controls\\BorderSpeed" ) then
		OptionsControls_Menu.BorderSpeed = GDB.GetValue( "Config\\Controls\\BorderSpeed" )
	end

	-- set the scroll speed
	OptionsControls_Menu.SetScrollSpeed(OptionsControls_Menu.BorderSpeed)
	
	--
	OptionsControls_Menu.KeysTextInitialized = false
	OptionsControls_Menu.KeysLine = 0
	
end


----------------------------------------------------------------------------------------------------
-- Init 
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.Close()	

	GDB.Save()
	
end

----------------------------------------------------------------------------------------------------
-- BorderSpeed slider
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.BorderSpeedUp(_sliderName)

	OptionsControls_Menu.BorderSpeed = OptionsControls_Menu.BorderSpeed + 5
	if OptionsControls_Menu.BorderSpeed > 100 then
		OptionsControls_Menu.BorderSpeed = 100
	end
	
	-- update the slider
	OptionsControls_Menu.BorderSpeedUpdate(_sliderName)

end
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.BorderSpeedDown(_sliderName)

	OptionsControls_Menu.BorderSpeed = OptionsControls_Menu.BorderSpeed - 5
	if OptionsControls_Menu.BorderSpeed < 0 then
		OptionsControls_Menu.BorderSpeed = 0
	end
	
	-- update the slider
	OptionsControls_Menu.BorderSpeedUpdate(_sliderName)

end
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.BorderSpeedUpdate(_sliderName)

	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsControls_Menu.BorderSpeed )

	GDB.SetValueNoSave( "Config\\Controls\\BorderSpeed", OptionsControls_Menu.BorderSpeed)

end
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu_OnBorderSpeedSliderMoved( _Value, _WidgetID )

	OptionsControls_Menu.BorderSpeed = _Value 
	
	OptionsControls_Menu.SetScrollSpeed( OptionsControls_Menu.BorderSpeed )

end                                                                                                                                                                                                                                                             


----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.SetScrollSpeed( _percent )

	local Min = 1000
	local Max = 7500
	local Dif = Max - Min	
	local Value = Min + ((Dif / 100) * _percent)

	if Camera ~= nil then
		Camera.ScrollSetSpeed(Value)
	end

end

----------------------------------------------------------------------------------------------------
-- Keys
----------------------------------------------------------------------------------------------------

function OptionsControls_Menu.KeysDown( _keysTextLeftWidgetID, _keysTextRightWidgetID, _numLines )
	OptionsControls_Menu.KeysLine = OptionsControls_Menu.KeysLine + 5
	OptionsControls_Menu_KeysUpdate(_keysTextLeftWidgetID, _keysTextRightWidgetID)

end


function OptionsControls_Menu.KeysUp( _keysTextLeftWidgetID, _keysTextRightWidgetID, _numLines )
	OptionsControls_Menu.KeysLine = OptionsControls_Menu.KeysLine - 5
	OptionsControls_Menu_KeysUpdate(_keysTextLeftWidgetID, _keysTextRightWidgetID)

end

function OptionsControls_Menu_KeysUpdate( _keysTextLeftWidgetID, _keysTextRightWidgetID, _numLines )

	-- Initialize the keys-text
	if OptionsControls_Menu.KeysTextInitialized == false then
--		XGUIEng.SetTextFromFile( _keysTextLeftWidgetID,  "Txt\\keybindings_left.txt", false )
--		XGUIEng.SetTextFromFile( _keysTextRightWidgetID, "Txt\\keybindings_right.txt", false )
		OptionsControls_Menu.KeysTextInitialized = true
	end

	-- Validate line
	if OptionsControls_Menu.KeysLine < 0 then
		OptionsControls_Menu.KeysLine = 0
	end
	
	-- Update widget
	XGUIEng.SetLinesToPrint( _keysTextLeftWidgetID,  OptionsControls_Menu.KeysLine, _numLines )
	XGUIEng.SetLinesToPrint( _keysTextRightWidgetID, OptionsControls_Menu.KeysLine, _numLines )
	
end

