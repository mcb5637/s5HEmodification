----------------------------------------------------------------------------------------------------
-- 40: Sound options screen
-- be careful, the key-names are inside the AS3D_MainFramework.cpp too
-- this file is loaded inside the local lua-state too 
----------------------------------------------------------------------------------------------------

OptionsSound_Menu = {}


----------------------------------------------------------------------------------------------------
-- Init 
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.Init( )	

	-- Default values	
	SoundOptions.InitSoundDefaultValues()
	
	OptionsSound_Menu.MainVolume = 10
	OptionsSound_Menu.SoundEffectVolume = 30
	OptionsSound_Menu.MusicVolume = 50
	OptionsSound_Menu.VoiceVolume = 90
	OptionsSound_Menu.FeedbackVolume = 100

	-- Try to load stored values from the GDB
	if GDB.IsKeyValid( "Config\\Sound\\MainVolume" ) then
		OptionsSound_Menu.MainVolume = GDB.GetValue( "Config\\Sound\\MainVolume" )
	end

	if GDB.IsKeyValid( "Config\\Sound\\SoundEffectVolume" ) then
		OptionsSound_Menu.SoundEffectVolume = GDB.GetValue( "Config\\Sound\\SoundEffectVolume" )
	end

	if GDB.IsKeyValid( "Config\\Sound\\MusicVolume" ) then
		OptionsSound_Menu.MusicVolume = GDB.GetValue( "Config\\Sound\\MusicVolume" )
	end

	if GDB.IsKeyValid( "Config\\Sound\\VoiceVolume" ) then
		OptionsSound_Menu.VoiceVolume = GDB.GetValue( "Config\\Sound\\VoiceVolume" )
	end

	if GDB.IsKeyValid( "Config\\Sound\\FeedbackVolume" ) then
		OptionsSound_Menu.FeedbackVolume = GDB.GetValue( "Config\\Sound\\FeedbackVolume" )
	end
	
	-- sound checks
	OptionsSound_Menu.HasHardware3dSound = false
	if SoundOptions.HasHardware3dSound() then
		OptionsSound_Menu.HasHardware3dSound = true
	end	

	OptionsSound_Menu.HasEAX = false
	if SoundOptions.HasEAX() then
		OptionsSound_Menu.HasEAX = true
	end	
	
end


----------------------------------------------------------------------------------------------------
-- Init 
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.Close()	

	GDB.Save()
	
end

----------------------------------------------------------------------------------------------------
-- Sound set on/off
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.SetSound( _Activate )
	
	GDB.SetValue( "Config\\Sound\\Hardware3dSoundEnabled", _Activate )	
	OptionsMenu.S41_Start()
	
end


function OptionsSound_Menu.UpdateSound( _Activate )

	if OptionsSound_Menu.HasHardware3dSound then
		-- we have sound so update the highlighting
		local Activate = 0
		if GDB.IsKeyValid( "Config\\Sound\\Hardware3dSoundEnabled" ) then
			Activate = GDB.GetValue( "Config\\Sound\\Hardware3dSoundEnabled" )
		end
			
		local HighLightFlag = 0
		if Activate == _Activate then
			HighLightFlag = 1
		end

		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )

	else	
		-- disable this button because we dont have sound
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	end
	
end


----------------------------------------------------------------------------------------------------
-- EAX set on/off
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.SetEAX( _Enabled )

	GDB.SetValue( "Config\\Sound\\EAXEnabled", _Enabled )
	OptionsMenu.S41_Start()

end

function OptionsSound_Menu.UpdateEAX( _Activate )

	local hasEAX = OptionsSound_Menu.HasEAX

	if GDB.IsKeyValid( "Config\\Sound\\Hardware3dSoundEnabled" ) then
		hasEAX = hasEAX and ( GDB.GetValue( "Config\\Sound\\Hardware3dSoundEnabled" ) ~= 0)
	end

	if hasEAX then
		-- we have sound so update the highlighting
		local Activate = 0
		if GDB.IsKeyValid( "Config\\Sound\\EAXEnabled" ) then
			Activate = GDB.GetValue( "Config\\Sound\\EAXEnabled" )
		end
			
		local HighLightFlag = 0
		if Activate == _Activate then
			HighLightFlag = 1
		end

		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )	
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	else
		-- disable this button because we dont have EAX
		
		if _Activate == 1 then
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
		else
			XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), 1 )
		end
	end

