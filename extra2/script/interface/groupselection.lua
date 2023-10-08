--------------------------------------------------------------------------------
-- Group selection
--------------------------------------------------------------------------------
-- Groups


function GroupSelection_Init()

	-- System inited
	gvGroupSelection = {}

	gvGroupSelection.RememberTroopsInitedFlag = 0
	
	-- Number of troops
	gvGroupSelection.RememberTroopsNumber = 10
	
	-- Maximum number of entities per troop
	gvGroupSelection.RememberTroopsMaximumSize = 50
	
	-- Entity IDs of troops
	gvGroupSelection.RememberTroopsEntityIDs = {}
	
	-- Selection time of troops - in real time seconds
	gvGroupSelection.RememberTroopsSelectionTime = {}
	
end

--------------------------------------------------------------------------------
-- Init groups
--------------------------------------------------------------------------------

function GroupSelection_Troops_Tool_Init()

	-- Already inited?
	if gvGroupSelection.RememberTroopsInitedFlag == 1 then
		return 
	end
	gvGroupSelection.RememberTroopsInitedFlag = 1


	-- Create empty tables
	gvGroupSelection.RememberTroopsEntityIDs = {}
	gvGroupSelection.RememberTroopsSelectionTime = {}
	for i=1, gvGroupSelection.RememberTroopsNumber, 1 do
		gvGroupSelection.RememberTroopsEntityIDs[ i ] = {}
		gvGroupSelection.RememberTroopsSelectionTime[ i ] = 0
	end

end


--------------------------------------------------------------------------------
-- Key to troop index - returns 0 for invalid keys
--------------------------------------------------------------------------------

function GroupSelection_Troops_Tool_KeyToTroopIndex( _key )

	-- Convert key to troop index
	local TroopIndex = _key
	
	-- Validate
	if TroopIndex < 1 then
		TroopIndex = 0
	elseif TroopIndex > gvGroupSelection.RememberTroopsNumber then
		TroopIndex = 0
	end
	
	-- Return index
	return TroopIndex
	
end


--------------------------------------------------------------------------------
-- Selection of groups by keys
--------------------------------------------------------------------------------

function GroupSelection_AssignTroops( _key )

	-- Init when not done yet
	GroupSelection_Troops_Tool_Init()
		
    -- In cutscene?
    if gvGroupSelection.CinematicFlag == 1 then
        return
    end

	-- Get troop ID
	local TroopIndex = GroupSelection_Troops_Tool_KeyToTroopIndex( _key )
	if TroopIndex == 0 then
		return
	end

    -- Create group    
	gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ] = { GUI.GetSelectedEntities() }
	
end


--------------------------------------------------------------------------------
-- Select groups
--------------------------------------------------------------------------------

function GroupSelection_SelectTroops( _key )


	-- Init when not done yet
	GroupSelection_Troops_Tool_Init()
	
	
    -- In cutscene?
    if gvGroupSelection.CinematicFlag == 1 then
        return
    end


	-- Get troop ID
	local TroopIndex = GroupSelection_Troops_Tool_KeyToTroopIndex( _key )
	if TroopIndex == 0 then
		return
	end


	-- Check if we should jump to group
	local JumpToTroop = 0
	do
	
		-- Get system time
		local CurrentTime = Game.RealTimeGetMs() / 1000
		
		-- Less than x time gone since last selection?
		local DeltaTime = CurrentTime - gvGroupSelection.RememberTroopsSelectionTime[ TroopIndex ]
		if DeltaTime < 0.5 then
			JumpToTroop = 1
		end
		
		-- Save time
		gvGroupSelection.RememberTroopsSelectionTime[ TroopIndex ] = CurrentTime
		
	end
		
	
	-- Select and place camera
	do
	
		-- Init position
		local XSum = 0
		local YSum = 0
		local NSum = 0
		
		
		-- Select them
		local SelectionCounter = 0
		local i
		for i=1, gvGroupSelection.RememberTroopsMaximumSize, 1 do
		
			-- Check if ID is set
			if		gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] ~= nil 
				and gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] ~= 0 
			then
			
				-- Get ID
				local EntityID = gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ]
				
				-- Is entity still valid?
				if Logic.IsEntityDestroyed( EntityID ) then
				
					-- Nope! Clear entity ID
					gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] = 0
					
				else
				
					-- Yeap: select it
					if SelectionCounter == 0 then
						GUI.SetSelectedEntity( EntityID )
					else
						GUI.SelectEntity( EntityID )
					end
					SelectionCounter = SelectionCounter + 1
					
					-- Update position
					local X, Y = Logic.GetEntityPosition( EntityID )
					if X ~= 0 then
						XSum = XSum + X
						YSum = YSum + Y
						NSum = NSum + 1
					end
								
				end
			end
		end
		
		
		-- Place camera if wanted
		if JumpToTroop == 1 then
			if NSum ~= 0 then
				Camera.ScrollSetLookAt( XSum / NSum, YSum / NSum )	
			end
		end
		
	end

end


--------------------------------------------------------------------------------
-- Resdign groups after upgrade
--------------------------------------------------------------------------------

function
GroupSelection_EntityIDChanged( _OldID, _NewID )

	-- Init when not done yet
	GroupSelection_Troops_Tool_Init()


	-- For all troops
	local TroopIndex
	for TroopIndex=1, gvGroupSelection.RememberTroopsNumber, 1 do
		if gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ] ~= nil then
		
			-- For all soldiers in troop
			local i
			for i=1, gvGroupSelection.RememberTroopsMaximumSize, 1 do
				if		gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] ~= nil 
					and gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] ~= 0 
				then
		
					-- Change entity ID when changing
					if gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] == _OldID then
						gvGroupSelection.RememberTroopsEntityIDs[ TroopIndex ][ i ] = _NewID
					end

				end
			end
		end
	end
	
end 


--------------------------------------------------------------------------------
