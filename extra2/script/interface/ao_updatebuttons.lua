--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AO: Update Buttons
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function GUIUpdate_AbilityButtons(_Button, _Technology)

	
	local PlayerID = GUI.GetPlayerID()
	local TechState = Logic.GetTechnologyState(PlayerID, _Technology)
	
	--Building is interdicted
	if TechState == 0 then	
		XGUIEng.DisableButton(_Button,1)
	
	--Building is not available yet or Technology is to far in the futur
	elseif TechState == 1 or TechState == 2 or TechState == 5 or TechState == 3 then
		XGUIEng.DisableButton(_Button,1)
		XGUIEng.ShowWidget(_Button,1)
		
	--Building is enabled and visible	
	elseif TechState == 4 then
		XGUIEng.ShowWidget(_Button,1)
		XGUIEng.DisableButton(_Button,0)	
	end

end

function GUITooltip_AbilityButton(_Technology,_Tooltip,_ShortCut)
	
	local PlayerID = GUI.GetPlayerID()
	local TechState = Logic.GetTechnologyState(PlayerID, _Technology)
	
	local CostString = " "
	local ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
	local TooltipText= " "
	
	if TechState == 3 or TechState == 4 then		
		TooltipText = _Tooltip .. "_normal"
	else
		TooltipText = _Tooltip .. "_disabled"
	end
	
	if TechState == 0 then
		TooltipText =  "MenuGeneric/TechnologyNotAvailable"
	end
	
	
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)	
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipText)		
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end




function GUIUpdate_ThiefSelection()
	local ThiefID = GUI.GetSelectedEntity()
	
	if ThiefID ~= nil then
		local RessouceID, RessourceAmount = Logic.GetStolenResourceInfo(ThiefID)
		
		if RessouceID == 0 then
			XGUIEng.ShowWidget( "Commands_ThiefHasStolen",0 )
			XGUIEng.ShowWidget( "Commands_ThiefNormal",1 )			
		else
			XGUIEng.ShowWidget( "Commands_ThiefHasStolen",1 )
			XGUIEng.ShowWidget( "Commands_ThiefNormal",0 )
			
			RessourceAmount = "@ra " .. RessourceAmount
			
			XGUIEng.SetText("Thief_StolenRessourceAmount", RessourceAmount)	
			
			
			local SourceTexture = "data\\graphics\\textures\\gui\\"
			
			if RessouceID == ResourceType.ClayRaw
			or RessouceID == ResourceType.Clay then
				SourceTexture = SourceTexture .. "i_res_mud.png"
			elseif RessouceID == ResourceType.WoodRaw 
			or RessouceID == ResourceType.Wood then
				SourceTexture = SourceTexture .. "i_res_wood.png"
			elseif RessouceID == ResourceType.StoneRaw
			or RessouceID == ResourceType.Stone then
				SourceTexture = SourceTexture .. "i_res_stone.png"
			elseif RessouceID == ResourceType.SulfurRaw 
			or RessouceID == ResourceType.Sulfur then
				SourceTexture = SourceTexture .. "i_res_sulfur.png"
			elseif RessouceID == ResourceType.IronRaw 
			or RessouceID == ResourceType.Iron then
				SourceTexture = SourceTexture .. "i_res_iron.png"
			else
				SourceTexture = SourceTexture .. "i_res_gold.png"
			end
			
			XGUIEng.SetMaterialTexture("Thief_StolenRessourceType",1,SourceTexture)
			

		end
	end
	
end



function GUIUpdate_AOHintText()

	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local NameAndType = {Framework.GetCurrentMapTypeAndCampaignName()}
	local Type = NameAndType[1]

	-- is map a campaign map?
	if Type == -1 then
		local Name = Framework.GetCurrentMapName()
		local MapTitle, MapDesc = Framework.GetMapNameAndDescription( Name, -1, NameAndType[2] )		
		
		local HintText 
		
		if NameAndType[2] == "Extra1" then
			HintText = XGUIEng.GetStringTableText( "CM02_MapHints/" .. Name )
		elseif NameAndType[2] == "Extra2_1" then
			HintText = XGUIEng.GetStringTableText( "CM03_MapHints/" .. Name )
		elseif NameAndType[2] == "Extra2_2" then
			HintText = XGUIEng.GetStringTableText( "CM04_MapHints/" .. Name )
		elseif NameAndType[2] == "Extra2_3" then
			HintText = XGUIEng.GetStringTableText( "CM05_MapHints/" .. Name )
		elseif NameAndType[2] == "Extra2_4" then
			HintText = XGUIEng.GetStringTableText( "CM06_MapHints/" .. Name )			
		else		
			if Name == "13_Plague" then
				Name = "13_Plaque"
			end
			
			HintText = XGUIEng.GetStringTableText( "CM01_MapHints/" .. Name )
		end
			
			
			
		XGUIEng.SetText("GameEndScreen_OutputBG", HintText)	
		XGUIEng.SetText(CurrentWidgetID, MapTitle)	
	
	end
end