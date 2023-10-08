--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- DEBUG 
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- State debug window 1
gvInterfaceDebugWindow1StatusFlag = 0

--------------------------------------------------------------------------------
-- Called by key binding to enable / disable the debug window 1

function Interface_ToggleDebugWindow1()
	
	gvInterfaceDebugWindow1StatusFlag = 1 - gvInterfaceDebugWindow1StatusFlag
	
	XGUIEng.ShowWidget( "DebugWindow", gvInterfaceDebugWindow1StatusFlag )

	--Game.ShowFPS( gvInterfaceDebugWindow1StatusFlag )
	
end

--------------------------------------------------------------------------------
-- Called by debug window for update

function GUIUpdate_UpdateDebugInfo()

	-- Get player ID    
	local PlayerID = GUI.GetPlayerID()
	
    -- Get entity under mouse
	local EntityID = GUI.GetEntityAtPosition( GUI.GetMousePosition() )
	
	-- Init debug string
	local DebugString = ""
	
	
	-- Anything under mouse?
	if EntityID  ~= 0 then	
		
		-- Print entity id
    	DebugString = DebugString .. "EntityID: " .. EntityID .. " @cr "
    		
   		-- Print entity type
    	local EntityType = Logic.GetEntityType( EntityID )
		DebugString = DebugString .. "EntityType: " .. EntityType .. " - " .. Logic.GetEntityTypeName( EntityType ) .. " @cr "

        -- Player id		
		DebugString = DebugString .. "Player: " .. Logic.EntityGetPlayer( EntityID ) .. " @cr "
		
		-- Health
		DebugString = DebugString .. "Health: " .. Logic.GetEntityHealth( EntityID ) .. " @cr "
		
		-- Current Sector
		DebugString = DebugString .. "Sector ID: " .. Logic.GetSector( EntityID ) .. " @cr "
		
		-- Is it a settler?
        if Logic.IsSettler( EntityID ) == 1 then
        
            -- Motivation
 			DebugString = DebugString .. "Motivation: " .. Logic.GetSettlersMotivation( EntityID ) .. " @cr "
			
			-- Work building
			local WorkPlaceEntityId = Logic.GetSettlersWorkBuilding( EntityId )
			if WorkPlaceEntityId  ~= 0 then
				local WorkPlaceEntityType = Logic.GetEntityType( WorkPlaceEntityId  )
				DebugString = DebugString .. "WorkPlaceEntityId: " .. WorkPlaceEntityId .. " - " .. Logic.GetEntityTypeName( WorkPlaceEntityType  ) .. " @cr "
			end
            
            -- Residence
			local ResidenceEntityId = Logic.GetSettlersResidence( EntityID )
			if ResidenceEntityId ~= 0 then
				local ResidenceEntityType = Logic.GetEntityType( ResidenceEntitId )
				--DebugString = DebugString .. "ResidenceEntityId: " .. ResidenceEntityId .. " - " .. Logic.GetEntityTypeName( ResidenceEntityType ) .. " @cr "
			end
            
            -- Farm
			local FarmEntityId = Logic.GetSettlersFarm( EntityID )
			if FarmEntityId ~= 0 then
				local FarmEntityType = Logic.GetEntityType( FarmEntityId )
				DebugString = DebugString .. "FarmEntityId: " .. FarmEntityId .. " - " .. Logic.GetEntityTypeName( FarmEntityType ) .. " @cr "
			end
			
			-- Task
			local TaskListEntityId  = Logic.GetCurrentTaskList( EntityID )
			if TaskListEntityId  ~= nil then
					DebugString = DebugString .. "CurrentTaskList: " .. TaskListEntityId  ..  " @cr "
			end
			
			DebugString = DebugString .. "Distance: " .. Display.GetDistanceToCamera(EntityID) .. " @cr "
		
		end
        
        -- Seperator line
		DebugString = DebugString .. "  @cr "

	end

	
	-- Generic infos
    do
    
        -- Player info
    	DebugString = DebugString .. "AttractionLimit: " .. Logic.GetNumberOfAttractedSettlers( PlayerID ) .. "-" .. Logic.GetPlayerAttractionLimit( PlayerID ) .. " @cr "
    	DebugString = DebugString .. "SleepPlaces: " .. Logic.GetPlayerSleepPlaceUsage( PlayerID ) .. "-" .. Logic.GetPlayerSleepPlacesLimit( PlayerID ) .. " @cr "
    	DebugString = DebugString .. "EatPlaces: " .. Logic.GetPlayerEatPlaceUsage( PlayerID ) .. "-" .. Logic.GetPlayerEatPlacesLimit( PlayerID ) .. " @cr "    	
    	DebugString = DebugString .. "Knowledge: " .. Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Knowledge ) .. " @cr "
    	DebugString = DebugString .. "Stone: " .. Logic.GetPlayersGlobalResource( PlayerID, ResourceType.Stone ) .. " @cr "
    
        -- Seperator line
    	DebugString = DebugString .. "  @cr "
    	
    end


	-- GUI
	do
	
        -- GUI state
    	DebugString = DebugString .. "GuiState: " .. GUI.GetCurrentStateName() .. " @cr "
    	
	end
		
	
	-- String cannot end with  @cr 
	DebugString = DebugString .. " "

		
	-- Set string
	XGUIEng.SetText( "DebugWindow", DebugString )
				
end    


--------------------------------------------------------------------------------
-- State debug window 2
gvInterfaceDebugWindow2StatusFlag = 0

--------------------------------------------------------------------------------
-- Called by key binding to enable / disable the debug window 2

function Interface_ToggleDebugWindow2()
	
	gvInterfaceDebugWindow2StatusFlag = 1 - gvInterfaceDebugWindow2StatusFlag
	
	XGUIEng.ShowWidget( "3dOnScreenDebug", gvInterfaceDebugWindow2StatusFlag )
	
	if gvInterfaceDebugWindow2StatusFlag == 1 then
		GUI.Debug_OnScreenDebug_ShowSettlerInfo( -1 )
	end

end

--------------------------------------------------------------------------------

function Sound_CheckAllSoundIds()

	table.foreach(	Sounds, function(_,_id) 
								local id = Sound.PlayFeedbackSound(_id, 0, 0)
								Sound.StopSound(id)
							end
					)
end