AddData = function(_Data)
	-- No table for expedition functions
	if DataTable == nil then
		DataTable = {}
	end
	-- Add function to table
	table.insert(DataTable, _Data)
	
	-- Return index
	return table.getn(DataTable)
end

QuestRedeploy = function(_Quest)
	-- Set anchor of army if army there
	if _Quest.Army ~= nil then
		if _Quest.ArmyPos ~= nil then
			Redeploy(_Quest.Army, GetPosition(_Quest.ArmyPos), _Quest.ArmyRange)
		end
	end
end

QuestSetup = function(_Quest,_Name, _Type)

	-- Redeploy attached army
	QuestRedeploy(_Quest)
	-- Get targets
	QuestGetTargetCount(_Quest)

	-- Remember data
	local Index = AddData(_Quest)

	local Type = Events.LOGIC_EVENT_EVERY_SECOND
	if _Type ~= nil then
		Type = _Type
	end

	-- Hostage trigger
	_Quest.triggerId = Trigger.RequestTrigger( Type,
				_Name.."_Condition",
				_Name.."_Action",
				1,
				{Index},
				{Index})
end

QuestArmyIsDead = function(_Quest)
	return _Quest.Army == nil or IsDead(_Quest.Army)
end

QuestAreaCleared = function(_Quest)
	-- No Area there, automaticly cleared
	if _Quest.AreaPos == nil then
		return true
	end

	-- Get Area position
	local PositionX, PositionY = Tools.GetPosition(_Quest.AreaPos)
	
	-- No building left
	return Logic.IsPlayerEntityInArea(_Quest.AreaPlayerID, PositionX, PositionY, _Quest.AreaSize, 8) == 0
end

QuestGetTargetCount = function(_Quest)

	-- Is string
	if type(_Quest.Targets) == "string" then
		-- Get target count
		_Quest.TargetCount = GetNumberOfEntities(_Quest.Targets)
	end
end

QuestTargetsDestroyed = function(_Quest)

	-- Any quest target
	if _Quest.Target ~= nil then
		-- Target not destroyed
		if IsAlive(_Quest.Target) then
			return false
		end
	end

	return QuestAllTargetsDestroyed(_Quest, "Targets", "TargetCount")

end

function QuestAllTargetsDestroyed(_Quest, _EntryName, _CounterName)

	-- No targets there
	if _Quest[_EntryName] == nil then
		return true
	end
	
	-- Are targets a table
	if type(_Quest[_EntryName]) == "table" then
		
		-- Check all entities in table
		local i
		for i=1, table.getn(_Quest[_EntryName]) do
		
			-- Stop if alive
			if IsAlive(_Quest[_EntryName][i]) then
				return false
			end
		end
		
		return true
		
	else
		-- Check if any target is alive
		local TargetCount = 0
	
		-- Count existing targets
		local Index
		for Index=1,_Quest[_CounterName] do
			-- Is entity alive
			if IsDead(_Quest[_EntryName]..Index) then
				TargetCount = TargetCount + 1
			else
				break
			end
		end
		-- All dead
		return TargetCount == _Quest[_CounterName]
	end

end

QuestCallback = function(_Index)

	-- Is briefing running
	if IsBriefingActive() then
		return false
	else
		if DataTable[_Index].Callback ~= nil then
			
			local returnValue = DataTable[_Index].Callback(DataTable[_Index])
			
			if returnValue ~= nil then
				return returnValue
			end
		end
		
		return true
	end	
end
-----------------------------------------------------------------------------------------------------------
-- Setup Expedition:	Entity must come close Enough to Other Entity
--
-- EntityName = Which unit should do the expedition...optional
-- Heroes = any hero should reach target...optional
-- Leaders = any leader should reach target...optional
-- Serfs = any serf should reach target...optional
-- TargetName = Where is the expedition center
-- Distance = Distance to center to finish expedition...max of 6400 if listening for heroes or military
-- Callback = Call this function if expedition quest done, return true if quest should be destroyed
-----------------------------------------------------------------------------------------------------------

SetupExpedition = function(_Quest)

	QuestSetup(_Quest, "Expedition")

end

