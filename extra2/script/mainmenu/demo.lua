----------------------------------------------------------------------------------------------------
-- Demo Menu
-- This menu shows, hides and grays out some buttons
-- and implement some extra menus
----------------------------------------------------------------------------------------------------

Demo_Menu = {}

----------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------

-- Table containing all 
Demo_Menu = {}
Demo_Menu.Maps = {}
Demo_Menu.Maps[1] = "00_Tutorial1"
Demo_Menu.Maps[2] = "DemoMap"

-- Selected map to load
Demo_Menu.LoadMapIndex = 1

----------------------------------------------------------------------------------------------------
-- Init 
----------------------------------------------------------------------------------------------------
function
Demo_Menu.Init()

	Demo_Menu.Initialized = true

	-- main menu
	--Demo_Menu.GrayButton( "StartMenu00_StartLAN", 1 )
	--Demo_Menu.GrayButton( "StartMenu00_StartOnline", 1 )
	Demo_Menu.GrayButton( "StartMenu00_StartExtra", 1 )

	-- option menus
	--Demo_Menu.GrayButton( "OptionsMenu00_ToNetwork", 1 )
	--Demo_Menu.GrayButton( "OptionsMenu10_ToNetwork", 1 )
	--Demo_Menu.GrayButton( "OptionsMenu20_ToNetwork", 1 )
	--Demo_Menu.GrayButton( "OptionsMenu30_ToNetwork", 1 )
	--Demo_Menu.GrayButton( "OptionsMenu40_ToNetwork", 1 )
	--Demo_Menu.GrayButton( "OptionsMenu50_ToNetwork", 1 )

	-- single player menus
	Demo_Menu.GrayButton( "SPM00_ToCampaignButton", 1 )	

	-- loadmap screen
	XGUIEng.ShowWidget( "SPM20_MapList", 0 )
	XGUIEng.ShowWidget( "SPM20_LoadMap", 0 )
	XGUIEng.ShowWidget( "SPM20_DemoMapList", 1 )
	XGUIEng.ShowWidget( "SPM20_DemoLoadMap", 1 )
	XGUIEng.ShowWidget( "Demo", 1 )

	-- Ubi.com - hide CD key input button
	XGUIEng.ShowWidget( "MPM50_ToEnterCDKeyButton", 0 )

	-- select the first one
	Demo_Menu.OnMapName(Demo_Menu.LoadMapIndex)

end


----------------------------------------------------------------------------------------------------
-- GrayButton
function
Demo_Menu.GrayButton( _widgetId, _state)

	XGUIEng.SetToolTipTextKeyName( _widgetId, "MainMenu/DemoToolTip" )
	XGUIEng.SetTextColor( _widgetId, 100, 100,100 )
	XGUIEng.DisableButton( _widgetId, 1 )
	XGUIEng.SetMaterialColor(_widgetId, 3, 100,100,100,255)

end

----------------------------------------------------------------------------------------------------
-- Post game screen
----------------------------------------------------------------------------------------------------

function
Demo_Menu.Button_Quit()
	Framework.ExitGame()
end


function
Demo_Menu.Visit_Ubisoftware()

    Framework.OpenDemoPostScreenUrl()

	Framework.ExitGame()
end

----------------------------------------------------------------------------------------------------
-- Load demo map
----------------------------------------------------------------------------------------------------

function
Demo_Menu.UpdateName( _number )

	local MapTitle, MapDesc = Framework.GetMapNameAndDescription( Demo_Menu.Maps[_number], 0 )
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), MapTitle)

	if Demo_Menu.LoadMapIndex == _number then
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), 1)
	else
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), 0)
	end

end

function
Demo_Menu.OnMapName( _number )

	local MapTitle, MapDesc = Framework.GetMapNameAndDescription( Demo_Menu.Maps[_number], 0 )

	-- set description and headline
	XGUIEng.SetText( "SPM20_MapTitle", MapTitle ) 
	XGUIEng.SetText( "SPM20_MapDescription", MapDesc)

	-- preview texture	
	local TextureName = Framework.GetMapPreviewMapTextureName( Demo_Menu.Maps[_number], 0)
	XGUIEng.SetMaterialTexture( "SPM20_MapPreview", 1, TextureName ) 

	Demo_Menu.LoadMapIndex = _number

end

function
Demo_Menu.LoadMap()

	Framework.StartMap( Demo_Menu.Maps[Demo_Menu.LoadMapIndex], 0 )
	LoadScreen_Init( 0, Demo_Menu.Maps[Demo_Menu.LoadMapIndex], 0 )

end