end

----------------------------------------------------------------------------------------------------
-- LowQuality set on/off
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.SetLowQuality( _Enabled )
		
	GDB.SetValue( "Config\\Sound\\LowQualityEnabled", _Enabled )
	OptionsMenu.S41_Start()

end


function OptionsSound_Menu.UpdateLowQuality( _Activate )

	-- we have sound so update the highlighting
	local Activate = 0
	if GDB.IsKeyValid( "Config\\Sound\\LowQualityEnabled" ) then
		Activate = GDB.GetValue( "Config\\Sound\\LowQualityEnabled" )
	end
			
	local HighLightFlag = 0
	if Activate == _Activate then
		HighLightFlag = 1
	end

	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )	

end


----------------------------------------------------------------------------------------------------
-- Main Volume
----------------------------------------------------------------------------------------------------

function  OptionsSound_Menu.MainVolumeUp(_sliderName)
	OptionsSound_Menu.MainVolume = OptionsSound_Menu.MainVolume + 5
	if OptionsSound_Menu.MainVolume > 100 then
		OptionsSound_Menu.MainVolume = 100
	end
	
	-- update the slider
	OptionsSound_Menu.MainVolumeUpdate(_sliderName)

end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.MainVolumeDown(_sliderName)
	OptionsSound_Menu.MainVolume = OptionsSound_Menu.MainVolume - 5
	if OptionsSound_Menu.MainVolume < 0 then
		OptionsSound_Menu.MainVolume = 0
	end
	
	-- update the slider
	OptionsSound_Menu.MainVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.MainVolumeUpdate(_sliderName)
	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsSound_Menu.MainVolume )

	-- Set in game
	GDB.SetValueNoSave( "Config\\Sound\\MainVolume", OptionsSound_Menu.MainVolume)
	SoundOptions.UpdateSound()
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu_OnMainVolumeSliderMoved( _Value, _WidgetID )
	OptionsSound_Menu.MainVolume = _Value 
end

----------------------------------------------------------------------------------------------------
-- SoundEffect Volume
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.SoundEffectVolumeUp(_sliderName)
	OptionsSound_Menu.SoundEffectVolume = OptionsSound_Menu.SoundEffectVolume + 5
	if OptionsSound_Menu.SoundEffectVolume > 100 then
		OptionsSound_Menu.SoundEffectVolume = 100
	end
	
	-- update the slider
	OptionsSound_Menu.SoundEffectVolumeUpdate(_sliderName)
	
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.SoundEffectVolumeDown(_sliderName)
	OptionsSound_Menu.SoundEffectVolume = OptionsSound_Menu.SoundEffectVolume - 5
	if OptionsSound_Menu.SoundEffectVolume < 0 then
		OptionsSound_Menu.SoundEffectVolume = 0
	end
	
	-- update the slider
	OptionsSound_Menu.SoundEffectVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.SoundEffectVolumeUpdate(_sliderName)
	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsSound_Menu.SoundEffectVolume )

	-- Set in game
	GDB.SetValueNoSave( "Config\\Sound\\SoundEffectVolume", OptionsSound_Menu.SoundEffectVolume)
	SoundOptions.UpdateSound()
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu_OnSoundEffectVolumeSliderMoved( _Value, _WidgetID )
	OptionsSound_Menu.SoundEffectVolume = _Value 
end

----------------------------------------------------------------------------------------------------
-- Music Volume
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.MusicVolumeUp(_sliderName)
	OptionsSound_Menu.MusicVolume = OptionsSound_Menu.MusicVolume + 5
	if OptionsSound_Menu.MusicVolume > 100 then
		OptionsSound_Menu.MusicVolume = 100
	end
	
	-- update the slider
	OptionsSound_Menu.MusicVolumeUpdate(_sliderName)
	
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.MusicVolumeDown(_sliderName)
	OptionsSound_Menu.MusicVolume = OptionsSound_Menu.MusicVolume - 5
	if OptionsSound_Menu.MusicVolume < 0 then
		OptionsSound_Menu.MusicVolume = 0
	end
	
	-- update the slider
	OptionsSound_Menu.MusicVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.MusicVolumeUpdate(_sliderName)
	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsSound_Menu.MusicVolume )
	
	GDB.SetValueNoSave( "Config\\Sound\\MusicVolume", OptionsSound_Menu.MusicVolume)
	SoundOptions.UpdateSound()
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu_OnMusicVolumeSliderMoved( _Value, _WidgetID )
	OptionsSound_Menu.MusicVolume = _Value 