Expedition_Condition = function(_Index)

	local near = false

	if DataTable[_Index].CategoryList == nil then
		DataTable[_Index].CategoryList = {}

		-- Add names to list if valid
		if DataTable[_Index].Heroes ~= nil then
			table.insert(DataTable[_Index].CategoryList, "Hero")
		end
		if DataTable[_Index].Leaders ~= nil then
			table.insert(DataTable[_Index].CategoryList, "Leader")
		end
		if DataTable[_Index].Serfs ~= nil then
			table.insert(DataTable[_Index].CategoryList, "Serf")
		end
	end
	
	-- Anything in list
	if table.getn(DataTable[_Index].CategoryList) > 0 then

		-- Get position
		local PosX, PosY = Tools.GetPosition(DataTable[_Index].TargetName)

		-- Check for any entity near
		near = near or Logic.IsPlayerEntityOfCategoryInArea(gvMission.PlayerID, PosX, PosY, DataTable[_Index].Distance, DataTable[_Index].CategoryList[1], DataTable[_Index].CategoryList[2], DataTable[_Index].CategoryList[3]) == 1
	end
	
	-- Any entity
	if DataTable[_Index].EntityName ~= nil then
		near = near or IsNear(DataTable[_Index].EntityName, DataTable[_Index].TargetName, DataTable[_Index].Distance)
	end

	return near
	
end
Expedition_Action = function(_Index)
	return QuestCallback(_Index)
end

-----------------------------------------------------------------------------------------------------------
-- Setup Rescue:Player has to destroy Guarding Army and all Buildings in Region to rescue Hostages
--		They will join Player after he clean all and come close enough to them.
--
-- Gift = Name of Hostages without Index example: Test for Test1 to TestX...optional
-- GiftEntity = Name of entity that will join player
--
-- AreaPos = Name of Script Entity for Center of Building Check...optinal
-- AreaSize = Range for Building Check
-- AreaPlayerID = Player Id of guarding towers
--
-- Target = This target must be destroyed...optional
-- Targets = This targets must be destroyed..optional 	Name without Index example: Test for Test1 to TestX
--							Can also be a table with X Entity Names
--
-- ApproachPos = Rescue position
-- ApproachRange = Range player entity must come close to rescue position
--
-- Army = Army guarding this hostages...optional
-- ArmyPos = Guarding position...optional
-- ArmyRange = Action Range for guarding army...optional
--
-- Callback = Call this function if rescue quest done
-----------------------------------------------------------------------------------------------------------

SetupRescue = function(_Quest)

	-- Set anchor of army if army there
	QuestSetup(_Quest, "Rescue")
end

Rescue_Condition = function(_Index)
	-- Check if army is destroyed
	if QuestArmyIsDead(DataTable[_Index]) then
		
		-- Any position there
		if QuestAreaCleared(DataTable[_Index]) and QuestTargetsDestroyed(DataTable[_Index]) then
			-- Get Position
			local PositionX, PositionY = Tools.GetPosition(DataTable[_Index].ApproachPos)
					
			-- Any hero or leader in area
			return Logic.IsPlayerEntityOfCategoryInArea(gvMission.PlayerID, PositionX, PositionY, DataTable[_Index].ApproachRange, "Hero", "Leader")
		end
	end
	-- Not done
	return false
end

Rescue_Action = function(_Index)
	-- Index
	local Index = 1

	-- Change player id of hostages
	while true do
		-- Is entity alive
		if DataTable[_Index].Gift ~= nil and IsAlive(DataTable[_Index].Gift..Index) then
			ChangePlayer(DataTable[_Index].Gift..Index, gvMission.PlayerID)
		else
			break
		end
		-- Increase Index
		Index = Index + 1
	end

	-- Any entity to change
	if DataTable[_Index].GiftEntity ~= nil then
		ChangePlayer(DataTable[_Index].GiftEntity, gvMission.PlayerID)
	end

	return QuestCallback(_Index)	
end

-----------------------------------------------------------------------------------------------------------
-- Setup Destroy:Player has to destroy Guarding Army and all Buildings in Region to finish the quest
--
--
-- AreaPos = Where is the target area...optional
-- AreaSize = Buildings should be destroyed in this area
-- AreaPlayerID = Player Id of buildings
--
-- Target = This target must be destroyed...optional
-- Targets = This targets must be destroyed...optional 	Name without Index example: Test for Test1 to TestX
--							Table with entries
--
-- Army = guarding Army...optional
-- ArmyPos = Guarding position...optional
-- ArmyRange = Action Range for army...optional
--
-- Callback = Call this function if destroy quest done
-----------------------------------------------------------------------------------------------------------

