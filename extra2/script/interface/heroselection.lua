-----------------------------------------------------------------------------------------------------------
-- Hero Selection
-- Tool function to allow switching between heroes in multiselection and using their abilities
-----------------------------------------------------------------------------------------------------------
-- Update hero selection and take same hero if possible else first in list
-----------------------------------------------------------------------------------------------------------

function HeroSelection_Init()

	-- Remember last type
	local lastHeroType = HeroSelection_GetCurrentHeroType()

	-- Reset hero type
	HeroSelection_SetCurrentHeroType(0)

	-- Search in selection for heroes
	if GUI_Selection ~= nil then
		
		local i
		for i=1, table.getn(GUI_Selection) do
	
			if Logic.IsHero(GUI_Selection[i]) == 1 then
	
				-- No current hero type set
				if HeroSelection_GetCurrentHeroType() == 0 then
					
					-- Set first found
					HeroSelection_SetCurrentHeroType(Logic.GetEntityType(GUI_Selection[i]))
				
				-- Same as last time
				elseif lastHeroType == Logic.GetEntityType(GUI_Selection[i]) then
				
					-- Use same hero
					HeroSelection_SetCurrentHeroType(lastHeroType)
				
				end
				
			end 
	
		end
	end	

end

-----------------------------------------------------------------------------------------------------------
-- Switch selection to next hero
-----------------------------------------------------------------------------------------------------------

function HeroSelection_Next()

	-- Search in selection for other hero
	if GUI_Selection ~= nil then
		
		-- Remember last type
		local currentHeroID = HeroSelection_GetCurrentSelectedHeroID()

		-- Any hero there if not, we can not found one because init select first hero automaticly
		if currentHeroID ~= 0 then

			local nextHeroID = -1
		
			local i
			for i=1, table.getn(GUI_Selection) do
	
				-- search for selected hero
				if GUI_Selection[i] == currentHeroID then
					nextHeroID = 0
				elseif nextHeroID == 0 then
					
					if Logic.IsHero(GUI_Selection[i]) == 1 then
						nextHeroID = GUI_Selection[i]
						break
					end
				end
					
			end
			
			-- Any Hero found
			if nextHeroID > 0 then
				
				HeroSelection_SetCurrentHeroType(Logic.GetEntityType(nextHeroID))				
				
			else
	
				-- Search first hero
				HeroSelection_SetCurrentHeroType(0)				
				HeroSelection_Init()
			end
			
		end
	end	

end

-----------------------------------------------------------------------------------------------------------
-- Switch selection to previous hero
-----------------------------------------------------------------------------------------------------------

function HeroSelection_Previous()

	-- Search in selection for other hero
	if GUI_Selection ~= nil then
		
		-- Remember last type
		local currentHeroID = HeroSelection_GetCurrentSelectedHeroID()

		-- Any hero there if not, we can not found one because init select first hero automaticly
		if currentHeroID ~= 0 then

			local previousHeroID = 0
		
			local i
			for i=1, table.getn(GUI_Selection) do
	
				-- search for selected hero
				if GUI_Selection[i] == currentHeroID then
					break
				else	
					if Logic.IsHero(GUI_Selection[i]) == 1 then
						previousHeroID = GUI_Selection[i]
					end
				end
					
			end
			
			-- Any Hero found
			if previousHeroID > 0 then
				
				HeroSelection_SetCurrentHeroType(Logic.GetEntityType(previousHeroID))				
				
			else
	
				-- Search from behind
				local previousHeroID = 0
			
				local i
				for i=table.getn(GUI_Selection), 1,-1 do
		
					-- search for selected hero
					if GUI_Selection[i] == currentHeroID then
						break
					else	
						if Logic.IsHero(GUI_Selection[i]) == 1 then
							previousHeroID = GUI_Selection[i]
							break
						end
					end
				end
				
				if previousHeroID > 0 then
					
					HeroSelection_SetCurrentHeroType(Logic.GetEntityType(previousHeroID))				
						
				end
			end
			
		end
	end	

end

-----------------------------------------------------------------------------------------------------------
-- Get current selected hero id
-----------------------------------------------------------------------------------------------------------

function HeroSelection_GetCurrentSelectedHeroID()

	-- Search in selection for heroes
	if GUI_Selection ~= nil then
		
		local i
		for i=1, table.getn(GUI_Selection) do
			
			if Logic.GetEntityType(GUI_Selection[i]) == HeroSelection_CurrentHeroType then
				return GUI_Selection[i]
			end
		end
	end		
	
	return 0
end

-----------------------------------------------------------------------------------------------------------
-- Get current selected hero entity type
-----------------------------------------------------------------------------------------------------------
function HeroSelection_GetCurrentHeroType()

	if HeroSelection_CurrentHeroType == nil then
		
		HeroSelection_CurrentHeroType = 0
		
	end

	return HeroSelection_CurrentHeroType

end

-----------------------------------------------------------------------------------------------------------
-- Set current selected hero entity type
-----------------------------------------------------------------------------------------------------------

function HeroSelection_SetCurrentHeroType(_type)

	HeroSelection_CurrentHeroType = _type

end