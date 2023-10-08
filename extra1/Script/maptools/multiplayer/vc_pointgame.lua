--------------------------------------------------------------------------------
-- Point Game
--------------------------------------------------------------------------------

MultiplayerTools.GameFinished = 0
MultiplayerTools.PointGameTime = 3600


--------------------------------------------------------------------------------------------------------------------
-- Activte Interface

Interface_InitVCMP()

		
--------------------------------------------------------------------------------------------------------------------
-- Check if a team has most points

function 
VC_PointGame()
	
	if MultiplayerTools.GameFinished == 1 then
		return
	end
	
	
	local BestTeam = 0
	local MostPoints = 0
	
	
	if Logic.GetTime() >= MultiplayerTools.PointGameTime then
	
		
		for i= 1, 8, 1
		do
	
			if MultiplayerTools.Teams[ i ] ~= nil then
			
				local Points = Score.GetTeamScore(i)
				
				if Points > MostPoints then
					MostPoints = Points
					BestTeam = i
				end
				
			end
		end
		
	
		local LocalPlayer = GUI.GetPlayerID()
		local LocalTeam = XNetwork.GameInformation_GetLogicPlayerTeam(LocalPlayer)
		
		
		if LocalTeam == BestTeam then								
			local Text = XGUIEng.GetStringTableText( "InGameMessages/Note_PointGameWon")
			XGUIEng.SetText(gvGUI_WidgetID.GameEndScreenMessage	, MostPoints .. Text ) 
			XGUIEng.AddRawTextAtEnd( "GameEndScreen_MessageDetails", MostPoints .. Text .. "\n"  )
		else
			local Points = Score.GetTeamScore(LocalTeam)				
			local Text = XGUIEng.GetStringTableText( "InGameMessages/Note_PointGameLost")
			XGUIEng.SetText(gvGUI_WidgetID.GameEndScreenMessage	, Points  .. Text )
			XGUIEng.AddRawTextAtEnd( "GameEndScreen_MessageDetails", Points .. Text .. "\n"  )
		end
		
		
		XGUIEng.ShowWidget( gvGUI_WidgetID.GameEndScreen,1 )				
		
		
		GUIAction_ToggleStopWatch(0, 0)
		MultiplayerTools.GameFinished = 1
		
	end
	
end


--------------------------------------------------------------------------------------------------------------------