SetupDestroy = function(_Quest)
	QuestSetup(_Quest, "Destroy")
end

Destroy_Condition = function(_Index)
	-- Check if army is destroyed
	return 		QuestArmyIsDead(DataTable[_Index])
		and	QuestAreaCleared(DataTable[_Index]) 
		and 	QuestTargetsDestroyed(DataTable[_Index])
end

Destroy_Action = function(_Index)
	return QuestCallback(_Index)
end

-----------------------------------------------------------------------------------------------------------
-- Setup establish: Player has to build different buildings in an optional area, no area whole map is used
--
-- Player = checking this player...optional
--
-- AreaPos = base must be established near this position...optional
-- AreaSize = in this range
-- EntityTypes = table with entities, Element(Type and Amount)
-- Any = any building is placed
--
-- Callback = Call this function after establish quest done
-----------------------------------------------------------------------------------------------------------

SetupEstablish = function(_Quest)
	QuestSetup(_Quest, "Establish")
end

EstablishEnoughBuildingCheck = function(_Amount,_Buildings)
	-- Not enough there
	if _Buildings[1] < _Amount then
		return false
	else
		-- Check if all are finished
		for i=2, _Buildings[1]+1 do
			if Logic.IsConstructionComplete(_Buildings[i]) == 0 then
				return false
			end
		end
	end
	-- Enough there
	return true
end

Establish_Condition = function(_Index)

	-- Default player is user
	local PlayerID = gvMission.PlayerID
	-- Take other if there
	if DataTable[_Index].Player ~= nil then
		PlayerID = DataTable[_Index].Player
	end
	
	-- Check for area
	if DataTable[_Index].AreaPos ~= nil then
		-- Get Area position
		local PositionX, PositionY = Tools.GetPosition(DataTable[_Index].AreaPos)

		-- Any building
		if DataTable[_Index].Any == nil then

			-- Check all entities
			local i
			for i=1,table.getn(DataTable[_Index].EntityTypes) do
				-- Get amount on map of type
				local Buildings = {Logic.GetPlayerEntitiesInArea(	PlayerID, 
											DataTable[_Index].EntityTypes[i][1], 
											PositionX, 
											PositionY,
											DataTable[_Index].AreaSize,
											DataTable[_Index].EntityTypes[i][2]) }
	
				-- Check buildings
				if not EstablishEnoughBuildingCheck(DataTable[_Index].EntityTypes[i][2],Buildings) then
					return false
				end
			end
		
		else
			
			-- Get buildings in range		
			local Buildings = {Logic.GetPlayerEntitiesInArea(	PlayerID, 
																0,
																PositionX, 
																PositionY, 
																DataTable[_Index].AreaSize, 
																10,
																8)}
																
			-- Check if any is finished
			local i
			for i=2, Buildings[1]+1 do
				if Logic.IsConstructionComplete(Buildings[i]) == 1 then
					return true
				end
			end
	
			-- no one finished
			return false
	
		end
	
	else
		-- Check all entities
		local i
		for i=1,table.getn(DataTable[_Index].EntityTypes) do
			-- Get amount on map of type
			local Buildings = { Logic.GetPlayerEntities(	PlayerID,
									DataTable[_Index].EntityTypes[i][1], 
									DataTable[_Index].EntityTypes[i][2]) }
			-- Check buildings
			if not EstablishEnoughBuildingCheck(DataTable[_Index].EntityTypes[i][2],Buildings) then
				return false
			end
		end
	end
	
	-- Enough there
	return true
end

Establish_Action = function(_Index)
	return QuestCallback(_Index)
end


-----------------------------------------------------------------------------------------------------------
-- Setup build troops: Player has to build different troops in an optional area, no area whole map is used
--
-- AreaPos = troops must be established near this position...optional
-- AreaSize = in this range
-- TroopTypes = table with upgrade categories, Element(Type and Amount)
--
-- Callback = Call this function after establish quest done
-----------------------------------------------------------------------------------------------------------

SetupBuildTroops = function(_Quest)
	QuestSetup(_Quest, "BuildTroops")
