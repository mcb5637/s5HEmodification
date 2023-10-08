--------------------------------------------------------------------------------------------------------------------
--Trigger for PeaceTime

Script.Load( "Data\\Script\\MapTools\\Counter.lua" )


--------------------------------------------------------------------------------------------------------------------

function
Condition_PeaceTime()
	
	return 	Counter.Tick2("PeaceTime", MultiplayerTools.PeaceTime )
	
end

--------------------------------------------------------------------------------------------------------------------

function
Action_PeaceTime()
	
	GUI.AddNote( XGUIEng.GetStringTableText( "InGameMessages/Note_PeaceTimeOver" ) )
	
	GUIAction_ToggleStopWatch(0, 0)

	Sound.PlayGUISound( Sounds.OnKlick_Select_kerberos, 127 )
	
	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()
	
	return true
	
end

--------------------------------------------------------------------------------------------------------------------

function
Condition_PeaceTimeTech()
	
	for i= 1, 8, 1 
	do
		if MultiplayerTools.Teams[i] ~= nil then
		
			local AmountOfPlayersInTeam = table.getn(MultiplayerTools.Teams[i])
			
			for j = 1, AmountOfPlayersInTeam,1
			do
				local PlayerID = MultiplayerTools.Teams[i][j]
				local TechState = Logic.GetTechnologyState(PlayerID,MultiplayerTools.PeaceTime )
				
				if TechState == 4 then
					return true
				end
				
			end	
		end
	end
		
end

--------------------------------------------------------------------------------------------------------------------

function
Action_PeaceTimeTech()

	GUI.AddNote( XGUIEng.GetStringTableText( "InGameMessages/Note_PeaceTimeOver" ) )
	
	GUIAction_ToggleStopWatch(0, 0)
	
	Sound.PlayGUISound( Sounds.OnKlick_Select_kerberos, 127 )
	
	MultiplayerTools.SetUpDiplomacyOnMPGameConfig()
	
	return true

end

--------------------------------------------------------------------------------------------------------------------
