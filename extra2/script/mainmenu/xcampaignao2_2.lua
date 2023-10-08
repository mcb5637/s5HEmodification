-- Emerald Battles

SPMenu.AO2Campaign_02Maps= {}
SPMenu.AO2Campaign_02Maps[1] = "01_Revenge"
SPMenu.AO2Campaign_02Maps[2] = "02_TheRichLand"
SPMenu.AO2Campaign_02Maps[3] = "03_TheBeautifulLand"
SPMenu.AO2Campaign_02Maps[4] = "04_BrutePower"
SPMenu.AO2Campaign_02Maps[5] = "05_EmeraldFields"
SPMenu.CurrentAO2Campaign_02Map = "01_Revenge"


----------------------------------------------------------------------------------------------------
-- Start campaign map
--
function SPMenu.StartAO2Campaign2Map()

	Framework.StartMap( SPMenu.CurrentAO2Campaign_02Map, -1, "Extra2_2" )
	LoadScreen_Init( 0, SPMenu.CurrentAO2Campaign_02Map, -1, "Extra2_2" )
	
end

----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.UpdateCampaign2_2Map(_MapName)

	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_02Maps)
	for i=1,AmountOfMaps,1
	do

		local DisableHilightContainerNamer = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_BG"
		XGUIEng.HighLightButton( DisableHilightContainerNamer, 0 )
	end
	
	-- Hilight Selected Map
	local HilightBG = "AO2_2_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton( HilightBG, 1 )

	SPMenu.S61_UpdateMapDescription(_MapName)
	SPMenu.S61_UpdateMapTitle(_MapName)
	
	SPMenu.CurrentAO2Campaign_02Map = _MapName
end

----------------------------------------------------------------------------------------------------
-- 
--
function
SPMenu.S61_UpdateCampaign2_2Maps()

	XGUIEng.ShowAllSubWidgets( "SPM61_CampaignMaps", 0 )
	
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_02Maps)
	local latestMap = 0
	
	for i=1,AmountOfMaps,1
	do
		if i <= 1 then
		
			local CampaignBG = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_BG"
			XGUIEng.ShowWidget( CampaignBG , 1 )

			local CampaignButton = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_Button"
			XGUIEng.ShowWidget( CampaignButton , 1 )

			local HideCampaignContainerNamer = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. SPMenu.AO2Campaign_02Maps[i-1]			
			if GDB.GetValue( GDBKeyName) == 1 then		
			
				local CampaignBG = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_BG"
				XGUIEng.ShowWidget( CampaignBG , 1 )

				local CampaignButton = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_Button"
				XGUIEng.ShowWidget( CampaignButton , 1 )

				local HideCampaignContainerNamer = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i		
			end
		end
		
	end

	if latestMap <= 1 then 
			latestMap = 1
		end	
	local LatestCampainContainerNamer = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )	

	-- set selected map to latest Campaign Map	
	SPMenu.CurrentAO2Campaign_02Map = SPMenu.AO2Campaign_02Maps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S61_UpdateMapDescription(SPMenu.AO2Campaign_02Maps[latestMap])
	SPMenu.S61_UpdateMapTitle(SPMenu.AO2Campaign_02Maps[latestMap])
	
	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO2_2_" .. SPMenu.AO2Campaign_02Maps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end     


----------------------------------------------------------------------------------------------------
-- Update map name
--
function
SPMenu.S61_UpdateMapDescription(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_2" )

	-- Set text	
	XGUIEng.SetText( "SPM61_MapDetailsDescription", MapDescString )

end

----------------------------------------------------------------------------------------------------
-- Update map name Title
--
function
SPMenu.S61_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_2" )

	-- Set text	
	XGUIEng.SetText( "SPM61_MapDetailsTitle", MapNameString )

end

----------------------------------------------------------------------------------------------------
-- Check map cheat - entered in campaign menu
--
function
SPMenu.S61_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AO2MapCheats/WonMap_2_" .. _MapName
	local Cheat = XGUIEng.GetStringTableText( StringKeyName )
	
	if Cheat == nil or Cheat == "" then
		return
	end
	
	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. _MapName
	GDB.SetValue( GDBKeyName, 1 )	
	SPMenu.S61_UpdateCampaign2_2Maps()
	
	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	
	
end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback
 
function 
SPGame_S61_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )
	
	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_02Maps)
	
	for i=1,AmountOfMaps,1
	do
		SPMenu.S61_CheckMapCheat( _Message, SPMenu.AO2Campaign_02Maps[i] )
	end
			
end



