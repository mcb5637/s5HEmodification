---------------------------------------------------------------------------------------------------
-- Globals
---------------------------------------------------------------------------------------------------
-- Load sub scripts

Script.LoadFolder("Data\\Script\\MainMenu") 


----------------------------------------------------------------------------------------------------
-- Main menu stuff
----------------------------------------------------------------------------------------------------
-- Table
LuaMainMenu = {}


----------------------------------------------------------------------------------------------------
-- Init functions
----------------------------------------------------------------------------------------------------
-- Called at program start

function
LuaMainMenu.Init()

	-- Init sub menus
	LoadMap.Init()
	LoadSaveGame.Init()
	OptionsDisplay_Menu.Init()
	OptionsSound_Menu.Init()
	OptionsControls_Menu.Init()
	MPMenu.System_InitMenuStatics()
	OptionsMenu.System_InitMenuStatics()
	PGMenu.System_InitMenuStatics()	
	
    if Framework.CheckIDV() then
		Demo_Menu.Init()
	end

	-- Play videos
	if Framework.ShouldPlayVideos() then
		Mouse.CursorHide()
		-- Filenames must be lowercase!
		Framework.PlayVideo( "videos\\start00.bik", true )
		Framework.PlayVideo( "videos\\ubisoft_logo.bik" )
		Framework.PlayVideo( "videos\\bb_logo.bik" )
		Framework.PlayVideo( "videos\\start10.bik", true )
		if Framework.CheckIDV() then
			Framework.PlayVideo( "videos\\demostartscreen.bik" )
		end
		Mouse.CursorShow()
	end
	
	-- Start main menu
	StartMenu.Start( 1 )
	
	--Input.KeyBindDown(Keys.ModifierShift + Keys.F4, 		"LuaMainMenu.AltFFour()",2)

end

----------------------------------------------------------------------------------------------------
-- Called after game ended

function
LuaMainMenu.Reinit()

	-- Stop stream
	Stream.Stop()

	-- Init save games
	LoadSaveGame.Init()
	
	-- Init controls
	OptionsControls_Menu.Init()

	-- Init Sound and display
	OptionsDisplay_Menu.Init()
	OptionsSound_Menu.Init()

	-- Start post game screen
	PGMenu.Start()
	
    if Framework.CheckIDV() then
		Demo_Menu.Init()
	end

	--Input.KeyBindDown(Keys.ModifierShift + Keys.F4, 		"KeyBindings_AltFFour()",2)

end


----------------------------------------------------------------------------------------------------
-- Global call backs
----------------------------------------------------------------------------------------------------
-- Callback that is executed to update progress bar

function
GameCallback_UpdateProgressBar()

	-- Update network
	do
	
		-- Work on base network
		do
		
			-- Update base network if existing
			if XNetwork.Manager_DoesExist() == 1 then
				if XNetwork.Manager_Update() == 0 then
					return
				end
			end
		
		end
				
				
		-- Work on Ubi.com
		do
		
			-- Update Ubi.com if existing
			if XNetworkUbiCom.Manager_DoesExist() == 1 then
				XNetworkUbiCom.Manager_Update()
			end
			
		end
		
	end	
	
end


----------------------------------------------------------------------------------------------------
--Function to end game by pressing ALT F4
function
LuaMainMenu.AltFFour()
	StartMenu.OnEndGame()
end