--------------------------------------------------------------------------------
-- User stuff
--------------------------------------------------------------------------------
-- Get player name

function UserTool_GetPlayerName( _PlayerID )

	-- Init name
	local PlayerName = XGUIEng.GetStringTableText("InGameMessages/GUI_Player") .. " " .. _PlayerID
		
	-- Network?
   	if XNetwork ~= nil and XNetwork.Manager_DoesExist() == 1 then
   	
   		-- Multi player: ask network
		local NetworkPlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( _PlayerID )
		if NetworkPlayerName ~= "" then
			PlayerName = NetworkPlayerName
		end
		
	else

		-- Single player
		if _PlayerID == GUI.GetPlayerID() then
			if GDB.IsKeyValid( "Config\\User\\Callsign" ) then
				PlayerName = GDB.GetString( "Config\\User\\Callsign" )
			end
		end
		
	end
	
	-- Return name
	return PlayerName
	
end

----------------------------------------------------------------------------------------------------
-- Get user's sex - 0: male; 1: female

function UserTool_GetLocalPlayerSex()

	local Sex = 0
	
	if GDB.IsKeyValid( "Config\\User\\Sex" ) then
		Sex = GDB.GetValue( "Config\\User\\Sex" )
	end

	return Sex
	
end

--------------------------------------------------------------------------------
