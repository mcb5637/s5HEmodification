-- The evil lurks within

SPMenu.AO2Campaign_03Maps= {}
SPMenu.AO2Campaign_03Maps[1] = "01_DemonDays"
SPMenu.AO2Campaign_03Maps[2] = "02_SecuringThePath"
SPMenu.AO2Campaign_03Maps[3] = "03_DarknessUprise"
SPMenu.AO2Campaign_03Maps[4] = "04_IntoShadowIntoLight"
SPMenu.CurrentAO2Campaign_03Map = "01_DemonDays"


----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.StartAO2Campaign3Map()
	
	Framework.StartMap( SPMenu.CurrentAO2Campaign_03Map, -1, "Extra2_3" )
	LoadScreen_Init( 0, SPMenu.CurrentAO2Campaign_03Map, -1, "Extra2_3" )
	
end

----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.UpdateCampaign2_3Map(_MapName)
	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_03Maps)
	for i=1,AmountOfMaps,1
	do

		local DisableHilightContainerNamer = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_BG"
		XGUIEng.HighLightButton( DisableHilightContainerNamer, 0 )
	end
	
	-- Hilight Selected Map
	local HilightBG = "AO2_3_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton( HilightBG, 1 )

	SPMenu.S62_UpdateMapDescription(_MapName)
	SPMenu.S62_UpdateMapTitle(_MapName)
	
	SPMenu.CurrentAO2Campaign_03Map = _MapName
end

----------------------------------------------------------------------------------------------------
-- 
--
function
SPMenu.S62_UpdateCampaign2_3Maps()

	XGUIEng.ShowAllSubWidgets( "SPM62_CampaignMaps", 0 )
	
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_03Maps)
	local latestMap = 0
	
	for i=1,AmountOfMaps,1
	do
		if i <= 1 then
			local CampaignBG = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_BG"
			XGUIEng.ShowWidget( CampaignBG , 1 )

			local CampaignButton = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_Button"
			XGUIEng.ShowWidget( CampaignButton , 1 )
			
			local HideCampaignContainerNamer = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. SPMenu.AO2Campaign_03Maps[i-1]			
			if GDB.GetValue( GDBKeyName) == 1 then		
			
				local CampaignBG = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_BG"
				XGUIEng.ShowWidget( CampaignBG , 1 )	

				local CampaignButton = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_Button"
				XGUIEng.ShowWidget( CampaignButton , 1 )	

				local HideCampaignContainerNamer = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i		
			end
		end
		
	end

	if latestMap <= 1 then 
			latestMap = 1
		end	
	local LatestCampainContainerNamer = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )	

	-- set selected map to latest Campaign Map	
	SPMenu.CurrentAO2Campaign_03Map = SPMenu.AO2Campaign_03Maps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S62_UpdateMapDescription(SPMenu.AO2Campaign_03Maps[latestMap])
	SPMenu.S62_UpdateMapTitle(SPMenu.AO2Campaign_03Maps[latestMap])
	
	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO2_3_" .. SPMenu.AO2Campaign_03Maps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end     


----------------------------------------------------------------------------------------------------
-- Update map name
--
function
SPMenu.S62_UpdateMapDescription(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_3" )

	-- Set text	
	XGUIEng.SetText( "SPM62_MapDetailsDescription", MapDescString )

end

----------------------------------------------------------------------------------------------------
-- Update map name Title
--
function
SPMenu.S62_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_3" )

	-- Set text	
	XGUIEng.SetText( "SPM62_MapDetailsTitle", MapNameString )

end

----------------------------------------------------------------------------------------------------
-- Check map cheat - entered in campaign menu
--
function
SPMenu.S62_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AO2MapCheats/WonMap_3_" .. _MapName
	local Cheat = XGUIEng.GetStringTableText( StringKeyName )
	
	if Cheat == nil or Cheat == "" then
		return
	end
	
	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. _MapName
	GDB.SetValue( GDBKeyName, 1 )	
	SPMenu.S62_UpdateCampaign2_3Maps()
	
	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	
	
end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback
 
function 
SPGame_S62_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )
	
	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_03Maps)
	
	for i=1,AmountOfMaps,1
	do
		SPMenu.S62_CheckMapCheat( _Message, SPMenu.AO2Campaign_03Maps[i] )
	end
			
end



