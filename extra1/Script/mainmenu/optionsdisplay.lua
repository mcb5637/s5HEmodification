----------------------------------------------------------------------------------------------------
-- 30: Graphics options screen
-- be careful, the key-names are inside the AS3D_MainFramework.cpp too
-- this file is loaded inside the local lua-state too 
----------------------------------------------------------------------------------------------------

OptionsDisplay_Menu = {}


----------------------------------------------------------------------------------------------------
-- Init 
function
OptionsDisplay_Menu.Init()

	-- Update the Display Options one time so we initialize all unset values with defaults
	DisplayOptions.InitDefaultValues()

	-- Get the resolution name
	local selectionIndex = 0
	local gdbResolutionName = "unknown"
	if GDB.IsKeyValid( "Config\\Display\\Resolution" ) then
		gdbResolutionName = GDB.GetString( "Config\\Display\\Resolution" )
	end

	-- Init resolution table
	do
	
		-- Create table
		OptionsDisplay_Menu.ResolutionTable = nil
		OptionsDisplay_Menu.ResolutionTable = {}								
		
		-- Init table		
		OptionsDisplay_Menu.ResolutionTable.Number = 0
		OptionsDisplay_Menu.ResolutionTable.Array = nil
		OptionsDisplay_Menu.ResolutionTable.Array = {}
		
		
		-- Add resolutions
		for ResolutionIndex = 0, 1000, 1 do
			local ResStatus, ResolutionName = DisplayOptions.GetResolutionNames( ResolutionIndex )
						
			if ResStatus == 1 then				
				
				if gdbResolutionName == ResolutionName then
					selectionIndex = OptionsDisplay_Menu.ResolutionTable.Number
				end
				
				OptionsDisplay_Menu.ResolutionTable.Array[ OptionsDisplay_Menu.ResolutionTable.Number ] = ResolutionName
				OptionsDisplay_Menu.ResolutionTable.Number = OptionsDisplay_Menu.ResolutionTable.Number + 1
			end
			
			if ResStatus == 2 then
				break
			end
			
		end
		
	end


	-- Init list box
	do		
					
		OptionsDisplay_Menu.ListBox = nil
		OptionsDisplay_Menu.ListBox = {}	
		OptionsDisplay_Menu.ListBox.ElementsShown = 6																								-- Elements in list box
		OptionsDisplay_Menu.ListBox.ElementsInList = OptionsDisplay_Menu.ResolutionTable.Number			-- Elements in list
		OptionsDisplay_Menu.ListBox.CurrentTopIndex = selectionIndex																-- Current top index
		OptionsDisplay_Menu.ListBox.CurrentSelectedIndex = selectionIndex														-- Current selected index
	
		-- Set start index to 0	
		ListBoxHandler_SetSelected( OptionsDisplay_Menu.ListBox, selectionIndex )
		ListBoxHandler_CenterOnSelected( OptionsDisplay_Menu.ListBox )
		
	end
	
	OptionsDisplay_Menu_UpdateSliderValue();
	
end


----------------------------------------------------------------------------------------------------
-- Set Ice 

function
OptionsDisplay_Menu.S30_SetIce( _Activate )
	GDB.SetValue( "Config\\Display\\IceReflections", _Activate )
	DisplayOptions.Update()
end

-- Update Ice
function
OptionsDisplay_Menu.S30_UpdateIce( _Activate  )

	local Activate = 0
	if GDB.IsKeyValid( "Config\\Display\\IceReflections" ) then
		Activate = GDB.GetValue( "Config\\Display\\IceReflections" )
	end
	
	local HighLightFlag = 0
	
	if Activate == _Activate then
		HighLightFlag = 1
	end
	
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )

	-- check if we have to disable this button

	local Min, Max = DisplayOptions.GetHardwareMinMax_IceReflection()
	local disable = 0

	if _Activate > Max then
		disable = 1
	end

	if _Activate < Min then	
		disable = 1
	end

	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), disable )

end

----------------------------------------------------------------------------------------------------
-- Set ShadowMapSize

function
OptionsDisplay_Menu.S30_SetShadowMapSize( _Size )
	GDB.SetValue( "Config\\Display\\ShadowMapSize", _Size )
	DisplayOptions.Update()
