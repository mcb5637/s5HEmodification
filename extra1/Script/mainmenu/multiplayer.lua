----------------------------------------------------------------------------------------------------
-- Multi player menu page ids:
--
-- 00: Multi player main menu screen - TO BE REMOVED!
-- 10: LAN main screen - ENTRY POINT
-- 20: Host menu screen
-- 40: Joiner joined session menu screen
--
-- 50: Ubi.com main screen - ENTRY POINT
--
-- 55: Ubi.com logging in screen
-- 60: Ubi.com lobby screen
-- 65: Ubi.com host room screen - NOT USED ANYMORE; ENHANCED SCREEN 20 TO SUPPORT UBI.COM
-- 68: Ubi.com creating room screen
-- 69: Ubi.com joining lobby screen
-- 70: Ubi.com joining room screen
-- 71: Ubi.com joined room screen - NOT USED ANYMORE; ENHANCED SCREEN 40 TO SUPPORT UBI.COM
-- 72: Ubi.com starting game screen
-- 73: Ubi.com host closing room screen
-- 74: Ubi.com waiting for match finish screen
-- 75: Ubi.com change account
-- 76: Ubi.com create/modify account
-- 77: Ubi.com enter CD key
--
-- 99: Error screen
-- t1,1001: Test 1 menu screen
----------------------------------------------------------------------------------------------------
-- DEBUG
--
-- LuaDebugger.Break()


----------------------------------------------------------------------------------------------------
-- Globals
----------------------------------------------------------------------------------------------------
-- Table containing ALL multiplayer menu stuff
MPMenu = {}


----------------------------------------------------------------------------------------------------
-- Global functions
----------------------------------------------------------------------------------------------------
-- Init data - called when main menu is created!

function 
MPMenu.System_InitMenuStatics()

	-- Init multi player screen ID
	MPMenu.GEN_ScreenID = 0
	
	-- Init MP global error message
	MPMenu.GEN_MPCriticalErrorMessage = nil
	
	-- Init Ubi.com global error message
	MPMenu.GEN_UbiComCriticalErrorMessage = nil
	
	-- Init minor Ubi.com error flag and message
	MPMenu.GEN_UbiComMinorErrorMessage = nil
	
	-- Init Ubi.com global error message
	MPMenu.GEN_UbiComUpdateMessage = nil
	
	-- Gray 
	if Framework.GetShowAutoupdate() == -1 then
		XGUIEng.ShowWidget("MPM98_Update", 0)
	end
	
end

----------------------------------------------------------------------------------------------------
-- Update

function 
MPMenu.System_UpdateNetwork()

	-- Check for global errors that could not be executed diretly
	do
		if MPMenu.GEN_UbiComUpdateMessage ~= nil then
			MPMenu.Screen_ToUpdate(MPMenu.GEN_UbiComUpdateMessage)
			MPMenu.GEN_UbiComUpdateMessage = nil
		end
		
		
		-- Global MP error set?	
		if MPMenu.GEN_MPCriticalErrorMessage ~= nil then
			MPMenu.Screen_ToError( MPMenu.GEN_MPCriticalErrorMessage )
			MPMenu.GEN_MPCriticalErrorMessage = nil
		end
	
		-- Global Ubi.com error set?
		if MPMenu.GEN_UbiComCriticalErrorMessage ~= nil then
			MPMenu.Screen_ToError( MPMenu.GEN_UbiComCriticalErrorMessage )				
			MPMenu.GEN_UbiComCriticalErrorMessage = nil
		end
		
		-- Minor Ubi.com error set?
		if MPMenu.GEN_UbiComMinorErrorMessage ~= nil then
			MPMenu.GEN_UbiComMinorErrorFlag = 1
			MPMenu.Screen_ToError( MPMenu.GEN_UbiComMinorErrorMessage )	
			MPMenu.GEN_UbiComMinorErrorMessage = nil
		end
		
	
		
	end
	
	
	-- Work on base network
	do
	
		-- Update base network if existing
		--if XNetwork.Manager_DoesExist() == 1 then
		--	if XNetwork.Manager_Update() == 0 then
		--		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorFailedToUpdateBaseNetwork" )  )
		--		return
		--	end
		--end
	
			-- Update base network if existing
		if XNetwork.Manager_DoesExist() == 1 then
			if XNetwork.Manager_Update() == 0 then
				-- Shut down TinCat first - is in error mode now
				MPMenu.System_ShutdownNetwork_TinCat()
				if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
					-- Have we lost the room?
					if 		XNetworkUbiCom.Lobby_State_IsInRoom() == 1 then
						XNetworkUbiCom.Lobby_Group_LeaveCurrent()
					end
					MPMenu.Screen_ToUbiComLoggedIn( 0 )
					return
				else
					MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorFailedToUpdateBaseNetwork" )  )
					return
				end
			end
		end
	
		-- Update base network screens
		do	
			
			-- Joiner joined server?
			if MPMenu.GEN_ScreenID == 40 then
			
				-- Client lost server?
				if MPMenu.S40_Var_ClientLostHost == 1 then
					MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorLostConnectionToHost" ) )					
				end
		
				-- Update
				MPMenu.S40_System_Update()							
				
			end
			
		end
		
		-- Update base network screens
		do	
			
			-- Joiner joined server?
			if MPMenu.GEN_ScreenID == 45 then
			
				-- Client lost server?
				if MPMenu.S45_Var_ClientLostHost == 1 then
					MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorLostConnectionToHost" ) )					
				end
		
				-- Update
				MPMenu.S45_System_Update()							
				
			end
			
		end
	
	end
			
			
	-- Work on Ubi.com
	do
		do	
			-- Logging in?
			if MPMenu.GEN_ScreenID == 55 then

				-- Log in started?
				if MPMenu.S55_Var_LogInStarted == 0 then
								
					-- Start Ubi.com
					if XNetworkUbiCom.Manager_Create() == 0 then
						MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateUbiComManager" ) )
						return
					end
					
					-- Start Ubi.com log in
					if XNetworkUbiCom.Manager_LogIn_Connect() == 0 then
						MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotConnectToUbiCom" ) )
						return
					end
					if XNetworkUbiCom.Manager_LogIn_Start() == 0 then
						MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartLogInToUbiCom" ) )
						return
					end
					
					-- Log in started
					MPMenu.S55_Var_LogInStarted = 1
					
				end
				
				-- Waiting for log in?
				if MPMenu.S55_Var_LogInStarted == 1 then
				
					-- Logged in? If so change screen
					if XNetworkUbiCom.Manager_GetState() == 4 then
						MPMenu.Screen_ToUbiComLoggedIn( 1 )
					end

					-- Error?
					if XNetworkUbiCom.Manager_GetState() == -1 and MPMenu.GEN_UbiComCriticalErrorMessage == nil and MPMenu.GEN_UbiComUpdateMessage == nil then
					  MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotLogInToUbiCom" ) )
					end
					
				end
				
			end
			
			
			-- In Ubi.com lobby?
			if MPMenu.GEN_ScreenID == 60 then
				MPMenu.S60_System_Update()							
			end
			
			-- In Ubi.com user creation?
			if MPMenu.GEN_ScreenID == 76 then
				MPMenu.S76_System_Update()			
			end
			
			
			-- In room?
			if 			MPMenu.GEN_ScreenID == 65 
					or	MPMenu.GEN_ScreenID == 70
					or	MPMenu.GEN_ScreenID == 71
					or	MPMenu.GEN_ScreenID == 20
					or	MPMenu.GEN_ScreenID == 25
					or	MPMenu.GEN_ScreenID == 40
					or	MPMenu.GEN_ScreenID == 45
			then

				-- Ubi.com existing?
			    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
				
					-- Have we lost the room?
					if 		XNetworkUbiCom.Lobby_State_IsInRoom() == 0 
						and XNetworkUbiCom.Lobby_State_IsCreatingRoom() == 0 
						and XNetworkUbiCom.Lobby_State_IsJoiningRoom() == 0 
					then
						-- todo ThHa: happens when game is started/starting and playing in 'real' internet!!! 
						-- MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorLostUbiComRoom" ) )
					end
			
				end
				
			end
			
			
			-- Creating room?
			if MPMenu.GEN_ScreenID == 68 then

				-- To host game screen when in game
				if XNetworkUbiCom.Lobby_State_IsInRoom() == 1 then

					MPMenu.Mouse_Normal()
					
					if XNetworkUbiCom.Lobby_Group_IsLadderGame(XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent())  then
						MPMenu.Screen_ToLadderHostSession()
					else
						MPMenu.Screen_ToHostSession( 1 , 0)
					end
					
				-- To error when not creating or joining
				elseif 		XNetworkUbiCom.Lobby_State_IsCreatingRoom() == 0 
						and XNetworkUbiCom.Lobby_State_IsJoiningRoom() == 0  
				then
					MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "NetworkUbiCom/ErrorCouldNotCreateRoom" ) )
				end
				
			end
				
				
			-- Joining lobby?
			if MPMenu.GEN_ScreenID == 69 then

				-- Are we in lobby now?
				if XNetworkUbiCom.Lobby_State_IsInLobby() == 1 then	
				
					-- Back to lobby screen
					MPMenu.Screen_ToUbiComLoggedIn( 0 )
					
				end
				
			end
				
				
			-- Joining room?
			if MPMenu.GEN_ScreenID == 70 then

				-- Are we in room now?
				if XNetworkUbiCom.Lobby_State_IsInRoom() == 1 then	
				
					-- Start TinCat and connect to server
					do
					
						-- Get current room, group ID
						local GroupID = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
						if GroupID < 0 then
							MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComRoomInvalid" ) )
							return
						end
			
		
						-- Create network
						if XNetwork.Manager_Create() == 0 then
							MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateBaseManager" ) )
							return
						end
						
						-- Start network - client
						XNetwork.StartUp_Network_SetServerFlag( 0 )
						if XNetwork.Manager_StartNetwork() == 0 then
							MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkClientMode" ) )
							return
						end
						
						-- Get host IP - primary address
						local IP1, IP2, IP3, IP4 = XNetworkUbiCom.Lobby_Room_GetHostIP( GroupID, 1 )
						
						-- Set server IP
						XNetwork.StartUp_Session_SetServerIP( IP1, IP2, IP3, IP4 )
								
						-- Start session
						if XNetwork.Manager_StartSession() == 0 then

							-- Primary address did not work! Try alternative!


							-- Shut down TinCat first - is in error mode now
							MPMenu.System_ShutdownNetwork_TinCat()
							
							
							-- Create network
							if XNetwork.Manager_Create() == 0 then
								MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateBaseManager" ) )
								return
							end
							
							-- Start network - client
							XNetwork.StartUp_Network_SetServerFlag( 0 )
							if XNetwork.Manager_StartNetwork() == 0 then
								MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkClientMode" ) )
								return
							end
							
							-- Get host IP - primary address
							local IP1, IP2, IP3, IP4 = XNetworkUbiCom.Lobby_Room_GetHostIP( GroupID, 2 )
							
							-- Set server IP
							XNetwork.StartUp_Session_SetServerIP( IP1, IP2, IP3, IP4 )
									
							-- Start session
							if XNetwork.Manager_StartSession() == 0 then
								MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseSessionClientMode" ) )
								return
							end

						end
						
					
						-- Connect TinCat user with Ubi.com user account
						do
							local TinCatNetworkAddress = XNetwork.Manager_GetLocalMachineNetworkAddress()
							local UbiComAccountName = XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName()
							XNetwork.UbiCom_ConnectTinCatUserWithUbiComAccount( TinCatNetworkAddress, UbiComAccountName )
						end
						
					end
				
					-- To screen			
					--MPMenu.Screen_ToUbiComJoinedRoom()
					if XNetworkUbiCom.Lobby_Group_IsLadderGame(XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()) then
						MPMenu.Screen_ToLadderJoinerJoined()
					else
						MPMenu.Screen_ToJoinerJoined()
					end
										
				end
				
			end
			
			
			-- Waiting for Ubi.com game start?
			if MPMenu.GEN_ScreenID == 72 then
			
				-- Ubi.com game started?
				if XNetworkUbiCom.Lobby_State_IsGameStarted() == 1 then
					
					-- Start game
					MPMenu.System_StartGame( MPMenu.S72_Var_MapName, MPMenu.S72_Var_MapType)
				
				end
				
			end
			
			
			-- Closing room?
			if MPMenu.GEN_ScreenID == 73 then
			
				-- Host the last one in session?
				if XNetworkUbiCom.Lobby_Group_IsOnlyLocalUserInCurrentGroup() == 1 then
				
					-- Leave current group - this closes the room
					XNetworkUbiCom.Lobby_Group_LeaveCurrent()	
					
					-- Back to lobby screen	
					MPMenu.Screen_ToUbiComLoggedIn( 0 )
					
				end
				
			end
			
			-- Closing room?
			if MPMenu.GEN_ScreenID == 74 then
			
				if XNetworkUbiCom.Lobby_IsMatch() == false then
					MPMenu.GEN_ScreenID = 0
					PGMenu.Screen_ToPostGame()
				end
				
			end
			
			
			-- Update Ubi.com active widget
			do

				-- Is ubi com active?
				local UbiComActiveFlag = 0
				if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
					UbiComActiveFlag = 1
				end
				
				-- Function to update Ubi.com active widget
				local function Update( _Screen, _UbiComActiveFlag )
					local WidgetName = "MPM" .. _Screen .. "_UbiComActive"
					local WidgetID = XGUIEng.GetWidgetID( WidgetName )
					if WidgetID ~= 0 then
					
						-- Show it
						XGUIEng.ShowWidget( WidgetID, _UbiComActiveFlag )
						
						-- Update texture
						if _UbiComActiveFlag == 1 then
							local TextureFlag = math.mod( XGUIEng.GetSystemTime() * 5, 10 )
							local TextureName = "graphics\\textures\\gui\\b_network_a.png"
							if TextureFlag > 5 then
								TextureName = "graphics\\textures\\gui\\b_network_b.png"
							end
							XGUIEng.SetMaterialTexture( WidgetID, 1, TextureName )
						end
					end
				end
				
				-- Update widget for all screens
				Update( 20, UbiComActiveFlag )
				Update( 25, UbiComActiveFlag )
				Update( 55, UbiComActiveFlag )
				Update( 60, UbiComActiveFlag )
				Update( 68, UbiComActiveFlag )
				Update( 69, UbiComActiveFlag )
				Update( 70, UbiComActiveFlag )
				Update( 72, UbiComActiveFlag )
				Update( 73, UbiComActiveFlag )
				if XNetworkUbiCom.IsLadderEnabled() == 1 then
					Update( 74, UbiComActiveFlag )
				end

			end			
						
						
		end
	
	end
	
end

----------------------------------------------------------------------------------------------------
-- Shut down network stuff

function 
MPMenu.System_ShutdownNetwork()

	-- Shut down TinCat
    MPMenu.System_ShutdownNetwork_TinCat()

	-- Shut down Ubi.com
    MPMenu.System_ShutdownNetwork_UbiCom()

end

----------------------------------------------------------------------------------------------------
-- Shut down TinCat network stuff

function 
MPMenu.System_ShutdownNetwork_TinCat()

	-- Network existing?
    if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then

		-- Stop broadcast
		XNetwork.Broadcast_Stop()
		
		-- Stop network
		XNetwork.Manager_Stop()
		
		-- Destroy network
		XNetwork.Manager_Destroy()

	end	

end

----------------------------------------------------------------------------------------------------
-- Shut down Ubi.com network stuff

function 
MPMenu.System_ShutdownNetwork_UbiCom()

	-- Ubi.com existing?
    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
    
    -- Stop Ubi.com
		XNetworkUbiCom.Manager_Destroy()

	end

end

----------------------------------------------------------------------------------------------------
-- Start TinCat server

function 
MPMenu.System_StartTinCatServer()

	-- Create network
	if XNetwork.Manager_Create() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateBaseManager" ) )
		return 0
	end
	
	
	-- Start network - server
	XNetwork.StartUp_Network_SetServerFlag( 1 )
	if XNetwork.Manager_StartNetwork() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkServerMode" ) )
		return 0
	end
	

	-- Start session
	if 		XNetwork.Manager_StartSession() == 0 
	then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseSessionServerMode" ) )
		return 0
	end
	if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
		XNetworkUbiCom.CDKey_StartAuthorization()
	end
	-- Ok
	return 1
	
end

----------------------------------------------------------------------------------------------------
-- Start game

function 
MPMenu.System_StartGame( _MapName, _MapType )

	-- Init screen ID - we are in game now!
	MPMenu.System_InitMenuStatics()

	-- Show load screen
	LoadScreen_Init( 0, _MapName, _MapType )
	
	-- Start game
	Framework.StartMultiPlayer( _MapName, _MapType)

end


----------------------------------------------------------------------------------------------------
-- Mouse to normal

function 
MPMenu.Mouse_Normal()
	Mouse.CursorSet( 10 )
end

----------------------------------------------------------------------------------------------------
-- Mouse to wait

function 
MPMenu.Mouse_Wait()
	Mouse.CursorSet( 28 )
end


----------------------------------------------------------------------------------------------------
-- General GUI functions
----------------------------------------------------------------------------------------------------
-- MP canceled

function 
MPMenu.GEN_Button_Cancel()

	-- Set mouse cursor to normal
	MPMenu.Mouse_Normal()

	-- Set screen ID
	MPMenu.System_InitMenuStatics()
	-- Shut down network
	if MPMenu.GEN_UbiComMinorErrorFlag == 1
	then
		XNetworkUbiCom.Lobby_Group_LeaveCurrent()	

		-- Back to lobby screen	
		MPMenu.Screen_ToUbiComLoggedIn( 0 )
		
		
		MPMenu.GEN_UbiComMinorErrorFlag = nil
		
	else
		MPMenu.System_ShutdownNetwork()

		
		-- To start menu
		StartMenu.Start( 0 )
	end
	
end

----------------------------------------------------------------------------------------------------
-- Update multi player

MPMenu.GEN_Update =
function()

	-- Update network
	MPMenu.System_UpdateNetwork()
	
end

----------------------------------------------------------------------------------------------------
-- Get player color - HACK!!!

function 
MPMenu.GEN_GetPlayerColor( _ColorID )

	if _ColorID == 1 then
		return 15, 64, 255
	elseif _ColorID == 2 then
		return 226, 0, 0
	elseif _ColorID == 3 then
		return 235, 209, 0
	elseif _ColorID == 4 then
		return 0, 235, 209
	elseif _ColorID == 5 then
		return 252, 164, 39
	elseif _ColorID == 6 then
		return 178, 2, 255
	elseif _ColorID == 7 then
		return 178, 176, 154
	elseif _ColorID == 8 then
		return 115, 209, 65
	elseif _ColorID == 9 then
		return 0, 140, 2
	elseif _ColorID == 10 then
		return 184, 184, 184
	elseif _ColorID == 11 then
		return 184, 182, 90
	elseif _ColorID == 12 then
		return 135, 135, 135 
	elseif _ColorID == 13 then
		return 230, 230, 230
	elseif _ColorID == 14 then
		return 57, 57, 57
	elseif _ColorID == 15 then
		return 139, 223, 255
	elseif _ColorID == 16 then
		return 255, 150, 214
	end
	
	return 0, 0, 0
	
end


--------------------------------------------------------------------------------
-- Tool to clear a text widget

function 
MPMenu.GEN_Tool_ClearTextWidget( _Name )
	if XGUIEng.IsWidgetExisting( _Name ) == 1 then
		local WidgetID = XGUIEng.GetWidgetID( _Name )
		if WidgetID ~= 0 then
			XGUIEng.SetText( WidgetID, "" )
		end
	end
end

--------------------------------------------------------------------------------
-- Tool to add a text line

function 
MPMenu.GEN_Tool_AddTextLineToWidget( _Name, _Message, _LineLimit, _ASCIIMessage )
	if XGUIEng.IsWidgetExisting( _Name ) == 1 then
		local WidgetID = XGUIEng.GetWidgetID( _Name )
		if WidgetID ~= 0 then
			XGUIEng.LimitTextLines( WidgetID, _LineLimit - 1, 1 )
			
			if _ASCIIMessage == 1 then
				XGUIEng.AddRawTextAtEnd( WidgetID, _Message, 0 )
			else
				XGUIEng.AddRawTextAtEnd( WidgetID, _Message )
			end
			
		end
	end
end


----------------------------------------------------------------------------------------------------
-- Print message to all chat widgets

function
MPMenu.GEN_Tool_PrintChatMessage( _Message, _SoundFlag )
	
	-- In multi player screen? Or in post game screen?
	if MPMenu.GEN_ScreenID ~= 0 or PGMenu.GEN_ScreenID ~= 0 then
	
		-- Message to print
		local Message = _Message .. "\n"
		
		-- Update widgets
		MPMenu.GEN_Tool_AddTextLineToWidget( "MPM20_ChatOutput", Message, 6 )
		MPMenu.GEN_Tool_AddTextLineToWidget( "MPM25_ChatOutput", Message, 6 )
		MPMenu.GEN_Tool_AddTextLineToWidget( "MPM40_ChatOutput", Message, 6 )
		MPMenu.GEN_Tool_AddTextLineToWidget( "MPM45_ChatOutput", Message, 6 )
		MPMenu.GEN_Tool_AddTextLineToWidget( "MPM65_ChatOutput", Message, 6 )
		MPMenu.GEN_Tool_AddTextLineToWidget( "MPM71_ChatOutput", Message, 6 )
		
		-- Sound
		if _SoundFlag == 1 then
			Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	
		end

	end

