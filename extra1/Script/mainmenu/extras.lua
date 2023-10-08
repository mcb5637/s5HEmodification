----------------------------------------------------------------------------------------------------
-- Extras menu page ids:
--
-- 00: Main options - GENERIC - NOT USED ANYMORE!!!
-- 10: 
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------
-- Table containing ALL options menu stuff
ExtrasMenu = {}


----------------------------------------------------------------------------------------------------
-- Global functions
----------------------------------------------------------------------------------------------------
-- Init data - called when main menu is created!

function 
ExtrasMenu.System_InitMenuStatics()

	-- Init screen ID - thats where we start
	ExtrasMenu.GEN_ScreenID = 0
	
end


----------------------------------------------------------------------------------------------------
-- 00 - generic
----------------------------------------------------------------------------------------------------
-- To options main menu screen - 00

function 
ExtrasMenu.S00_Start()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "ExtrasMenu00", 1 )
	
	if ExtrasMenu.GEN_ScreenID == 0 then
		ExtrasMenu.S00_Start()
	end

	-- No special videos existing
	if not Framework.SpecialVideosExisting() then
		XGUIEng.ShowWidget( "ExtrasMenu00_GCSpecial",0)
		XGUIEng.ShowWidget( "ExtrasMenu00_MakingOf",0)
	end
end

----------------------------------------------------------------------------------------------------
-- To start screen

function 
ExtrasMenu.S00_Button_ToStart()

	-- To start menu
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "StartMenu00", 1 )

	-- Set screen ID
	OptionsMenu.GEN_ScreenID = 0

end

function
ExtrasMenu.S10_StartCredits()
	
	
	Framework.StartMap( "CreditsMap", -1, "Main" )
	LoadScreen_Init( 0, "CreditsMap", -1, "Main")
	
	

end

function
ExtrasMenu.S10_StartVideo(_video)

    local Found, FilePath = Framework.GetCDPath("Videos\\".. _video)
    
    if Found then
    
    	Mouse.CursorHide()
    	Sound.PauseAll(true)
    	Framework.PlayVideo(FilePath)
    	Sound.PauseAll(false)
    	Mouse.CursorShow()
    else    
		XGUIEng.ShowWidget( "DVDNotFoundOverlayScreen", 1 )
		ExtrasMenu.LastStartedVideo = _video
    end

end

function
DVDNotFound_Button_Cancel()
	XGUIEng.ShowWidget( "DVDNotFoundOverlayScreen", 0 )
end

function
DVDNotFound_Button_TryAgain()
	XGUIEng.ShowWidget( "DVDNotFoundOverlayScreen", 0 )
	ExtrasMenu.S10_StartVideo(ExtrasMenu.LastStartedVideo)
end


function
ExtrasMenu.S10_StartVideoFromHD(_video)

    local FilePath = "Videos\\".. _video
    
	Mouse.CursorHide()
	Sound.PauseAll(true)
	Framework.PlayVideo(FilePath)
	Sound.PauseAll(false)
	Mouse.CursorShow()

end


function
ExtrasMenu.S10_UpdateVideoButtons(_MapName)


	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local GDBKeyName = 	"Game\\Campaign01\\WonMap_" .. _MapName
	
	if GDB.GetValue( GDBKeyName) == 1 then		
		XGUIEng.DisableButton(CurrentWidgetID,0)
	else
		XGUIEng.DisableButton(CurrentWidgetID,1)
	end
	
    

end

function
ExtrasMenu.S00_Button_ToGameVideos()

	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("ExtrasMenu10", 1)
end