end

-- Update ShadowMapSize
function
OptionsDisplay_Menu.S30_UpdateShadowMapSize( _Size )

	local Size = 0
	if GDB.IsKeyValid( "Config\\Display\\ShadowMapSize" ) then
		Size = GDB.GetValue( "Config\\Display\\ShadowMapSize" )
	end
	
	local HighLightFlag = 0
	
	if Size == _Size then
		HighLightFlag = 1
	end
	
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )

	-- check if we have to disable this button

	local Min, Max = DisplayOptions.GetHardwareMinMax_ShadowMapSize()
	local disable = 0

	if _Size > Max then
		disable = 1
	end

	if _Size < Min then	
		disable = 1
	end

	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), disable )
end

----------------------------------------------------------------------------------------------------
-- Set Occlusion

function
OptionsDisplay_Menu.S30_SetOcclusion( _Activate )
	GDB.SetValue( "Config\\Display\\Occlusion", _Activate )
	DisplayOptions.Update()
end

-- Update Occlusion
function
OptionsDisplay_Menu.S30_UpdateOcclusion( _Activate  )

	local Activate = 0
	if GDB.IsKeyValid( "Config\\Display\\Occlusion" ) then
		Activate = GDB.GetValue( "Config\\Display\\Occlusion" )
	end
	
	local HighLightFlag = 0
	
	if Activate == _Activate then
		HighLightFlag = 1
	end
	
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
	
	-- check if we have to disable this button

	local Min, Max = DisplayOptions.GetHardwareMinMax_OcclusionEffect()
	local disable = 0

	if _Activate > Max then
		disable = 1
	end

	if _Activate < Min then	
		disable = 1
	end

	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), disable )	
	
end

----------------------------------------------------------------------------------------------------
-- Update Terrain

function
OptionsDisplay_Menu.S30_SetTerrain( _Size )
	GDB.SetValue( "Config\\Display\\TerrainDetail", _Size )
	DisplayOptions.Update()
end

function
OptionsDisplay_Menu.S30_UpdateTerrain( _Size )

	local Size = 0
	if GDB.IsKeyValid( "Config\\Display\\TerrainDetail" ) then
		Size = GDB.GetValue( "Config\\Display\\TerrainDetail" )
	end
	
	local HighLightFlag = 0
	
	if Size == _Size then
		HighLightFlag = 1
	end
	
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
	
	-- check if we have to disable this button

	local Min, Max = DisplayOptions.GetHardwareMinMax_TerrainQuality()
	local disable = 0

	if _Size > Max then
		disable = 1
	end

	if _Size < Min then	
		disable = 1
	end

	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), disable )		
end

----------------------------------------------------------------------------------------------------
-- Update Ornamental

function
OptionsDisplay_Menu.S30_SetOrnamental( _Size )
	GDB.SetValue( "Config\\Display\\Ornamental", _Size )
	DisplayOptions.Update()
end

function
OptionsDisplay_Menu.S30_UpdateOrnamental( _Size )

	local Size = 0
	if GDB.IsKeyValid( "Config\\Display\\Ornamental" ) then
		Size = GDB.GetValue( "Config\\Display\\Ornamental" )
	end
	
	local HighLightFlag = 0
	
	if Size == _Size then
		HighLightFlag = 1
	end
	
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
	
	-- check if we have to disable this button

	local Min, Max = DisplayOptions.GetHardwareMinMax_ObjectQuality()
	local disable = 0

	if _Size > Max then
		disable = 1
	end

	if _Size < Min then	
		disable = 1
	end

	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), disable )		
	
end

----------------------------------------------------------------------------------------------------
-- Update Texture Res

function
OptionsDisplay_Menu.S30_SetTextureRes( _Size )
	GDB.SetValue( "Config\\Display\\TextureResolution", _Size )
	OptionsMenu.S31_Start()
end

function
OptionsDisplay_Menu.S30_UpdateTextureRes( _Size )

	local Size = 1
	if GDB.IsKeyValid( "Config\\Display\\TextureResolution" ) then
		Size = GDB.GetValue( "Config\\Display\\TextureResolution" )
	end
	
	local HighLightFlag = 0
	
	if Size == _Size then
		HighLightFlag = 1
	end
	
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
	