end

----------------------------------------------------------------------------------------------------
-- Clear all chat widgets

function
MPMenu.GEN_Tool_ClearChat()
	
	-- In multi player screen? Or in post game screen?
	if MPMenu.GEN_ScreenID ~= 0 or PGMenu.GEN_ScreenID ~= 0 then
	
		-- Update widgets
		MPMenu.GEN_Tool_ClearTextWidget( "MPM20_ChatOutput" )
		MPMenu.GEN_Tool_ClearTextWidget( "MPM25_ChatOutput" )
		MPMenu.GEN_Tool_ClearTextWidget( "MPM40_ChatOutput" )
		MPMenu.GEN_Tool_ClearTextWidget( "MPM45_ChatOutput" )
		MPMenu.GEN_Tool_ClearTextWidget( "MPM65_ChatOutput" )
		MPMenu.GEN_Tool_ClearTextWidget( "MPM71_ChatOutput" )
		
	end

end


----------------------------------------------------------------------------------------------------
-- Screen 00 - multi player main screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToMain()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu00", 1 )
	
	-- Set mouse cursor to normal
	MPMenu.Mouse_Normal()

	-- Set screen ID
	MPMenu.System_InitMenuStatics()
	
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S00_Button_ToLANMain()
	MPMenu.Screen_ToLANMain()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S00_Button_ToUbiComMain()
	MPMenu.Screen_ToUbiComMain()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S00_Button_ToT1()
	MPMenu.Screen_ToT1()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S00_Button_Back()
	MPMenu.GEN_Button_Cancel()
end



----------------------------------------------------------------------------------------------------
-- Screen 10 - multi player LAN main screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToLANMain()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu10", 1 )
	
	
	-- Create network
	if XNetwork.Manager_Create() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateBaseManager" ) )
		return
	end
	
	
	-- Start network - client
	XNetwork.StartUp_Network_SetServerFlag( 0 )
	if XNetwork.Manager_StartNetwork() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkClientMode" ) )
		return
	end
	

	-- Start broadcast
	if 		XNetwork.Broadcast_Start() == 0 
	then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkBroadcastClientMode" ) )
		return
	end
	
	
	-- Set screen ID
	MPMenu.GEN_ScreenID = 10
	
	
	-- Nothing selected yet
	MPMenu.S10_Var_SelectedServerIP1 = 0
	MPMenu.S10_Var_SelectedServerIP2 = 0
	MPMenu.S10_Var_SelectedServerIP3 = 0
	MPMenu.S10_Var_SelectedServerIP4 = 0
	MPMenu.S10_Var_SelectedServerName = ""


	-- Init list box
	do
		MPMenu.S10_Var_ListBox = nil
		MPMenu.S10_Var_ListBox = {}	
		MPMenu.S10_Var_ListBox.ElementsShown = 5					-- Elements in list box
		MPMenu.S10_Var_ListBox.ElementsInList = 20					-- Elements in list
		MPMenu.S10_Var_ListBox.CurrentTopIndex = 0					-- Current top index
		MPMenu.S10_Var_ListBox.CurrentSelectedIndex = 0				-- Current selected index
	
		-- Set start index	
		ListBoxHandler_SetSelected( MPMenu.S10_Var_ListBox, 0 )
		ListBoxHandler_CenterOnSelected( MPMenu.S10_Var_ListBox )
		MPMenu_S10_MapList_UpdateSliderValue()
	end

		
end

----------------------------------------------------------------------------------------------------
-- Host button

function 
MPMenu.S10_Button_ToHostSession()

	-- Shut down network again (we are in client mode!)
	MPMenu.System_ShutdownNetwork_TinCat()

	-- To host screen
	MPMenu.Screen_ToHostSession( 0 )
	
end

----------------------------------------------------------------------------------------------------
-- Join button

function 
MPMenu.S10_Button_JoinGame()

	-- Join server
	if MPMenu.S10_Var_SelectedServerIP1 ~= 0 then
	
		-- Stop broadcast
		XNetwork.Broadcast_Stop()
	
		-- Set server IP
		XNetwork.StartUp_Session_SetServerIP( MPMenu.S10_Var_SelectedServerIP1, MPMenu.S10_Var_SelectedServerIP2, MPMenu.S10_Var_SelectedServerIP3, MPMenu.S10_Var_SelectedServerIP4 )
				
		-- Start session
		if 		XNetwork.Manager_StartSession() == 0 
		then
			MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseSessionClientMode" ) )
			return
		end
					
		-- Joined session: change screen
		MPMenu.Screen_ToJoinerJoined()

	end		
		
end

----------------------------------------------------------------------------------------------------
-- Update game list button

function 
MPMenu.S10_Button_UpdateGameList()
	
	-- Test! Update server list does not update the server names :(
	XNetwork.Broadcast_Stop()
	XNetwork.Broadcast_Start()
	
	-- Update server list
	--XNetwork.Broadcast_Client_UpdateServerList()
	
	-- Set start index	
	ListBoxHandler_SetSelected( MPMenu.S10_Var_ListBox, 0 )
	ListBoxHandler_CenterOnSelected( MPMenu.S10_Var_ListBox )
	MPMenu_S10_MapList_UpdateSliderValue()
	
end

----------------------------------------------------------------------------------------------------
-- Session buttons

function 
MPMenu.S10_Button_SelectSession( _Index )

	-- Get session index
	local SessionIndex = _Index + MPMenu.S10_Var_ListBox.CurrentTopIndex
	
	-- Valid index?
	if SessionIndex < XNetwork.Broadcast_Client_GetNumberOfServer() then
	
		-- Get server information
		local IP1, IP2, IP3, IP4, Name = XNetwork.Broadcast_Client_GetServerInformation( SessionIndex )
		
		-- Save server information
		MPMenu.S10_Var_SelectedServerIP1 = IP1
		MPMenu.S10_Var_SelectedServerIP2 = IP2
		MPMenu.S10_Var_SelectedServerIP3 = IP3
		MPMenu.S10_Var_SelectedServerIP4 = IP4
		MPMenu.S10_Var_SelectedServerName = Name
		
	end
	
end

----------------------------------------------------------------------------------------------------
-- Back button

function 
MPMenu.S10_Button_Back()

	-- Shut down TinCat
	MPMenu.System_ShutdownNetwork_TinCat()
	
	-- Back to main screen!
	MPMenu.GEN_Button_Cancel()
	
end

----------------------------------------------------------------------------------------------------
-- Update session information widget

function MPMenu.S10_Update_SessionButton( _Index )

	-- Get session index
	local SessionIndex = _Index + MPMenu.S10_Var_ListBox.CurrentTopIndex
	
	-- Update text
	do	
		
		-- Init text	
		local Text = "@center " 
			
		-- Valid index?
		if SessionIndex < XNetwork.Broadcast_Client_GetNumberOfServer() then
		
			-- Get server information
			local IP1, IP2, IP3, IP4, Name = XNetwork.Broadcast_Client_GetServerInformation( SessionIndex )
			
			-- Print name
			--Text = Text .. Name .. "   (IP: " .. IP1 .. "." .. IP2 .. "." .. IP3 .. "." .. IP4 .. ")"
			Text = Text .. Name
	
		else
		
			-- No server
			Text = Text .. "-"
					
		end
			
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end
	

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		local HighLightFlag = 0
		
		-- Valid index?
		if SessionIndex >= XNetwork.Broadcast_Client_GetNumberOfServer() then
		
			-- Nope: disable
			DisableState = 1
			
		else
			
			-- Yes: check highlight
			
			-- Is server selected?
			if MPMenu.S10_Var_SelectedServerIP1 ~= 0 then
				local IP1, IP2, IP3, IP4, Name = XNetwork.Broadcast_Client_GetServerInformation( SessionIndex )
				if 			IP1 == MPMenu.S10_Var_SelectedServerIP1
						and	IP2 == MPMenu.S10_Var_SelectedServerIP2
						and	IP3 == MPMenu.S10_Var_SelectedServerIP3
						and	IP4 == MPMenu.S10_Var_SelectedServerIP4
				then
				
					-- Yes!
					HighLightFlag = 1
					
				end
			end
					
		end
		
		-- Enable, high light
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update session information widget

function MPMenu.S10_Update_SessionInformation()

	-- Update selected server
	do
	
		-- Server selected
		if MPMenu.S10_Var_SelectedServerIP1 ~= 0 then
		
			-- Valid?
			if XNetwork.Broadcast_Client_GetServerIndex( MPMenu.S10_Var_SelectedServerIP1, MPMenu.S10_Var_SelectedServerIP2, MPMenu.S10_Var_SelectedServerIP3, MPMenu.S10_Var_SelectedServerIP4 ) == -1 then
			
				-- Nope: invalidate
				MPMenu.S10_Var_SelectedServerIP1 = 0
				MPMenu.S10_Var_SelectedServerIP2 = 0
				MPMenu.S10_Var_SelectedServerIP3 = 0
				MPMenu.S10_Var_SelectedServerIP4 = 0
				MPMenu.S10_Var_SelectedServerName = ""
				
			end
			
		end
		
	end
	

	-- Update text
	do	
		
		-- Init text	
		local Text = "@center " 
				
		-- Server selected?
		if MPMenu.S10_Var_SelectedServerIP1 ~= 0 then
		
			-- Print name
			Text = Text .. MPMenu.S10_Var_SelectedServerName .. " - IP: " .. MPMenu.S10_Var_SelectedServerIP1 .. "." .. MPMenu.S10_Var_SelectedServerIP2 .. "." .. MPMenu.S10_Var_SelectedServerIP3 .. "." .. MPMenu.S10_Var_SelectedServerIP4

		else
		
			-- None
			Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNoServerSelected" )

		end
					
		-- Add number of server
		Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNumberOfServer" ) .. " " .. XNetwork.Broadcast_Client_GetNumberOfServer()
					
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end
	
end

----------------------------------------------------------------------------------------------------

function MPMenu.S10_Button_SessionList_Down()
	MPMenu.S10_Var_ListBox.CurrentTopIndex = MPMenu.S10_Var_ListBox.CurrentTopIndex + 1
	ListBoxHandler_ValidateTopIndex( MPMenu.S10_Var_ListBox )	
	MPMenu_S10_MapList_UpdateSliderValue()
end

----------------------------------------------------------------------------------------------------

function
MPMenu.S10_Button_SessionList_Up()
	MPMenu.S10_Var_ListBox.CurrentTopIndex = MPMenu.S10_Var_ListBox.CurrentTopIndex - 1
	ListBoxHandler_ValidateTopIndex( MPMenu.S10_Var_ListBox )
	MPMenu_S10_MapList_UpdateSliderValue()
end
	
----------------------------------------------------------------------------------------------------

function MPMenu_S10_Button_SessionList_OnSliderMoved( _Value, _WidgetID )
	local ElementsInListMinusElementsOnScreen = MPMenu.S10_Var_ListBox.ElementsInList - MPMenu.S10_Var_ListBox.ElementsShown
	local Index = math.floor( ( _Value * ElementsInListMinusElementsOnScreen ) / 100 )
	MPMenu.S10_Var_ListBox.CurrentTopIndex = Index 
	ListBoxHandler_ValidateTopIndex( MPMenu.S10_Var_ListBox )
end

----------------------------------------------------------------------------------------------------
-- Update slider value

function MPMenu_S10_MapList_UpdateSliderValue()
	local ElementsInListMinusElementsOnScreen = MPMenu.S10_Var_ListBox.ElementsInList - MPMenu.S10_Var_ListBox.ElementsShown
	local Value = math.ceil( ( MPMenu.S10_Var_ListBox.CurrentTopIndex * 100 ) / ElementsInListMinusElementsOnScreen )
	XGUIEng.SetCustomScrollBarSliderValue( "MPM10_SessionList_Slider", Value )
end




----------------------------------------------------------------------------------------------------
-- Screen 20 - multi player host menu screen
----------------------------------------------------------------------------------------------------

function MPMenu.Screen_ToHostSession( _UbiComFlag)

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu20", 1 )
	
	
	-- Start TinCat server
	if MPMenu.System_StartTinCatServer() == 0 then
		return
	end
	

	-- Start broadcast - no broadcast when doing Ubi.com!
	if _UbiComFlag == 0 then
		if XNetwork.Broadcast_Start() == 0 then
			MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkBroadcastServerMode" ) )
			return
		end
	end
	
	-- Connect TinCat user with Ubi.com user account
	if _UbiComFlag == 1 then
		local TinCatNetworkAddress = XNetwork.Manager_GetLocalMachineNetworkAddress()
		local UbiComAccountName = XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName()
		XNetwork.UbiCom_ConnectTinCatUserWithUbiComAccount( TinCatNetworkAddress, UbiComAccountName )
	end
	
	
	
	
	-- Set screen ID
	MPMenu.GEN_ScreenID = 20
	
	
	-- Init variables
	MPMenu.S20_Var_SelectedClientNetworkAddress = 0
	MPMenu.S20_Var_SubState = 1
	MPMenu.S20_Var_SelectedMapOptionsFlagSet = 0
	MPMenu.S20_Var_SessionPlayerListOffset = 0
	

	
	-- Init map table
	do
		MPMenu.S20_Var_MapTable = nil
		MPMenu.S20_Var_MapTable = {}								-- Create table
		MapListHandler_Init( MPMenu.S20_Var_MapTable )				-- Init table
		MapListHandler_AddMaps( MPMenu.S20_Var_MapTable, 2, nil, true )		-- Add multi player maps
		MapListHandler_AddMaps( MPMenu.S20_Var_MapTable, 3, nil, true )		-- Add user maps
	
		table.sort(MPMenu.S20_Var_MapTable.MapArray, LoadMap.Sort)
	end

	-- Init list box
	do
		MPMenu.S20_Var_ListBox = nil
		MPMenu.S20_Var_ListBox = {}	
		MPMenu.S20_Var_ListBox.ElementsShown = 5					-- Elements in list box
		MPMenu.S20_Var_ListBox.ElementsInList = MPMenu.S20_Var_MapTable.NumberOfMaps	-- Elements in list
		MPMenu.S20_Var_ListBox.CurrentTopIndex = 0					-- Current top index
		MPMenu.S20_Var_ListBox.CurreNtSelectedIndex = nil			-- Current selected index
	
		-- Set start index to current map	
		local MapIndex = MapListHandler_GetMapIndex( MPMenu.S20_Var_MapTable, Framework.GetCurrentMapName() )
		ListBoxHandler_SetSelected( MPMenu.S20_Var_ListBox, MapIndex )
		ListBoxHandler_CenterOnSelected( MPMenu.S20_Var_ListBox )

		-- Do select map when current map set - so network is updated as well
		if MapIndex ~= -1 then
			MPMenu.S20_Button_SelectMap( MapIndex )
			MPMenu.S20_Button_ToMapSelection()
		end
		
		-- Update map preview
		MPMenu.S20_UpdateMapPreview()
				
	end
	
	
	-- Clear chat
	MPMenu.GEN_Tool_ClearChat()
	
	
	-- Init widgets
	MPMenu.S20_Tool_UpdateSubStateWidgets()
		
end


----------------------------------------------------------------------------------------------------
-- Set state of widgets depending on sub mode

function 
MPMenu.S20_Tool_UpdateSubStateWidgets()

	-- Hide all
	do
		XGUIEng.ShowWidget( "MPM20_ToGamePlayerButton", 0 )
		XGUIEng.ShowWidget( "MPM20_PlayerInGameList", 0 )
		XGUIEng.ShowWidget( "MPM20_ToSelectMapButton", 0 )
		XGUIEng.ShowWidget( "MPM20_MapSelectionContainer", 0 )
		XGUIEng.ShowWidget( "MPM20_MapDetailsContainer", 0 )

		XGUIEng.ShowWidget( "MPM20_FreeMPMode1", 0 )
		XGUIEng.ShowWidget( "MPM20_FreeMPMode2", 0 )
		XGUIEng.ShowWidget( "MPM20_FreeMPMode3", 0 )
		
		XGUIEng.ShowWidget( "MPM20_PeaceTime0", 0 )
		XGUIEng.ShowWidget( "MPM20_PeaceTime1", 0 )
		XGUIEng.ShowWidget( "MPM20_PeaceTime2", 0 )
		XGUIEng.ShowWidget( "MPM20_PeaceTime3", 0 )
		
		XGUIEng.ShowWidget( "MPM20_FastGame", 0 )
	end
	
	
	-- Game player attachment
	if MPMenu.S20_Var_SubState == 0 then
		XGUIEng.ShowWidget( "MPM20_ToSelectMapButton", 1 )
	end
	
	
	-- Show game details
	if true then
	
		XGUIEng.ShowWidget( "MPM20_PlayerInGameList", 1 )

		-- Free mode allowed at all?
		if XNetwork.GameInformation_GetMPFreeGameModeFlag() == 1 then
		
			-- Death match
			if XNetwork.GameInformation_IsMPGameOptionsFlagSet( 2 ) == 1 then
				XGUIEng.ShowWidget( "MPM20_FreeMPMode1", 1 )
			end
			
			-- Tech race
			if XNetwork.GameInformation_IsMPGameOptionsFlagSet( 4 ) == 1 then
				XGUIEng.ShowWidget( "MPM20_FreeMPMode2", 1 )
			end
			
			-- Time game
			if XNetwork.GameInformation_IsMPGameOptionsFlagSet( 8 ) == 1 then
				XGUIEng.ShowWidget( "MPM20_FreeMPMode3", 1 )
			end
			
		end

		-- Peace time allowed?		
		if 		XNetwork.GameInformation_IsMPGameOptionsFlagSet( 16 ) == 1 
			and	XNetwork.GameInformation_GetMPFreeGameModeFlag() ~= 0 
			and	XNetwork.GameInformation_GetMPFreeGameMode() ~= 3
		then
			XGUIEng.ShowWidget( "MPM20_PeaceTime0", 1 )
			XGUIEng.ShowWidget( "MPM20_PeaceTime1", 1 )
			XGUIEng.ShowWidget( "MPM20_PeaceTime2", 1 )
			XGUIEng.ShowWidget( "MPM20_PeaceTime3", 1 )
		end
		
		-- Fast game allowed?		
		if 		XNetwork.GameInformation_IsMPGameOptionsFlagSet( 32 ) == 1 then
			XGUIEng.ShowWidget( "MPM20_FastGame", 1 )
		end
		
	end
	
	
	-- Map selection
	if MPMenu.S20_Var_SubState == 1 then
	
		-- Yeap: show map selection
		XGUIEng.ShowWidget( "MPM20_MapSelectionContainer", 1 )
		XGUIEng.ShowWidget( "MPM20_ToGamePlayerButton", 1 )
	else
	
		-- Nope: show map details when map selected
		if MPMenu.S20_Var_ListBox.CurrentSelectedIndex ~= nil then
			XGUIEng.ShowWidget( "MPM20_MapDetailsContainer", 1 )
		end
		
	end
	
end

----------------------------------------------------------------------------------------------------
-- Start game button

function 
MPMenu.S20_Button_StartGame()

	-- Can game be started (game information filled out?)
	if XNetwork.GameInformation_CanStartGame(false) == 0 then
		return
	end
	
	
	-- Start game
	if XNetwork.Host_StartGame() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorHostCouldNotStartGame" ) )
		return
	end
	
	MPMenu.LastGameWasMatch = 0
	-- Stop broadcast
	XNetwork.Broadcast_Stop()
	
end



----------------------------------------------------------------------------------------------------
-- Kick selected player button

function 
MPMenu.S20_Button_KickPlayer()

	-- Someone selected that is not the server?
	if 		MPMenu.S20_Var_SelectedClientNetworkAddress ~= 0 
		and MPMenu.S20_Var_SelectedClientNetworkAddress ~= XNetwork.Host_UserInSession_GetHostNetworkAddress() 
	then

		-- Kick!
		XNetwork.Manager_KickPlayerOutOfSession( MPMenu.S20_Var_SelectedClientNetworkAddress )
		
	end
	
end

----------------------------------------------------------------------------------------------------
-- Select game player button

function 
MPMenu.S20_Button_SelectGamePlayer( _GamePlayerSlotID )
	
	local PlayerID = _GamePlayerSlotID + 1
	
	XNetwork.GameInformation_SetLogicPlayerNetworkAddress( PlayerID, MPMenu.S20_Var_SelectedClientNetworkAddress )  
	
end

----------------------------------------------------------------------------------------------------
-- Change game player color

function 
MPMenu.S20_Button_ChangeGamePlayerColor( _GamePlayerSlotID )
	
	local PlayerID = _GamePlayerSlotID + 1

	local ColorID = XNetwork.GameInformation_GetLogicPlayerColor( PlayerID )
	
	ColorID = XNetwork.GameInformation_GetNextFreeLogicPlayerColor( ColorID )

	XNetwork.GameInformation_SetLogicPlayerColor( PlayerID, ColorID )

end

----------------------------------------------------------------------------------------------------
-- Change game player team

function 
MPMenu.S20_Button_ChangeGamePlayerTeam( _GamePlayerSlotID )
	
	local PlayerID = _GamePlayerSlotID + 1

	XNetwork.GameInformation_ToggleLogicPlayerTeam( PlayerID )
	
end

----------------------------------------------------------------------------------------------------
-- Change free mp game mode

function
MPMenu.S20_Button_ToFreeGameMode( _Mode )
	XNetwork.GameInformation_SetMPFreeGameMode( _Mode )

	if _Mode == 3 then
		XNetwork.GameInformation_SetMPPeaceTime( 0 )
	end
	
	MPMenu.S20_Tool_UpdateSubStateWidgets()
end

----------------------------------------------------------------------------------------------------
-- Set peace time

function
MPMenu.S20_Button_ToPeaceTime( _Time )
	XNetwork.GameInformation_SetMPPeaceTime( _Time )
	MPMenu.S20_Tool_UpdateSubStateWidgets()
end

----------------------------------------------------------------------------------------------------
-- Toggle fast game flag

function
MPMenu.S20_Button_ToFastGame()
	XNetwork.GameInformation_ToggleMPFastGameFlag()
	MPMenu.S20_Tool_UpdateSubStateWidgets()
end


----------------------------------------------------------------------------------------------------
-- Select session player button

function 
MPMenu.S20_Button_SelectSessionPlayer( _SessionPlayerSlotID )
	
	-- Get slot
	local SlotID = MPMenu.S20_Var_SessionPlayerListOffset + _SessionPlayerSlotID
	
	-- Get network address		
	local NetworkAddress = XNetwork.UserInSession_GetNetworkAddressByIndex( SlotID )
	
	-- Select it
	MPMenu.S20_Var_SelectedClientNetworkAddress = NetworkAddress
		
end


----------------------------------------------------------------------------------------------------
-- Session list up

function 
MPMenu.S20_Button_SessionPlayerListUp()
	MPMenu.S20_Var_SessionPlayerListOffset = MPMenu.S20_Var_SessionPlayerListOffset - 1
	if MPMenu.S20_Var_SessionPlayerListOffset < 0 then
		MPMenu.S20_Var_SessionPlayerListOffset = 0
	end
end
	
----------------------------------------------------------------------------------------------------
-- Session list down

function 
MPMenu.S20_Button_SessionPlayerListDown()
	MPMenu.S20_Var_SessionPlayerListOffset = MPMenu.S20_Var_SessionPlayerListOffset + 1
	if MPMenu.S20_Var_SessionPlayerListOffset > 20 then
		MPMenu.S20_Var_SessionPlayerListOffset = 20
	end
end
	

----------------------------------------------------------------------------------------------------
-- To map selection button

function 
MPMenu.S20_Button_ToMapSelection()
	MPMenu.S20_Var_SubState = 1
	MPMenu.S20_Tool_UpdateSubStateWidgets()
end

----------------------------------------------------------------------------------------------------
-- To game player attachment button

function 
MPMenu.S20_Button_ToGamePlayer()
	MPMenu.S20_Var_SubState = 0
	MPMenu.S20_Tool_UpdateSubStateWidgets()
end

----------------------------------------------------------------------------------------------------
-- Select map button

function 
MPMenu.S20_Button_SelectMap( _Index )

	-- Get map index
	local MapIndex = MPMenu.S20_Var_ListBox.CurrentTopIndex + _Index
	if MapIndex >= 0 and MapIndex < MPMenu.S20_Var_ListBox.ElementsInList then

		-- Set selected	
		ListBoxHandler_SetSelected( MPMenu.S20_Var_ListBox, MapIndex )

		-- Get map name and MP data
		local MapName = MPMenu.S20_Var_MapTable.MapArray[ MapIndex+1 ].Name
		local MapType = MPMenu.S20_Var_MapTable.MapArray[ MapIndex+1 ].Type
		local MPFlag, MPPlayerNumber, MPFlagSet, MapGUID = Framework.GetMapMultiplayerInformation( MapName, MapType)
		
		
		-- Select map
		XNetwork.GameInformation_SetMap( MapName, MPPlayerNumber, MPFlagSet, MapGUID, MapType)


		-- Save flag set
		MPMenu.S20_Var_SelectedMapOptionsFlagSet = MPFlagSet
		

		-- Update broadcast server name
		XNetwork.Broadcast_Update()
		
		
		-- Update preview
		MPMenu.S20_UpdateMapPreview()


		-- Back to player attachment
		MPMenu.S20_Button_ToGamePlayer()
		
		
		-- Update buttons
		MPMenu.S20_Tool_UpdateSubStateWidgets()
		
		
	end

end

----------------------------------------------------------------------------------------------------
-- Back button 

function 
MPMenu.S20_Button_Back()

	for PlayerID=1, XNetwork.GameInformation_GetLogicPlayerIDMaximum(), 1 do
			local NetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
			if NetworkAddress ~= 0 and NetworkAddress ~= XNetwork.Manager_GetLocalMachineNetworkAddress() then
				XNetwork.Manager_KickPlayerOutOfSession(PlayerID)
			end
		end
	-- Shut down TinCat
	MPMenu.System_ShutdownNetwork_TinCat()
	
	
	-- Ubi.com existing?
    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then

		-- Close room when local machine is master
		do
			local GroupID = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
			if GroupID >= 0 then
				if XNetworkUbiCom.Lobby_Group_IsLocalUserGroupMaster( GroupID ) == 1 then
					MPMenu.Screen_ToUbiComHostClosingRoom()
					return
				end
			end
		end


		-- Leave current group
		XNetworkUbiCom.Lobby_Group_LeaveCurrent()	

		-- Back to lobby screen	
		MPMenu.Screen_ToUbiComLoggedIn( 0 )

	else
	
		-- Back to LAN main screen
		MPMenu.Screen_ToLANMain()

	end
	
end

----------------------------------------------------------------------------------------------------
-- Update start game button

function 
MPMenu.S20_Update_StartGameButton()

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		
		-- Disable when game cannot be started	
		if XNetwork.GameInformation_CanStartGame(false) == 0 then
			DisableState = 1 
		end
		
		-- Enable
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
			
	end

end


----------------------------------------------------------------------------------------------------
-- Update free game mode buttons

function 
MPMenu.S20_Update_FreeGameModeButton( _Mode )

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		local HighLightFlag = 0
		
		-- Disable when mode free MP game modes allowed
		if XNetwork.GameInformation_GetMPFreeGameModeFlag() == 0 then
			DisableState = 1 
		end
		
		-- Highlight when mode selected
		if XNetwork.GameInformation_GetMPFreeGameMode() == _Mode then
			HighLightFlag = 1
		end
		
		-- Enable, high light
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update peace time

function
MPMenu.S20_Update_PeaceTimeButton( _Time )

	-- Update button state
	do	
	
		-- Init state
		local HighLightFlag = 0
				
		-- Highlight when mode selected
		if XNetwork.GameInformation_GetMPPeaceTime() == _Time then
			HighLightFlag = 1
		end
		
		-- Enable, high light
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update fast game button

function
MPMenu.S20_Update_FastGameButton()

	-- Update button state
	do	
	
		-- Init state
		local HighLightFlag = 0
				
		-- Highlight when mode selected
		if XNetwork.GameInformation_GetMPFastGameFlag() == 1 then
			HighLightFlag = 1
		end
		
		-- Enable, high light
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end
	
end

----------------------------------------------------------------------------------------------------
-- Update kick player button

function 
MPMenu.S20_Update_KickPlayerButton()

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		
		-- Disable when no player selecetd
		if 		MPMenu.S20_Var_SelectedClientNetworkAddress == 0 
			or  MPMenu.S20_Var_SelectedClientNetworkAddress == XNetwork.Host_UserInSession_GetHostNetworkAddress() 
		then
			DisableState = 1 
		end
		
		-- Enable
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update game player widget

function 
MPMenu.S20_Update_GamePlayerButton( _GamePlayerSlotID )

	-- Get parameter
	local PlayerID = _GamePlayerSlotID + 1
	local PlayerNetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
	local PlayerName = ""
	if PlayerNetworkAddress ~= 0 then
		PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
	end
			

	-- Update text
	do	

		-- Init text	
		local Text = "@center"
			
		-- Add player name
		if PlayerNetworkAddress ~= 0 then
			Text = Text .. " " .. PlayerName
		end
		
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end


	-- Update enable state
	do
	
		-- Player ID ok?
		local PlayerMaximum = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
		if PlayerID <= PlayerMaximum then
		
			-- Enable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	
		else
		
			-- Disable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	
		end
	
	end
	
end

----------------------------------------------------------------------------------------------------
-- Update game player color widget

function 
MPMenu.S20_Update_GamePlayerColorButton( _GamePlayerSlotID )

	-- Get parameter
	local PlayerID = _GamePlayerSlotID + 1

	-- Get maximum player ID
	local PlayerMaximum = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	

	-- Is server?
	local ServerFlag = 0
	if 		XNetwork ~= nil 
		and XNetwork.Manager_DoesExist() == 1 
		and XNetwork.Mode_Get() == 1 
	then
		ServerFlag = 1
	end
	

	-- Update color
	do
	
		-- Get color ID
		local ColorID = XNetwork.GameInformation_GetLogicPlayerColor( PlayerID )
		
		-- Player ID ok?
		if PlayerID > PlayerMaximum then
			ColorID = 0
		end
		
		-- Get R, G, B
		local r, g, b = MPMenu.GEN_GetPlayerColor( ColorID )
		
		-- Set color
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 0, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 1, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 2, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 3, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 4, r, g, b, 255 )
	
	end

	-- Update enable state
	do
	
		-- Player ID ok?
		if PlayerID <= PlayerMaximum and ServerFlag == 1 then
		
			-- Enable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	
		else
		
			-- Disable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	
		end
	
	end
	
	
