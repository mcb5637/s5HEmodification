--------------------------------------------------------------------------------------------------------------------
-- Table to hold multi player tools stuff
MultiplayerTools = {}

--Needed so the Merchants will work in the Addon
Script.Load("Data\\Script\\MapTools\\MultiPlayer\\AOMultiPlayerTools.lua")
Script.Load( "Data\\Script\\MapTools\\GlobalMissionScripts.lua" )
Script.Load( "Data\\Script\\MapTools\\Tools.lua" )	
Script.Load("Data\\Script\\MapTools\\Comfort.lua")		
Script.Load("Data\\Script\\MapTools\\Ai\\Support.lua")
Script.Load("Data\\Script\\MapTools\\Quests.lua")
Script.Load("Data\\Script\\MapTools\\Information.lua")
Script.Load("Data\\Script\\MapTools\\NPC.lua")
Script.Load( "Data\\Script\\MapTools\\WeatherSets.lua" )

--------------------------------------------------------------------------------------------------------------------
-- Set up mp logic stuff: set diplomacy state, share exploration, transfer names into logic, ...

function 
MultiplayerTools.SetUpGameLogicOnMPGameConfig()


	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
		
	
	-- Transfer player names
	do
		for PlayerID=1, HumenPlayer, 1 do
			local PlayerName = XNetwork.GameInformation_GetLogicPlayerUserName( PlayerID )
			Logic.SetPlayerRawName( PlayerID, PlayerName )			
		end
	end
	
	
	-- Set game state & human flag - transfer player color (needed in logic for post game statistics)
	do
		for PlayerID=1, HumenPlayer, 1 do			
			local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( PlayerID )
			if IsHumanFlag == 1 then
				Logic.PlayerSetGameStateToPlaying( PlayerID )			
				Logic.PlayerSetIsHumanFlag( PlayerID, 1 )
				
				local PlayerColorR, PlayerColorG, PlayerColorB = GUI.GetPlayerColor( PlayerID )
				Logic.PlayerSetPlayerColor( PlayerID, PlayerColorR, PlayerColorG, PlayerColorB )
			end
		end
	end
	
	
	-- Remove entities of humen player that are not in the game
	do
		for PlayerID=1, HumenPlayer, 1 do
			local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( PlayerID )
			if IsHumanFlag == 0 then
				MultiplayerTools.RemoveAllPlayerEntities( PlayerID )	
			end
		end
	end
	
	
	
	-- ???
	MultiplayerTools.CreateMPTables()
	
	-- Set up FoW
	MultiplayerTools.SetUpFogOfWarOnMPGameConfig()
	
	-- Set up game mode
	MultiplayerTools.SetMPGameMode()
	
	
	--[AnSu] I have to make a function to init the MP Interface
	--XGUIEng.ShowWidget(gvGUI_WidgetID.DiplomacyWindowMiniMap,0)	
	XGUIEng.ShowWidget(gvGUI_WidgetID.NetworkWindowInfoCustomWidget,1)	
	
	
	
	--Extra keybings only in MP 
	Input.KeyBindDown(Keys.NumPad0, "KeyBindings_MPTaunt(1,1)", 2)  --Yes
	Input.KeyBindDown(Keys.NumPad1, "KeyBindings_MPTaunt(2,1)", 2)  --No
	Input.KeyBindDown(Keys.NumPad2, "KeyBindings_MPTaunt(3,1)", 2)  --Now	
	Input.KeyBindDown(Keys.NumPad3, "KeyBindings_MPTaunt(7,1)", 2)  --help
	Input.KeyBindDown(Keys.NumPad4, "KeyBindings_MPTaunt(8,1)", 2)  --clay
	Input.KeyBindDown(Keys.NumPad5, "KeyBindings_MPTaunt(9,1)", 2)  --gold
	Input.KeyBindDown(Keys.NumPad6, "KeyBindings_MPTaunt(10,1)", 2) --iron	
	Input.KeyBindDown(Keys.NumPad7, "KeyBindings_MPTaunt(11,1)", 2) --stone
	Input.KeyBindDown(Keys.NumPad8, "KeyBindings_MPTaunt(12,1)", 2) --sulfur
	Input.KeyBindDown(Keys.NumPad9, "KeyBindings_MPTaunt(13,1)", 2) --wood
	
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad0, "KeyBindings_MPTaunt(5,1)", 2)  --attack here
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "KeyBindings_MPTaunt(6,1)", 2)  --defend here
	
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad2, "KeyBindings_MPTaunt(4,0)", 2)  --attack you
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad3, "KeyBindings_MPTaunt(14,0)", 2) --VeryGood
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "KeyBindings_MPTaunt(15,0)", 2) --Lame
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "KeyBindings_MPTaunt(16,0)", 2) --funny comments 
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad6, "KeyBindings_MPTaunt(17,0)", 2) --funny comments 
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "KeyBindings_MPTaunt(18,0)", 2) --funny comments 
	Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "KeyBindings_MPTaunt(19,0)", 2) --funny comments 
	
