----------------------------------------------------------------------------------------
-- Create NPC table description
--
--	must be
--		.name				=	Name of Npc Entity
--			.briefing		=	reference to briefing table that will be shown
--		or
--			.callback		=	callback if talked to npc with npc table as parameter
--
--	optional
--		.vanishPos			=	position/entity name where the npc is moving to vanish after briefing done
--								vanishing position should be unexplored else npc will not be removed
--		.heroName			=	the npc is only talking to this hero
--		.wrongHeroMessage	=	string table key or string with wrong hero message
--		.follow				=	true/false npc will follow nearest hero
--								name of entity, serf will only follow this entity
--
----------------------------------------------------------------------------------------

NPC_LOOK_AT_HERO_DISTANCE = 2000
NPC_HERO_COUNT = 9

IncludeGlobals("NPC_Extra")

SetupNPCSystem = function()

	-- Is NPC Table there
	if NPCTable == nil then
		NPCTable = {}
		
		NPCTable_Heroes = {}
		NPCTable_Heroes.LastUpdate = 0
		
		-- Create trigger for look at
		Trigger.RequestTrigger(	Events.LOGIC_EVENT_EVERY_SECOND,
					nil,
					"NPCLookAt_Action",
					1)
		
		-- Create trigger for move actions
		Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_SECOND,
					nil,
					"NPCMove_Action",
					1)

	end

end


InitNPC = function(_Name)
	
	SetupNPCSystem()
	
	-- Create default values
	NPCTable[_Name] = {}
	NPCTable[_Name].LookAt = 0 -- 1 is hero
	NPCTable[_Name].WayPoints = {}
	NPCTable[_Name].Follow = nil
	NPCTable[_Name].FollowDistance = 0
end


UpdateHeroesTable = function()
		
	-- Get current time
	local currentTime = Logic.GetTime()
	
	-- Some time gone
	if NPCTable_Heroes.LastUpdate < currentTime then
		
		-- Get heroes of player
		local Count
		Count, NPCTable_Heroes[1] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero1, 1)
		Count, NPCTable_Heroes[2] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero1a, 1)
		Count, NPCTable_Heroes[3] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero1b, 1)
		Count, NPCTable_Heroes[4] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero1c, 1)
		Count, NPCTable_Heroes[5] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero2, 1)
		Count, NPCTable_Heroes[6] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero3, 1)
		Count, NPCTable_Heroes[7] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero4, 1)
		Count, NPCTable_Heroes[8] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero5, 1)
		Count, NPCTable_Heroes[9] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero6, 1)
		
		if UpdateHeroesTable_Extra ~= nil then
			UpdateHeroesTable_Extra()
		end

		-- Set new time
		NPCTable_Heroes.LastUpdate = currentTime
	end
	
end

GetNearestHero = function(_NPC, _MaxDistance)
	-- Get all heroes
	UpdateHeroesTable()
	local bestDistance 
	-- Get distances for valid heroes
	if _MaxDistance == nil then
		bestDistance = 1000000000000000
	else
		bestDistance = _MaxDistance*_MaxDistance
	end
	local bestHero
	
	-- Get position of NPC
	local PosX,PosY = Tools.GetPosition(_NPC)

	
	-- for all heroes
	local i
	for i=1, NPC_HERO_COUNT do
	
		-- Valid hero
		if NPCTable_Heroes[i] ~= nil and IsAlive(NPCTable_Heroes[i]) then
				
			-- Get position of hero
			local HeroPosX,HeroPosY = Tools.GetPosition(NPCTable_Heroes[i])
			
			local DeltaX = HeroPosX-PosX
			local DeltaY = HeroPosY-PosY
			-- Get distance
			local Distance = (DeltaX*DeltaX)+(DeltaY*DeltaY)
			
			-- Is better than best
			if Distance < bestDistance then
			
				bestDistance = Distance
				bestHero = i

			end
			
		end
		
	end
	-- Return best hero
	if bestHero ~= nil then
		return NPCTable_Heroes[bestHero]
	else
		return nil
	end
end
-----------------------------------------------------------------------------------------------------------
-- Set look at target of NPC: 0 - stop looking 1 - look at nearest hero
-----------------------------------------------------------------------------------------------------------

SetNPCLookAtTarget = function(_Name, _TargetType)
	-- Set look at
	NPCTable[_Name].LookAt = _TargetType
end

NPCLookAt_Action = function()
	-- For every NPC
	table.foreach(NPCTable, NPCLookAt_Code)
end