end

----------------------------------------------------------------------------------------------------
-- Update game player team widget

function 
MPMenu.S20_Update_GamePlayerTeamButton( _GamePlayerSlotID )

	-- Get parameter
	local PlayerID = _GamePlayerSlotID + 1

	-- Get maximum player ID
	local PlayerMaximum = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	

	-- Is server?
	local ServerFlag = 0
	if 		XNetwork ~= nil 
		and XNetwork.Manager_DoesExist() == 1 
		and XNetwork.Mode_Get() == 1 
	then
		ServerFlag = 1
	end
	

	-- Update enable state
	do
	
		-- Player ID ok?
		if 		PlayerID <= PlayerMaximum 
			and XNetwork.GameInformation_GetFreeAlliancesFlag() == 1 
			and ServerFlag == 1 
		then
		
			-- Enable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	
		else
		
			-- Disable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	
		end
	
	end
	

	-- Update text
	do	

		-- Init text	
		local Text = ""
		
		-- Player ID ok AND allies allowed?
		if 		PlayerID <= PlayerMaximum 
			and XNetwork.GameInformation_GetFreeAlliancesFlag() == 1 
		then
			local TeamID = XNetwork.GameInformation_GetLogicPlayerTeam( PlayerID )
			Text = "@center " .. XGUIEng.GetStringTableText( "MainMenuMP/NameTeam" ) .. TeamID
		end
		
		--PlayerID ok AND allies not allowed
		if 	XNetwork.GameInformation_GetFreeAlliancesFlag() == 0 
		and PlayerID <= PlayerMaximum 
		then
			Text = "@center " .. XGUIEng.GetStringTableText( "MainMenuMP/FixedTeam" )
		end
							
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end
	
	
end

----------------------------------------------------------------------------------------------------
-- Update session player widget

function 
MPMenu.S20_Update_SessionPlayerButton( _SessionPlayerSlotID )

	
	-- Get slot
	local SlotID = MPMenu.S20_Var_SessionPlayerListOffset + _SessionPlayerSlotID


	-- Get network address		
	local NetworkAddress = 0
	if SlotID < XNetwork.UserInSession_GetNumber() then
		NetworkAddress = XNetwork.UserInSession_GetNetworkAddressByIndex( SlotID )
	end


	-- Init locals
	local UserName = ""
	local Ping = 0
	local ValidForGame = 0

	
	-- User on slot?
	if NetworkAddress ~= 0 then
	
		-- Get user name
		UserName = XNetwork.UserInSession_GetUserNameByNetworkAddress( NetworkAddress )
		
	
		-- Get ping
		Ping = XNetwork.Ping_Get( NetworkAddress )
		
		-- Valid user for a game?
		ValidForGame = XNetwork.UserInSession_IsNetworkAddressAValidUser( NetworkAddress )
		
	end
	

	-- Update text
	do	

		-- Init text	
		local Text = "@center " -- .. SlotID + 1 .. ": "
		
		-- Is host 
		if NetworkAddress == XNetwork.Host_UserInSession_GetHostNetworkAddress() then
			Text = Text .. "* "
		end
		
		-- Add name
		if NetworkAddress ~= 0 then
			Text = Text .. UserName
		else
			Text = Text .. "-"
		end

		
		-- Debug stuff
		if true then
		
			-- Add ping
			if Ping ~= 0 then
				Text = Text .. "     (" .. Ping .. ")"
			end
			
		end
		
					
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end
	

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		local HighLightFlag = 0
		
		-- Disable when no network address OR not valid for game
		if 		NetworkAddress == 0 
			or	ValidForGame == 0
		then
			DisableState = 1 
		end
		
		-- Highlight
		if 		NetworkAddress ~= 0 
			and NetworkAddress == MPMenu.S20_Var_SelectedClientNetworkAddress 
			and DisableState == 0
		then
			HighLightFlag = 1
		end
		
		-- Enable, high light
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update network information widget

function 
MPMenu.S20_Update_NetworkInformation()

	-- Init text	
	local Text = "@center"
	
	-- Add information
	Text = Text .. " " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNumberOfLoggedInClients" ) .. " " .. XNetwork.UserInSession_GetNumber()				
	if MPMenu.S20_Var_SelectedClientNetworkAddress ~= 0 then
	
		local UserName = XNetwork.UserInSession_GetUserNameByNetworkAddress( MPMenu.S20_Var_SelectedClientNetworkAddress )
		local UbiComAccountName = XNetwork.UserInSession_GetUbiComAccountNameByNetworkAddress( MPMenu.S20_Var_SelectedClientNetworkAddress )
		
		Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageSelectedUser" ) .. " " .. UserName
		
		if UbiComAccountName ~= "" then
			Text = Text .. " (" .. UbiComAccountName .. ")"
		end
		
	end
							
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

end

----------------------------------------------------------------------------------------------------
-- Update map button

function MPMenu.S20_Update_MapButton( _Index )

	local MapIndex = MPMenu.S20_Var_ListBox.CurrentTopIndex + _Index
	
	local Name = ""
	if MapIndex >= 0 and MapIndex < MPMenu.S20_Var_ListBox.ElementsInList then
		if MPMenu.S20_Var_MapTable.MapArray[ MapIndex+1 ].MapNameString ~= "" then
			Name = MPMenu.S20_Var_MapTable.MapArray[ MapIndex+1 ].MapNameString
		else
			Name = MPMenu.S20_Var_MapTable.MapArray[ MapIndex+1 ].Name
		end
	end
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Name )
	
	local HighLightFlag = 0
	if MapIndex == MPMenu.S20_Var_ListBox.CurrentSelectedIndex then
		HighLightFlag = 1
	end
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )

end

----------------------------------------------------------------------------------------------------
-- Go up in list

function 
MPMenu.S20_Button_Action_MapList_Up()

	MPMenu.S20_Var_ListBox.CurrentTopIndex = MPMenu.S20_Var_ListBox.CurrentTopIndex - 1
	ListBoxHandler_ValidateTopIndex( MPMenu.S20_Var_ListBox )
		
	MPMenu_S20_MapList_UpdateSliderValue()
	
end

----------------------------------------------------------------------------------------------------
-- Go down in list

function 
MPMenu.S20_Button_Action_MapList_Down()

	MPMenu.S20_Var_ListBox.CurrentTopIndex = MPMenu.S20_Var_ListBox.CurrentTopIndex + 1
	ListBoxHandler_ValidateTopIndex( MPMenu.S20_Var_ListBox )
	
	MPMenu_S20_MapList_UpdateSliderValue()
	
end

----------------------------------------------------------------------------------------------------
-- Update up button

function 
MPMenu.S20_Button_Update_MapList_Up()
	local DisableState = 0
	if MPMenu.S20_Var_ListBox.CurrentTopIndex == 0 then
		DisableState = 1 
	end
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
end

----------------------------------------------------------------------------------------------------
-- Update down button

function 
MPMenu.S20_Button_Update_MapList_Down()
	local DisableState = 0
	if MPMenu.S20_Var_ListBox.CurrentTopIndex >= MPMenu.S20_Var_ListBox.ElementsInList - MPMenu.S20_Var_ListBox.ElementsShown then
		DisableState = 1 
	end
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
end

----------------------------------------------------------------------------------------------------
-- Slider moved

function 
MPMenu_S20_MapList_OnSliderMoved( _Value, _WidgetID )
	local ElementsInListMinusElementsOnScreen = MPMenu.S20_Var_ListBox.ElementsInList - MPMenu.S20_Var_ListBox.ElementsShown
	local Index = math.floor( ( _Value * ElementsInListMinusElementsOnScreen ) / 100 )
	MPMenu.S20_Var_ListBox.CurrentTopIndex = Index 
	ListBoxHandler_ValidateTopIndex( MPMenu.S20_Var_ListBox )
end

----------------------------------------------------------------------------------------------------
-- Update slider value

function 
MPMenu_S20_MapList_UpdateSliderValue()
	local ElementsInListMinusElementsOnScreen = MPMenu.S20_Var_ListBox.ElementsInList - MPMenu.S20_Var_ListBox.ElementsShown
	local Value = math.ceil( ( MPMenu.S20_Var_ListBox.CurrentTopIndex * 100 ) / ElementsInListMinusElementsOnScreen )
	XGUIEng.SetCustomScrollBarSliderValue( "MPM20_MapNameSlider", Value )
end



----------------------------------------------------------------------------------------------------
-- Update map preview

function
MPMenu.S20_UpdateMapPreview()

	-- Any map selected?
	if MPMenu.S20_Var_ListBox.CurrentSelectedIndex == nil then
		return
	end
	

	-- Title
	do
	
		-- Get description
		local MapTitle = MPMenu.S20_Var_MapTable.MapArray[ MPMenu.S20_Var_ListBox.CurrentSelectedIndex+1 ].MapNameString
	
		-- Set text	
		XGUIEng.SetText( "MPM20_MapTitle", MapTitle )
		
	end
	
	
	-- Description
	do
	
		-- Get description
		local MapDesc = MPMenu.S20_Var_MapTable.MapArray[ MPMenu.S20_Var_ListBox.CurrentSelectedIndex+1 ].MapDescString
	
		-- Set text	
		XGUIEng.SetText( "MPM20_MapDescription", MapDesc )

	end


	-- Texture
	do
	
		-- Init name
		local TextureName = ""
		
		-- Get preview texture name
		do
			
			-- Get selected map
			local MapName = MPMenu.S20_Var_MapTable.MapArray[ MPMenu.S20_Var_ListBox.CurrentSelectedIndex+1 ].Name
			local MapType = MPMenu.S20_Var_MapTable.MapArray[ MPMenu.S20_Var_ListBox.CurrentSelectedIndex+1 ].Type
			local MapIndex = MPMenu.S20_Var_MapTable.MapArray[ MPMenu.S20_Var_ListBox.CurrentSelectedIndex+1 ].CampaignIndex
			
			-- Get texture name
			TextureName = Framework.GetMapPreviewMapTextureName( MapName, MapType, MapIndex )
			
		end
		
		-- Set texture
		XGUIEng.SetMaterialTexture( "MPM20_MapPreview", 1, TextureName )

	end

end

----------------------------------------------------------------------------------------------------
-- Screen 25 - multi player host menu screen
----------------------------------------------------------------------------------------------------

