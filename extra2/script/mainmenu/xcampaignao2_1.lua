-- Shores in flames

SPMenu.AO2Campaign_01Maps= {}
SPMenu.AO2Campaign_01Maps[1] = "01_NewBeginning"
SPMenu.AO2Campaign_01Maps[2] = "02_Patrol"
SPMenu.AO2Campaign_01Maps[3] = "03_Neighborhood"
SPMenu.AO2Campaign_01Maps[4] = "04_WolfsLair"
SPMenu.CurrentAO2Campaign_01Map = "01_NewBeginning"


----------------------------------------------------------------------------------------------------
-- Start campaign map
--
function SPMenu.StartAO2Campaign1Map()
		
	Framework.StartMap( SPMenu.CurrentAO2Campaign_01Map, -1, "Extra2_1" )
	LoadScreen_Init( 0, SPMenu.CurrentAO2Campaign_01Map, -1, "Extra2_1" )
	
end

----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.UpdateCampaign2_1Map(_MapName)
	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_01Maps)
	for i=1,AmountOfMaps,1
	do

		local DisableHilightContainerNamer = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_BG"
		XGUIEng.HighLightButton( DisableHilightContainerNamer, 0 )
	end
	
	-- Hilight Selected Map
	local HilightBG = "AO2_1_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton( HilightBG, 1 )

	SPMenu.S60_UpdateMapDescription(_MapName)
	SPMenu.S60_UpdateMapTitle(_MapName)
	
	SPMenu.CurrentAO2Campaign_01Map = _MapName
end

----------------------------------------------------------------------------------------------------
-- 
--
function
SPMenu.S60_UpdateCampaign2_1Maps()

	XGUIEng.ShowAllSubWidgets( "SPM60_CampaignMaps", 0 )
	
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_01Maps)
	local latestMap = 0
	
	for i=1,AmountOfMaps,1
	do
		if i <= 1 then
		
			local CampaignBG = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_BG"
			XGUIEng.ShowWidget( CampaignBG , 1 )

			local CampaignButton = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_Button"
			XGUIEng.ShowWidget( CampaignButton , 1 )
			
			local HideCampaignContainerNamer = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. SPMenu.AO2Campaign_01Maps[i-1]			
			if GDB.GetValue( GDBKeyName) == 1 then		

				local CampaignBG = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_BG"
				XGUIEng.ShowWidget( CampaignBG , 1 )	

				local CampaignButton = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_Button"
				XGUIEng.ShowWidget( CampaignButton , 1 )	

				local HideCampaignContainerNamer = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i		
			end
		end
		
	end

	if latestMap <= 1 then 
			latestMap = 1
		end	
	local LatestCampainContainerNamer = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )	

	-- set selected map to latest Campaign Map	
	SPMenu.CurrentAO2Campaign_01Map = SPMenu.AO2Campaign_01Maps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S60_UpdateMapDescription(SPMenu.AO2Campaign_01Maps[latestMap])
	SPMenu.S60_UpdateMapTitle(SPMenu.AO2Campaign_01Maps[latestMap])
	
	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO2_1_" .. SPMenu.AO2Campaign_01Maps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end     


----------------------------------------------------------------------------------------------------
-- Update map name
--
function
SPMenu.S60_UpdateMapDescription(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_1" )

	-- Set text	
	XGUIEng.SetText( "SPM60_MapDetailsDescription", MapDescString )

end

----------------------------------------------------------------------------------------------------
-- Update map name Title
--
function
SPMenu.S60_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_1" )

	-- Set text	
	XGUIEng.SetText( "SPM60_MapDetailsTitle", MapNameString )

end

----------------------------------------------------------------------------------------------------
-- Check map cheat - entered in campaign menu
--
function
SPMenu.S60_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AO2MapCheats/WonMap_1_" .. _MapName
	local Cheat = XGUIEng.GetStringTableText( StringKeyName )
	
	if Cheat == nil or Cheat == "" then
		return
	end
	
	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. _MapName
	GDB.SetValue( GDBKeyName, 1 )	
	SPMenu.S60_UpdateCampaign2_1Maps()
	
	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	
	
end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback
 
function 
SPGame_S60_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )
	
	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_01Maps)
	
	for i=1,AmountOfMaps,1
	do
		SPMenu.S60_CheckMapCheat( _Message, SPMenu.AO2Campaign_01Maps[i] )
	end
			
end



