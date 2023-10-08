----------------------------------------------------------------------------------------------------
-- Post game menu page ids:
--
-- 20: Post game screen
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------
-- Table containing ALL post game menu stuff
PGMenu = {}


----------------------------------------------------------------------------------------------------
-- Global functions
----------------------------------------------------------------------------------------------------
-- Init data - called when main menu is created!

function PGMenu.System_InitMenuStatics()

	-- Init multi player screen ID
	PGMenu.GEN_ScreenID = 0
	
end


function PGMenu.GENUpdate()
			if PGMenu.GEN_ScreenID == 20 then
				-- Is network game 
				if 		XNetworkUbiCom ~= nil 
					and XNetworkUbiCom.Manager_DoesExist() == 1 
					and MPMenu.LastGameWasMatch == 1
				then
					-- Yeap: show chat
					XGUIEng.ShowWidget( "PGM20_ChatScreen", 1 )
					--do
					--	local Flag = 0
					--	Flag = XNetworkUbiCom.Chat_CanSend()
					--	XGUIEng.ShowWidget( "PGM20_ChatInputContainer", Flag )
					--end
					XNetworkUbiCom.Match_OutputFinalResult()
				else
					-- Nope: hide chat
					XGUIEng.ShowWidget( "PGM20_ChatScreen", 0 )
				end
			end
end


MPGame_ApplicationCallback_PGChatMessage = function(_Message, _Parameter2)
    	MPMenu.GEN_Tool_AddTextLineToWidget( "PGM20_ChatOutput", _Message, 6 )
end
----------------------------------------------------------------------------------------------------
-- Entry point

function PGMenu.Start()

	-- Where do we come from?
	do
	
		-- Get map name
		local CurrentMapName = Framework.GetCurrentMapName()
		
		-- Credits?
		if CurrentMapName == "CreditsMap" then
			StartMenu.Start( 1 )
			return
		end
		
	end
	
	
	-- To screen
	PGMenu.Screen_ToPostGame()
		
end


----------------------------------------------------------------------------------------------------
-- Screen 20 - post game screen
----------------------------------------------------------------------------------------------------

function PGMenu.Screen_ToPostGame()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "PGMenu20", 1 )
	
	-- Set screen ID
	PGMenu.GEN_ScreenID = 20
	
	-- Set up environment
	StartMenu.DoInitStuff( 1 )


	-- Is network game 
	if 		XNetworkUbiCom ~= nil 
		and XNetworkUbiCom.Manager_DoesExist() == 1 
	then
		-- Yeap: show chat
		XGUIEng.ShowWidget( "PGM20_ChatScreen", 1 )
	else
		-- Nope: hide chat
		XGUIEng.ShowWidget( "PGM20_ChatScreen", 0 )
	end
	

	-- Is Ubi.com game?
	if 		XNetworkUbiCom ~= nil 
		and XNetworkUbiCom.Manager_DoesExist() == 1 
	then
		if XNetworkUbiCom.Lobby_IsMatch() then
			-- Activate screen
			PGMenu.GEN_ScreenID = 0
			MPMenu.Screen_ToMPMenuWaitForMatchFinish()
		else
			if MPMenu.LastGameWasMatch ~= 1 then
			if XNetworkUbiCom.Lobby_State_IsInLobby() ~= 1 then
				if XNetworkUbiCom.Lobby_Game_Finish() ~= 1
				then
					MPMenu.System_ShutdownNetwork_UbiCom()
				end
			end
		end
			-- Temporarily removed - If I forgot to remove this permanently it should be okay to delete it...
			--if XNetworkUbiCom.Lobby_Group_LeaveCurrent() ~= 1
			--then
				--MPMenu.System_ShutdownNetwork_UbiCom()
			--end
		end
	end
	
end

----------------------------------------------------------------------------------------------------

function PGMenu.S20_Button_Quit()

	-- Quit post game menu
	PGMenu.GEN_ScreenID = 0
	--LuaDebugger.Break()
	
	MPMenu.GEN_Tool_ClearTextWidget( "PGM20_ChatOutput" )
	-- Shut down network here!
	MPMenu.System_ShutdownNetwork_TinCat()
	
	-- Is Ubi.com game?
	if 		XNetworkUbiCom ~= nil 
		and XNetworkUbiCom.Manager_DoesExist() == 1 
	then
		if XNetworkUbiCom.Lobby_Group_LeaveCurrent() ~= 1
		then
			--LuaDebugger.Break()
			MPMenu.System_ShutdownNetwork_UbiCom()
		end
	end
	
	-- To start menu 
	StartMenu.Start( 0 )
	
	
	-- Where do we come from?
	do
	
		-- Is Ubi.com active?
		if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
    	
    	MPMenu.Screen_ToUbiComLoggedIn(0)
    	
		else
			-- Get map type and campaign name
			local CurrentMapName = Framework.GetCurrentMapName()
			local CurrentMapType, CurrentCampaignName = Framework.GetCurrentMapTypeAndCampaignName()
			
			
			
			-- Campaign?
			if CurrentMapType == -1 then
				if CurrentCampaignName == "Main" then
					SPMenu.S00_ToCampaignMenu()
				elseif CurrentCampaignName == "Extra1" then
					SPMenu.S00_ToAOCampaignMenu()
				end
				return
			end
		end
		
	end
	
end


----------------------------------------------------------------------------------------------------