function MPMenu.Screen_ToLadderHostSession( )

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu25", 1 )
	
	
	-- Start TinCat server
	if MPMenu.System_StartTinCatServer() == 0 then
		return
	end
	
	MPMenu.S25_Var_GameStarted = 0

	-- Connect TinCat user with Ubi.com user account
	
	local TinCatNetworkAddress = XNetwork.Manager_GetLocalMachineNetworkAddress()
	local UbiComAccountName = XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName()
	XNetwork.UbiCom_ConnectTinCatUserWithUbiComAccount( TinCatNetworkAddress, UbiComAccountName )
	
	
	
	
	-- Set screen ID
	MPMenu.GEN_ScreenID = 25
	
	
	-- Init variables
	MPMenu.S25_Var_SelectedClientNetworkAddress = 0
	MPMenu.S25_Var_SubState = 1
	MPMenu.S25_Var_SelectedMapOptionsFlagSet = 0
	MPMenu.S25_Var_SessionPlayerListOffset = 0
	

	
	-- Init map table
	do
		MPMenu.S25_Var_MapTable = nil
		MPMenu.S25_Var_MapTable = {}								-- Create table
		MapListHandler_Init( MPMenu.S25_Var_MapTable )				-- Init table
		MapListHandler_AddMaps( MPMenu.S25_Var_MapTable, 2, nil, true, true )		-- Add multi player maps
	
		table.sort(MPMenu.S25_Var_MapTable.MapArray, LoadMap.Sort)
	end

	-- Init list box
	do
		MPMenu.S25_Var_ListBox = nil
		MPMenu.S25_Var_ListBox = {}	
		MPMenu.S25_Var_ListBox.ElementsShown = 5					-- Elements in list box
		MPMenu.S25_Var_ListBox.ElementsInList = MPMenu.S25_Var_MapTable.NumberOfMaps	-- Elements in list
		MPMenu.S25_Var_ListBox.CurrentTopIndex = 0					-- Current top index
		MPMenu.S25_Var_ListBox.CurreNtSelectedIndex = nil			-- Current selected index
	
		-- Set start index to current map	
		local MapIndex = MapListHandler_GetMapIndex( MPMenu.S25_Var_MapTable, Framework.GetCurrentMapName() )
		ListBoxHandler_SetSelected( MPMenu.S25_Var_ListBox, MapIndex )
		ListBoxHandler_CenterOnSelected( MPMenu.S25_Var_ListBox )

		-- Do select map when current map set - so network is updated as well
		if MapIndex ~= -1 then
			MPMenu.S25_Button_SelectMap( MapIndex )
			MPMenu.S25_Button_ToMapSelection()
		end
		
		-- Update map preview
		MPMenu.S25_UpdateMapPreview()
				
	end
	
	
	-- Clear chat
	MPMenu.GEN_Tool_ClearChat()
	
	
	-- Init widgets
	MPMenu.S25_Tool_UpdateSubStateWidgets()
		
end


----------------------------------------------------------------------------------------------------
-- Set state of widgets depending on sub mode

function 
MPMenu.S25_Tool_UpdateSubStateWidgets()

	-- Hide all
	do
		XGUIEng.ShowWidget( "MPM25_ToGamePlayerButton", 0 )
		XGUIEng.ShowWidget( "MPM25_PlayerInGameList", 0 )
		XGUIEng.ShowWidget( "MPM25_ToSelectMapButton", 0 )
		XGUIEng.ShowWidget( "MPM25_MapSelectionContainer", 0 )
		XGUIEng.ShowWidget( "MPM25_MapDetailsContainer", 0 )

		XGUIEng.ShowWidget( "MPM25_FastGame", 0 )
	end
	
	
	-- Game player attachment
	if MPMenu.S25_Var_SubState == 0 then
		XGUIEng.ShowWidget( "MPM25_ToSelectMapButton", 1 )
	end
	
	
	-- Show game details
	if true then
	
		XGUIEng.ShowWidget( "MPM25_PlayerInGameList", 1 )
		
		-- Fast game allowed?		
		if 		XNetwork.GameInformation_IsMPGameOptionsFlagSet( 32 ) == 1 then
			XGUIEng.ShowWidget( "MPM25_FastGame", 1 )
		end
		
	end
	
	
	-- Map selection
	if MPMenu.S25_Var_SubState == 1 then
	
		-- Yeap: show map selection
		XGUIEng.ShowWidget( "MPM25_MapSelectionContainer", 1 )
		XGUIEng.ShowWidget( "MPM25_ToGamePlayerButton", 1 )
	else
	
		-- Nope: show map details when map selected
		if MPMenu.S25_Var_ListBox.CurrentSelectedIndex ~= nil then
			XGUIEng.ShowWidget( "MPM25_MapDetailsContainer", 1 )
		end
		
	end
	
end


----------------------------------------------------------------------------------------------------
-- Start game button

function 
MPMenu.S25_Button_StartGame()

	-- Can game be started (game information filled out?)
	if XNetwork.GameInformation_CanStartGame(true) == 0 then
		return
	end
	
	MPMenu.S25_Var_GameStarted = 1
	
	NrOfPlayers = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	if NrOfPlayers == 2 then
		XNetworkUbiCom.Lobby_SetInitialMatchInfo(1, 1)
	elseif NrOfPlayers == 4 then 
		XNetworkUbiCom.Lobby_SetInitialMatchInfo(1, 2)
	else
		return
	end
	MPMenu.LastGameWasMatch = 1
	
	-- Start game
	if XNetwork.Host_StartGame() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorHostCouldNotStartGame" ) )
		return
	end
	
	-- Stop broadcast
	XNetwork.Broadcast_Stop()
	
end


----------------------------------------------------------------------------------------------------
-- Kick selected player button

function 
MPMenu.S25_Button_KickPlayer()

	-- Someone selected that is not the server?
	if 		MPMenu.S25_Var_SelectedClientNetworkAddress ~= 0 
		and MPMenu.S25_Var_SelectedClientNetworkAddress ~= XNetwork.Host_UserInSession_GetHostNetworkAddress() 
		and MPMenu.S25_Var_GameStarted == 0
	then

		-- Kick!
		XNetwork.Manager_KickPlayerOutOfSession( MPMenu.S25_Var_SelectedClientNetworkAddress )
		
	end
	
end

----------------------------------------------------------------------------------------------------
-- Select game player button

function 
MPMenu.S25_Button_SelectGamePlayer( _GamePlayerSlotID )
	
	local PlayerID = _GamePlayerSlotID + 1
	
	XNetwork.GameInformation_SetLogicPlayerNetworkAddress( PlayerID, MPMenu.S25_Var_SelectedClientNetworkAddress )  
	
end

----------------------------------------------------------------------------------------------------
-- Change game player color

function 
MPMenu.S25_Button_ChangeGamePlayerColor( _GamePlayerSlotID )
	
	local PlayerID = _GamePlayerSlotID + 1

	local ColorID = XNetwork.GameInformation_GetLogicPlayerColor( PlayerID )
	
	ColorID = XNetwork.GameInformation_GetNextFreeLogicPlayerColor( ColorID )

	XNetwork.GameInformation_SetLogicPlayerColor( PlayerID, ColorID )

end

----------------------------------------------------------------------------------------------------
-- Change game player team

function 
MPMenu.S25_Button_ChangeGamePlayerTeam( _GamePlayerSlotID )
	
	local PlayerID = _GamePlayerSlotID + 1

	XNetwork.GameInformation_ToggleLogicPlayerTeam( PlayerID )
	
end

-----------------------------------------------------------------------------------------------
-- Toggle fast game flag

function
MPMenu.S25_Button_ToFastGame()
	XNetwork.GameInformation_ToggleMPFastGameFlag()
	MPMenu.S25_Tool_UpdateSubStateWidgets()
end


----------------------------------------------------------------------------------------------------
-- Select session player button

function 
MPMenu.S25_Button_SelectSessionPlayer( _SessionPlayerSlotID )
	
	-- Get slot
	local SlotID = MPMenu.S25_Var_SessionPlayerListOffset + _SessionPlayerSlotID
	
	-- Get network address		
	local NetworkAddress = XNetwork.UserInSession_GetNetworkAddressByIndex( SlotID )
	
	-- Select it
	MPMenu.S25_Var_SelectedClientNetworkAddress = NetworkAddress
		
end


----------------------------------------------------------------------------------------------------
-- Session list up

function 
MPMenu.S25_Button_SessionPlayerListUp()
	MPMenu.S25_Var_SessionPlayerListOffset = MPMenu.S25_Var_SessionPlayerListOffset - 1
	if MPMenu.S25_Var_SessionPlayerListOffset < 0 then
		MPMenu.S25_Var_SessionPlayerListOffset = 0
	end
end
	
----------------------------------------------------------------------------------------------------
-- Session list down

function 
MPMenu.S25_Button_SessionPlayerListDown()
	MPMenu.S25_Var_SessionPlayerListOffset = MPMenu.S25_Var_SessionPlayerListOffset + 1
	if MPMenu.S25_Var_SessionPlayerListOffset > 25 then
		MPMenu.S25_Var_SessionPlayerListOffset = 25
	end
end
	

----------------------------------------------------------------------------------------------------
-- To map selection button

function 
MPMenu.S25_Button_ToMapSelection()
	MPMenu.S25_Var_SubState = 1
	MPMenu.S25_Tool_UpdateSubStateWidgets()
end

----------------------------------------------------------------------------------------------------
-- To game player attachment button

function 
MPMenu.S25_Button_ToGamePlayer()
	MPMenu.S25_Var_SubState = 0
	MPMenu.S25_Tool_UpdateSubStateWidgets()
end

----------------------------------------------------------------------------------------------------
-- Select map button

function 
MPMenu.S25_Button_SelectMap( _Index )

	-- Get map index
	local MapIndex = MPMenu.S25_Var_ListBox.CurrentTopIndex + _Index
	if MapIndex >= 0 and MapIndex < MPMenu.S25_Var_ListBox.ElementsInList then

		-- Set selected	
		ListBoxHandler_SetSelected( MPMenu.S25_Var_ListBox, MapIndex )

		-- Get map name and MP data
		local MapName = MPMenu.S25_Var_MapTable.MapArray[ MapIndex+1 ].Name
		local MapType = MPMenu.S25_Var_MapTable.MapArray[ MapIndex+1 ].Type
		local MPFlag, MPPlayerNumber, MPFlagSet, MapGUID = Framework.GetMapMultiplayerInformation( MapName, MapType)
		
		
		-- Select map
		XNetwork.GameInformation_SetMap( MapName, MPPlayerNumber, MPFlagSet, MapGUID, MapType)


		-- Save flag set
		MPMenu.S25_Var_SelectedMapOptionsFlagSet = MPFlagSet
		

		-- Update broadcast server name
		XNetwork.Broadcast_Update()
		
		
		-- Update preview
		MPMenu.S25_UpdateMapPreview()


		-- Back to player attachment
		MPMenu.S25_Button_ToGamePlayer()
		
		XNetwork.GameInformation_HostSetStaticNumberOfTeams(2)
		
		-- Update buttons
		MPMenu.S25_Tool_UpdateSubStateWidgets()
		
		
	end

end

----------------------------------------------------------------------------------------------------
-- Back button 

function 
MPMenu.S25_Button_Back()

	for PlayerID=1, XNetwork.GameInformation_GetLogicPlayerIDMaximum(), 1 do
			local NetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
			if NetworkAddress ~= 0 and NetworkAddress ~= XNetwork.Manager_GetLocalMachineNetworkAddress() then
				XNetwork.Manager_KickPlayerOutOfSession(PlayerID)
			end
		end
	-- Shut down TinCat
	MPMenu.System_ShutdownNetwork_TinCat()
	
	
	-- Ubi.com existing?
    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then

		-- Close room when local machine is master
		do
			local GroupID = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
			if GroupID >= 0 then
				if XNetworkUbiCom.Lobby_Group_IsLocalUserGroupMaster( GroupID ) == 1 then
					MPMenu.Screen_ToUbiComHostClosingRoom()
					return
				end
			end
		end


		-- Leave current group
		XNetworkUbiCom.Lobby_Group_LeaveCurrent()	

		-- Back to lobby screen	
		MPMenu.Screen_ToUbiComLoggedIn( 0 )

	else
	
		-- Back to LAN main screen
		MPMenu.Screen_ToLANMain()

	end
	
end


----------------------------------------------------------------------------------------------------
-- Update start game button

function 
MPMenu.S25_Update_StartGameButton()

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		
		-- Disable when game cannot be started		
		if XNetwork.GameInformation_CanStartGame(true) == 0 then
			DisableState = 1 
		end
		
		-- Enable
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
			
	end

end


----------------------------------------------------------------------------------------------------
-- Update fast game button

function
MPMenu.S25_Update_FastGameButton()

	-- Update button state
	do	
	
		-- Init state
		local HighLightFlag = 0
				
		-- Highlight when mode selected
		if XNetwork.GameInformation_GetMPFastGameFlag() == 1 then
			HighLightFlag = 1
		end
		
		-- Enable, high light
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end
	
end

----------------------------------------------------------------------------------------------------
-- Update kick player button

function 
MPMenu.S25_Update_KickPlayerButton()

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		
		-- Disable when no player selecetd
		if 		MPMenu.S25_Var_SelectedClientNetworkAddress == 0 
			or  MPMenu.S25_Var_SelectedClientNetworkAddress == XNetwork.Host_UserInSession_GetHostNetworkAddress() 
			or  MPMenu.S25_Var_GameStarted == 1
		then
			DisableState = 1 
		end
		
		-- Enable
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update game player widget

function 
MPMenu.S25_Update_GamePlayerButton( _GamePlayerSlotID )

	-- Get parameter
	local PlayerID = _GamePlayerSlotID + 1
	local PlayerNetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
	local PlayerName = ""
	if PlayerNetworkAddress ~= 0 then
		PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
	end
			
	
	-- Update text
	do	

		-- Init text	
		local Text = "@center"
			
		-- Add player name
		if PlayerNetworkAddress ~= 0 then
			Text = Text .. " " .. PlayerName
		end
		
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end


	-- Update enable state
	do
	
		-- Player ID ok?
		local PlayerMaximum = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
		if PlayerID <= PlayerMaximum then
		
			-- Enable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	
		else
		
			-- Disable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	
		end
	
	end
	
end

----------------------------------------------------------------------------------------------------
-- Update game player color widget

function 
MPMenu.S25_Update_GamePlayerColorButton( _GamePlayerSlotID )

	-- Get parameter
	local PlayerID = _GamePlayerSlotID + 1

	-- Get maximum player ID
	local PlayerMaximum = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	

	-- Is server?
	local ServerFlag = 0
	if 		XNetwork ~= nil 
		and XNetwork.Manager_DoesExist() == 1 
		and XNetwork.Mode_Get() == 1 
	then
		ServerFlag = 1
	end
	

	-- Update color
	do
	
		-- Get color ID
		local ColorID = XNetwork.GameInformation_GetLogicPlayerColor( PlayerID )
		
		-- Player ID ok?
		if PlayerID > PlayerMaximum then
			ColorID = 0
		end
		
		-- Get R, G, B
		local r, g, b = MPMenu.GEN_GetPlayerColor( ColorID )
		
		-- Set color
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 0, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 1, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 2, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 3, r, g, b, 255 )
		XGUIEng.SetMaterialColor( XGUIEng.GetCurrentWidgetID(), 4, r, g, b, 255 )
	
	end

	-- Update enable state
	do
	
		-- Player ID ok?
		if PlayerID <= PlayerMaximum and ServerFlag == 1 then
		
			-- Enable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	
		else
		
			-- Disable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	
		end
	
	end
	
	
end

----------------------------------------------------------------------------------------------------
-- Update game player team widget

function 
MPMenu.S25_Update_GamePlayerTeamButton( _GamePlayerSlotID )

	-- Get parameter
	local PlayerID = _GamePlayerSlotID + 1

	-- Get maximum player ID
	local PlayerMaximum = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
	

	-- Is server?
	local ServerFlag = 0
	if 		XNetwork ~= nil 
		and XNetwork.Manager_DoesExist() == 1 
		and XNetwork.Mode_Get() == 1 
	then
		ServerFlag = 1
	end
	

	-- Update enable state
	do
	
		-- Player ID ok?
		if 		PlayerID <= PlayerMaximum 
			and XNetwork.GameInformation_GetFreeAlliancesFlag() == 1 
			and ServerFlag == 1 
		then
		
			-- Enable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 0 )
	
		else
		
			-- Disable
			XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), 1 )
	
		end
	
	end
	

	-- Update text
	do	

		-- Init text	
		local Text = ""
		
		-- Player ID ok AND allies allowed?
		if 		PlayerID <= PlayerMaximum 
			and XNetwork.GameInformation_GetFreeAlliancesFlag() == 1 
		then
			local TeamID = XNetwork.GameInformation_GetLogicPlayerTeam( PlayerID )
			Text = "@center " .. XGUIEng.GetStringTableText( "MainMenuMP/NameTeam" ) .. TeamID
		end
							
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end
	
	
end

----------------------------------------------------------------------------------------------------
-- Update session player widget

function 
MPMenu.S25_Update_SessionPlayerButton( _SessionPlayerSlotID )

	
	-- Get slot
	local SlotID = MPMenu.S25_Var_SessionPlayerListOffset + _SessionPlayerSlotID


	-- Get network address		
	local NetworkAddress = 0
	if SlotID < XNetwork.UserInSession_GetNumber() then
		NetworkAddress = XNetwork.UserInSession_GetNetworkAddressByIndex( SlotID )
	end


	-- Init locals
	local UserName = ""
	local Ping = 0
	local ValidForGame = 0

	
	-- User on slot?
	if NetworkAddress ~= 0 then
	
		-- Get user name
		UserName = XNetwork.UserInSession_GetUserNameByNetworkAddress( NetworkAddress )
		
	
		-- Get ping
		Ping = XNetwork.Ping_Get( NetworkAddress )
		
		-- Valid user for a game?
		ValidForGame = XNetwork.UserInSession_IsNetworkAddressAValidUser( NetworkAddress )
		
	end
	

	-- Update text
	do	

		-- Init text	
		local Text = "@center " -- .. SlotID + 1 .. ": "
		
		-- Is host 
		if NetworkAddress == XNetwork.Host_UserInSession_GetHostNetworkAddress() then
			Text = Text .. "* "
		end
		
		-- Add name
		if NetworkAddress ~= 0 then
			Text = Text .. UserName
		else
			Text = Text .. "-"
		end

		
		-- Debug stuff
		if true then
		
			-- Add ping
			if Ping ~= 0 then
				Text = Text .. "     (" .. Ping .. ")"
			end
			
		end
		
					
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end
	

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		local HighLightFlag = 0
		
		-- Disable when no network address OR not valid for game
		if 		NetworkAddress == 0 
			or	ValidForGame == 0
		then
			DisableState = 1 
		end
		
		-- Highlight
		if 		NetworkAddress ~= 0 
			and NetworkAddress == MPMenu.S25_Var_SelectedClientNetworkAddress 
			and DisableState == 0
		then
			HighLightFlag = 1
		end
		
		-- Enable, high light
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update network information widget

function 
MPMenu.S25_Update_NetworkInformation()

	-- Init text	
	local Text = "@center"
	
	-- Add information
	Text = Text .. " " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNumberOfLoggedInClients" ) .. " " .. XNetwork.UserInSession_GetNumber()				
	if MPMenu.S25_Var_SelectedClientNetworkAddress ~= 0 then
	
		local UserName = XNetwork.UserInSession_GetUserNameByNetworkAddress( MPMenu.S25_Var_SelectedClientNetworkAddress )
		local UbiComAccountName = XNetwork.UserInSession_GetUbiComAccountNameByNetworkAddress( MPMenu.S25_Var_SelectedClientNetworkAddress )
		
		Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageSelectedUser" ) .. " " .. UserName
		
		if UbiComAccountName ~= "" then
			Text = Text .. " (" .. UbiComAccountName .. ")"
		end
		
	end
							
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

end

----------------------------------------------------------------------------------------------------
-- Update map button

function MPMenu.S25_Update_MapButton( _Index )

	local MapIndex = MPMenu.S25_Var_ListBox.CurrentTopIndex + _Index
	
	local Name = ""
	if MapIndex >= 0 and MapIndex < MPMenu.S25_Var_ListBox.ElementsInList then
		if MPMenu.S25_Var_MapTable.MapArray[ MapIndex+1 ].MapNameString ~= "" then
			Name = MPMenu.S25_Var_MapTable.MapArray[ MapIndex+1 ].MapNameString
		else
			Name = MPMenu.S25_Var_MapTable.MapArray[ MapIndex+1 ].Name
		end
	end
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Name )
	
	local HighLightFlag = 0
	if MapIndex == MPMenu.S25_Var_ListBox.CurrentSelectedIndex then
		HighLightFlag = 1
	end
	XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )

end

----------------------------------------------------------------------------------------------------
-- Go up in list

function 
MPMenu.S25_Button_Action_MapList_Up()

	MPMenu.S25_Var_ListBox.CurrentTopIndex = MPMenu.S25_Var_ListBox.CurrentTopIndex - 1
	ListBoxHandler_ValidateTopIndex( MPMenu.S25_Var_ListBox )
		
	MPMenu_S25_MapList_UpdateSliderValue()
	
end

----------------------------------------------------------------------------------------------------
-- Go down in list

function 
MPMenu.S25_Button_Action_MapList_Down()

	MPMenu.S25_Var_ListBox.CurrentTopIndex = MPMenu.S25_Var_ListBox.CurrentTopIndex + 1
	ListBoxHandler_ValidateTopIndex( MPMenu.S25_Var_ListBox )
	
	MPMenu_S25_MapList_UpdateSliderValue()
	
end

----------------------------------------------------------------------------------------------------
-- Update up button

function 
MPMenu.S25_Button_Update_MapList_Up()
	local DisableState = 0
	if MPMenu.S25_Var_ListBox.CurrentTopIndex == 0 then
		DisableState = 1 
	end
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
end

----------------------------------------------------------------------------------------------------
-- Update down button

function 
MPMenu.S25_Button_Update_MapList_Down()
	local DisableState = 0
	if MPMenu.S25_Var_ListBox.CurrentTopIndex >= MPMenu.S25_Var_ListBox.ElementsInList - MPMenu.S25_Var_ListBox.ElementsShown then
		DisableState = 1 
	end
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
end

----------------------------------------------------------------------------------------------------
-- Slider moved

