Explore = {}
Explore.ID = {}

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Create an exploration or move to another position
-- Param1: Name of exploration
-- Param2: Position table, id or entity name
-- Param3: Range in centimeter

function Explore.Show(_Name, _Where, _Range)

	-- Get Type
	local Type = type(_Where)
	
	-- Is string
	if Type == "string" then
		-- Get ID from string
		_Where = Logic.GetEntityIDByName(_Where)
		-- Position is now a number
		Type = "number"
	end
	if Type == "number" then
		-- Get position table
		local ID = _Where
		_Where = {}
		Tools.GetEntityPosition(ID, _Where)
	end


	-- Clear possible old one
	Explore.Hide(_Name)
	
	-- Create new exploration
	Explore.ID[_Name] = GlobalMissionScripting.ExploreArea(_Where.X, _Where.Y, _Range/100)
end

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Destroy an exploration
-- Param1: Name of exploration

function Explore.Hide(_Name)
	-- Exploration with same name there? Destroy it
	if Explore.ID[_Name] ~= nil then
		Logic.DestroyEntity(Explore.ID[_Name])
		Explore.ID[_Name] = nil
	end
end