end


--------------------------------------------------------------------------------------------------------------------
-- Set up diplomacy state 

function 
MultiplayerTools.SetUpDiplomacyOnMPGameConfig()

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
		
	-- Free alliances allowed?
	if XNetwork.GameInformation_GetFreeAlliancesFlag() == 1 then

		-- Update relation and fow
		if HumenPlayer > 1 then
			for SrcPlayerID=1, HumenPlayer, 1 do
				for DstPlayerID=1, HumenPlayer, 1 do
					if SrcPlayerID ~= DstPlayerID then
						local SrcTeam = XNetwork.GameInformation_GetLogicPlayerTeam( SrcPlayerID )
						local DstTeam = XNetwork.GameInformation_GetLogicPlayerTeam( DstPlayerID )
						if SrcTeam == DstTeam then
							Logic.SetDiplomacyState( DstPlayerID, SrcPlayerID, Diplomacy.Friendly )							
						else
							Logic.SetDiplomacyState( DstPlayerID, SrcPlayerID, Diplomacy.Hostile )
						end
					end
				end
			end
		end

	end	
	
end


--------------------------------------------------------------------------------------------------------------------
-- Set up Fog of War

function 
MultiplayerTools.SetUpFogOfWarOnMPGameConfig()

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
		
	-- Free alliances allowed?
	if XNetwork.GameInformation_GetFreeAlliancesFlag() == 1 then

		-- Update relation and fow
		if HumenPlayer > 1 then
			for SrcPlayerID=1, HumenPlayer, 1 do
				for DstPlayerID=1, HumenPlayer, 1 do
					if SrcPlayerID ~= DstPlayerID then
						local SrcTeam = XNetwork.GameInformation_GetLogicPlayerTeam( SrcPlayerID )
						local DstTeam = XNetwork.GameInformation_GetLogicPlayerTeam( DstPlayerID )
						if SrcTeam == DstTeam then							
							Logic.SetShareExplorationWithPlayerFlag( SrcPlayerID, DstPlayerID, 1 )
							Logic.SetShareExplorationWithPlayerFlag( DstPlayerID, SrcPlayerID, 1 )						
						end
					end
				end
			end
		end

	end	
	
end


--------------------------------------------------------------------------------------------------------------------
-- Set Game Modes for MP