function 
MPMenu_S25_MapList_OnSliderMoved( _Value, _WidgetID )
	local ElementsInListMinusElementsOnScreen = MPMenu.S25_Var_ListBox.ElementsInList - MPMenu.S25_Var_ListBox.ElementsShown
	local Index = math.floor( ( _Value * ElementsInListMinusElementsOnScreen ) / 100 )
	MPMenu.S25_Var_ListBox.CurrentTopIndex = Index 
	ListBoxHandler_ValidateTopIndex( MPMenu.S25_Var_ListBox )
end

----------------------------------------------------------------------------------------------------
-- Update slider value

function 
MPMenu_S25_MapList_UpdateSliderValue()
	local ElementsInListMinusElementsOnScreen = MPMenu.S25_Var_ListBox.ElementsInList - MPMenu.S25_Var_ListBox.ElementsShown
	local Value = math.ceil( ( MPMenu.S25_Var_ListBox.CurrentTopIndex * 100 ) / ElementsInListMinusElementsOnScreen )
	XGUIEng.SetCustomScrollBarSliderValue( "MPM25_MapNameSlider", Value )
end



----------------------------------------------------------------------------------------------------
-- Update map preview

function
MPMenu.S25_UpdateMapPreview()

	-- Any map selected?
	if MPMenu.S25_Var_ListBox.CurrentSelectedIndex == nil then
		return
	end
	

	-- Title
	do
	
		-- Get description
		local MapTitle = MPMenu.S25_Var_MapTable.MapArray[ MPMenu.S25_Var_ListBox.CurrentSelectedIndex+1 ].MapNameString
	
		-- Set text	
		XGUIEng.SetText( "MPM25_MapTitle", MapTitle )
		
	end
	
	
	-- Description
	do
	
		-- Get description
		local MapDesc = MPMenu.S25_Var_MapTable.MapArray[ MPMenu.S25_Var_ListBox.CurrentSelectedIndex+1 ].MapDescString
	
		-- Set text	
		XGUIEng.SetText( "MPM25_MapDescription", MapDesc )

	end


	-- Texture
	do
	
		-- Init name
		local TextureName = ""
		
		-- Get preview texture name
		do
			
			-- Get selected map
			local MapName = MPMenu.S25_Var_MapTable.MapArray[ MPMenu.S25_Var_ListBox.CurrentSelectedIndex+1 ].Name
			local MapType = MPMenu.S25_Var_MapTable.MapArray[ MPMenu.S25_Var_ListBox.CurrentSelectedIndex+1 ].Type
			local MapIndex = MPMenu.S25_Var_MapTable.MapArray[ MPMenu.S25_Var_ListBox.CurrentSelectedIndex+1 ].CampaignIndex
			
			-- Get texture name
			TextureName = Framework.GetMapPreviewMapTextureName( MapName, MapType, MapIndex )
			
		end
		
		-- Set texture
		XGUIEng.SetMaterialTexture( "MPM25_MapPreview", 1, TextureName )

	end

end

----------------------------------------------------------------------------------------------------
-- Screen 40 - multi player joiner joined session menu screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToJoinerJoined()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu40", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 40
	
	-- Init variables
	MPMenu.S40_Var_ClientLostHost = 0

	-- Mouse normal
	MPMenu.Mouse_Normal()
	
	-- Update map preview
	MPMenu.S40_Var_CurrentMapName = nil
	MPMenu.S40_UpdateMapPreview()
	
	-- Clear chat
	MPMenu.GEN_Tool_ClearChat()
	
end

----------------------------------------------------------------------------------------------------
-- Back button

function 
MPMenu.S40_Button_Back()

	-- Shut down TinCat
	MPMenu.System_ShutdownNetwork_TinCat()
	
	
	-- Ubi.com existing?
    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
    
		-- Leave current group
		XNetworkUbiCom.Lobby_Group_LeaveCurrent()
			
		-- Back to Ubi.com lobby screen	
		MPMenu.Screen_ToUbiComLoggedIn( 0 )

    else
    
		-- Back to LAN main screen
		MPMenu.Screen_ToLANMain()
	
	end
		
end


----------------------------------------------------------------------------------------------------
-- Update

function
MPMenu.S40_System_Update()
	MPMenu.S40_UpdateMapPreview()
end

----------------------------------------------------------------------------------------------------
-- Update map preview

function
MPMenu.S40_UpdateMapPreview()


	-- Get map name
	local MapName = XNetwork.GameInformation_GetMapName()
	
	-- Get map type
	local MapType = XNetwork.GameInformation_GetMapType()
	

	-- Map changed?
	if MapName == MPMenu.S40_Var_CurrentMapName then
		return
	end
	MPMenu.S40_Var_CurrentMapName = MapName


	-- Any map?
	if MapName == "" then
		XGUIEng.ShowWidget( "MPM40_MapDetailsContainer", 0 )
		return
	else
		XGUIEng.ShowWidget( "MPM40_MapDetailsContainer", 1 )
	end
	
	
	-- Get map data
	local MapTitle, MapDesc = Framework.GetMapNameAndDescription( MapName, MapType )
	local TextureName = Framework.GetMapPreviewMapTextureName( MapName, MapType )
		
	-- Title
	XGUIEng.SetText( "MPM40_MapTitle", MapTitle )
	
	-- Description
	XGUIEng.SetText( "MPM40_MapDescription", MapDesc )

	-- Set texture
	XGUIEng.SetMaterialTexture( "MPM40_MapPreview", 1, TextureName )

end

----------------------------------------------------------------------------------------------------
-- Update game information widget function

function 
MPMenu.S40_Update_PlayerInSessionInfo()

	local Text = XNetwork.Manager_GetUserInSessionInfoString()
	
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

end


----------------------------------------------------------------------------------------------------
-- Update game information widget function

function 
MPMenu.S40_Update_GameInformation()

	-- Init text	
	local Text = "@center" 
	
	-- Add map
	do
		local MapName = XNetwork.GameInformation_GetMapName()
		Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageSelectedMap" ) .. " " 
		if MapName ~= "" then
			Text = Text .. MapName
		else
			Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNoMapSelected" )
		end
		
		local MapMode = XNetwork.GameInformation_GetMPFreeGameMode()
		if MapMode == 1 then
			Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageMPModeDeathMatch" )
		elseif MapMode == 2 then
			Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageMPModeTechRace" )
		elseif MapMode == 3 then
			Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessageMPModeTimeRace" )
		end
	end
	
	-- Add player names
	do
		Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessagePlayer" ) .. " "
		local PlayerAdded = 0
		local PlayerID
		for PlayerID=1, XNetwork.GameInformation_GetLogicPlayerIDMaximum(), 1 do
			local NetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
			if NetworkAddress ~= 0 then
				local PlayerName= XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
				Text = Text .. PlayerName .. " "
				PlayerAdded = 1
			end
		end
		if PlayerAdded == 0 then
			Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNoPlayer" ) .. " "
		end
	end
	
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
	
end


----------------------------------------------------------------------------------------------------
-- Screen 45 - multi player joiner joined session menu screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToLadderJoinerJoined()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu45", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 45
	
	-- Init variables
	MPMenu.S45_Var_ClientLostHost = 0

	-- Mouse normal
	MPMenu.Mouse_Normal()
	
	-- Update map preview
	MPMenu.S45_Var_CurrentMapName = nil
	MPMenu.S45_UpdateMapPreview()
	
	-- Clear chat
	MPMenu.GEN_Tool_ClearChat()
	
end

----------------------------------------------------------------------------------------------------
-- Back button

function 
MPMenu.S45_Button_Back()

	-- Shut down TinCat
	MPMenu.System_ShutdownNetwork_TinCat()
	
	
	-- Ubi.com existing?
    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
    
		-- Leave current group
		XNetworkUbiCom.Lobby_Group_LeaveCurrent()
			
		-- Back to Ubi.com lobby screen	
		MPMenu.Screen_ToUbiComLoggedIn( 0 )

    else
    
		-- Back to LAN main screen
		MPMenu.Screen_ToLANMain()
	
	end
		
end


----------------------------------------------------------------------------------------------------
-- Update

function
MPMenu.S45_System_Update()
	MPMenu.S45_UpdateMapPreview()
end

----------------------------------------------------------------------------------------------------
-- Update map preview

function
MPMenu.S45_UpdateMapPreview()


	-- Get map name
	local MapName = XNetwork.GameInformation_GetMapName()
	
	-- Get map type
	local MapType = XNetwork.GameInformation_GetMapType()
	

	-- Map changed?
	if MapName == MPMenu.S45_Var_CurrentMapName then
		return
	end
	MPMenu.S45_Var_CurrentMapName = MapName


	-- Any map?
	if MapName == "" then
		XGUIEng.ShowWidget( "MPM45_MapDetailsContainer", 0 )
		return
	else
		XGUIEng.ShowWidget( "MPM45_MapDetailsContainer", 1 )
	end
	
	
	-- Get map data
	local MapTitle, MapDesc = Framework.GetMapNameAndDescription( MapName, MapType )
	local TextureName = Framework.GetMapPreviewMapTextureName( MapName, MapType )
		
	-- Title
	XGUIEng.SetText( "MPM45_MapTitle", MapTitle )
	
	-- Description
	XGUIEng.SetText( "MPM45_MapDescription", MapDesc )

	-- Set texture
	XGUIEng.SetMaterialTexture( "MPM45_MapPreview", 1, TextureName )

end

----------------------------------------------------------------------------------------------------
-- Update game information widget function

function 
MPMenu.S45_Update_PlayerInSessionInfo()

	local Text = XNetwork.Manager_GetUserInSessionInfoString()
	
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

end


----------------------------------------------------------------------------------------------------
-- Update game information widget function

function 
MPMenu.S45_Update_GameInformation()

	-- Init text	
	local Text = "@center" 
	
	-- Add map
	do
		local MapName = XNetwork.GameInformation_GetMapName()
		Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageSelectedMap" ) .. " " 
		if MapName ~= "" then
			Text = Text .. MapName
		else
			Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNoMapSelected" )
		end
	end
	
	-- Add player names
	do
		Text = Text .. " - " .. XGUIEng.GetStringTableText( "MainMenuMP/MessagePlayer" ) .. " "
		local PlayerAdded = 0
		local PlayerID
		for PlayerID=1, XNetwork.GameInformation_GetLogicPlayerIDMaximum(), 1 do
			local NetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
			if NetworkAddress ~= 0 then
				local PlayerName= XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
				Text = Text .. PlayerName .. " "
				PlayerAdded = 1
			end
		end
		if PlayerAdded == 0 then
			Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageNoPlayer" ) .. " "
		end
	end
	
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
	
end

----------------------------------------------------------------------------------------------------
-- Screen 50 - multi player main Ubi.com menu screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComMain()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu50", 1 )


	-- Init Ubi.com global error message
	MPMenu.GEN_UbiComCriticalErrorMessage = nil


	-- Update log in button state
	do
		
		-- Demo?
		if Demo_Menu == nil or Demo_Menu.Initialized == nil then
		
			-- Nope!
			local DisableState = 0
			
			if XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName() == "" then
				DisableState = 1
			end
			if XNetworkUbiCom.CDKey_GetCDKey() == "" then
				DisableState = 1
			end
			if XNetworkUbiCom.CDKey_GetCDKeyActivationState() == 2 then
				DisableState = 1
			end
			
			XGUIEng.DisableButton( "MPM50_ToLogInButton", DisableState )
			
		else
		
			-- Yeap! Demo: no CD key
			XGUIEng.ShowWidget( "MPM50_ToEnterCDKeyButton", 0 )
			XGUIEng.DisableButton( "MPM50_ToLogInButton", 0 )
		
		end
		
	end


	-- Update change account button state
	do
		local DisableState = 0
		
		if XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName() == "" then
			DisableState = 1
		end
		
		XGUIEng.DisableButton( "MPM50_ToModifyAccountButton", DisableState )
	end
	

	-- Set screen ID
	MPMenu.GEN_ScreenID = 50
	
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S50_Button_ToLogIn()
	MPMenu.Screen_ToUbiComLoggingIn()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S50_Button_ToChangeAccount()
	MPMenu.Screen_ToUbiComChangeAccount( 0 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S50_Button_ToCreateAccount()
	MPMenu.Screen_ToUbiComCreateAccount( 1 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S50_Button_ToModifyAccount()
	MPMenu.Screen_ToUbiComCreateAccount( 11 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S50_Button_ToEnterCDKey()
	MPMenu.Screen_ToUbiComEnterCDKey()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S50_Button_Back()
	MPMenu.GEN_Button_Cancel()
end


----------------------------------------------------------------------------------------------------
-- Screen 55 - multi player main Ubi.com logging in screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComLoggingIn()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu55", 1 )
	
	-- Set screen ID
	MPMenu.GEN_ScreenID = 55
	
	-- Init variables
	MPMenu.S55_Var_LogInStarted = 0
	
	-- Set mouse cursor to wait
	MPMenu.Mouse_Wait()

end


----------------------------------------------------------------------------------------------------
-- Screen 60 - multi player main Ubi.com logged in screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComLoggedIn( _StartLobbyFlag )

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu60", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 60

	-- Starting lobby?
	if _StartLobbyFlag == 1 then
	
		-- Start lobby
		if XNetworkUbiCom.Manager_Lobby_Start() == 0 then
			MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotConnectToUbiComLobby" ) )
			return
		end
	
		-- Init last group index
		MPMenu.S60_Var_LastGroupIndex = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		
	end
	
	-- Init list box offsets
	MPMenu.S60_Var_LobbyListOffset = 0
	MPMenu.S60_Var_UserListOffset = 0
	MPMenu.S60_Tool_ValidateListOffsets()
	
	-- Set mouse cursor to normal
	MPMenu.Mouse_Normal()
		
	-- Clear info area!!!
	MPMenu.S60_Tool_ClearMessages()
	
end

----------------------------------------------------------------------------------------------------
-- Update screen 60 stuff

function 
MPMenu.S60_System_Update()


	-- Print info when lobby is changing
	do
		local GroupIndex = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		if MPMenu.S60_Var_LastGroupIndex ~= GroupIndex then
			MPMenu.S60_Var_LastGroupIndex = GroupIndex
			
			MPMenu.S60_Debug_PrintCurrentGroup( 1 )
		end
	end
	
	-- Update chat input widget container
	do
		local Flag = 0
		if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
			Flag = XNetworkUbiCom.Chat_CanSend()
		end
	    XGUIEng.ShowWidget( "MPM60_Info_ChatInputContainer", Flag )
	end
	
	
	-- Validate list offsets
	MPMenu.S60_Tool_ValidateListOffsets()


	-- Update start new game button
	do
		local Flag = 1
		local GroupIndex = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		if GroupIndex < 0 or XNetworkUbiCom.Lobby_Group_IsRoom( GroupIndex ) == 1 then
			Flag = 0
		end
		XGUIEng.ShowWidget( "MPM60_StartNewGameButton", Flag )
		if XGUIEng.IsWidgetExisting("MPM60_StartLadderGameButton") == 1 then
			XGUIEng.ShowWidget( "MPM60_StartLadderGameButton", Flag )
		end
	end
	
	-- Update back button
	do
		local Flag = 1
		if XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent() < 0 then
			Flag = 0
		end
		XGUIEng.ShowWidget( "MPM60_BackButton", Flag )
	end
	
	-- Update player list container
	do
		local Flag = 1
		if XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent() < 0 then
			Flag = 0
		end
		XGUIEng.ShowWidget( "MPM60_UserList", Flag )
	end
		
end

----------------------------------------------------------------------------------------------------
-- Validate list offsets

function 
MPMenu.S60_Tool_ValidateListOffsets()

	-- Lobbies list offset
	do
	
		-- No negative offsets
		if MPMenu.S60_Var_LobbyListOffset < 0 then
			MPMenu.S60_Var_LobbyListOffset = 0
		end

		-- Get sub groups - lobbies
		local SubGroupIndexes = { XNetworkUbiCom.Lobby_Group_GetCurrentAccessibleSubGroups() }
		local SubGroupNumber = table.getn( SubGroupIndexes )
		
		-- Lobbies on screen
		local LobbiesToDisplay = 10
		
		-- Validate offset
		if SubGroupNumber <= LobbiesToDisplay then
			MPMenu.S60_Var_LobbyListOffset = 0
		else
			if MPMenu.S60_Var_LobbyListOffset > ( SubGroupNumber - LobbiesToDisplay ) then
				MPMenu.S60_Var_LobbyListOffset = ( SubGroupNumber - LobbiesToDisplay )
			end		
		end
		
	end

	-- User list offset	
	do
	
		-- No negative offsets
		if MPMenu.S60_Var_UserListOffset < 0 then
			MPMenu.S60_Var_UserListOffset = 0
		end
	
		-- Get user
		local UserIndexes = { XNetworkUbiCom.Lobby_Group_GetCurrentUsers() }
		local UserNumber = table.getn( UserIndexes )

		-- User to display
		local UserToDisplay = 1

		-- Validate offset
		if UserNumber <= UserToDisplay then
			MPMenu.S60_Var_UserListOffset = 0
		else
			if MPMenu.S60_Var_UserListOffset > ( UserNumber - UserToDisplay ) then
				MPMenu.S60_Var_UserListOffset = ( UserNumber - UserToDisplay )
			end		
		end

	end
	
end


----------------------------------------------------------------------------------------------------
-- Tool to convert lobby list index into group index - returns -1 for invalid

function 
MPMenu.S60_Tool_LobbyListIndexToGroupIndex( _LobbyListIndex )

	-- Get sub groups
	local SubGroupIndexes = { XNetworkUbiCom.Lobby_Group_GetCurrentAccessibleSubGroups() }
	local SubGroupNumber = table.getn( SubGroupIndexes )
	
	-- Calculate real index
	local LobbyListIndex = _LobbyListIndex + MPMenu.S60_Var_LobbyListOffset
	
	-- Index out of bounds?
	if LobbyListIndex < 0 or LobbyListIndex >= SubGroupNumber then
		return -1
	end
	
	-- Get group index - LUA tables start at index 1!
	local GroupIndex = SubGroupIndexes[ LobbyListIndex + 1 ]
	
	-- Return it
	return GroupIndex
	
end

----------------------------------------------------------------------------------------------------
-- Tool to convert user list index into user index - returns -1 for invalid!

function 
MPMenu.S60_Tool_UserListIndexToUserIndex( _UserListIndex )

	-- Get user
	local UserIndexes = { XNetworkUbiCom.Lobby_Group_GetCurrentUsers() }
	local UserNumber = table.getn( UserIndexes )
	
	-- Calculate real index
	local UserListIndex = _UserListIndex + MPMenu.S60_Var_UserListOffset

	-- Index out of bounds?
	if UserListIndex < 0 or UserListIndex >= UserNumber then
		return -1
	end
	
	-- Get user index - LUA tables start at index 1!
	local UserIndex = UserIndexes[ UserListIndex + 1 ]
	
	-- Return it
	return UserIndex
	
end

----------------------------------------------------------------------------------------------------
-- Select lobby

function 
MPMenu.S60_Button_SelectLobby( _LobbyListIndex )

	-- Is CD key 
	if XNetworkUbiCom.CDKey_GetCDKeyActivationState() ~= 1 then
		MPMenu.S60_Tool_PrintMessage( XGUIEng.GetStringTableText( "NetworkUbiCom/MessageWaitingOnCDKeyActivation" ), 1 )
		return
	end
	
	
	-- Get parameter
	local GroupIndex = MPMenu.S60_Tool_LobbyListIndexToGroupIndex( _LobbyListIndex )
	if GroupIndex < 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorSelectedInvalidUbiComGroup" ) )					
		return
	end
	
	-- Enter room
	if XNetworkUbiCom.Lobby_Group_Enter( GroupIndex ) == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotEnterUbiComRoom" ) )					
		return
	end
	
	-- Is entered group a room or a lobby?
	if XNetworkUbiCom.Lobby_Group_IsRoom( GroupIndex ) == 1 then
		MPMenu.Screen_ToUbiComJoiningRoom()
	else
		MPMenu.Screen_ToUbiComJoiningLobby()
	end
	
	-- Init list box offsets
	MPMenu.S60_Var_LobbyListOffset = 0
	MPMenu.S60_Var_UserListOffset = 0
	MPMenu.S60_Tool_ValidateListOffsets()
		
end

----------------------------------------------------------------------------------------------------
-- Go back in lobby hierarchy

function 
MPMenu.S60_Button_Back()

	-- Leave current group
	XNetworkUbiCom.Lobby_Group_LeaveCurrent()
	
	-- Init list box offsets
	MPMenu.S60_Var_LobbyListOffset = 0
	MPMenu.S60_Var_UserListOffset = 0
	MPMenu.S60_Tool_ValidateListOffsets()

	-- Clear info area!!!
	MPMenu.S60_Tool_ClearMessages()
	
	
	-- TEST - reprint MOTD
	if true then
		-- MPMenu_ApplicationCallback_UbiComMOTD( XNetworkUbiCom.MOTD_GetUbiSoftMessage(), 0 )
		MPMenu_ApplicationCallback_UbiComMOTD( XNetworkUbiCom.MOTD_GetGameMessage(), 1 )
	end
	
end

----------------------------------------------------------------------------------------------------
-- Select user

function 
MPMenu.S60_Button_SelectUser( _UserListIndex )

end

----------------------------------------------------------------------------------------------------
-- Start new game button

function 
MPMenu.S60_Button_StartNewGame()
	
	-- Create a new game, room
	if XNetworkUbiCom.Lobby_Room_Create() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateUbiComRoom" ) )					
		return
	end
	
	XNetworkUbiCom.Lobby_SetInitialMatchInfo(0)
	-- Creating room now
	MPMenu.Screen_ToUbiComCreatingRoom()
	
end


----------------------------------------------------------------------------------------------------
-- Start new game button

function 
MPMenu.S60_Button_StartLadderGame()
	
	-- Create a new game, room
	if XNetworkUbiCom.Lobby_Room_Create(1) == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateUbiComRoom" ) )					
		return
	end
	
	-- Creating room now
	MPMenu.Screen_ToUbiComCreatingRoom()
	
end

----------------------------------------------------------------------------------------------------
-- Update lobby button

function 
MPMenu.S60_Update_LobbyButton( _LobbyListIndex )

	-- Get parameter
	local GroupIndex = MPMenu.S60_Tool_LobbyListIndexToGroupIndex( _LobbyListIndex )
	
	
	-- Update text
	do	

		-- Init text	
		local Text = "@center"
		
		-- Create text
		if GroupIndex >= 0 then
			Text = Text .. " " .. XNetworkUbiCom.Lobby_Group_GetName( GroupIndex )
		else
			Text = Text .. " " .. "-"
		end
			
			
						
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
		if XNetworkUbiCom.Lobby_Group_IsRoom(GroupIndex) == 1 then
			if XNetworkUbiCom.Lobby_Group_IsCompatibleGame(GroupIndex) then
				if XNetworkUbiCom.Lobby_Group_IsLadderGame(GroupIndex) then
					XGUIEng.SetTextColor(XGUIEng.GetCurrentWidgetID(), 255,255,0)
				else
					XGUIEng.SetTextColor(XGUIEng.GetCurrentWidgetID(), 0,255,0)
				end
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 0)
			else
				XGUIEng.SetTextColor(XGUIEng.GetCurrentWidgetID(), 255,0,0)
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 1)
			end
		else
				XGUIEng.SetTextColor(XGUIEng.GetCurrentWidgetID(), 255,255,255)
				XGUIEng.DisableButton(XGUIEng.GetCurrentWidgetID(), 0)
		end
	end
	

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		local HighLightFlag = 0
		
		-- Disable when no network address		
		if GroupIndex < 0 then
			DisableState = 1 
		end
		
		-- Enable, high light
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------
-- Update user button

function 
MPMenu.S60_Update_UserButton( _UserListIndex )

	-- Get user index
	local UserIndex = MPMenu.S60_Tool_UserListIndexToUserIndex( _UserListIndex )
	
	-- Update text
	do	

		-- Init text	
		local Text = "@center"
		
		-- Create text
		if UserIndex >= 0 then
			Text = Text .. " " .. XNetworkUbiCom.GroupUser_GetName( UserIndex )
		else
			Text = Text .. " " .. "-"
		end
				
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
		if XNetworkUbiCom.GroupUser_IsVersionCompatible(UserIndex) then
			XGUIEng.SetTextColor(XGUIEng.GetCurrentWidgetID(), 0,255,0)
		else
			XGUIEng.SetTextColor(XGUIEng.GetCurrentWidgetID(), 255,0,0)
		end

	end
	

	-- Update button state
	do	
	
		-- Init state
		local DisableState = 0
		local HighLightFlag = 0
		
		-- Disable
		if UserIndex < 0 then
			DisableState = 1
		end
		
		-- Enable, high light
		XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )
		XGUIEng.HighLightButton( XGUIEng.GetCurrentWidgetID(), HighLightFlag )
			
	end

