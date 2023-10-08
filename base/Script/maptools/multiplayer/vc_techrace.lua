--------------------------------------------------------------------------------
-- Tech Race
--------------------------------------------------------------------------------

MultiplayerTools.GameFinished = 0

MultiplayerTools.TechTable =
							{
							Technologies.GT_Mercenaries,
							Technologies.GT_StandingArmy,
							Technologies.GT_Tactics,
							Technologies.GT_Strategies,
								
							Technologies.GT_Construction,
							Technologies.GT_ChainBlock,
							Technologies.GT_GearWheel,
							Technologies.GT_Architecture,
							
							Technologies.GT_Alchemy,
							Technologies.GT_Alloying,
							Technologies.GT_Metallurgy,
							Technologies.GT_Chemistry,
							
							Technologies.GT_Literacy,
							Technologies.GT_Trading,
							Technologies.GT_Printing,
							Technologies.GT_Library
							}	

--overwrite the table for the AddOn
if MultiplayerTools.AOTechTable ~= nil then	
	MultiplayerTools.AOTechTable()
end
--------------------------------------------------------------------------------------------------------------------
--activte Interface

Interface_InitVCMP()


--------------------------------------------------------------------------------------------------------------------
--Add reserached  technology to Team table

function
VC_OnTechnologyResearched( _PlayerID, _TechnologyType )
	
	
	local PlayerTeam = XNetwork.GameInformation_GetLogicPlayerTeam(_PlayerID)
	
	
	for i= 1, table.getn(MultiplayerTools.TechTable), 1
	do
		if _TechnologyType ==  MultiplayerTools.TechTable[i] then		
			local ResearchedTechnologies = table.getn(MultiplayerTools.TeamTechTable[PlayerTeam])
			
			if ResearchedTechnologies == 0 or ResearchedTechnologies == nil then
				ResearchedTechnologies = 1
			end
			
			local TechAllreadyInsert = 0
			
			for j=1, ResearchedTechnologies ,1
			do
				if _TechnologyType == MultiplayerTools.TeamTechTable[PlayerTeam][j] then
					TechAllreadyInsert = 1
					break					
				end
			end
			
			if TechAllreadyInsert == 0 then
				table.insert(MultiplayerTools.TeamTechTable[PlayerTeam], _TechnologyType)
			end
			
		end
	end
	
end

		
--------------------------------------------------------------------------------------------------------------------
--check if a team has reserached all technologies

function 
VC_TechRace()
	
	if MultiplayerTools.GameFinished == 1 then
		return
	end

	
	local LocalPlayer = GUI.GetPlayerID()
	local LocalTeam = XNetwork.GameInformation_GetLogicPlayerTeam(LocalPlayer)
		
	local AmountOfTechnologiesToResearch = table.getn(MultiplayerTools.TechTable)
	local WinnerTeam = 0
	

	-- Check for one winner team
	do
			
		for i= 1, 8, 1 do
		
			if MultiplayerTools.Teams[ i ] ~= nil then
				
				
				local AmountOfResearchedTechnologies = table.getn(MultiplayerTools.TeamTechTable[i])
				
	
				if AmountOfResearchedTechnologies >= AmountOfTechnologiesToResearch then
					
					if LocalTeam ~= i then					
						GUI.AddNote( XGUIEng.GetStringTableText( "InGameMessages/Note_PlayerTeamLost" ) )
						XGUIEng.AddRawTextAtEnd( "GameEndScreen_MessageDetails", XGUIEng.GetStringTableText( "InGameMessages/Note_PlayerTeamLost" ) .. "\n"  )
					else
						GUI.AddNote( XGUIEng.GetStringTableText( "InGameMessages/Note_TeamWonGame" ))
						XGUIEng.AddRawTextAtEnd( "GameEndScreen_MessageDetails", XGUIEng.GetStringTableText( "InGameMessages/Note_TeamWonGame" ) .. "\n"  )
					end
					
					
					for j=1,8,1
					do
						if MultiplayerTools.Teams[ i ][ j ] ~= nil then
							if Logic.PlayerGetGameState(MultiplayerTools.Teams[ i ][ j ]) == 1 then
								Logic.PlayerSetGameStateToWon(MultiplayerTools.Teams[ i ][ j ])
							end
						end
					end
					
					WinnerTeam = i
					MultiplayerTools.GameFinished = 1
					
				end
		
			end
			
		end
		
	end
	
	
	-- Some body won?
	if WinnerTeam ~= 0 then

		-- Mark all other teams as looser		
		for i=1, 8, 1 do

			if i ~= WinnerTeam then
			
				if MultiplayerTools.Teams[ i ] ~= nil then
					
					for k=1,8,1 do			
						if MultiplayerTools.Teams[ i ][ k ] ~= nil then
							if Logic.PlayerGetGameState(MultiplayerTools.Teams[ i ][ k ]) == 1 then
								Logic.PlayerSetGameStateToLost(MultiplayerTools.Teams[ i ][ k ])
							end
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