end

GetTrainedTroops = function(_Troops)
	local i
	local count = 0
	-- Check if leader is trained
	for i=2, _Troops[1]+1 do
		if Logic.LeaderGetBarrack(_Troops[i]) == 0 then
			count = count + 1
		end
	end
	-- Enough there
	return count
end

BuildTroops_Condition = function(_Index)

	-- Positions
	local PositionX, PositionY

	-- Check for area
	if DataTable[_Index].AreaPos ~= nil then
		-- Get Area position
		PositionX, PositionY = Tools.GetPosition(DataTable[_Index].AreaPos)
	end
	
	-- Check all entities
	local i
	for i=1,table.getn(DataTable[_Index].TroopTypes) do
		
		-- Get soldier types from upgrade category
		local UpgradeTypes = {Logic.GetSettlerTypesInUpgradeCategory(DataTable[_Index].TroopTypes[i][1])}
		local Troops

		-- Troop count
		local TroopCount = 0

		-- For all types
		local j
		for j=2, UpgradeTypes[1]+1 do
			-- Area?
			if DataTable[_Index].AreaPos ~= nil then
				-- Get amount on map of type
				Troops = {Logic.GetPlayerEntitiesInArea(	gvMission.PlayerID, 
										UpgradeTypes[j], 
										PositionX, 
										PositionY,
										DataTable[_Index].AreaSize,
										DataTable[_Index].TroopTypes[i][2]-TroopCount) }
			else
				-- Get amount on map of type
				Troops = { Logic.GetPlayerEntities(	gvMission.PlayerID,
									UpgradeTypes[j], 
									DataTable[_Index].TroopTypes[i][2]-TroopCount) }
			end
	
			-- Get trained troops
			TroopCount = TroopCount + GetTrainedTroops(Troops)
			
			-- Enough break
			if TroopCount >= DataTable[_Index].TroopTypes[i][2] then
				break
			end
		end
		
		-- Not enough stop
		if TroopCount < DataTable[_Index].TroopTypes[i][2] then
			return false
		end
	end
	
	-- Enough there
	return true
end

BuildTroops_Action = function(_Index)
	return QuestCallback(_Index)
end

-----------------------------------------------------------------------------------------------------------
--	Setup Weather:	Quest is done on weather change to target state
--
--	.WeatherStates = table of target weather states
--
--	.Callback = call this function after weather changed, stop if true is returned
--
-----------------------------------------------------------------------------------------------------------

SetupWeather = function(_Quest)
	QuestSetup(_Quest, "Weather", Events.LOGIC_EVENT_WEATHER_STATE_CHANGED)
end

Weather_Condition = function(_Index)

	-- Correct weather state
	local i
	for i=1, table.getn(DataTable[_Index].WeatherStates) do
		if Event.GetNewWeatherState() == DataTable[_Index].WeatherStates[i] then
			return true
		end
	end
	return false
end
Weather_Action = function(_Index)
	return QuestCallback(_Index)
end

-----------------------------------------------------------------------------------------------------------
--	Setup Caravan:	Quest is done after caravan reached target
--
--	.Unit 			= table of caravan units or Name without Index example: Test for Test1 to TestX
--	.Waypoint		= list of waypoints
--		.Name		= entity name of waypoint
--		.WaitTime	= wait for X seconds to move to next waypoint
--	.Remove			= if set units are removed after reached last position...optional
--
--	.Callback 		= call this function after caravan reached target, parameter is number of left units
--	.ArrivedCount	= number of arrived units after quest done
--	.ArrivedCallback	= callback for every unit arrived at target...optional
--
-----------------------------------------------------------------------------------------------------------
function SetupCaravan(_Quest)

	assert(_Quest.Unit~=nil)
	
	if type(_Quest.Unit) == "string" then
		_Quest.UnitCount = GetNumberOfEntities(_Quest.Unit)
		
		local name = _Quest.Unit
		
		-- Not a single name?
		if _Quest.UnitCount > 0 then
			
			_Quest.Unit = {}
			
			local i
			for i = 1, _Quest.UnitCount do
			
				_Quest.Unit[i] = { Name = name..i }
								
			end
			
		else
		
			_Quest.Unit = {}
			_Quest.Unit[1] = { Name = name }
		
		end
	end
	
	_Quest.ArrivedCount = 0
	
	QuestSetup(_Quest, "Caravan")
	
