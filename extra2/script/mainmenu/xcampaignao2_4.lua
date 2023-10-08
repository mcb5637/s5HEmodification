-- Vision of light

SPMenu.AO2Campaign_04Maps= {}
SPMenu.AO2Campaign_04Maps[1] = "01_RestoringTheFaith"
SPMenu.AO2Campaign_04Maps[2] = "02_DefendingTheDryMoat"
SPMenu.AO2Campaign_04Maps[3] = "03_DivineAnger"
SPMenu.AO2Campaign_04Maps[4] = "04_TaintedLight"
SPMenu.CurrentAO2Campaign_04Map = "01_RestoringTheFaith"


----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.StartAO2Campaign4Map()
	
	Framework.StartMap( SPMenu.CurrentAO2Campaign_04Map, -1, "Extra2_4" )
	LoadScreen_Init( 0, SPMenu.CurrentAO2Campaign_04Map, -1, "Extra2_4" )
	
end

----------------------------------------------------------------------------------------------------
-- Update map name
--
function SPMenu.UpdateCampaign2_4Map(_MapName)
	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_04Maps)
	for i=1,AmountOfMaps,1
	do

		local DisableHilightContainerNamer = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_BG"
		XGUIEng.HighLightButton( DisableHilightContainerNamer, 0 )
	end
	
	-- Hilight Selected Map
	local HilightBG = "AO2_4_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton( HilightBG, 1 )

	SPMenu.S63_UpdateMapDescription(_MapName)
	SPMenu.S63_UpdateMapTitle(_MapName)
	
	SPMenu.CurrentAO2Campaign_04Map = _MapName
end

----------------------------------------------------------------------------------------------------
-- 
--
function
SPMenu.S63_UpdateCampaign2_4Maps()

	XGUIEng.ShowAllSubWidgets( "SPM63_CampaignMaps", 0 )
	
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_04Maps)
	local latestMap = 0
	
	for i=1,AmountOfMaps,1
	do
		if i <= 1 then
			local CampaignBG = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_BG"
			XGUIEng.ShowWidget( CampaignBG , 1 )

			local CampaignButton = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_Button"
			XGUIEng.ShowWidget( CampaignButton , 1 )
			
			local HideCampaignContainerNamer = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. SPMenu.AO2Campaign_04Maps[i-1]			
			if GDB.GetValue( GDBKeyName) == 1 then		

				local CampaignBG = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_BG"
				XGUIEng.ShowWidget( CampaignBG , 1 )	

				local CampaignButton = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_Button"
				XGUIEng.ShowWidget( CampaignButton , 1 )	

				local HideCampaignContainerNamer = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i		
			end
		end
		
	end

	if latestMap <= 1 then 
			latestMap = 1
		end	
	local LatestCampainContainerNamer = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )	

	-- set selected map to latest Campaign Map	
	SPMenu.CurrentAO2Campaign_04Map = SPMenu.AO2Campaign_04Maps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S63_UpdateMapDescription(SPMenu.AO2Campaign_04Maps[latestMap])
	SPMenu.S63_UpdateMapTitle(SPMenu.AO2Campaign_04Maps[latestMap])
	
	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO2_4_" .. SPMenu.AO2Campaign_04Maps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end     


----------------------------------------------------------------------------------------------------
-- Update map name
--
function
SPMenu.S63_UpdateMapDescription(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_4" )

	-- Set text	
	XGUIEng.SetText( "SPM63_MapDetailsDescription", MapDescString )

end

----------------------------------------------------------------------------------------------------
-- Update map name Title
--
function
SPMenu.S63_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra2_4" )

	-- Set text	
	XGUIEng.SetText( "SPM63_MapDetailsTitle", MapNameString )

end

----------------------------------------------------------------------------------------------------
-- Check map cheat - entered in campaign menu
--
function
SPMenu.S63_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AO2MapCheats/WonMap_4_" .. _MapName
	local Cheat = XGUIEng.GetStringTableText( StringKeyName )
	
	if Cheat == nil or Cheat == "" then
		return
	end
	
	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Campaign03\\WonMap_" .. _MapName
	GDB.SetValue( GDBKeyName, 1 )	
	SPMenu.S63_UpdateCampaign2_4Maps()
	
	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	
	
end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback
 
function 
SPGame_S63_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )
	
	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AO2Campaign_04Maps)
	
	for i=1,AmountOfMaps,1
	do
		SPMenu.S63_CheckMapCheat( _Message, SPMenu.AO2Campaign_04Maps[i] )
	end
			
end