end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S60_Update_LobbyName()

	-- Init text	
	local Text = "@center" 
	
	-- Network existing?
	if XNetworkUbiCom.Manager_DoesExist() then
	
		-- Get current lobby index
		local Index = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		
		-- Root?
		if Index == -1 then
			Text = Text .. " " .. XGUIEng.GetStringTableText( "MainMenuMP/NameUbiComRootGroup" )
		end
		
		-- Sub lobby		
		if Index >= 0 then
			local Name = XNetworkUbiCom.Lobby_Group_GetName( Index )
			Text = Text .. " " .. Name
			local NumberActiveGames = XNetworkUbiCom.Lobby_GetNumberOfActiveGames()
			Text = Text .. " (" .. XGUIEng.GetStringTableText( "MainMenu/MPM60_Games") .. " " .. NumberActiveGames .. " " 
			local NumberPlayers = XNetworkUbiCom.Lobby_Group_GetNrOfPlayers()
			Text = Text .. XGUIEng.GetStringTableText( "MainMenu/MPM60_Players") .. " " .. NumberPlayers .. ")" 
			
		end

	end
		
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
	
end

----------------------------------------------------------------------------------------------------
-- Update back button state

function 
MPMenu.S60_Update_BackButton()

	-- Init state
	local DisableState = 0
	
	-- Disable when root or error
	if XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent() < 0 then
		DisableState = 1 
	end
	
	-- Enable
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )

end

----------------------------------------------------------------------------------------------------
-- Update start-new-game button state

function 
MPMenu.S60_Update_StartNewGameButton()

	-- Init state
	local DisableState = 0


	-- Update state
	do

		-- Get group index		
		local GroupIndex = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		
		-- Disable when root or error or room
		if GroupIndex < 0 or XNetworkUbiCom.Lobby_Group_IsRoom( GroupIndex ) == 1 then
			DisableState = 1 
		end
	
	end
	
		
	-- Enable
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )

end


----------------------------------------------------------------------------------------------------
-- Update start-new-game button state

function 
MPMenu.S60_Update_StartLadderGameButton()

	-- Init state
	local DisableState = 0


	-- Update state
	do

		-- Get group index		
		local GroupIndex = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		
		-- Disable when root or error or room
		if GroupIndex < 0 or XNetworkUbiCom.Lobby_Group_IsRoom( GroupIndex ) == 1 then
			DisableState = 1 
		end
	
	end
	
		
	-- Enable
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableState )

end

----------------------------------------------------------------------------------------------------
-- Lobby list down

function
MPMenu.S60_Button_LobbyList_Down()
	MPMenu.S60_Var_LobbyListOffset = MPMenu.S60_Var_LobbyListOffset + 1
	MPMenu.S60_Tool_ValidateListOffsets()
end

----------------------------------------------------------------------------------------------------
-- Lobby list up

function
MPMenu.S60_Button_LobbyList_Up()
	MPMenu.S60_Var_LobbyListOffset = MPMenu.S60_Var_LobbyListOffset - 1
	MPMenu.S60_Tool_ValidateListOffsets()
end


----------------------------------------------------------------------------------------------------
-- User list down

function
MPMenu.S60_Button_UserList_Down()
	MPMenu.S60_Var_UserListOffset = MPMenu.S60_Var_UserListOffset + 1
	MPMenu.S60_Tool_ValidateListOffsets()
end

----------------------------------------------------------------------------------------------------
-- User list up

function
MPMenu.S60_Button_UserList_Up()
	MPMenu.S60_Var_UserListOffset = MPMenu.S60_Var_UserListOffset - 1
	MPMenu.S60_Tool_ValidateListOffsets()
end


--------------------------------------------------------------------------------
-- Get current group name

function
MPMenu.S60_Tool_GetCurrentGroupName()
	local RoomName = nil
	if XNetworkUbiCom.Manager_DoesExist() then
		local Index = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		if Index == -1 then
			RoomName = XGUIEng.GetStringTableText( "MainMenuMP/NameUbiComRootGroup" )
		end
		if Index >= 0 then
			RoomName = XNetworkUbiCom.Lobby_Group_GetName( Index )
		end
	end
	return RoomName
end
	
--------------------------------------------------------------------------------
-- Print current group name

function
MPMenu.S60_ToolTipGroup( _LobbyListIndex )
-- Get parameter
	local GroupIndex = MPMenu.S60_Tool_LobbyListIndexToGroupIndex( _LobbyListIndex )
	if GroupIndex == -1 then
		XGUIEng.SetTextKeyName(XGUIEng.GetWidgetID( "StartMenu_TooltipText" ), "MainMenuTooltips/MPM60_GroupButtonEmpty")
	else
		if XNetworkUbiCom.Lobby_Group_IsRoom(GroupIndex) == 1 then
			if XNetworkUbiCom.Lobby_Group_IsCompatibleGame(GroupIndex) then
				if XNetworkUbiCom.Lobby_Group_IsLadderGame(GroupIndex) then
					XGUIEng.SetTextKeyName(XGUIEng.GetWidgetID( "StartMenu_TooltipText" ), "MainMenuTooltips/MPM60_GroupButtonRoomLadderGame")
				else
					XGUIEng.SetTextKeyName(XGUIEng.GetWidgetID( "StartMenu_TooltipText" ), "MainMenuTooltips/MPM60_GroupButtonRoomJoinPossible")
				end
			else
				XGUIEng.SetTextKeyName(XGUIEng.GetWidgetID( "StartMenu_TooltipText" ), "MainMenuTooltips/MPM60_GroupButtonRoomNoJoin")
			end
		else
			XGUIEng.SetTextKeyName(XGUIEng.GetWidgetID( "StartMenu_TooltipText" ), "MainMenuTooltips/MPM60_GroupButtonLobbyJoin")
		end
	end
end

function
MPMenu.S60_ToolTipUser( _UserListIndex )
	local UserIndex = MPMenu.S60_Tool_UserListIndexToUserIndex( _UserListIndex )
	local Text
	if UserIndex == -1 then
		Text = XGUIEng.GetStringTableText( "MainMenuTooltips/MPM60_UserButtonEmpty" )
	else
		if XNetworkUbiCom.GroupUser_IsVersionCompatible(UserIndex) then
			Text = XGUIEng.GetStringTableText( "MainMenuTooltips/MPM60_UserButtonCompatible" )
		else
			Text = XGUIEng.GetStringTableText( "MainMenuTooltips/MPM60_UserButtonIncompatible" )
		end
		Rank1on1 = XNetworkUbiCom.GroupUser_Ladder_GetRank1on1( _UserListIndex )
		Rank2on2 = XNetworkUbiCom.GroupUser_Ladder_GetRank2on2( _UserListIndex )
		if Rank1on1 ~= nil and Rank1on1 ~= 0 then
			Text = Text .. " " .. XGUIEng.GetStringTableText("MainMenu/MP60_OneOnOne") .. Rank1on1
		end
		if Rank2on2 ~= nil and Rank2on2 ~= 0 then
			Text = Text .. " " .. XGUIEng.GetStringTableText("MainMenu/MP60_TwoOnTwo") .. Rank2on2
		end
	end
	XGUIEng.SetText(XGUIEng.GetWidgetID( "StartMenu_TooltipText"), Text )
end


function
MPMenu.S60_Debug_PrintCurrentGroup( _ActionMode )

	-- Debug only
	if false then
		
		-- Get current room name
		local RoomName = MPMenu.S60_Tool_GetCurrentGroupName()
		
		-- Room name set?
		if RoomName ~= nil then
		
			-- Init text	
			local Text = "" 
			if _ActionMode == 1 then
				Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageEnterUbiComLobby" ) .. " " .. RoomName
			end
			if _ActionMode == 2 then
				Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageLeaveUbiComLobby" ) .. " " .. RoomName
			end
				
			-- Print
			MPMenu.S60_Tool_PrintMessage( Text, 1 )
		
		end
	
	end
		
end

--------------------------------------------------------------------------------
-- Add message

function
MPMenu.S60_Tool_PrintMessage( _Message, _ASCIIMessage )

	-- Message to print
	local Message = _Message .. "\n"
	
	-- Update widgets
	MPMenu.GEN_Tool_AddTextLineToWidget( "MPM60_InfoArea_Info", Message, 12, _ASCIIMessage )

end

--------------------------------------------------------------------------------
-- Clear messages

function
MPMenu.S60_Tool_ClearMessages()

	MPMenu.GEN_Tool_ClearTextWidget( "MPM60_InfoArea_Info" )

end


----------------------------------------------------------------------------------------------------
-- Screen 65 - multi player main Ubi.com host room screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComHostRoom()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu65", 1 )


	-- Start TinCat server
	if MPMenu.System_StartTinCatServer() == 0 then
		return
	end


	-- Connect TinCat user with Ubi.com account
	do
		local TinCatNetworkAddress = XNetwork.Manager_GetLocalMachineNetworkAddress()
		local UbiComAccountName = XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName()
		XNetwork.GameInformation_ConnectTinCatUserWithUbiComAccount( TinCatNetworkAddress, UbiComAccountName )
	end
	

	-- Set screen ID
	MPMenu.GEN_ScreenID = 65
	
	
end

----------------------------------------------------------------------------------------------------
-- Go back in lobby hierarchy

function 
MPMenu.S65_Button_Back()

	-- Shut down TinCat
	MPMenu.System_ShutdownNetwork_TinCat()
	

	-- Leave current group
	XNetworkUbiCom.Lobby_Group_LeaveCurrent()
	

	-- Back to lobby screen	
	MPMenu.Screen_ToUbiComLoggedIn( 0 )
	
end


----------------------------------------------------------------------------------------------------
-- Screen 68 - multi player main Ubi.com creating room
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComCreatingRoom()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu68", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 68
	
	-- Set mouse cursor to wait
	MPMenu.Mouse_Wait()
		
end


----------------------------------------------------------------------------------------------------
-- Screen 69 - multi player main Ubi.com joining lobby screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComJoiningLobby()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu69", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 69
	
	-- Set mouse cursor to wait
	MPMenu.Mouse_Wait()
		
end


----------------------------------------------------------------------------------------------------
-- Screen 70 - multi player main Ubi.com joining room screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComJoiningRoom()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu70", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 70
	
	-- Set mouse cursor to wait
	MPMenu.Mouse_Wait()

end


----------------------------------------------------------------------------------------------------
-- Screen 71 - multi player main Ubi.com joined room screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComJoinedRoom()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu71", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 71
	
end


----------------------------------------------------------------------------------------------------
-- Screen 72 - multi player Ubi.com starting game
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComStartingGame( _MapName, _MapType )

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu72", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 72
	
	-- Save map name
	MPMenu.S72_Var_MapName = _MapName
	MPMenu.S72_Var_MapType = _MapType

	
	-- Start Ubi.com game
	do
		local GroupID = XNetworkUbiCom.Lobby_Group_GetIndexOfCurrent()
		if GroupID < 0 then
			MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorInvalidUbiComGroupIndex" ) )
			return
		end
		if XNetworkUbiCom.Lobby_Group_IsLocalUserGroupMaster( GroupID ) == 1 then
			if XNetworkUbiCom.Lobby_Game_Start() == 0 then
				MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartUbiComGame" ) )
			end
		else
			if XNetworkUbiCom.Lobby_Group_IsLadderGame(GroupID) then
				NrOfPlayers = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
				MPMenu.LastGameWasMatch = 1
				if NrOfPlayers == 2 then
					XNetworkUbiCom.Lobby_SetInitialMatchInfo(2, 1)
				elseif NrOfPlayers == 4 then 
					XNetworkUbiCom.Lobby_SetInitialMatchInfo(2, 2)
				else
					return
				end
			else
				MPMenu.LastGameWasMatch = 0
				XNetworkUbiCom.Lobby_SetInitialMatchInfo(0)
			end
		end
	end
	
end


----------------------------------------------------------------------------------------------------
-- Screen 73 - multi player Ubi.com host closing room
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComHostClosingRoom()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu73", 1 )

	-- Set screen ID
	MPMenu.GEN_ScreenID = 73
	
	
	-- Host closing room now
	if XNetworkUbiCom.Lobby_Room_HostClosesRoom() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorHostCouldNotCloseUbiComGroup" ) )					
	end

	
end


----------------------------------------------------------------------------------------------------
-- Screen 74 - Ubi.com Wait for match to finish
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToMPMenuWaitForMatchFinish()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu74", 1 )


	-- Set screen ID
	MPMenu.GEN_ScreenID = 74


	-- First input account
	XGUIEng.ShowAllSubWidgets( "MPM74_InfoArea", 1 )

end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S74_Button_Back()
	XNetworkUbiCom.Lobby_Match_Abort()
	if XNetworkUbiCom.Lobby_State_IsInRoom() == 1 then
		XNetworkUbiCom.Lobby_Group_LeaveCurrent()
	end
	PGMenu.Screen_ToPostGame()
end


----------------------------------------------------------------------------------------------------
-- Screen 75 - Ubi.com change account
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComChangeAccount( _Mode )

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu75", 1 )


	-- Set screen ID
	MPMenu.GEN_ScreenID = 75


	-- Init variables
	do
		-- Do not reset account when reentering PW
		if _Mode ~= 1 then
			MPMenu.S75_Var_UserAccount = ""
		end
		
		-- Clear PWs
		MPMenu.S75_Var_UserPW1 = ""
		MPMenu.S75_Var_UserPW2 = ""
	end


	-- Init GUI elements
	do 
	
		-- String input
		MPMenu75_NameStringInputDone( nil, 0 )
		MPMenu75_PW1StringInputDone( nil, 0 )
		MPMenu75_PW2StringInputDone( nil, 0 )
		
		-- Info area
		if _Mode == 0 then
			MPMenu.S75_Tool_ClearInfoArea()
		end
		
	end


	-- First input account
	XGUIEng.ShowAllSubWidgets( "MPM75_SubContainer", 0 )

	-- Well, when reentering PW start with PW1 otherwise with account
	if _Mode == 1 then
		XGUIEng.ShowWidget( "MPM75_UbiComUserPW1_Container", 1 )
	else
		XGUIEng.ShowWidget( "MPM75_UbiComUserName_Container", 1 )
	end

