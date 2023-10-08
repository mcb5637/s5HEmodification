--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------
-- Toggle state

function Chat_Toggle( _AlliedOnlyFlag )

	-- Get chat widget
	local ChatWidgetID = XGUIEng.GetWidgetID( "ChatInput" )
	if ChatWidgetID ~= 0 then
	
		-- Toggle state
		if XGUIEng.IsWidgetShown( ChatWidgetID ) == 1 then
		
			-- Hide it!
			XGUIEng.ShowWidget( ChatWidgetID, 0 )
		
		else
		
			-- Network active?
		   	if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then

				-- Show it
				XGUIEng.ShowWidget( ChatWidgetID, 1 )
				
				-- Set global flag
				ChatToAlliedOnlyFlag = _AlliedOnlyFlag
	
			end			
		end
	end
end



----------------------------------------------------------------------------------------------------
-- GUI callbacks
----------------------------------------------------------------------------------------------------
-- Chat string input callback

function GameCallback_GUI_ChatStringInputDone( _Message, _WidgetID )

	-- Special commands
	do
		if _Message == "togglenetworkdebug" then
			GUI.NetworkWindow_ToggleDebug()
			--Sound.PlayGUISound( Sounds.Misc_Chat2, 0 )
			return
		end
	end
	
	
	
	-- Network active?
    if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then

		-- Yes: send chat message
		local PlayerID = GUI.GetPlayerID()
		local UserName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
		local ColorR, ColorG, ColorB = GUI.GetPlayerColor( PlayerID )
	   	local Message 
	    if string.find(_Message, '/send') ~= 1 then
	    	Message = "@color:" .. ColorR .. "," .. ColorG .. "," .. ColorB .. " " .. UserName .. " @color:255,255,255 > " .. _Message
	    else
	    	Message = _Message
	    end 
    
    
    	if ChatToAlliedOnlyFlag == 1 then
    		XNetwork.Chat_SendMessageToAllied( Message )
    	else
    		XNetwork.Chat_SendMessageToAll( Message )
    	end
    
    else
	
		-- Nope: add note directly
		GUI.AddNote( _Message )
	
	end

end



--------------------------------------------------------------------------------
-- GAME callbacks
--------------------------------------------------------------------------------
-- Received chat message

