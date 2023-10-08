Counter = {}

function Counter.SetLimit(_Name, _Limit)
	Counter[_Name] = {}
	Counter[_Name].Limit = _Limit
	Counter[_Name].TickCount = 0
end

function Counter.GetLimit(_Name)
	return Counter[_Name].Limit
	end

function Counter.IsValid(_Name)
	return Counter[_Name] ~= nil
end

function Counter.Tick(_Name)
	assert(Counter[_Name]~=nil)
	
	Counter[_Name].TickCount = Counter[_Name].TickCount + 1
	if Counter[_Name].TickCount >= Counter[_Name].Limit then
		Counter[_Name].TickCount = 0
		return true
	else
		return false
	end
end

function Counter.Reset(_Name)
	Counter[_Name].TickCount = 0
	end

function Counter.GetTick(_Name)		
	assert(Counter[_Name]~=nil)
	return Counter[_Name].TickCount
end

function Counter.Tick2(_Name,_Limit)
	if Counter[_Name] == nil then
		Counter.SetLimit(_Name, _Limit)
	end
	
	return Counter.Tick(_Name)
end