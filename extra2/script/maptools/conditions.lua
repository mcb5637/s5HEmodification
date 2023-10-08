--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This Condition checks if player id and entity type is same as wanted
-- Param1: Player ID
-- Param2: Entity Type
-- Return: 1 if same object else 0
function Condition_OnEntityCreated_ByPlayerIDOfEntityType(_PlayerID, _EntityType)
	-- Get entity id
	local EntityID = Event.GetEntityID()
	
	-- Is player 2
	if Logic.EntityGetPlayer(EntityID) == _PlayerID then
		if Logic.GetEntityType(EntityID) == _EntityType then
			return 1
		end
	end
	
	-- not same
	return 0	
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- This Condition checks if cutscene is finished
-- Return: 1 if finished else 0
function Condition_Cutscene_Finished()
	if (gvCamera_CutsceneStartTime ~= nil) and (gvCamera_CutsceneStartTime < 0) then
		return 1
	else
		return 0
	end
end