NPCLookAt_Code = function(_Name,_Data)

	if IsDead(_Name) then
		InitNPC(_Name)
	-- Is look at active
	elseif _Data.LookAt == 1 and not Logic.IsEntityMoving(_Name) then
	
		-- Get position of NPC
		local PosX,PosY = Tools.GetPosition(_Name)
		
		-- Is hero near
		if Logic.IsPlayerEntityOfCategoryInArea(gvMission.PlayerID, PosX, PosY, NPC_LOOK_AT_HERO_DISTANCE, "Hero") == 1 then
			
			-- Get nearest hero
			local NearestHero = GetNearestHero(_Name)
			
			-- Valid
			if NearestHero ~= nil then
			
				-- Look at this hero
				LookAt(_Name, NearestHero)
			
			end
		end		
	end
	
end

-----------------------------------------------------------------------------------------------------------
-- Add Waypoint to NPC
-----------------------------------------------------------------------------------------------------------

SetNPCWaypoints = function(_Name, _Waypoints, _Time)

	-- Get number of elements
	local count = GetNumberOfEntities(_Waypoints)

	-- Any waypoint
	if count ~= 0 then

		-- Add waypoint to list
		-- Waypoint 	1 = Target Pos
		--		2 = Time for movement
		--		3 = number of points
		NPCTable[_Name].WayPoints.Name= _Waypoints
		NPCTable[_Name].WayPoints.Time = _Time
		NPCTable[_Name].WayPoints.Count = count
		NPCTable[_Name].WayPoints.LastTime = Logic.GetTime()
	end
end

-----------------------------------------------------------------------------------------------------------
-- Follow this target type nil = stop following 1 = nearest hero
-----------------------------------------------------------------------------------------------------------

SetNPCFollow = function(_Name, _TargetType, _Distance, _MaxDistance, _LostCallback)

	-- Setup
	NPCTable[_Name].Follow = _TargetType
	NPCTable[_Name].FollowDistance = _Distance
	NPCTable[_Name].MaxDistance = _MaxDistance
	NPCTable[_Name].LostCallback = _LostCallback
end


NPCMove_Action = function()
	-- For every NPC
	table.foreach(NPCTable, NPCMove_Code)
end

NPCMove_Code = function(_Name,_Data)

	if IsDead(_Name) then
		InitNPC(_Name)
	-- Any waypoint and no follow active
	elseif _Data.Follow == nil and _Data.WayPoints.Count ~= nil and _Data.WayPoints.Count ~= 0 then
		
		local CurrentTime = Logic.GetTime()
		
		-- Get position of NPC
		local PosX,PosY = Tools.GetPosition(_Name)

		-- Is last time gone and no hero near
		if _Data.WayPoints.LastTime < CurrentTime and Logic.IsPlayerEntityOfCategoryInArea(gvMission.PlayerID, PosX, PosY, NPC_LOOK_AT_HERO_DISTANCE, "Hero") == 0 then

			-- Get random target
			local TagetIndex = Logic.GetRandom(_Data.WayPoints.Count)+1

			-- Set new last time
			_Data.WayPoints.LastTime = CurrentTime + _Data.WayPoints.Time
			
			-- Start movement
			Move(_Name, _Data.WayPoints.Name..TagetIndex)
		end
		
	elseif _Data.Follow ~= nil then

		-- Get ID
		local FollowID = nil
		if type(_Data.Follow) == "string" then
			FollowID = GetEntityId(_Data.Follow)
		else
			FollowID = GetNearestHero(_Name, _Data.MaxDistance)
		end

		-- Is target valid
		if FollowID ~= nil and IsAlive(FollowID) then
						
			-- Move near target
			Move(_Name, FollowID, _Data.FollowDistance)			

		else
			-- disable follow
			_Data.Follow = nil
			if _Data.LostCallback ~= nil then
				_Data.LostCallback()
			end
		end
	end

end

-----------------------------------------------------------------------------------------------------------
--	Heroes Look At <Entity> 
--	Let all heroes look at entity
-----------------------------------------------------------------------------------------------------------

HeroesLookAt = function(_entity)

	SetupNPCSystem()
		
	if IsAlive(_entity) then

		UpdateHeroesTable()
		
		local i
		for i=1, NPC_HERO_COUNT do
		
			if IsAlive(NPCTable_Heroes[i]) then
				
				if IsNear(NPCTable_Heroes[i], _entity, NPC_LOOK_AT_HERO_DISTANCE) then
				
					LookAt(NPCTable_Heroes[i], _entity)
					
				end
				
			end
		
		end

	end

end

----------------------------------------------------------------------------------------
-- Init and let npc look at heroes, enable marker
----------------------------------------------------------------------------------------

InitNPCLookAt = function(_Name)
	InitNPC(_Name)
	SetNPCLookAtTarget(_Name,1)
	EnableNpcMarker(_Name)
end


----------------------------------------------------------------------------------------
-- Create NPCs; give table with npc names
----------------------------------------------------------------------------------------

