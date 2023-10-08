function CreateDynamicFog(_name, _currentIndex)

	if dynamicFogTable == nil then
		dynamicFogTable = {}
	end
	
	dynamicFogTable[_name] 				= {}
	dynamicFogTable[_name].currentIndex	= 	_currentIndex
	dynamicFogTable[_name].maxIndex 	=	GetDynamicFogMaxIndex(_name)
	dynamicFogTable[_name].triggerId	=	0
	
	for i=1,dynamicFogTable[_name].maxIndex do
		
		dynamicFogTable[_name][i] 				=	{}
		
		if dynamicFogTable[_name].currentIndex >= i then
			dynamicFogTable[_name][i].alpha		=	1
		else
			dynamicFogTable[_name][i].alpha		=	0
		end
		
		dynamicFogTable[_name][i].blendingTime	=	0
		dynamicFogTable[_name][i].startTime		=	0
		dynamicFogTable[_name][i].done 			=	true
		
	end
	
	SetupDynamicFog(_name, _currentIndex)
	
end

function GetDynamicFogMaxIndex(_name)

	local i = 0

	while IsExisting(_name..(i+1).."_1") do
		i = i + 1
	end

	return i

end

function SetupDynamicFog(_name, _currentIndex)

	for i=1,dynamicFogTable[_name].maxIndex do
		
		TransferDynamicFogAlphaBlending(_name, i, dynamicFogTable[_name][i].alpha, 0)
		
	end

end

function TransferDynamicFogAlphaBlending(_name, _index, _alpha, _time)

	local i = 1
		
	while IsExisting(_name.._index.."_"..i) do
		
		Logic.StartAlphaBlending(GetEntityId(_name.._index.."_"..i),_alpha, _time)
		
		i = i + 1
		
	end

end

function ChangeDynamicFog(_name, _newIndex, _time)

	-- new index must be valid
	assert(_newIndex <= dynamicFogTable[_name].maxIndex)
	if _newIndex > dynamicFogTable[_name].maxIndex then
		_newIndex = dynamicFogTable[_name].maxIndex
	end

	-- direction of fog
	if dynamicFogTable[_name].currentIndex < _newIndex then
		
		for i=dynamicFogTable[_name].currentIndex+1, _newIndex do
			SetupDynamicFogAlphaBlending(_name,i, i-(dynamicFogTable[_name].currentIndex+1), 1, _time)
		end

	else

		for i=_newIndex+1, dynamicFogTable[_name].currentIndex do
			SetupDynamicFogAlphaBlending(_name,i, dynamicFogTable[_name].currentIndex-i, 0, _time)
		end
	
	end

	dynamicFogTable[_name].currentIndex = _newIndex

	-- Hostage trigger
	assert(dynamicFogTable[_name].triggerId==0)
	dynamicFogTable[_name].triggerId = Trigger.RequestTrigger( Events.LOGIC_EVENT_EVERY_TURN,
																nil,
																"ExecuteDynamicFog",
																1,
																nil,
																{_name})

end

function SetupDynamicFogAlphaBlending(_name, _index, _offset, _alpha, _time)

	dynamicFogTable[_name][_index].done 		=	false
	dynamicFogTable[_name][_index].alpha 		=	_alpha
	dynamicFogTable[_name][_index].blendingTime	=	_time
	dynamicFogTable[_name][_index].startTime	=	Logic.GetTime()+(_time/2)*_offset
		
end

function ExecuteDynamicFog(_name)

	local blendingDone = true
	
	for i=1, dynamicFogTable[_name].maxIndex do
		
		-- not done
		if dynamicFogTable[_name][i].done ~= true then
			
			-- Is time to start fading
			local time = Logic.GetTime()
			if time >= dynamicFogTable[_name][i].startTime then
				
				local blendingTime = (dynamicFogTable[_name][i].startTime-time)+dynamicFogTable[_name][i].blendingTime
				
				TransferDynamicFogAlphaBlending(_name, i, dynamicFogTable[_name][i].alpha, blendingTime )
				
				dynamicFogTable[_name][i].done = true
				
			end
			
			blendingDone = false
				
		end
		
	end	

	if blendingDone then
		dynamicFogTable[_name].triggerId = 0
	end

	return blendingDone

end