function
MultiplayerTools.SetMPGameMode()


	if XNetwork ~= nil then
		local GameType = XNetwork.GameInformation_GetMPFreeGameMode()		
		
		--Always Deathmatch
		Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\VC_Deathmatch.lua" )
		Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, NIL, "VC_Deathmatch", 1)
		
		
		-- Tech race
		if GameType == 2 then			
			--for addon
			Script.Load("Data\\Script\\MapTools\\MultiPlayer\\AOVC_TechRace.lua")
			
			Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\VC_TechRace.lua" )
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, NIL, "VC_TechRace", 1)			
			
			
		-- Point game
		elseif GameType == 3 then
			Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\VC_PointGame.lua" )
			Script.Load( "Data\\Script\\MapTools\\Score.lua" )
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND, NIL, "VC_PointGame", 1)								
		end
	
	
		--PeaceTime
		local PeaceTime = XNetwork.GameInformation_GetMPPeaceTime()
		
		if PeaceTime == 0 then
		
			-- Set up diplomacy
			MultiplayerTools.SetUpDiplomacyOnMPGameConfig()
			
		elseif PeaceTime == 1 then
			if GameType ~= 3 then
				MultiplayerTools.PeaceTime = 900				
				GUIAction_ToggleStopWatch(MultiplayerTools.PeaceTime, 1)
				Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\PeaceTime.lua" )				
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"Condition_PeaceTime","Action_PeaceTime",1)
			end
			
		elseif PeaceTime == 2 then
			if GameType ~= 3 then
				MultiplayerTools.PeaceTime = 1800				
				GUIAction_ToggleStopWatch(MultiplayerTools.PeaceTime, 1)
				Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\PeaceTime.lua" )				
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"Condition_PeaceTime","Action_PeaceTime",1)
			end

		elseif PeaceTime == 3 then			
			MultiplayerTools.PeaceTime = Technologies.GT_Alloying			
			Script.Load( "Data\\Script\\MapTools\\MultiPlayer\\PeaceTime.lua" )
			Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,"Condition_PeaceTimeTech","Action_PeaceTimeTech",1)
		end
		
		
		-- Fast game
		if XNetwork.GameInformation_GetMPFastGameFlag() == 1 then
			MultiplayerTools.SetupFastGame()
		else
			MultiplayerTools.SetupNormalGame()
		end
		
	end
	
end
	
	
--------------------------------------------------------------------------------------------------------------------
-- Allow humen player to buy heros

function 
MultiplayerTools.GiveBuyableHerosToHumanPlayer( _NumberOfHeros )

	-- Get number of humen player
	local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()

	-- For all humen player
	for PlayerID=1, HumenPlayer, 1 do
	
		-- Give heros to buy
		Logic.SetNumberOfBuyableHerosForPlayer( PlayerID, _NumberOfHeros )
		
	end

end


--------------------------------------------------------------------------------------------------------------------
-- A player left the game!

function 
MultiplayerTools.PlayerLeftGame( _PlayerID )

	-- Player valid?
	if _PlayerID == 0 then
		return
	end


	
	-- Distribute resources to allied player AND remove players resources
	do
	
		-- Get number of humen player
		local HumenPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()
		
		-- Is leaving player a humen?
		if _PlayerID <= HumenPlayer then
		
			-- Count allied player
			local Allies = 0
			
			-- Do count
			do
				for TempPlayerID=1, HumenPlayer, 1 do
					if TempPlayerID ~= _PlayerID then
						if Logic.GetDiplomacyState( TempPlayerID, _PlayerID ) == Diplomacy.Friendly then
							Allies = Allies + 1
						end
					end
				end
			end
			
			-- Get player resources
			local PlayerClay   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Clay ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.ClayRaw )	
			local PlayerGold   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Gold ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.GoldRaw )
			local PlayerSilver = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Silver ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.SilverRaw )
			local PlayerWood   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Wood ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.WoodRaw )
			local PlayerIron   = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Iron ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.IronRaw )
			local PlayerStone  = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Stone ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.StoneRaw )
			local PlayerSulfur = Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.Sulfur ) + Logic.GetPlayersGlobalResource( _PlayerID, ResourceType.SulfurRaw )
			
			-- Any allies?
			if Allies ~= 0 then
			
				-- Distribute resources
				for TempPlayerID=1, HumenPlayer, 1 do
					if TempPlayerID ~= _PlayerID then
						if Logic.GetDiplomacyState( TempPlayerID, _PlayerID ) == Diplomacy.Friendly then
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Clay,   PlayerClay / Allies )
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Gold,   PlayerGold / Allies )
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Silver, PlayerSilver / Allies )
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Wood,   PlayerWood / Allies )
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Iron,   PlayerIron / Allies )
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Stone,  PlayerStone / Allies )
							Logic.AddToPlayersGlobalResource( TempPlayerID, ResourceType.Sulfur, PlayerSulfur / Allies )
						end
					end
				end
			end
			
			-- Remove player resources
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Clay, PlayerClay )
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Gold, PlayerGold )
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Silver, PlayerSilver )
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Wood, PlayerWood )
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Iron, PlayerIron )
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Stone, PlayerStone )
			Logic.SubFromPlayersGlobalResource( _PlayerID, ResourceType.Sulfur, PlayerSulfur )
			
		end
	
	end
	

	-- Become enemy to all other player
	do 
	
		-- For all player
		for TempPlayerID=1, Logic.GetMaximumNumberOfPlayer(), 1 do
			if TempPlayerID ~= _PlayerID then
				Logic.SetDiplomacyState( TempPlayerID, _PlayerID, Diplomacy.Hostile )
			end
		end
		
	end
	
	
	-- Remove player entities
	MultiplayerTools.RemoveAllPlayerEntities( _PlayerID )


	-- Update victory conditions
	do
		VC_Deathmatch()
		if VC_PointGame ~= nil then
			VC_PointGame()
		end
		if VC_TechRace ~= nil then
			VC_TechRace()
		end
	end


	--say logic, player has lost
	Logic.PlayerSetGameStateToLeft( _PlayerID )
		
		
	