end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S75_Button_Back()
	MPMenu.Screen_ToUbiComMain()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu75_NameStringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- Account name ok?
		if XNetworkUbiCom.Account_IsAccountNameOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S75_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComAccountNameNotCorrect" ) )
			MPMenu.S75_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S75_Var_UserAccount = _String
		
		-- Go on with PW1
		XGUIEng.ShowAllSubWidgets( "MPM75_SubContainer", 0 )
		XGUIEng.ShowWidget( "MPM75_UbiComUserPW1_Container", 1 )
		
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM75_UbiComUserName_Input_CustomWidget", MPMenu.S75_Var_UserAccount )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S75_NameOk()
	local Name = XGUIEng.GetStringInputCustomWidgetString( "MPM75_UbiComUserName_Input_CustomWidget" )
	MPMenu75_NameStringInputDone( Name, 0 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu75_PW1StringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- PW ok?
		if XNetworkUbiCom.Account_IsPasswordOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S75_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComPasswordNotCorrect" ) )
			MPMenu.S75_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end


		-- Yes: save it
		MPMenu.S75_Var_UserPW1 = _String
		
		
-- No re-enter of PW needed in this case - save immediatly

		-- Save account data
		GDB.SetString( "Config\\UbiCom\\Account", MPMenu.S75_Var_UserAccount )		
		XNetworkUbiCom.User_SetPassword( MPMenu.S75_Var_UserPW1 )		

		-- Go back
		MPMenu.Screen_ToUbiComMain()


-- No re-enter of PW needed in this case

		-- Go on with PW2
		--XGUIEng.ShowAllSubWidgets( "MPM75_SubContainer", 0 )
		--XGUIEng.ShowWidget( "MPM75_UbiComUserPW2_Container", 1 )
		
	else
		
		-- Nope: reset PW
		XGUIEng.SetStringInputCustomWidgetString( "MPM75_UbiComUserPW1_Input_CustomWidget", MPMenu.S75_Var_UserPW1 )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S75_PW1Ok()
	local Password = XGUIEng.GetStringInputCustomWidgetString( "MPM75_UbiComUserPW1_Input_CustomWidget" )
	MPMenu75_PW1StringInputDone( Password, 0 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu75_PW2StringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- Yes: save it
		MPMenu.S75_Var_UserPW2 = _String
		
		-- Do PW match?
		if MPMenu.S75_Var_UserPW1 ~= MPMenu.S75_Var_UserPW2 then
		
			-- Nope! Info user!
			MPMenu.S75_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComPasswordMismatch" ) )
	
			-- Init PWs
			MPMenu.S75_Var_UserPW1 = ""
			MPMenu.S75_Var_UserPW2 = ""

			-- Reset widgets			
			MPMenu75_PW1StringInputDone( nil, 0 )
			MPMenu75_PW2StringInputDone( nil, 0 )
			
			-- Go on with PW1
			XGUIEng.ShowAllSubWidgets( "MPM75_SubContainer", 0 )
			XGUIEng.ShowWidget( "MPM75_UbiComUserPW1_Container", 1 )
			
			-- Ok
			return
			
		end		
		
		
		-- Save account data
		GDB.SetString( "Config\\UbiCom\\Account", MPMenu.S75_Var_UserAccount )		
		XNetworkUbiCom.User_SetPassword( MPMenu.S75_Var_UserPW1 )		

		
		-- Go back
		MPMenu.Screen_ToUbiComMain()
		
	else
		
		-- Nope: reset PW
		XGUIEng.SetStringInputCustomWidgetString( "MPM75_UbiComUserPW2_Input_CustomWidget", MPMenu.S75_Var_UserPW2 )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S75_PW2Ok()
	local Password = XGUIEng.GetStringInputCustomWidgetString( "MPM75_UbiComUserPW2_Input_CustomWidget" )
	MPMenu75_PW2StringInputDone( Password, 0 )
end

	
--------------------------------------------------------------------------------
-- Add info message

function
MPMenu.S75_Tool_AddInfoMessage( _Message )
	
	-- Anything?	
	if _Message == nil or _Message == "" then
		return
	end

	-- Message to print
	local Message = _Message .. "\n"
	
	-- Update widgets
	MPMenu.GEN_Tool_AddTextLineToWidget( "MPM75_InfoArea_Info", Message, 4 )

end

--------------------------------------------------------------------------------
-- Clear info messages

function
MPMenu.S75_Tool_ClearInfoArea()
	
	-- Clear widgets
	MPMenu.GEN_Tool_ClearTextWidget( "MPM75_InfoArea_Info" )
	
end


----------------------------------------------------------------------------------------------------
-- Get account syntax error 

function 
MPMenu75_GetLastAccountSyntaxErrorMessage()

	-- Get error code
	local ErrorCode = XNetworkUbiCom.Account_GetLastSyntaxErrorCode()
	
	
	
	
	-- On error
	if ErrorCode == 10 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxAccountDoesNotStartWithLetter" )
	elseif ErrorCode == 20 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxAccountLengthWrong" )
	elseif ErrorCode == 21 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxAccountWrongCharacter" )
	elseif ErrorCode == 30 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxPasswordLengthWrong" )
	elseif ErrorCode == 31 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxPasswordWrongCharacter" )
	elseif ErrorCode == 32 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxPasswordNoLetter" )
	elseif ErrorCode == 33 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxPasswordNoNumber" )
	elseif ErrorCode == 40 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxEMailWrongCharacter" )
	elseif ErrorCode == 41 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxEMailInvalidFormat" )
	elseif ErrorCode == 50 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxCDKeyLengthWrong" )
	elseif ErrorCode == 51 then
		return XGUIEng.GetStringTableText( "MainMenuMP/ErrorSyntaxCDKeyWrongCharacter" )
	end
	
	-- No error
	return ""

end


----------------------------------------------------------------------------------------------------
-- Tool function to get the Ubi.com Account country code
-- This function should modify language strings if language code
-- differs from country code (ISO)
----------------------------------------------------------------------------------------------------
function 
MPMenu.GetUbiComAccountCountry()
	Language = XNetworkUbiCom.Tool_GetCurrentLanguageShortName()
	
	-- For Taiwanese version - Chinese version is english :-(
	if string.upper(Language) == "ZH" then
		Language = "TW"
	end
	
	return Language
end



----------------------------------------------------------------------------------------------------
-- Screen 76 - Ubi.com create account
----------------------------------------------------------------------------------------------------
-- Mode:  1: start create account
--        2: redo create account - error occured
--       11: modify account
function 
MPMenu.Screen_ToUbiComCreateAccount( _Mode )

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu76", 1 )


	-- Set screen ID
	MPMenu.GEN_ScreenID = 76
	
	
	-- Save mode
	MPMenu.S76_Var_Mode = _Mode


	-- Init variables
	do
		if _Mode == 1 then
		
			MPMenu.S76_Var_UserAccount = ""
	
			MPMenu.S76_Var_UserFirstName = ""
			MPMenu.S76_Var_UserLastName = ""
			MPMenu.S76_Var_UserEmail = ""
			MPMenu.S76_Var_UserCountry = MPMenu.GetUbiComAccountCountry()

		end
		
		if _Mode == 11 then
		
			MPMenu.S76_Var_UserAccount = MPMenu.SUbiCom_GEN_GetUserAccount()
	
			MPMenu.S76_Var_UserFirstName = ""
			MPMenu.S76_Var_UserLastName = ""
			MPMenu.S76_Var_UserEmail = ""
			MPMenu.S76_Var_UserCountry = MPMenu.GetUbiComAccountCountry()

		end
			
			
		MPMenu.S76_Var_UserPW1 = ""
		MPMenu.S76_Var_UserPW2 = ""

		MPMenu.S76_Var_CreateAccountResult = nil
		MPMenu.S76_Var_CreateAccountError = nil
				
		MPMenu.S76_Var_ModifyingState = nil
		MPMenu.S76_Var_ModifyAccountResult = nil
		MPMenu.S76_Var_ModifyAccountError = nil
				
		
	end


	-- Init GUI elements
	do 
	
		-- String input
		MPMenu76_AccountNameStringInputDone( nil, 0 )
		MPMenu76_PW1StringInputDone( nil, 0 )
		MPMenu76_PW2StringInputDone( nil, 0 )
		MPMenu76_FirstNameStringInputDone( nil, 0 )
		MPMenu76_LastNameStringInputDone( nil, 0 )
		MPMenu76_EmailStringInputDone( nil, 0 )
		MPMenu76_CountryStringInputDone( nil, 0 )
		
		-- Info area
		if _Mode == 1 then
			MPMenu.S76_Tool_ClearInfoArea()
		end
		
		-- Terms of use
		if _Mode == 1 then
		  if ( XGUIEng.GetStringTableText("MainMenuMP/FlagUseNormText") == "false" ) then
			  XGUIEng.SetTextFromFile( "MPM76_UbiComTerms_Terms", "Txt\\UbiComTerms.txt", true )
			else
			  XGUIEng.SetTextFromFile( "MPM76_UbiComTerms_Terms", "Txt\\UbiComTerms.txt", false )
			end
		end
		MPMenu.S76_Var_TermsLine = 0
		MPMenu76_UpdateTerms()
		
	end


	-- To first page to show
	do
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		if _Mode == 1 then
			XGUIEng.ShowWidget( "MPM76_UbiComTerms_Container", 1 )
		end
		if _Mode == 2 then
			XGUIEng.ShowWidget( "MPM76_UbiComUserAccountName_Container", 1 )
		end
		if _Mode == 11 then
			XGUIEng.ShowWidget( "MPM76_UbiComUserPW1_Container", 1 )
		end
	end
	
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_Button_Back()
	MPMenu.Screen_ToUbiComMain()
end


----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_TermsOk()
	
	-- To account name
	XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
	XGUIEng.ShowWidget( "MPM76_UbiComUserAccountName_Container", 1 )

end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_TermsUp()
	MPMenu.S76_Var_TermsLine = MPMenu.S76_Var_TermsLine - 5
	MPMenu76_UpdateTerms()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_TermsDown()
	MPMenu.S76_Var_TermsLine = MPMenu.S76_Var_TermsLine + 5
	MPMenu76_UpdateTerms()
end

----------------------------------------------------------------------------------------------------

function
MPMenu76_UpdateTerms()

	-- Validate line
	if MPMenu.S76_Var_TermsLine < 0 then
		MPMenu.S76_Var_TermsLine = 0
	end
	
	-- Update widget
	XGUIEng.SetLinesToPrint( "MPM76_UbiComTerms_Terms", MPMenu.S76_Var_TermsLine, -1 )
	
end

----------------------------------------------------------------------------------------------------

function 
MPMenu76_AccountNameStringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- Account name ok?
		if XNetworkUbiCom.Account_IsAccountNameOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComAccountNameNotCorrect" ) )
			MPMenu.S76_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S76_Var_UserAccount = _String
		
		-- Go on with PW1
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		XGUIEng.ShowWidget( "MPM76_UbiComUserPW1_Container", 1 )
		
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserAccountName_Input_CustomWidget", MPMenu.S76_Var_UserAccount )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_AccountNameOk()
	local Name = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserAccountName_Input_CustomWidget" )
	MPMenu76_AccountNameStringInputDone( Name, 0 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu76_PW1StringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- PW ok?
		if XNetworkUbiCom.Account_IsPasswordOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComPasswordNotCorrect" ) )
			MPMenu.S76_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end

		-- Yes: save it
		MPMenu.S76_Var_UserPW1 = _String
		
		-- Go on with PW2
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		XGUIEng.ShowWidget( "MPM76_UbiComUserPW2_Container", 1 )
		
	else
		
		-- Nope: reset PW
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserPW1_Input_CustomWidget", MPMenu.S76_Var_UserPW1 )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_PW1Ok()
	local Password = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserPW1_Input_CustomWidget" )
	MPMenu76_PW1StringInputDone( Password, 0 )
end

----------------------------------------------------------------------------------------------------

function 
MPMenu76_PW2StringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- Yes: save it
		MPMenu.S76_Var_UserPW2 = _String
		
		-- Do PW match?
		if MPMenu.S76_Var_UserPW1 ~= MPMenu.S76_Var_UserPW2 then
		
			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComPasswordMismatch" ) )

			-- Init PWs
			MPMenu.S76_Var_UserPW1 = ""
			MPMenu.S76_Var_UserPW2 = ""

			-- Reset widgets			
			MPMenu76_PW1StringInputDone( nil, 0 )
			MPMenu76_PW2StringInputDone( nil, 0 )
			
			-- Go on with PW1
			XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
			XGUIEng.ShowWidget( "MPM76_UbiComUserPW1_Container", 1 )

			-- Ok
			return
			
		end		
		
		
		-- Go on with first name
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		XGUIEng.ShowWidget( "MPM76_UbiComUserFirstName_Container", 1 )

		
	else
		
		-- Nope: reset PW
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserPW2_Input_CustomWidget", MPMenu.S76_Var_UserPW2 )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_PW2Ok()
	local Password = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserPW2_Input_CustomWidget" )
	MPMenu76_PW2StringInputDone( Password, 0 )
end


----------------------------------------------------------------------------------------------------

function 
MPMenu76_FirstNameStringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil then
	
		-- Account name ok?
		if XNetworkUbiCom.Account_IsRealNameOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComFirstNameNotCorrect" ) )
			MPMenu.S76_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S76_Var_UserFirstName = _String
		
		-- Go on with last name
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		XGUIEng.ShowWidget( "MPM76_UbiComUserLastName_Container", 1 )
		
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserFirstName_Input_CustomWidget", MPMenu.S76_Var_UserFirstName )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_FirstNameOk()
	local Text = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserFirstName_Input_CustomWidget" )
	MPMenu76_FirstNameStringInputDone( Text, 0 )
end


----------------------------------------------------------------------------------------------------

function 
MPMenu76_LastNameStringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil then
	
		-- Account name ok?
		if XNetworkUbiCom.Account_IsRealNameOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComLastNameNotCorrect" ) )
			MPMenu.S76_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S76_Var_UserLastName = _String
		
		-- Go on with email
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		XGUIEng.ShowWidget( "MPM76_UbiComUserEmail_Container", 1 )
		
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserLastName_Input_CustomWidget", MPMenu.S76_Var_UserLastName )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_LastNameOk()
	local Text = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserLastName_Input_CustomWidget" )
	MPMenu76_LastNameStringInputDone( Text, 0 )
end


----------------------------------------------------------------------------------------------------

function 
MPMenu76_EmailStringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil then
	
		-- Account name ok?
		if XNetworkUbiCom.Account_IsEmailAddressOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComEmailNotCorrect" ) )
			MPMenu.S76_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S76_Var_UserEmail = _String
		
		
		-- Go on with country
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		
		-- Do not enter country! Switch directly to create!
		--XGUIEng.ShowWidget( "MPM76_UbiComUserCountry_Container", 1 )

		-- Go on with create OR modify
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		if MPMenu.S76_Var_Mode < 10 then
			XGUIEng.ShowWidget( "MPM76_CreateUbiComAccount_Container", 1 )
		else
			XGUIEng.ShowWidget( "MPM76_ModifyUbiComAccount_Container", 1 )
		end
		
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserEmail_Input_CustomWidget", MPMenu.S76_Var_UserEmail )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_EmailOk()
	local Text = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserEmail_Input_CustomWidget" )
	MPMenu76_EmailStringInputDone( Text, 0 )
end



----------------------------------------------------------------------------------------------------

function 
MPMenu76_CountryStringInputDone( _String, _WidgetID )

	-- Valid user name passed?
	if _String ~= nil and _String ~= "" then
	
		-- Account name ok?
		if XNetworkUbiCom.Account_IsCountryNameOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorUbiComCountryNotCorrect" ) )
			MPMenu.S76_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S76_Var_UserCountry = _String
		
		-- Go on with create OR modify
		XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
		if MPMenu.S76_Var_Mode < 10 then
			XGUIEng.ShowWidget( "MPM76_CreateUbiComAccount_Container", 1 )
		else
			XGUIEng.ShowWidget( "MPM76_ModifyUbiComAccount_Container", 1 )
		end
		
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM76_UbiComUserCountry_Input_CustomWidget", MPMenu.S76_Var_UserCountry )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S76_CountryOk()
	local Text = XGUIEng.GetStringInputCustomWidgetString( "MPM76_UbiComUserCountry_Input_CustomWidget" )
	MPMenu76_CountryStringInputDone( Text, 0 )
end


----------------------------------------------------------------------------------------------------
-- Do create account button pressed

function 
MPMenu.S76_DoCreateAccount()

	-- Create Ubi.com manager
	if XNetworkUbiCom.Manager_Create() == 0 then
	
		-- Print message
		MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateUbiComManager" ) )
		
		-- Restart
		MPMenu.Screen_ToUbiComCreateAccount( 2 )
		
		-- Failed
		return

	end
	
	
	-- Do connect 
	if XNetworkUbiCom.Manager_LogIn_Connect() == 0 then
	
		-- Shut down Ubi.com!
		MPMenu.System_ShutdownNetwork_UbiCom()
	
		-- Print message
		MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotConnectToUbiCom" ) )
		
		-- Restart
		MPMenu.Screen_ToUbiComCreateAccount( 2 )
		
		-- Failed
		return
		
	end


	-- Create account
	if XNetworkUbiCom.Account_Create(
				MPMenu.S76_Var_UserAccount,
				MPMenu.S76_Var_UserPW1,
				MPMenu.S76_Var_UserFirstName,
				MPMenu.S76_Var_UserLastName,
				MPMenu.S76_Var_UserEmail,
				MPMenu.S76_Var_UserCountry
			) == 0
	then

		-- Shut down Ubi.com!
		MPMenu.System_ShutdownNetwork_UbiCom()
	
		-- Print message
		MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateUbiComAccount" ) )
		
		-- Restart
		MPMenu.Screen_ToUbiComCreateAccount( 2 )
		
		-- Failed
		return
				
	end
			
			
	-- Go on with creating account screen - wait for callback
	XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
	XGUIEng.ShowWidget( "MPM76_CreatingUbiComAccount_Container", 1 )

end

----------------------------------------------------------------------------------------------------
-- Ubi.com account created callback

function 
MPMenu.S76_CreatedAccount_Callback( _SuccessFlag, _ErrorMessage )

	-- Save data - used next update - otherwise manager would be killed in CallBack!
	MPMenu.S76_Var_CreateAccountResult = _SuccessFlag
	MPMenu.S76_Var_CreateAccountError = _ErrorMessage

end

----------------------------------------------------------------------------------------------------
-- Ubi.com account modified callback

function 
MPMenu.S76_ModifiedAccount_Callback( _SuccessFlag, _ErrorMessage )

	-- Save data - used next update - otherwise manager would be killed in CallBack!
	MPMenu.S76_Var_ModifyAccountResult = _SuccessFlag
	MPMenu.S76_Var_ModifyAccountError = _ErrorMessage

end


----------------------------------------------------------------------------------------------------
-- Do modify account button pressed

function 
MPMenu.S76_DoModifyAccount()

	-- Start Ubi.com
	if XNetworkUbiCom.Manager_Create() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateUbiComManager" ) )
		return
	end
	
	-- Start Ubi.com log in
	if XNetworkUbiCom.Manager_LogIn_Connect() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotConnectToUbiCom" ) )
		return
	end
	if XNetworkUbiCom.Manager_LogIn_Start() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartLogInToUbiCom" ) )
		return
	end

	-- Log in started
	MPMenu.S76_Var_ModifyingState = 1

	-- Go on with modifying account screen - wait for callback
	XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
	XGUIEng.ShowWidget( "MPM76_ModifyingUbiComAccount_Container", 1 )

end

	
--------------------------------------------------------------------------------
-- Update

function 
MPMenu.S76_System_Update()

	-- Account create call back came in?
	if MPMenu.S76_Var_CreateAccountResult ~= nil then
	
		-- Yeap!
		
		-- Shut down Ubi.com!
		MPMenu.System_ShutdownNetwork_UbiCom()
		
		-- Success?
		if MPMenu.S76_Var_CreateAccountResult == 1 then
		
			-- Yes!
			
			-- Use this account now
			GDB.SetString( "Config\\UbiCom\\Account", MPMenu.S76_Var_UserAccount )		
			XNetworkUbiCom.User_SetPassword( MPMenu.S76_Var_UserPW1 )		
	
			-- Go on with created account screen
			XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
			XGUIEng.ShowWidget( "MPM76_CreatedUbiComAccount_Container", 1 )
			
		else
		
			-- Nope!
			
			-- Print message
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/MessageUbiComAccountCreationFailed" ) .. " " .. MPMenu.S76_Var_CreateAccountError )
			
			-- Restart
			MPMenu.Screen_ToUbiComCreateAccount( 2 )
			
		end

		-- Reset flags	
		MPMenu.S76_Var_CreateAccountResult = nil
		MPMenu.S76_Var_CreateAccountError = nil
	
	end



	-- Modify account: waiting for log in?
	if MPMenu.S76_Var_ModifyingState == 1 then
	
		-- Logged in?
		if XNetworkUbiCom.Manager_GetState() == 4 then

			-- Modify account
			if XNetworkUbiCom.Account_Modify(
						MPMenu.S76_Var_UserPW1,
						MPMenu.S76_Var_UserFirstName,
						MPMenu.S76_Var_UserLastName,
						MPMenu.S76_Var_UserEmail,
						MPMenu.S76_Var_UserCountry
					) == 0
			then
		
				-- Shut down Ubi.com!
				MPMenu.System_ShutdownNetwork_UbiCom()
			
				-- Print message
				MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotModifyUbiComAccount" ) )
				
				-- Restart
				MPMenu.Screen_ToUbiComCreateAccount( 11 )
				
				-- Failed
				return
						
			end
					
			-- Wait for modify result - now wait for callback
			MPMenu.S76_Var_ModifyingState = 2
			
		end

		-- Error?
		if XNetworkUbiCom.Manager_GetState() == -1 and MPMenu.GEN_UbiComCriticalErrorMessage == nil and MPMenu.GEN_UbiComUpdateMessage == nil then
			MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotLogInToUbiCom" ) )
			return
		end
		
	end

	-- Account modify call back came in?
	if MPMenu.S76_Var_ModifyAccountResult ~= nil then
	
		-- Yeap!
		
		-- Shut down Ubi.com!
		MPMenu.System_ShutdownNetwork_UbiCom()
		
		-- Success?
		if MPMenu.S76_Var_ModifyAccountResult == 1 then
		
			-- Yes!
			
			-- Use this account now
			GDB.SetString( "Config\\UbiCom\\Account", MPMenu.S76_Var_UserAccount )		
			XNetworkUbiCom.User_SetPassword( MPMenu.S76_Var_UserPW1 )		
	
			-- Go on with mofified account screen
			XGUIEng.ShowAllSubWidgets( "MPM76_SubContainer", 0 )
			XGUIEng.ShowWidget( "MPM76_ModifiedUbiComAccount_Container", 1 )
			
		else
		
			-- Nope!
			
			-- Print message
			MPMenu.S76_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "MainMenuMP/MessageUbiComAccountModifyFailed" ) .. " " .. MPMenu.S76_Var_ModifyAccountError )
			
			-- Restart
			MPMenu.Screen_ToUbiComCreateAccount( 11 )
			
		end

		-- Reset flags	
		MPMenu.S76_Var_ModifyAccountResult = nil
		MPMenu.S76_Var_ModifyAccountError = nil
	
	end
	

end

	
--------------------------------------------------------------------------------
-- Add info message

function
MPMenu.S76_Tool_AddInfoMessage( _Message )
	
	-- Anything?	
	if _Message == nil or _Message == "" then
		return
	end

	-- Message to print
	local Message = _Message .. "\n"
	
	-- Update widgets
	MPMenu.GEN_Tool_AddTextLineToWidget( "MPM76_InfoArea_Info", Message, 4 )

end

--------------------------------------------------------------------------------
-- Clear info messages

function
MPMenu.S76_Tool_ClearInfoArea()
	
	-- Clear widgets
	MPMenu.GEN_Tool_ClearTextWidget( "MPM76_InfoArea_Info" )
	
end


----------------------------------------------------------------------------------------------------
-- Update entered data info windget

function
MPMenu.S76_Update_EnteredDataInfoArea()

	-- Create text
	local Text = 		MPMenu.S76_Var_UserAccount 
					.. 	"\n" .. MPMenu.S76_Var_UserFirstName  .. " " .. MPMenu.S76_Var_UserLastName
					.. 	"\n" .. MPMenu.S76_Var_UserEmail
				--	.. 	"\n" .. MPMenu.S76_Var_UserCountry
	
	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
	
end


----------------------------------------------------------------------------------------------------
-- Screen 77 - Ubi.com cd key
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToUbiComEnterCDKey()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu77", 1 )


	-- Set screen ID
	MPMenu.GEN_ScreenID = 77


	-- Init variables
	do
		MPMenu.S77_Var_CDKey = ""
		MPMenu.S77_Var_CDKey = XNetworkUbiCom.CDKey_GetCDKey()
	end


	-- Init GUI elements
	do 
		--
		MPMenu.S77_Tool_ClearInfoArea()
	
		-- String input
		MPMenu77_CDKeyStringInputDone( nil, 0 )
		
	end

end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S77_Button_Back()
	MPMenu.Screen_ToUbiComMain()
end

----------------------------------------------------------------------------------------------------

function 
MPMenu77_CDKeyStringInputDone( _String, _WidgetID )

	-- Valid CD key passed?
	if _String ~= nil and _String ~= "" then
	
		-- CD key ok?
		if XNetworkUbiCom.CDKey_IsCDKeyOk( _String ) ~= 1 then

			-- Nope! Info user!
			MPMenu.S77_Tool_AddInfoMessage( XGUIEng.GetStringTableText( "NetworkUbiCom/MessageInvalidCDKey" ) )
			MPMenu.S77_Tool_AddInfoMessage( MPMenu75_GetLastAccountSyntaxErrorMessage() )
			
			-- Ok
			return

		end
		
	
		-- Yes: save it
		MPMenu.S77_Var_CDKey = _String
		
		-- Set key
		XNetworkUbiCom.CDKey_SetCDKey( MPMenu.S77_Var_CDKey )
		
		-- Reset it
		MPMenu.S77_Var_CDKey = ""
		
		-- Back to main
		MPMenu.Screen_ToUbiComMain()
				
	else
	
		-- Nope: reset it!
		XGUIEng.SetStringInputCustomWidgetString( "MPM77_CDKey_Input_CustomWidget", MPMenu.S77_Var_CDKey )	
		
	end
end

----------------------------------------------------------------------------------------------------

function 
MPMenu.S77_CDKeyOk()
	local Key = XGUIEng.GetStringInputCustomWidgetString( "MPM77_CDKey_Input_CustomWidget" )
	MPMenu77_CDKeyStringInputDone( Key, 0 )
end

--------------------------------------------------------------------------------
-- Add info message

function
MPMenu.S77_Tool_AddInfoMessage( _Message )
	
	-- Anything?	
	if _Message == nil or _Message == "" then
		return
	end

	-- Message to print
	local Message = _Message .. "\n"
	
	-- Update widgets
	MPMenu.GEN_Tool_AddTextLineToWidget( "MPM77_InfoArea_Info", Message, 4 )

end

--------------------------------------------------------------------------------
-- Clear info messages

function
MPMenu.S77_Tool_ClearInfoArea()
	
	-- Clear widgets
	MPMenu.GEN_Tool_ClearTextWidget( "MPM77_InfoArea_Info" )
	
end



----------------------------------------------------------------------------------------------------
-- Generic Ubi.com functions
----------------------------------------------------------------------------------------------------
-- Quit Ubi.com

function 
MPMenu.SUbiCom_Button_Quit() 

	-- Shut down network
	MPMenu.System_ShutdownNetwork()

	-- Back to Ubi.com main
	MPMenu.Screen_ToUbiComMain()

	-- Mouse normal
	MPMenu.Mouse_Normal()

end

----------------------------------------------------------------------------------------------------
-- Update Ubi.com state text widget

function 
MPMenu.SUbiCom_Update_UbiComInformation()

	-- Update text
	do	

		-- Init text	
		local Text = ""
			
		-- Add state string
		if XNetworkUbiCom.Manager_DoesExist() == 1 then
			Text = "@center " .. XNetworkUbiCom.Debug_GetStateString()
		end
				
		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end

end

----------------------------------------------------------------------------------------------------
-- Update Ubi.com user information text widget

function 
MPMenu.SUbiCom_Update_UbiComUserInformation()

	-- Update text
	do	

		-- Init text	
		local Text = "@center "
			
		-- Add user name
		do
			local Account = MPMenu.SUbiCom_GEN_GetUserAccount()
			if Account ~= "" then
				Text = Text .. XGUIEng.GetStringTableText( "MainMenuMP/MessageCurrentUbiComAccount" ) .. " " 
				Text = Text .. Account
			else
				Text = Text .. XGUIEng.GetStringTableText( "NetworkUbiCom/MessageNeedToCreateUbiComAccount" )
			end
		end

		-- Add CD key
		do
			if XNetworkUbiCom.CDKey_GetCDKey() == "" then
				Text = Text .. " - "
				Text = Text .. XGUIEng.GetStringTableText( "NetworkUbiCom/MessageNeedToEnterCDKey" )
			end
			
			if XNetworkUbiCom.CDKey_GetCDKeyActivationState() == 2 then
				Text = Text .. " - "
				Text = Text .. XGUIEng.GetStringTableText( "NetworkUbiCom/MessageEnteredInvalidCDKey" )
			end
		end
					
		-- Add password
		if false then
			Text = Text .. " - " .. "PW: " 
			local Password = MPMenu.SUbiCom_GEN_GetUserPW()
			if Password ~= "" then
				Text = Text .. Password
			else
				Text = Text .. "-"
			end
		end

		-- Set text
		XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )

	end

end

----------------------------------------------------------------------------------------------------
-- Get Ubi.com user account

function 
MPMenu.SUbiCom_GEN_GetUserAccount()
	local String = ""
	if GDB.IsKeyValid( "Config\\UbiCom\\Account" ) then
		String = GDB.GetString( "Config\\UbiCom\\Account" )
	end
	return String
end

----------------------------------------------------------------------------------------------------
-- Get Ubi.com user password

function 
MPMenu.SUbiCom_GEN_GetUserPW()
	return XNetworkUbiCom.User_GetPassword()
end


----------------------------------------------------------------------------------------------------
-- Screen 99 - error screen
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToError( _ErrorMessage )

	-- Shut down network
	if MPMenu.GEN_UbiComMinorErrorFlag == 1
	then
		MPMenu.System_ShutdownNetwork_TinCat()
	else
		MPMenu.System_ShutdownNetwork()
	end
	
	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu99", 1 )
	-- Set error message
	XGUIEng.SetText( "MPM99_Info", "@color:255,0,0,255 @center " .. XGUIEng.GetStringTableText( "MainMenuMP/ErrorGeneric" ) .. " " .. _ErrorMessage )
	
	-- Set mouse cursor to normal
	MPMenu.Mouse_Normal()

	-- Set screen ID
	MPMenu.GEN_ScreenID = 99
	
end

function 
MPMenu.Screen_ToUpdate( _ErrorMessage )

	MPMenu.System_ShutdownNetwork()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenu98", 1 )
	-- Set error message
	XGUIEng.SetText( "MPM98_Info", "@color:255,0,0,255 @center " .. XGUIEng.GetStringTableText( "MainMenuMP/ErrorGeneric" ) .. " " .. _ErrorMessage )
	
	-- Set mouse cursor to normal
	MPMenu.Mouse_Normal()

	-- Set screen ID
	MPMenu.GEN_ScreenID = 98
	
end

function
MPMenu.MPMenu98_Update()
	if Framework.StartAutoupdate() == -1 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenu/MPM98_CannotStartUpdate" ) )
	else
		Framework.ExitGame()
	end
end





----------------------------------------------------------------------------------------------------
-- Screen 1001 - T1
----------------------------------------------------------------------------------------------------

function 
MPMenu.Screen_ToT1()

	-- Activate screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "MPMenuT1", 1 )


	-- Set screen ID
	MPMenu.GEN_ScreenID = 1001
	
