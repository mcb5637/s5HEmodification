
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
SPMenu.S00_ToAOCampaignMenu()

	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget("SPMenu40", 1)
	SPMenu.S40_UpdateCampaignMaps()

end



function SPMenu.StartAOCampaignMap()
	
	Framework.StartMap( SPMenu.CurrentAOCampaignMap, -1, "Extra1" )
	LoadScreen_Init( 0, SPMenu.CurrentAOCampaignMap, -1, "Extra1" )
	
end


function SPMenu.UpdateCampaignMap(_MapName)
	-- Switch off all HiLights for all maps
	local AmountOfMaps = table.getn(SPMenu.AOCampaignMaps)
	for i=1,AmountOfMaps,1
	do

		local DisableHilightContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[i] .. "_BG"
		XGUIEng.HighLightButton( DisableHilightContainerNamer, 0 )
	end
	
	-- Hilight Selected Map
	local HilightBG = "AO_" .. _MapName .. "_BG"
	XGUIEng.HighLightButton( HilightBG, 1 )

	SPMenu.S40_UpdateMapDescription(_MapName)
	SPMenu.S40_UpdateMapTitle(_MapName)
	
	SPMenu.CurrentAOCampaignMap = _MapName
end

function
SPMenu.S40_UpdateCampaignMaps()

	XGUIEng.ShowAllSubWidgets( "SPM40_CampaignMaps", 0 )
	
	local AmountOfMaps = table.getn(SPMenu.AOCampaignMaps)
	local latestMap = 0
	
	for i=1,AmountOfMaps,1
	do
		if i <= 1 then
			local CampaignContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[i]
			XGUIEng.ShowWidget( CampaignContainerNamer , 1 )

			local HideCampaignContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[i] .. "_flag"
			XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )
		else
			local GDBKeyName = 	"Game\\Campaign02\\WonMap_" .. SPMenu.AOCampaignMaps[i-1]
			if GDB.GetValue( GDBKeyName) == 1 then		
				local CampaignContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[i]
				XGUIEng.ShowWidget( CampaignContainerNamer , 1 )	

				local HideCampaignContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[i] .. "_flag"
				XGUIEng.ShowWidget( HideCampaignContainerNamer , 0 )

				latestMap = i		
			end
		end
		
	end

	if latestMap <= 1 then 
			latestMap = 1
		end	
	local LatestCampainContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[latestMap] .. "_flag"
	XGUIEng.ShowWidget( LatestCampainContainerNamer , 1 )	

	-- set selected map to latest Campaign Map	
	SPMenu.CurrentAOCampaignMap = SPMenu.AOCampaignMaps[latestMap]

	-- display map info of latest Campain Map
	SPMenu.S40_UpdateMapDescription(SPMenu.AOCampaignMaps[latestMap])
	SPMenu.S40_UpdateMapTitle(SPMenu.AOCampaignMaps[latestMap])
	
	-- Hilight Button for latest Campaign Map
	local DisableHilightContainerNamer = "AO_" .. SPMenu.AOCampaignMaps[latestMap] .. "_BG"
	XGUIEng.HighLightButton( DisableHilightContainerNamer, 1 )
end     


----------------------------------------------------------------------------------------------------
-- Update map name

function
SPMenu.S40_UpdateMapDescription(_MapName)

--	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( MapName, _MapType, _CampaignName )
	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra1" )

	-- Set text	
	XGUIEng.SetText( "SPM40_MapDetailsDescription", MapDescString )

end
----------------------------------------------------------------------------------------------------
-- Update map name Title

function
SPMenu.S40_UpdateMapTitle(_MapName)

	local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, -1, "Extra1" )

	-- Set text	
	XGUIEng.SetText( "SPM40_MapDetailsTitle", MapNameString )
	
	--XGUIEng.SetText( "SPM40_MapDetailsTitle", _MapName )

end



-- Check map cheat - entered in campaign menu

function
SPMenu.S40_CheckMapCheat( _Message, _MapName )

	local StringKeyName = "AddOnMapCheats/WonMap_" .. _MapName
	local Cheat = XGUIEng.GetStringTableText( StringKeyName )
	
	if Cheat == nil or Cheat == "" then
		return
	end
	
	if _Message ~= Cheat then
		return
	end

	local GDBKeyName = 	"Game\\Campaign02\\WonMap_" .. _MapName
	GDB.SetValue( GDBKeyName, 1 )
	SPMenu.S40_UpdateCampaignMaps()
	
	Sound.PlayGUISound( Sounds.Misc_Chat, 0 )	
	
end

----------------------------------------------------------------------------------------------------
-- Cheat string input callback
 
function 
SPGame_S40_ApplicationCallback_ChatStringInputDone( _Message, _WidgetID )

	-- Check map cheats
	local AmountOfMaps = table.getn(SPMenu.AOCampaignMaps)
	
	for i=1,AmountOfMaps,1
	do
		SPMenu.S40_CheckMapCheat( _Message, SPMenu.AOCampaignMaps[i] )
	end
	
		
end