end


--------------------------------------------------------------------------------------------------------------------
-- Remove all player entities

function 
MultiplayerTools.RemoveAllPlayerEntities( _PlayerID )
	
	-- As long as there are entities	
	while true do
	
		-- Get next x entities
		local Table = { Logic.GetAllPlayerEntities( _PlayerID, 20 ) }
		local Number = Table[ 1 ]
		
		-- Break when done
		if Number == 0 then
			break
		end
		
		-- Delete them
		for i=1, Number, 1 do
			local EntityID = Table[ i + i ]
			Logic.DestroyEntity( EntityID )
		end
	end

end


--------------------------------------------------------------------------------------------------------------------
-- Init the Camera Position for the current player: ScriptEntity with name "P1_StartPos" has to exist for each player
function
MultiplayerTools.InitCameraPositionsForPlayers()

	--Get Player ID
	local PlayerID = GUI.GetPlayerID()	
	
	--create name
	local CameraPositionName = "P" .. PlayerID .. "_StartPos"
	local Start 
	
	--fix:
	if IsExisting(CameraPositionName) then
		--Move Camera to starting point	
		Start = Logic.GetEntityIDByName(CameraPositionName)
	else
		
		local UpgradeTypeTable = {Logic.GetBuildingTypesInUpgradeCategory(UpgradeCategories.Headquarters)}
		
		local AmountOfUpgradeTypes = UpgradeTypeTable[1]	
		for i=1,AmountOfUpgradeTypes,1 
		do
			-- Get ID of upgradecategory of player
			local TempTable = {Logic.GetPlayerEntities( GUI.GetPlayerID(), UpgradeTypeTable[i+1], 48 )	}
			local number = TempTable[1]		
			for j=1,number,1 
			do
				if TempTable[j+1] ~= nil then
					Start = TempTable[j+1]
					break
				end
			end		
		end
		
	end
	local StartPos_x, StartPos_y, StartPos_z = Logic.EntityGetPos(Start)		
		Camera.ScrollGameTimeSynced(StartPos_x, StartPos_y)

end


--------------------------------------------------------------------------------------------------------------------
-- Set Resources for all players: "few", "normal", "many"

function
MultiplayerTools.InitResources(_amount)
		
	-- Initial normal Resources
	local InitGoldRaw 	= 300
	local InitClayRaw 	= 1200
	local InitWoodRaw 	= 1000
	local InitStoneRaw 	= 800
	local InitIronRaw 	= 0
	local InitSulfurRaw	= 0
	
	--init few or many resources: AnSu: I will do this later
	if _amount == "few" then
	elseif _amount == "many" then
		InitGoldRaw 	= 99999
		InitClayRaw 	= 99999
		InitWoodRaw 	= 99999
		InitStoneRaw 	= 99999
		InitIronRaw 	= 99999
		InitSulfurRaw	= 99999
	end
	
	--Give resources to players
	local i
	for i = 1, 8, 1
	do
		Tools.GiveResouces(i, InitGoldRaw, InitClayRaw,InitWoodRaw,InitStoneRaw,InitIronRaw,InitSulfurRaw)
	end
end


--------------------------------------------------------------------------------------------------------------------