end

----------------------------------------------------------------------------------------------------
-- resolution name was cliked

function 
OptionsDisplay_Menu.OnResolution( _Index ) 
	local Index = OptionsDisplay_Menu.ListBox.CurrentTopIndex + _Index
	if Index >= 0 and Index < OptionsDisplay_Menu.ListBox.ElementsInList then
		ListBoxHandler_SetSelected( OptionsDisplay_Menu.ListBox, Index )
		GDB.SetString( "Config\\Display\\Resolution", OptionsDisplay_Menu.ResolutionTable.Array[ Index ] )
		OptionsMenu.S31_Start()
	end
end

----------------------------------------------------------------------------------------------------
-- Update resolution name 

function 
OptionsDisplay_Menu.UpdateResolution( _Index ) 

	local Index = OptionsDisplay_Menu.ListBox.CurrentTopIndex + _Index
	
	local Name = ""
	
	if Index >= 0 and Index < OptionsDisplay_Menu.ListBox.ElementsInList then
		Name = OptionsDisplay_Menu.ResolutionTable.Array[ Index ]
	end
	
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Name )
	
	local HighLightFlag = 0
	if Index == OptionsDisplay_Menu.ListBox.CurrentSelectedIndex then
		HighLightFlag = 1
	end
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
	
end

----------------------------------------------------------------------------------------------------
-- Go up in list

function OptionsDisplay_Menu.Button_Action_Up()

	OptionsDisplay_Menu.ListBox.CurrentTopIndex = OptionsDisplay_Menu.ListBox.CurrentTopIndex - 1
	ListBoxHandler_ValidateTopIndex( OptionsDisplay_Menu.ListBox )
		
	OptionsDisplay_Menu_UpdateSliderValue()
		
end

----------------------------------------------------------------------------------------------------
-- Go down in list

function OptionsDisplay_Menu.Button_Action_Down()

	OptionsDisplay_Menu.ListBox.CurrentTopIndex = OptionsDisplay_Menu.ListBox.CurrentTopIndex + 1
	ListBoxHandler_ValidateTopIndex( OptionsDisplay_Menu.ListBox )
	
	OptionsDisplay_Menu_UpdateSliderValue()
	
end

----------------------------------------------------------------------------------------------------
-- Update up button

function OptionsDisplay_Menu.Button_Update_Up()
	local DisableState = 0
	if OptionsDisplay_Menu.ListBox.CurrentTopIndex == 0 then
		DisableState = 1 
	end
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
end

----------------------------------------------------------------------------------------------------
-- Update down button

function OptionsDisplay_Menu.Button_Update_Down()
	local DisableState = 0
	if OptionsDisplay_Menu.ListBox.CurrentTopIndex >= OptionsDisplay_Menu.ListBox.ElementsInList - OptionsDisplay_Menu.ListBox.ElementsShown then
		DisableState = 1 
	end
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
end

----------------------------------------------------------------------------------------------------
-- Slider moved

function OptionsDisplay_Menu_OnSliderMoved( _Value, _WidgetID )
	local ElementsInListMinusElementsOnScreen = OptionsDisplay_Menu.ListBox.ElementsInList - OptionsDisplay_Menu.ListBox.ElementsShown
	local Index = math.floor( ( _Value * ElementsInListMinusElementsOnScreen ) / 100 )
	OptionsDisplay_Menu.ListBox.CurrentTopIndex = Index 
	ListBoxHandler_ValidateTopIndex( OptionsDisplay_Menu.ListBox )
end

----------------------------------------------------------------------------------------------------
-- Update slider value

function OptionsDisplay_Menu_UpdateSliderValue()
	local ElementsInListMinusElementsOnScreen = OptionsDisplay_Menu.ListBox.ElementsInList - OptionsDisplay_Menu.ListBox.ElementsShown
	local Value = math.ceil( ( OptionsDisplay_Menu.ListBox.CurrentTopIndex * 100 ) / ElementsInListMinusElementsOnScreen )
	XGUIEng.SetCustomScrollBarSliderValue( "OptionsMenu30_ResolutionSlider", Value )
end

----------------------------------------------------------------------------------------------------