end       

----------------------------------------------------------------------------------------------------
-- GUI Volume
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.GUIVolumeUp(_sliderName)
	OptionsSound_Menu.GUIVolume = OptionsSound_Menu.GUIVolume + 5
	if OptionsSound_Menu.GUIVolume > 100 then
		OptionsSound_Menu.GUIVolume = 100
	end
	
	-- update the slider
	OptionsSound_Menu.GUIVolumeUpdate(_sliderName)
	
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.GUIVolumeDown(_sliderName)
	OptionsSound_Menu.GUIVolume = OptionsSound_Menu.GUIVolume - 5
	if OptionsSound_Menu.GUIVolume < 0 then
		OptionsSound_Menu.GUIVolume = 0
	end
	
	-- update the slider
	OptionsSound_Menu.GUIVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.GUIVolumeUpdate(_sliderName)
	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsSound_Menu.GUIVolume )
	
	SoundOptions.UpdateSound()
	
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu_OnGUIVolumeSliderMoved( _Value, _WidgetID )
	OptionsSound_Menu.GUIVolume = _Value 
end              

----------------------------------------------------------------------------------------------------
-- Voice Volume
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.VoiceVolumeUp(_sliderName)
	OptionsSound_Menu.VoiceVolume = OptionsSound_Menu.VoiceVolume + 5
	if OptionsSound_Menu.VoiceVolume > 100 then
		OptionsSound_Menu.VoiceVolume = 100
	end
	
	-- update the slider
	OptionsSound_Menu.VoiceVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.VoiceVolumeDown(_sliderName)
	OptionsSound_Menu.VoiceVolume = OptionsSound_Menu.VoiceVolume - 5
	if OptionsSound_Menu.VoiceVolume < 0 then
		OptionsSound_Menu.VoiceVolume = 0
	end
	
	-- update the slider
	OptionsSound_Menu.VoiceVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.VoiceVolumeUpdate(_sliderName)
	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsSound_Menu.VoiceVolume )

	GDB.SetValueNoSave( "Config\\Sound\\VoiceVolume", OptionsSound_Menu.VoiceVolume)
	SoundOptions.UpdateSound()

end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu_OnVoiceVolumeSliderMoved( _Value, _WidgetID )
	OptionsSound_Menu.VoiceVolume = _Value 
end                                                                                                                                                                                                                                                             


----------------------------------------------------------------------------------------------------
-- Feedback Volume
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.FeedbackVolumeUp(_sliderName)
	OptionsSound_Menu.FeedbackVolume = OptionsSound_Menu.FeedbackVolume + 5
	if OptionsSound_Menu.FeedbackVolume > 100 then
		OptionsSound_Menu.FeedbackVolume = 100
	end
	
	-- update the slider
	OptionsSound_Menu.FeedbackVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.FeedbackVolumeDown(_sliderName)
	OptionsSound_Menu.FeedbackVolume = OptionsSound_Menu.FeedbackVolume - 5
	if OptionsSound_Menu.FeedbackVolume < 0 then
		OptionsSound_Menu.FeedbackVolume = 0
	end
	
	-- update the slider
	OptionsSound_Menu.FeedbackVolumeUpdate(_sliderName)
end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu.FeedbackVolumeUpdate(_sliderName)
	XGUIEng.SetCustomScrollBarSliderValue( _sliderName, OptionsSound_Menu.FeedbackVolume )

	GDB.SetValueNoSave( "Config\\Sound\\FeedbackVolume", OptionsSound_Menu.FeedbackVolume)
	SoundOptions.UpdateSound()

end
----------------------------------------------------------------------------------------------------

function OptionsSound_Menu_OnFeedbackVolumeSliderMoved( _Value, _WidgetID )
	OptionsSound_Menu.FeedbackVolume = _Value 
end                                                                                                                                                                                                                                                             
