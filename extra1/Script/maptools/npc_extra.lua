NPC_HERO_COUNT = 11

function UpdateHeroesTable_Extra()

		Count, NPCTable_Heroes[10] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero10, 1)
		Count, NPCTable_Heroes[11] = Logic.GetPlayerEntities(gvMission.PlayerID, Entities.PU_Hero11, 1)

end

function NPCInteraction_Extra(_hero,_npc)

	local id = Logic.GetMerchantBuildingId(_npc)

	if id ~= 0 then
		GUIAction_MerchantCallback(id, _hero)
	end

end