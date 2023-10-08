
SPMenu.AOCampaignMaps= {}
SPMenu.AOCampaignMaps[1] = "01_HugeBridge"
SPMenu.AOCampaignMaps[2] = "02_BigRiver"
SPMenu.AOCampaignMaps[3] = "03_BigCity"
SPMenu.AOCampaignMaps[4] = "04_TradingCaravans"
SPMenu.AOCampaignMaps[5] = "05_Headhunter"
SPMenu.AOCampaignMaps[6] = "06_TechOrResources"
SPMenu.AOCampaignMaps[7] = "07_FleeOrFight"
SPMenu.AOCampaignMaps[8] = "08_UnexploredLand"
SPMenu.AOCampaignMaps[9] = "10_FloodedLand"
SPMenu.AOCampaignMaps[10] = "10_FloodedLand"

SPMenu.CurrentAOCampaignMap = "01_HugeBridge"

----------------------------------------------------------------------------------------------------
-- Show campaign screen

function 
SPMenu.S00_ToAO2CampaignMenu()	
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu50", 1)
end
----------------------------------------------------------------------------------------------------
-- to campaign menues Shores in flames
function
SPMenu.S05_ToAO2Campaign01Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu60", 1)	
	SPMenu.S60_UpdateCampaign2_1Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues Emerald Battles
function
SPMenu.S05_ToAO2Campaign02Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu61", 1)	
	SPMenu.S61_UpdateCampaign2_2Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues The Evil lurks within
function
SPMenu.S05_ToAO2Campaign03Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu62", 1)	
	SPMenu.S62_UpdateCampaign2_3Maps()
end
----------------------------------------------------------------------------------------------------
-- to campaign menues Vision of Light
function
SPMenu.S05_ToAO2Campaign04Menu()
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu63", 1)	
	SPMenu.S63_UpdateCampaign2_4Maps()
end