function
MultiplayerTools.CreateMPTables()

	MultiplayerTools.Teams = {}
	MultiplayerTools.TeamTechTable = {}
	MultiplayerTools.TeamCounter = 0

	local PlayerAmount = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer()	
	local GameType = XNetwork.GameInformation_GetMPFreeGameMode()		
	
	
	
	for i=1,PlayerAmount,1
	do
		
		local IsHumanFlag = XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( i )
		if IsHumanFlag == 1 then
	
			local PlayerTeam = XNetwork.GameInformation_GetLogicPlayerTeam( i )
						
			-- Create Team Table
			if MultiplayerTools.Teams[ PlayerTeam ] == nil then

				MultiplayerTools.Teams[ PlayerTeam ] = {}
				
				if GameType == 2 then					
					MultiplayerTools.TeamTechTable[PlayerTeam]= {}
				end
				
				MultiplayerTools.TeamCounter = MultiplayerTools.TeamCounter + 1
				
			end
			
			-- Add player in Team Table
			table.insert( MultiplayerTools.Teams[ PlayerTeam ], i )
			
		end
	end
end


--------------------------------------------------------------------------------------------------------------------

function
MultiplayerTools.SetupFastGame()
	
	local AdditionalGoldRaw 	= 300
	local AdditionalClayRaw 	= 1200
	local AdditionalWoodRaw 	= 1000
	local AdditionalStoneRaw 	= 800
	local AdditionalIronRaw 	= 0
	local AdditionalSulfurRaw	= 0
	
	
	for i= 1, 8, 1 
	do
		if MultiplayerTools.Teams[i] ~= nil then
		
			local AmountOfPlayersInTeam = table.getn(MultiplayerTools.Teams[i])
			
			for j = 1, AmountOfPlayersInTeam,1
			do
				local PlayerID = MultiplayerTools.Teams[i][j]
				
				Logic.SetTechnologyState(PlayerID, Technologies.GT_Mercenaries,3)
				Logic.SetTechnologyState(PlayerID, Technologies.GT_Construction,3)
				Logic.SetTechnologyState(PlayerID, Technologies.GT_Alchemy,3)
				Logic.SetTechnologyState(PlayerID, Technologies.GT_Literacy,3)
				
				if MultiplayerTools.AOMultiPlayerToolsSetupFastGame ~= nil then
					MultiplayerTools.AOMultiPlayerToolsSetupFastGame(PlayerID)
				end
				
				Tools.GiveResouces(PlayerID, AdditionalGoldRaw, AdditionalClayRaw,AdditionalWoodRaw,AdditionalStoneRaw,AdditionalIronRaw,AdditionalSulfurRaw)
				
				GUI.UpgradeBuildingCategory(UpgradeCategories.Headquarters,PlayerID)				
			end	
		end
	end

end


--------------------------------------------------------------------------------------------------------------------

function
MultiplayerTools.SetupNormalGame()
	
	for i= 1, 8, 1 
	do
		if MultiplayerTools.Teams[i] ~= nil then
		
			local AmountOfPlayersInTeam = table.getn(MultiplayerTools.Teams[i])
			
			for j = 1, AmountOfPlayersInTeam,1
			do
				local PlayerID = MultiplayerTools.Teams[i][j]
				
				MultiplayerTools.DeleteFastGameStuff(PlayerID)
				
			end	
		end
	end

end


--------------------------------------------------------------------------------------------------------------------

function
MultiplayerTools.DeleteFastGameStuff(_PlayerID)
	for k=1,11,1
	do		
	
		local EntityName = "P" .. _PlayerID .. "_FastGame" .. k
		--AnSu: Fix
		if IsExisting(EntityName) == true then
			local EntityID = Logic.GetEntityIDByName(EntityName)		
			Logic.DestroyEntity(EntityID)
		end
	end
end


------------------------------------------------------------------------------------------------------------
--MP games can not be saved. But this missions can also be played in singleplayer

function
MultiplayerTools.OnSaveGameLoaded()


	--first re init gfx sets for all maps
	Mission_InitWeatherGfxSetsForAllMaps()
	
	-- Re init weather gfx sets in the map script (can overwrite Mission_InitWeatherGfxSetsForAllMaps)
	Mission_InitWeatherGfxSets()

end