function CreateNPCsBriefings(_NPCs, _Briefings)

	if NPC == nil then
		NPC = {}
	end
	
	NPC.Seen 			= {}
	NPC.Name			= _NPCs
	createBriefingNPC	= {}	
	briefingNPC			= {}	

	for npcCreate = 1, table.getn(NPC.Name) do 
	
		InitNPCLookAt(NPC.Name[npcCreate])

		NPC.Seen[npcCreate]		= 0
	
		if _Briefings ~= nil and _Briefings[npcCreate] ~= nil then
		    
			briefingNPC[npcCreate] = _Briefings[npcCreate]

		else
			
			briefingNPC[npcCreate] = {}	
			briefingNPC[npcCreate].restoreCamera = true
			
			local page = 0
		    
			--	page
			
				page = page +1
			
				briefingNPC[npcCreate][page] 				= 	{}
				briefingNPC[npcCreate][page].title			= 	String.Key("briefingNPC["..npcCreate.."].title" )
				briefingNPC[npcCreate][page].text			=	String.Key("briefingNPC["..npcCreate.."].text" )
				briefingNPC[npcCreate][page].position		=	GetPosition(NPC.Name[npcCreate] )
				briefingNPC[npcCreate][page].dialogCamera	=	true

		end
		
	end
	
end



----------------------------------------------------------------------------------------
-- Check for NPCs; set in local file "briefingNPC.Name_Tips.lua"
----------------------------------------------------------------------------------------

function MapLocal_npcCheck(_heroId,_npcId)

	-- Ignore if running briefing
	if IsBriefingActive() then
		return
	end

	for npcCheck = 1, table.getn(NPC.Name) do 
		
		if IsAlive(NPC.Name[npcCheck]) then
	
			if NPC.Seen[npcCheck] == 0 and _npcId == GetEntityId(NPC.Name[npcCheck]) then
			
				if IsNear(_heroId,_npcId,BRIEFING_TALK_DISTANCE) then
				
					HeroesLookAt(_npcId)

				--	go!
					StartBriefing(briefingNPC[npcCheck])

					NPC.Seen[npcCheck] = 1
					DisableNpcMarker(NPC.Name[npcCheck])
					
					if IsAlive(NPC.Name[npcCheck].."_target") then
						
						CurrentNPC 			= NPC.Name[npcCheck]
						CurrentNPCTarget 	= NPC.Name[npcCheck].."_target"
					
						StartJob("Delay")
					end
					
				end
					
			end
		end
	
	end
end




Condition_Delay = function()
	if IsBriefingActive() ~= true then
		return true
	end

	return false
end                                                             


Action_Delay = function()

	assert(CurrentNPC ~= nil)
	MoveAndVanish(CurrentNPC, CurrentNPCTarget)
	return true

end


-------------------------------------------------------------------------------------------------------------------------
--	GameCallback_NPCInteraction
-------------------------------------------------------------------------------------------------------------------------
function GameCallback_NPCInteraction (_heroId,_npcId)

	-- Ignore if running briefing
	if IsBriefingActive() then
		return
	end
	
	-- talking to valid npc
	if NPC ~= nil and NPC[_npcId] ~= nil then
		
		-- Already talked to
		if NPC[_npcId].talkedTo == nil then
			
			-- Correct hero
			if NPC[_npcId].heroName ~= nil then
			
				-- Incorrect hero
				if GetEntityId(NPC[_npcId].heroName)~=_heroId then
			
					-- key or text?
					local Text = XGUIEng.GetStringTableText(NPC[_npcId].wrongHeroMessage)
					if Text == nil then
						Message(NPC[_npcId].wrongHeroMessage)
					else
						SpokenMessage(NPC[_npcId].wrongHeroMessage)
					end
					return					
				end
			end
			
			-- set talked to flag
			NPC[_npcId].talkedTo = true
			
			-- let all heroes look at npc
			HeroesLookAt(_npcId)

			DisableNpcMarker(_npcId)
			InitNPC(NPC[_npcId].name)

			if NPC[_npcId].briefing ~= nil then
				StartBriefing(NPC[_npcId].briefing)
			else
				NPC[_npcId].callback(NPC[_npcId], _heroId)
			end
				
			if NPC[_npcId].vanishPos ~= nil then
					
				Trigger.RequestTrigger(	Events.LOGIC_EVENT_EVERY_SECOND,
										nil,
										"NPC_MoveAndVanish",
										1,
										nil,
										{_npcId})
			end
							
		end	
		
	else
		
		if NPCInteraction_Extra ~= nil then
			NPCInteraction_Extra(_heroId,_npcId)
		end
					
	end
	
end
-------------------------------------------------------------------------------------------------------------------------
--	Job NPC_MoveAndVanish
-------------------------------------------------------------------------------------------------------------------------
function NPC_MoveAndVanish(_npcId)

	if IsBriefingActive() == false then
		MoveAndVanish(_npcId, NPC[_npcId].vanishPos)
		return true
	end

end