end

--------------------------------------------------------------------------------
-- Connect to IP

function 
MPMenu_ST1_Callback_ConnectToIP( _Message, _Parameter2 )
	
	
	-- Shut down TinCat first
	MPMenu.System_ShutdownNetwork_TinCat()


	-- Init IP
	local IP1 = 0
	local IP2 = 0
	local IP3 = 0
	local IP4 = 0
	
	-- Convert string into IP address
	IP1, IP2, IP3, IP4 = XNetwork.Tool_ConvertStringToIPAddress( _Message )
	
	
	-- Create network
	if XNetwork.Manager_Create() == 0 then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotCreateBaseManager" ) )
		return
	end
	
	
	-- Start network - client
	XNetwork.StartUp_Network_SetServerFlag( 0 )
	if 		XNetwork.Manager_StartNetwork() == 0 
	then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseNetworkClientMode" ) )
		return
	end
	
	
	-- Set server IP
	XNetwork.StartUp_Session_SetServerIP( IP1, IP2, IP3, IP4 )
			
	-- Start session
	if 		XNetwork.Manager_StartSession() == 0 
	then
		MPMenu.Screen_ToError( XGUIEng.GetStringTableText( "MainMenuMP/ErrorCouldNotStartBaseSessionClientMode" ) )
		return
	end
				
	-- Joined session: change screen
	MPMenu.Screen_ToJoinerJoined()
	
end

----------------------------------------------------------------------------------------------------
-- Back button

function 
MPMenu.ST1_Button_Back()
	MPMenu.GEN_Button_Cancel()
end


----------------------------------------------------------------------------------------------------
-- Main menu application callbacks - functions called by program in MAIN MENU!
----------------------------------------------------------------------------------------------------
-- Start game callback

function 
MPMenu_ApplicationCallback_StartGame( _MapName, _MapType )
	-- Start Ubi.com game!
	do
		-- Ubi.com existing?
	    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
	    
	    	-- Start Ubi.com game
	    	MPMenu.Screen_ToUbiComStartingGame( _MapName, _MapType)
	    	
	    	-- Wait for Ubi.com game to be started
	    	return
	    	
	    end
	end
	

	-- Start game
	MPMenu.System_StartGame( _MapName, _MapType)
		
	
end

----------------------------------------------------------------------------------------------------
-- Client lost server!

function 
MPGame_ApplicationCallback_ClientLostHost( _MapName, _Parameter2 )

	-- Joiner joined?
	if MPMenu.GEN_ScreenID == 40 then
	
		-- Yes: set flag - need to change screen later, because we are in call back!
		MPMenu.S40_Var_ClientLostHost = 1
		
	end

		-- Joiner joined?
	if MPMenu.GEN_ScreenID == 45 then
	
		-- Yes: set flag - need to change screen later, because we are in call back!
		MPMenu.S45_Var_ClientLostHost = 1
		
	end
	
	-- In game?
	if MPMenu.GEN_ScreenID == 0 then

		-- Yes!

	end
	
end

----------------------------------------------------------------------------------------------------
-- Client left game

function 
MPGame_ApplicationCallback_ClientLeftGame( _NetworkAddress, _Parameter2 )

	-- Hosting TinCat session
	if MPMenu.GEN_ScreenID == 20 or MPMenu.GEN_ScreenID == 25 or MPMenu.GEN_ScreenID == 65 then
	
		-- Is the leaving one the selected?
		if _NetworkAddress == MPMenu.S20_Var_SelectedClientNetworkAddress then
			MPMenu.S20_Var_SelectedClientNetworkAddress = 0
		end
		
		if _NetworkAddress == MPMenu.S25_Var_SelectedClientNetworkAddress then
			MPMenu.S25_Var_SelectedClientNetworkAddress = 0
		end
		
	end
	
end

----------------------------------------------------------------------------------------------------
-- Local player should kick himself - used to transmit reason to client

function
MPMenu_ApplicationCallback_LocalUserKickSelf( _Reason, _Parameter2 )
	-- Are we in menu or in game
	if MPMenu.GEN_ScreenID ~= 0 then
	
		-- Menu!
		if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
	    -- Set Ubi.Com error -> this will result in entering the lobby
	    MPMenu.GEN_UbiComMinorErrorMessage =	XGUIEng.GetStringTableText( "MainMenuMP/MessageLocalPlayerKicked" ) .. " " .. _Reason  	    	
	  else
		  -- Set global error! Cannot switch to error mode directly, because we are in a
			-- CallBack! Error mode would delete network manager!
			MPMenu.GEN_MPCriticalErrorMessage = XGUIEng.GetStringTableText( "MainMenuMP/MessageLocalPlayerKicked" ) .. " " .. _Reason  	
	  end			
	end
end


----------------------------------------------------------------------------------------------------
-- Lost connection to Ubi.com

function
MPMenu_ApplicationCallback_LostUbiComConnection( _Reason, _Parameter2 )

	-- Are we in menu or in game
	if MPMenu.GEN_ScreenID ~= 0 then
	
		-- Menu!
		
		-- Set global error! Cannot switch to error mode directly, because we are in a
		-- CallBack! Error mode would delete network manager!
		MPMenu.GEN_MPCriticalErrorMessage = XGUIEng.GetStringTableText( "NetworkUbiCom/ErrorLostConnectionToUbiCom" )
					
	end

end


----------------------------------------------------------------------------------------------------
-- Account created callback

function
MPMenu_ApplicationCallback_UbiComAccountCreated( _ErrorMessage, _SuccessFlag )

	MPMenu.S76_CreatedAccount_Callback( _SuccessFlag, _ErrorMessage )
	
end

----------------------------------------------------------------------------------------------------
-- Account modified callback

function
MPMenu_ApplicationCallback_UbiComAccountModified( _ErrorMessage, _SuccessFlag )

	MPMenu.S76_ModifiedAccount_Callback( _SuccessFlag, _ErrorMessage )

end

----------------------------------------------------------------------------------------------------
-- Ubi.com critical error occured!

function
MPMenu_ApplicationCallback_UbiComCriticalErrorOccured( _ErrorMessage, _UbiComErrorMessage )
	-- Paste error messages
	local Message = _ErrorMessage 
	if _UbiComErrorMessage ~= nil and _UbiComErrorMessage ~= "" then
		Message = Message .. " - " .. _UbiComErrorMessage
	end

	-- Set error
	MPMenu.GEN_UbiComCriticalErrorMessage = Message
	
end

----------------------------------------------------------------------------------------------------
-- Ubi.com version update neede!

function
MPMenu_ApplicationCallback_UbiComVersionUpdateNeeded( _ErrorMessage, _UbiComErrorMessage )
	-- Paste error messages
	local Message = _ErrorMessage 
	if _UbiComErrorMessage ~= nil and _UbiComErrorMessage ~= "" then
		Message = Message .. " - " .. _UbiComErrorMessage
	end

	-- Set error
	MPMenu.GEN_UbiComUpdateMessage = Message
	
end

----------------------------------------------------------------------------------------------------
-- Ubi.com message of the day received

function
MPMenu_ApplicationCallback_UbiComMOTD( _Message, _MessageType )

	-- Print message
	MPMenu.S60_Tool_PrintMessage( _Message, 1 )

end


----------------------------------------------------------------------------------------------------
-- In game application callbacks - functions called by program DURING the game!
----------------------------------------------------------------------------------------------------
-- Quit game callback - called by network to close game/framework

MPGame_ApplicationCallback_QuitGame =
function( _PlayerID, _NetworkAddress )

	-- In game?
	if XNetwork.Manager_IsGameRunning() == 1 then
	
		-- Local player leaving?
		if XNetwork.Manager_GetLocalMachineLogicPlayerID() == _PlayerID then
			-- Update game result structure
			Framework.GameResult_Update()
			
			
			if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 and XNetworkUbiCom.Lobby_IsMatch() then
				XNetworkUbiCom.Lobby_Match_Exit()
			end
			-- Close game
			Framework.CloseGame()

			-- Ok - shut down network!
			return 1
			
		end
	
	end
	
	-- Nothing to be done
	return 0
	
end

----------------------------------------------------------------------------------------------------
-- Do quit game! Need to be done outside MPGame_ApplicationCallback_QuitGame! Because this is called 
-- from event execution deep inside network module!

MPGame_ApplicationCallback_DoQuitGame =
function( _Param1, _Param2 )

	-- Shut down system!
	MPMenu.System_ShutdownNetwork_TinCat()
	
end


----------------------------------------------------------------------------------------------------
-- Callbacks
----------------------------------------------------------------------------------------------------
-- Chat string input callback

function 
MPGame_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )

	-- Cheats, special commands
	do
		-- Allow MP games with just 1 team
		if _Message == "playalone" then
			XNetwork.GameInformation_SetMinimumNumberOfTeams( 1 )
			Sound.PlayGUISound( Sounds.Misc_Chat2, 0 )
			return
		end
		
		-- Ubi.com debug
		if _Message == "toggleubicomdebug" then
			if XNetworkUbiCom ~= nil then
				XNetworkUbiCom.Debug_PrintDebugStuff_Toggle()
				Sound.PlayGUISound( Sounds.Misc_Chat2, 0 )
			end
			return
		end
	end
	
	
	-- Network active?
    if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then

			local UserName = XNetwork.Manager_GetLocalMachineUserName()
			local UbiComName
			if XNetworkUbiCom ~= nil then
				UbiComName = XNetworkUbiCom.Manager_GetLocalUserUbiComAccountName()
			end
			
			if UbiComName ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
				UserName = UbiComName
			end



		-- Yes: send chat message
    	local Message 
    	if string.find(_Message, '/send') ~= 1 then
    		Message = UserName .. "> " .. _Message
    	else
    		Message = _Message
    	end
    
    	XNetwork.Chat_SendMessageToAll( Message )
    
	end
	
end

--------------------------------------------------------------------------------
-- Received chat message

function
MPGame_ApplicationCallback_ReceivedChatMessage( _Message, _Parameter2 )
	MPMenu.GEN_Tool_PrintChatMessage( _Message, 1 )	
end


----------------------------------------------------------------------------------------------------
-- Ubi.com chat string input callback

function 
MPGame_ApplicationCallback_UbiComChatStringInputDone( _Message, _WidgetID )

	-- Cheats, special commands
	do
		-- Ubi.com debug
		if _Message == "toggleubicomdebug" then
			if XNetworkUbiCom ~= nil then
				XNetworkUbiCom.Debug_PrintDebugStuff_Toggle()
				Sound.PlayGUISound( Sounds.Misc_Chat2, 0 )
			end
			return
		end
	end
	

	-- Network active?
    if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
    
    	-- Send out chat
    	XNetworkUbiCom.Chat_Send( _Message )
    	
	end
	
end

--------------------------------------------------------------------------------
-- Received Ubi.com chat message

function
MPGame_ApplicationCallback_ReceivedUbiComChatMessage( _Message, _Parameter2 )

	-- Print message
	MPMenu.S60_Tool_PrintMessage( _Message, 0 )
	
end


--------------------------------------------------------------------------------
-- To check if a multi player map is known on client side

function
MPGame_ApplicationCallback_IsMPMapKnown( _MapName, _MapGUID, _MapType)

	-- Is MP map known?
	local MapIndex = Framework.GetIndexOfMapName( _MapName, _MapType )
	if MapIndex == -1 then
		return 0
	end
	
	local MPFlag, MPPlayerNumber, MPFlagSet, MapGUID = Framework.GetMapMultiplayerInformation( _MapName, _MapType)
	if MapGUID ~= _MapGUID then
		return 1
	end
	
		
	-- Yeap!
	return 2
	
end


----------------------------------------------------------------------------------------------------
-- Main menu application access - functions called by network, Ubi.com to access application stuff
----------------------------------------------------------------------------------------------------
-- Get global string

function 
MPMenu_ApplicationAccess_GetGlobalString( _KeyName )

	local Result = ""
	
	if GDB.IsKeyValid( _KeyName ) then
		Result = GDB.GetString( _KeyName )
	end
	
	return Result

end

----------------------------------------------------------------------------------------------------
-- Set global string

function 
MPMenu_ApplicationAccess_SetGlobalString( _KeyName, _String )

	Result = GDB.SetString( _KeyName, _String )

end

----------------------------------------------------------------------------------------------------
-- Get global value

function 
MPMenu_ApplicationAccess_GetGlobalValue( _KeyName )

	local Result = ""
	
	if GDB.IsKeyValid( _KeyName ) then
		Result = GDB.GetValue( _KeyName )
	end
	
	return Result

end

----------------------------------------------------------------------------------------------------
-- Set global value

function 
MPMenu_ApplicationAccess_SetGlobalValue( _KeyName, _Value )

	Result = GDB.SetValue( _KeyName, _Value )

end

----------------------------------------------------------------------------------------------------
-- Does global value exist?

function 
MPMenu_ApplicationAccess_DoesGlobalValueExist( _KeyName )

	local Result = 0
	
	if GDB.IsKeyValid( _KeyName ) then
		Result = 1
	end
	
	return Result

end


----------------------------------------------------------------------------------------------------
-- Get map 'real' map name

function
MPMenu_ApplicationAccess_GetRealMPMapName( _MapName, _MapType )

	-- Any map?
	if _MapName == "" then
		return ""
	end
		
	-- Get map data
	local MapTitle, MapDesc = Framework.GetMapNameAndDescription( _MapName, _MapType )

	-- Return title
	return MapTitle
	
end


----------------------------------------------------------------------------------------------------
-- Base GUI callbacks
----------------------------------------------------------------------------------------------------
-- Key stroke

function
EGUIX_ApplicationCallback_Feedback_KeyStroke()
	Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )	
end

----------------------------------------------------------------------------------------------------
-- Button clicked

function
EGUIX_ApplicationCallback_Feedback_ButtonClicked()
	Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )	
end

----------------------------------------------------------------------------------------------------