function
MPGame_ApplicationCallback_ReceivedChatMessage( _Message, _AlliedOnly, _SenderPlayerID )


	-- Allied only?
	if 		_AlliedOnly == 1 
		and _SenderPlayerID ~= GUI.GetPlayerID()
		and	Logic.GetDiplomacyState( _SenderPlayerID, GUI.GetPlayerID() ) ~= Diplomacy.Friendly 
	then
		return
	end
	
	
	-- Chat is ok!
	
	-- Sound feedback
	do

		if _SenderPlayerID ~= -1 then
		local UserName = XNetwork.GameInformation_GetLogicPlayerUserName( _SenderPlayerID )
		local ColorR, ColorG, ColorB = GUI.GetPlayerColor( _SenderPlayerID )
    	local PreMessage = "@color:" .. ColorR .. "," .. ColorG .. "," .. ColorB .. " " .. UserName .. " @color:255,255,255 > "
	
	
		local SoundID = Sounds.Misc_Chat
	
	
		-- Fun!!!
		if string.find( _Message, "yipie", 1, true ) ~= nil then
			SoundID = Sounds.Misc_Chat2
		elseif   string.find( _Message, "#01", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntYes		
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntYes")
		elseif   string.find( _Message, "#02", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNo
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNo")
		elseif   string.find( _Message, "#03", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNow
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNow")
		elseif   string.find( _Message, "#04", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntAttack
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntAttack")
		elseif   string.find( _Message, "#05", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntAttackArea
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntAttackArea")
		elseif   string.find( _Message, "#06", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntDefendArea
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntDefendArea")
		elseif   string.find( _Message, "#07", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntHelpMe
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntHelpMe")
		elseif   string.find( _Message, "#08", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNeedClay
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNeedClay")
		elseif   string.find( _Message, "#09", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNeedGold
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNeedGold")
		elseif   string.find( _Message, "#10", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNeedIron
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNeedIron")
		elseif   string.find( _Message, "#11", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNeedStone
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNeedStone")
		elseif   string.find( _Message, "#12", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNeedSulfur
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNeedSulfur")
		elseif   string.find( _Message, "#13", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntNeedWood
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntNeedWood")
		elseif   string.find( _Message, "#14", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntVeryGood
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntVeryGood")
		elseif   string.find( _Message, "#15", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntYouAreLame
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntYouAreLame")
		elseif   string.find( _Message, "#16", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntFunny01
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntFunny01")
		elseif   string.find( _Message, "#17", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntFunny02
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntFunny02")
		elseif   string.find( _Message, "#18", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntFunny03
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntFunny03")
		elseif   string.find( _Message, "#19", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntFunny04
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntFunny04")
		elseif   string.find( _Message, "#19", 1, true ) ~= nil then
			SoundID = Sounds.VoicesMentor_MP_TauntFunny05
			_Message = PreMessage .. XGUIEng.GetStringTableText("VoicesMentor/MP_TauntFunny05")
		end
		if   string.find( _Message, "#", 1, true ) ~= nil then
			Sound.PlayGUISound( SoundID, 0 )	
		else
			Sound.PlayFeedbackSound( SoundID, 0 )	
		end
		else
			Sound.PlayGUISound(Sounds.Misc_Chat, 0)
		end
	end
	
	
	-- Add chat as note
	GUI.AddNote( _Message )

end

--------------------------------------------------------------------------------
-- Received marker message

function
MPGame_ApplicationCallback_ReceivedMarkerMessage( _SenderPlayerID, _WorldX, _WorldY )

	-- Get local player ID
	local LocalPlayerID = GUI.GetPlayerID()
	
	-- Is local or allied player?
	if 		_SenderPlayerID == 0
		or	LocalPlayerID == _SenderPlayerID
		or	Logic.GetDiplomacyState( _SenderPlayerID, LocalPlayerID ) == Diplomacy.Friendly 
	then
	
		-- Add marker
		GUI.ScriptSignal( _WorldX, _WorldY, 2, 0 )

		-- Start feedback sound	
		Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	

	end
	
end



--------------------------------------------------------------------------------
-- Well, what a hack, but the easiest way to access logic via network!
-- A logic access interface would have helped a lot!!!

function
MPGame_ApplicationAccess_GetPlayerLeftLogicFlag( _PlayerID )

	-- Simply forward
	return Logic.PlayerGetLeftGameFlag( _PlayerID )
	
end


--------------------------------------------------------------------------------
-- NETWORK GAME CALLBACKS
--------------------------------------------------------------------------------
-- Player left game - info player, remove logic stuff, ...

function
MPGame_ApplicationCallback_PlayerLeftGame( _PlayerID, _Misc )

	-- Print message that player left
	do
	
		-- Get player name
		local PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( _PlayerID )
		
		-- Create message
		local Message = PlayerName .. " " .. XGUIEng.GetStringTableText( "InGameMessages/GUI_PlayerXLeftTheGame" )
		
		-- Add as note
		GUI.AddNote( Message )

	end
	
	
	-- Do logic exit stuff
	MultiplayerTools.PlayerLeftGame( _PlayerID )

	
	-- Check how many human player are still in game
	do
	
		-- Init variables
		local PlayerInGameCounter = 0
		local LocalPlayerInGameFlag = 0
	
		-- Count number of player in game and if local player is in game
		for PlayerID=1, XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer(), 1 do
		
			-- Check network address
			local PlayerNetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
			if PlayerNetworkAddress ~= 0 then
			
				-- Check playing in logic
				if Logic.PlayerGetGameState( PlayerID ) == 1 then
				
					-- Yeap: count player
					PlayerInGameCounter = PlayerInGameCounter + 1
					
					-- Is local player?
					if PlayerNetworkAddress == XNetwork.Manager_GetLocalMachineNetworkAddress() then
						LocalPlayerInGameFlag = 1
					end
				end
			end
		end

		-- Add note when only one player is left
		if PlayerInGameCounter == 1 then		
			if LocalPlayerInGameFlag == 1 then
				GUI.AddNote( XGUIEng.GetStringTableText( "NetworkBasics/MessageLocalPlayerIsTheLastInGame" ) )
			else
				GUI.AddNote( XGUIEng.GetStringTableText( "NetworkBasics/MessageOnlyOnePlayerInGame" ) )
			end
		end
		
	end

end

----------------------------------------------------------------------------------------------------
-- Local player should kick himself - used to transmit reason to client

function
MPGame_ApplicationCallback_LocalUserKickSelf( _Reason, _Parameter2 )

	-- Add as note
	GUI.AddNote( _Reason )


	-- Restart network module!
	XNetwork.Manager_RestartAsServer_SinglePlayer()


	-- Ubi.com game?
	if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
		-- Yeap: quit!
		XNetworkUbiCom.Manager_Destroy();
		
		-- Add as note
		GUI.AddNote( XGUIEng.GetStringTableText( "NetworkUbiCom/MessageLeftUbiCom" ) )
		
	end
	
end

--------------------------------------------------------------------------------
-- Game desynced (0), resynced (1)

function
MPGame_ApplicationCallback_SyncChanged( _Message, _SyncMode )

	-- Create message
	local Text = ""
	if _SyncMode == 0 then
		Text = XGUIEng.GetStringTableText( "NetworkBasics/MessageGameDeSync" )
		Framework.SaveGame( "DesyncSave", "This was saved upon desync!", true)
	else
		Text = XGUIEng.GetStringTableText( "NetworkBasics/MessageGameReSync" )
	end
	Text = Text  .. " - " .. _Message
	
	-- Add as note
	GUI.AddNote( Text )

end

----------------------------------------------------------------------------------------------------
-- Lost connection to Ubi.com

function
MPGame_ApplicationCallback_LostUbiComConnection( _Reason, _Parameter2 )

	-- Add as note
	GUI.AddNote( _Reason )

	-- Ubi.com game?
	if XNetworkUbiCom ~= nil and XNetworkUbiCom.Manager_DoesExist() == 1 then
	
		-- Yeap: quit Ubi.com manager ASAP 
		-- Not directly: we are in a callback now!
		XNetworkUbiCom.Manager_DestroyASAP();
		
		-- Add as note
		GUI.AddNote( XGUIEng.GetStringTableText( "NetworkUbiCom/MessageLeftUbiCom" ) )
		
	end

end

----------------------------------------------------------------------------------------------------
-- Print debug messge

function
MPGame_ApplicationCallback_PrintMessage( _Message, _Parameter2 )

	-- Add as note
	GUI.AddNote( _Message )

end


--------------------------------------------------------------------------------
-- Network window stuff
--------------------------------------------------------------------------------

function 
GUIUpdate_NetworkWindow_PlayerName( _Index )

	-- Init text
	local Text = ""
	
	-- Network running?
	if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then
	
		-- Get player ID
		local PlayerID = _Index + 1 
		
		-- Get network addresses of host and player
		local HostNetworkAddress = XNetwork.Host_UserInSession_GetHostNetworkAddress()
		local PlayerNetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )

		-- Is player host?
		if HostNetworkAddress == PlayerNetworkAddress then
			Text = Text .. "(*) " 
		end
		
		-- Player that left game?
		if XNetwork.GameInformation_IsHumanPlayerThatLeftAttachedToPlayerID( PlayerID ) == 1 then
			Text = Text .. "@color:160,160,160 "
		end
		
		-- Get name
		local Name = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
		if Name ~= "" then
		
			-- Add player info
			
			local UbiComAccountName = ""
			local Ping = 0
			
			if PlayerNetworkAddress ~= 0 then
				UbiComAccountName = XNetwork.UserInSession_GetUbiComAccountNameByNetworkAddress( PlayerNetworkAddress )
				Ping = XNetwork.Ping_Get( PlayerNetworkAddress )
			end
			
			Text = Text .. Name
				
			--if UbiComAccountName ~= "" then
			--	Text = Text .. "   (" .. UbiComAccountName .. ")"
			--end
				
			if Ping ~= 0 then
				Text = Text .. "   (" .. Ping .. ")"
			end
			
			if PlayerNetworkAddress == 0 then
				Text = Text .. "      (" .. XGUIEng.GetStringTableText( "NetworkBasics/MessagePlayerNotInGame" ) .. ")"
			end
			
		else
		
			-- Nameless player
			Text = Text .. "-"
			
		end
		
	end

	-- Set text
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )		
	
end

--------------------------------------------------------------------------------
-- Kick player

function 
GUIAction_NetworkWindow_KickPlayer( _Index )

	local Text = ""
	
	if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then
	
		local PlayerID = _Index + 1 
		local NetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID( PlayerID )
		
		if NetworkAddress ~= 0 then
			XNetwork.Manager_KickPlayerOutOfSession( NetworkAddress )
		end
		
	end
	
end
		

--------------------------------------------------------------------------------

function 
GUIUpdate_NetworkProblemWindow_Reason()

	local Reason = XNetwork.GameSystem_GetReasonForHanging()
	
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Reason )		
		
end


----------------------------------------------------------------------------------------------------
-- UNFILED - Base GUI callbacks
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