--------------------------------------------------------------------------------------------------------------------
-- Table to hold multi player tools stuff for AddOn

function MultiplayerTools.AOMultiPlayerToolsSetupFastGame(_PlayerID)
	Logic.SetTechnologyState(_PlayerID, Technologies.GT_Mathematics,3)
end


function
MultiplayerTools.CreatePatrolingTroop(_PlayerId, _Entity, _Soldiers, _StartPosition, _TargetPosition)
	
	--create Troop
	CreateMilitaryGroup(_PlayerId,_Entity,_Soldiers,GetPosition(_StartPosition),_StartPosition,0)
	
	--get targetposition
	local PatrolPosition= {}
	PatrolPosition = GetPosition(_TargetPosition)
	
	--give command
	Logic.GroupPatrol(GetID(_StartPosition), PatrolPosition.X, PatrolPosition.Y)
	
	
end