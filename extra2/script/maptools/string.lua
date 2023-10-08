----------------------------------------------------------------------------------
-- Init function
-- Param1: Main String table name
String = {}
function String.Init(_MainKey)
	-- Set main key
	String.MainKey = _MainKey .."/"
end

----------------------------------------------------------------------------------
-- Get string table key
-- Param1: Get string table key string
function String.Get(_KeyName)

	return XGUIEng.GetStringTableText(String.MainKey.._KeyName)

	end


function String.Key(_KeyName)
	
	return String.MainKey.._KeyName
		
	end
	
	
function String.Table(_KeyName)

	return XGUIEng.GetStringTableText(_KeyName)

	end

function String.Player(_playerId)

	return String.MainKey.."_Player".._playerId.."Name"

end

function String.GenericKey(_KeyName)

	return "CM_GenericText/".._KeyName

end