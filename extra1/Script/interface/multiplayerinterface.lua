--------------------------------------------------------------------------------
-- Multiplayer window stuff
--------------------------------------------------------------------------------

function
Interface_InitVCMP()
	
	XGUIEng.ShowWidget(gvGUI_WidgetID.VCMP_Window,1)	
	
	XGUIEng.ShowAllSubWidgets(gvGUI_WidgetID.VCMP_Window,0)	
	
	
	local j = 1
	for i= 1, 8, 1
	do
	
		if MultiplayerTools.Teams[ i ] ~= nil then
			
			XGUIEng.ShowWidget(gvGUI_WidgetID.VCMP_Team[j],1)					
			
			local GameType = XNetwork.GameInformation_GetMPFreeGameMode()		
			if GameType == 2 then					
				XGUIEng.ShowWidget(gvGUI_WidgetID.VCMP_TeamTechRace[j],1)
			elseif GameType == 3 then
				GUIAction_ToggleStopWatch(MultiplayerTools.PointGameTime, 1)
				XGUIEng.ShowWidget(gvGUI_WidgetID.VCMP_PointGame[j],1)
			end
			
			XGUIEng.SetBaseWidgetUserVariable(gvGUI_WidgetID.VCMP_Team[j], 0,i)					
			j = j + 1
			
		end
	end
	
	
	--force update of widgets
	XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)

end

function
GUIUpdate_VCTechRaceColor(_Player)
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)	
	local TeamID = XGUIEng.GetBaseWidgetUserVariable(MotherContainer, 0)
	
	local Alpha = 0
	local ColorR = 0
	local ColorG= 0 
	local ColorB = 0
	local SizeOfTeam  = 0
	
	if MultiplayerTools.Teams[TeamID] ~= nil then
		SizeOfTeam = table.getn(MultiplayerTools.Teams[TeamID])
	end
	
	if _Player <=  SizeOfTeam then
		local PlayerID = MultiplayerTools.Teams[TeamID][_Player]	
		
		if PlayerID ~= nil then
			Alpha = 255
			ColorR, ColorG, ColorB = GUI.GetPlayerColor( PlayerID )
		end
	end
	
	XGUIEng.SetMaterialColor(CurrentWidgetID,0,ColorR, ColorG, ColorB,Alpha)
	
end


function
GUIUpdate_VCTechRaceProgress()

	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
	local GrandMaContainer= XGUIEng.GetWidgetsMotherID(MotherContainer)
	local TeamID = XGUIEng.GetBaseWidgetUserVariable(GrandMaContainer, 0)
	
	local AmountOfTechnologiesToResearch = table.getn(MultiplayerTools.TechTable)		
	local AmountOfResearchedTechnologies = table.getn(MultiplayerTools.TeamTechTable[TeamID])
	
	
	XGUIEng.SetProgressBarValues(CurrentWidgetID,AmountOfResearchedTechnologies, AmountOfTechnologiesToResearch)
	
end


function
GUIUpdate_GetTeamPoints()
	
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	local MotherContainer= XGUIEng.GetWidgetsMotherID(CurrentWidgetID)
	local GrandMaContainer= XGUIEng.GetWidgetsMotherID(MotherContainer)
	local TeamID = XGUIEng.GetBaseWidgetUserVariable(GrandMaContainer, 0)
	
	if MultiplayerTools.GameFinished ~= nil or
	MultiplayerTools.GameFinished == 0 then
		
		Points = Score.GetTeamScore(TeamID, "all")
		XGUIEng.SetText(CurrentWidgetID, Points)	
	end
	
end