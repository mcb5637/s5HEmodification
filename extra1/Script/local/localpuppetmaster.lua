---------------------------------------------------------------------------
-- Puppet Master for GC 2004
-- Author: Andreas Suika

function
	PuppetMasterInit()
	
	gvScholarTalkFlag = 0	
	gvScholarID = 0
	gvBNID = 0

	gvPodiumToggle = 0		
	gvPodiumID = 0
	
	gvToggleCamera = 0
	
	Input.KeyBindDown( Keys.NumPad9, "Toggel_GCBlackKnightOrder()" )
	
	Input.KeyBindDown( Keys.NumPad0, "Toggel_GCScholarTalking(TaskLists.TL_NPC_IDLE)" )
	Input.KeyBindDown( Keys.NumPad1, "Toggel_GCScholarTalking(TaskLists.TL_GC_SCHOLAR_TALK1)" )
	Input.KeyBindDown( Keys.NumPad2, "Toggel_GCScholarTalking(TaskLists.TL_GC_SCHOLAR_TALK2)" )
	Input.KeyBindDown( Keys.NumPad3, "Toggel_GCScholarTalking(TaskLists.TL_GC_SCHOLAR_TALK3)" )
	Input.KeyBindDown( Keys.ModifierAlt + Keys.D1, "Create_Scholar()" )
	Input.KeyBindDown( Keys.ModifierAlt + Keys.D2, "Create_BN()" )	
	Input.KeyBindDown( Keys.ModifierAlt + Keys.D3, "Toggle_Podium()" )	
	Input.KeyBindDown( Keys.ModifierAlt + Keys.D4, "Toggle_Camera()" )	
	
	Input.KeyBindDown( Keys.ModifierControl  +Keys.D1, "Destroy_Scholar()" )
	Input.KeyBindDown( Keys.ModifierControl  +Keys.D2, "Destroy_BN()" )
end


function
Toggel_GCBlackKnightOrder()	
	if gvBNID ~=  0 and gvBNID ~= nil then
		Logic.SetTaskList(gvBNID,TaskLists.TL_GC_BLACKKNIGHT_ORDER)	
	end
	
end

function
Toggel_GCScholarTalking(_TaskList)	
	if gvScholarID ~= 0 and gvScholarID ~= nil then		
		Logic.SetTaskList(gvScholarID,_TaskList)			
	end
end

function
Destroy_Scholar()
	gvScholarID = Destroy_Puppets(gvScholarID)
end

function
Destroy_BN()
	gvBNID = Destroy_Puppets(gvBNID)
end

function
Destroy_Puppets(_EntityID)
	
	--Does Entity  exist?
	if _EntityID ~= 0
	and _EntityID ~= nil then				
		
		local EntityX,EntityY = Logic.GetEntityPosition(_EntityID)	
		Logic.CreateEffect(GGL_Effects.FXDie,EntityX,EntityY, 1)
		Logic.DestroyEntity(_EntityID)	
	end
	return _EntityID

end

function
Create_Puppet(_EntityID, _EntityType, _EffectType , _Orientation)
	
	local x,y = GUI.Debug_GetMapPositionUnderMouse()
		
	--Does Entity  exist?
	if _EntityID ~= 0
	and _EntityID ~= nil then				
		Logic.DestroyEntity(_EntityID)		
		if _EntityID == gvScholarID then
			Logic.DestroyEntity(gvPodiumID)		
		end
	end
	
	
	local EntityID = Logic.CreateEntity(_EntityType,x,y,_Orientation,8)
	
	if _EffectType ~= nil then	
		local EntityX,EntityY = Logic.GetEntityPosition(EntityID)	
		Logic.CreateEffect(_EffectType,EntityX,EntityY, 1)
	end
	return EntityID
	
end

function
Create_Scholar()
	gvScholarID = Create_Puppet(gvScholarID,Entities.CU_GCScholar,GGL_Effects.FXCrushBuilding,210)
end	

function
Create_BN()	
	gvBNID = Create_Puppet(gvBNID,Entities.CU_GCBlackKnight,GGL_Effects.FXExplosion,275)
end	

function
Toggle_Podium()
	
	if gvScholarID ~= 0 and gvScholarID ~= nil then
		if gvPodiumToggle == 1 then
			if gvPodiumID ~= 0 and gvPodiumID ~= nil then			
				Logic.DestroyEntity(gvPodiumID)		
				gvPodiumToggle = 0
				gvPodiumID = 0
				return 
			end
		else
			
			local EntityX,EntityY = Logic.GetEntityPosition(gvScholarID)	
			local EntityID = Logic.CreateEntity(Entities.XD_GCPodium,EntityX,EntityY,300,8)		
			Logic.CreateEffect(GGL_Effects.FXExplosion,EntityX,EntityY, 5)
			gvPodiumToggle = 1
			gvPodiumID = EntityID
			return 
		end
	end
	
end

function
Toggle_Camera()
	
	if gvToggleCamera == 0 then
		if gvScholarID ~= 0 or gvScholarID ~= nil then
			local EntityX,EntityY = Logic.GetEntityPosition(gvScholarID)
			
			gvCamera.DefaultFlag = 0
			Camera.ZoomSetDistanceGameTimeSynced(1000)
			Camera.RotSetAngle(-60)	
			Camera.ZoomSetAngle(26)			
			Camera.ScrollSetLookAt(EntityX,EntityY)		
			Game.GUIActivate(0)
			gvToggleCamera = 1
		end
	else
		gvCamera.DefaultFlag = 1	
		Display_SetDefaultValues()		
		GameCallback_Camera_CalculateZoom( 1 )			
		gvToggleCamera = 0
	end
end