end

function CaravanAllUnitsDead(_Quest)

	-- Check all entities in table
	local i
	for i=1, table.getn(_Quest.Unit) do
	
		-- Stop if alive
		if IsAlive(_Quest.Unit[i].Name ) then
			return false
		end
	end

	return true
	
end

function Caravan_Condition(_Index)
	
	local Quest = DataTable[_Index]
	
	if CaravanAllUnitsDead(Quest) then
		return true
	end
	
	-- current waypoint invalid
	if Quest.currentWaypoint == nil then
	
		Quest.currentWaypoint = 1
		
		Quest.state = 1
	
	end
	
	-- first
	local first = true
	local lastUnit

	-- move to waypoint
	local i
	for i=1, table.getn(Quest.Unit) do

		-- alive
		if IsAlive(Quest.Unit[i].Name) then
			
			-- First
			if first then
				
				-- Is first, send to waypoint if not already there
				if not IsNear(Quest.Unit[i].Name, Quest.Waypoint[Quest.currentWaypoint].Name, 50) then
					Move(Quest.Unit[i].Name, Quest.Waypoint[Quest.currentWaypoint].Name)
				end

				-- Is moving to next waypoint							
				if Quest.state == 1 and IsNear(Quest.Unit[i].Name, Quest.Waypoint[Quest.currentWaypoint].Name, 500) then
				
					-- Wait
					Quest.waitingTime = Quest.Waypoint[Quest.currentWaypoint].WaitTime
					if Quest.waitingTime == nil then
						Quest.waitingTime = 10
					end
					
					Quest.state = 2
				end
				
				first = false
				
			else
			
				Move(Quest.Unit[i].Name, lastUnit, 500)
			end
		
			-- move near way point if waypoint reched
			if Quest.state == 2 then
				lastUnit = Quest.Waypoint[Quest.currentWaypoint].Name		
			-- follow last Unit
			else
				lastUnit = Quest.Unit[i].Name
			end		

		end
		
	end
	
	-- all near
	return Quest.state == 2

end

function Caravan_Action(_Index)

	local Quest = DataTable[_Index]

	-- All dead
	if CaravanAllUnitsDead(Quest) then
		
		-- Callback
		QuestCallback(_Index)
		-- destroy quest
		return true
	end
	
	-- Last waypoint
	if Quest.currentWaypoint == table.getn(Quest.Waypoint) then
		
		-- should not remove, but should stop
		local targetReached = false
		
		-- first Unit reached target
		local i
		for i=1, table.getn(Quest.Unit) do
			
			if IsAlive(Quest.Unit[i].Name) then
				
				-- at end position
				if IsNear(Quest.Unit[i].Name, Quest.Waypoint[Quest.currentWaypoint].Name, 50) then
					
					-- remember and remove ariver
					Caravan_IncreaseArivedCount(Quest)

					if Quest.Remove == true then

						DestroyEntity(Quest.Unit[i].Name)

						-- continue moving to target
						Quest.state = 1
						return false

					else
						targetReached = true
					end
					
				elseif targetReached then
					Caravan_IncreaseArivedCount(Quest)
				end
				
			end
		end
	
		-- reached
		if targetReached == true then
			-- Callback
			QuestCallback(_Index)
			-- destroy quest
			return true			
		else
			return false
		end
			
	end

	-- Wait
	Quest.waitingTime = Quest.waitingTime - 1

	-- wait done?
	if Quest.waitingTime <= 0 then
		
		--next waypoint
		Quest.currentWaypoint = Quest.currentWaypoint + 1
		
		-- continue moving
		Quest.state = 1
	end
end

function Caravan_IncreaseArivedCount(_Quest)

	-- all arived
	_Quest.ArrivedCount = _Quest.ArrivedCount + 1
	
	if _Quest.ArrivedCallback ~= nil then
		_Quest.ArrivedCallback(_Quest)
	end

end
-----------------------------------------------------------------------------------------------------------
-- DestroyQuest <QuestTable>
-----------------------------------------------------------------------------------------------------------
function DestroyQuest(_Quest)

	Trigger.UnrequestTrigger(_Quest.triggerId)

end