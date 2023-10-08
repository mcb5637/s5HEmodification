--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Update Tooltips
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--------------------------------------------------------------------------------
-- Display the Costs and the Text for the building buttons
--------------------------------------------------------------------------------

function
GUITooltip_ConstructBuilding(_CategoryType, _NormalTooltip, _DiabledTooltip,_TechnologyType, _ShortCut)

	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

	local PlayerID = GUI.GetPlayerID()	
	Logic.FillBuildingCostsTable( Logic.GetBuildingTypeByUpgradeCategory(_CategoryType, PlayerID ), InterfaceGlobals.CostTable )
	local CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )
	local TooltipText = " "
	local ShortCutToolTip = " "
	local ShowCosts = 1
	
	if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then		
		TooltipText =  _DiabledTooltip		
	else
		TooltipText = _NormalTooltip
		if _ShortCut ~= nil then
			ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
		end
	end
	
	if _TechnologyType ~= nil then
		local TechState = Logic.GetTechnologyState(PlayerID, _TechnologyType)			
		if TechState == 0 then
			TooltipText =  "MenuGeneric/BuildingNotAvailable"
			ShowCosts = 0
		end
	end
	
	
	if ShowCosts == 0 then
		CostString = " "
	end
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipText)		
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end


--------------------------------------------------------------------------------
-- Display the Costs and the Text for the upgarde buttons
--------------------------------------------------------------------------------

function
GUITooltip_UpgradeBuilding(_BuildingType, _DisabledTooltip, _NormalTooltip, _TechnologyType)
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local PlayerID = GUI.GetPlayerID()	
	Logic.FillBuildingUpgradeCostsTable( _BuildingType, InterfaceGlobals.CostTable )
	local CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )
	local TooltipText = " "
	local ShowCosts = 1
	
	local ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText("KeyBindings/UpgradeBuilding") .. "]"
	
		
	if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then		
		TooltipText = _DisabledTooltip				
	else
		TooltipText = _NormalTooltip
	end
	
	if _TechnologyType ~= nil then
		local TechState = Logic.GetTechnologyState(PlayerID, _TechnologyType)			
		if TechState == 0 then
			TooltipText =  "MenuGeneric/UpgradeNotAvailable"
			ShowCosts = 0
		end
	end
	
	if ShowCosts == 0 then		
		CostString = " "
	end
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText,TooltipText)
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end


--------------------------------------------------------------------------------
-- Display the Costs and the Text for the technology buttons with only one additional parameter for the textkey
--------------------------------------------------------------------------------
function
GUITooltip_ResearchTechnologies(_TechnologyType,_Tooltip, _ShortCut)
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local PlayerID = GUI.GetPlayerID()
	local TechState = Logic.GetTechnologyState(PlayerID, _TechnologyType)	
	Logic.FillTechnologyCostsTable(_TechnologyType, InterfaceGlobals.CostTable)	
	local CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )		
	local TooltipText = " "
	local ShortCutToolTip = " "
	local ShowCosts = 1
	
	if TechState == 0 then
		TooltipText =  "MenuGeneric/TechnologyNotAvailable"
		ShowCosts = 0
	elseif TechState == 1 or  TechState == 5 then		
	--if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then		
		TooltipText =  _Tooltip .. "_disabled"
		ShowCosts = 1
	elseif TechState == 2 or TechState == 3 then 
	--elseif XGUIEng.IsButtonDisabled(CurrentWidgetID) == 0 then		
		TooltipText = _Tooltip .. "_normal"
		if _ShortCut ~= nil then
			ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
		end
	
	--overwright Tooltip if technology is researched
	elseif TechState == 4 then		
		TooltipText = _Tooltip .. "_researched"
		ShowCosts = 1
	end
	
	if ShowCosts == 0 then
		CostString = " "
	end
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipText)
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end
--------------------------------------------------------------------------------
-- Display the Costs and the Text for the Buy Serf Button
--------------------------------------------------------------------------------

function
GUITooltip_BuySerf()

	Logic.FillSerfCostsTable(InterfaceGlobals.CostTable)
	local CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )
	
	local ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText("KeyBindings/BuyUnits1") .. "]"
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	--AnSu: CHANGE THIS! No Text in Script!
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText,"MenuHeadquarter/BuySerf")
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end

--------------------------------------------------------------------------------
-- Display the Costs and the Text for Buttons that buy military units
--------------------------------------------------------------------------------

function
GUITooltip_BuyMilitaryUnit(_UpgradeCategory,_NormalTooltip,_DisabledTooltip, _TechnologyType,_ShortCut)
	
	
	local PlayerID = GUI.GetPlayerID()		
	
	local SettlerTypeID = Logic.GetSettlerTypeByUpgradeCategory(_UpgradeCategory, PlayerID )
	
	Logic.FillLeaderCostsTable(PlayerID, _UpgradeCategory, InterfaceGlobals.CostTable)
	local CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )
	local TooltipText = _NormalTooltip
	local NeededPlaces = Logic.GetAttractionLimitValueByEntityType(SettlerTypeID)
	local ShortCutToolTip = " "
	
	CostString = CostString .. XGUIEng.GetStringTableText("InGameMessages/GUI_NamePlaces") .. ": " .. NeededPlaces
	
	
	if _TechnologyType ~= nil then
		local TechState = Logic.GetTechnologyState(PlayerID, _TechnologyType)			
		if TechState == 0 then
			TooltipText =  "MenuGeneric/UnitNotAvailable"
			CostString = " "
		elseif TechState == 1 then
			TooltipText = _DisabledTooltip
		end
	end
	
	if _ShortCut ~= nil then
		ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
	end
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipText)
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end

--------------------------------------------------------------------------------
-- Display Text and costs for a buy soldiers button
--------------------------------------------------------------------------------

function
GUITooltip_BuySoldier(_NormalTooltip, _DisabledTooltip,_ShortCut)
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local LeaderID = GUI.GetSelectedEntity()
	local PlayerID = GUI.GetPlayerID()
		
	
	local UpgradeCategory = Logic.LeaderGetSoldierUpgradeCategory( LeaderID )
	Logic.FillSoldierCostsTable(PlayerID, UpgradeCategory, InterfaceGlobals.CostTable)
	local CostString = InterfaceTool_CreateCostString( InterfaceGlobals.CostTable )
	local ShortCutToolTip = " "
	
	if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then		
		TooltipText =  _DisabledTooltip
	elseif XGUIEng.IsButtonDisabled(CurrentWidgetID) == 0 then		
		TooltipText = _NormalTooltip
	end
	
	if _ShortCut ~= nil then
		ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
	end

	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipText)	
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
	
end

--------------------------------------------------------------------------------
-- Display the Text for the Bless buttons
--------------------------------------------------------------------------------
function
GUITooltip_BlessSettlers(_DisabledTooltip,_NormalTooltip,_NotUsed, _ShortCut)
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local ShortCutToolTip = " "
	
	if XGUIEng.IsButtonDisabled(CurrentWidgetID) == 1 then		
		TooltipText =  _DisabledTooltip
	elseif XGUIEng.IsButtonDisabled(CurrentWidgetID) == 0 then		
		TooltipText = _NormalTooltip
	end
	
	if _ShortCut ~= nil then
		ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
	end
	
	CostString = ""
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipText)
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
end


--------------------------------------------------------------------------------
-- Display Text for a normal button
--------------------------------------------------------------------------------
function
GUITooltip_NormalButton(_TooltipString, _ShortCut)
	local CostString = " "
	local ShortCutToolTip = " "
	
	if _ShortCut ~= nil then
		ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
	end
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, _TooltipString)
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
end

--------------------------------------------------------------------------------
-- Display generic tooltip (AnSu: put Normal Button and this function together)
--------------------------------------------------------------------------------
function
GUITooltip_Generic(_TooltipString)
	GUITooltip_NormalButton(_TooltipString, _ShortCut)
end

--------------------------------------------------------------------------------
-- Tooltip Levy Taxes
--------------------------------------------------------------------------------

function
GUITooltip_LevyTaxes()
	
	local PlayerID = GUI.GetPlayerID()
	local TaxAmount = Logic.GetPlayerTaxIncome( PlayerID )
	local CostString = "Taxes: " .. TaxAmount
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, "MenuHeadquarter/levytaxes")
	
end

--------------------------------------------------------------------------------
-- Display payday tooltip
--------------------------------------------------------------------------------

function
GUITooltip_Payday()
	
	local TooltipString = ""
	local PlayerID = GUI.GetPlayerID()
	local PaydayTimeLeft = math.ceil(Logic.GetPlayerPaydayTimeLeft(PlayerID)/1000)
	local PaydayFrequency = Logic.GetPlayerPaydayFrequency(PlayerID)	
	local PaydayCosts = Logic.GetPlayerPaydayCost(PlayerID)
	
	--local TooltipString= " @color:200,200,200,255 " .. XGUIEng.GetStringTableText("IngameMenu/NameTaxday") .. "@cr " .. PaydayTimeLeft .. " @color:255,255,255,255 seconds left until you get @color:200,200,200,255 " .. PaydayCosts .. " @color:255,255,255,255 Gold Taxes" 
	local TooltipString= " @color:200,200,200,255 " .. XGUIEng.GetStringTableText("IngameMenu/NameTaxday") .. " @cr " .. PaydayTimeLeft .. " @color:255,255,255,255 " .. XGUIEng.GetStringTableText("IngameMenu/TimeUntilTaxday")
		
	XGUIEng.SetText("TooltipTopText", TooltipString)
		
end 

function
GUITooltip_WokerButtons(_tooltip)

	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()

	local CostString = " "
	local ShortCutToolTip = " "
	local TooltipString = _tooltip
	
	if XGUIEng.IsButtonDisabled( CurrentWidgetID  ) == 1 then
		TooltipString = TooltipString .. "_notavailable"
	elseif XGUIEng.IsButtonHighLighted( CurrentWidgetID  ) == 1 then
		TooltipString = TooltipString .. "_upgrading"
	else
		TooltipString = TooltipString .. "_normal"
	end
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipString)
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
end


function
GUITooltip_FindHero()

	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()	
	local EntityID = XGUIEng.GetBaseWidgetUserVariable(CurrentWidgetID, 0)
	
	local CostString = " "
	local ShortCutToolTip = " "
	local TooltipString = " "
	
	if EntityID  ~= 0 then
		if Logic.IsEntityInCategory(EntityID,EntityCategories.Hero1) == 1 then	
			TooltipString = "MenuTop/Find_hero1"
		elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero2) == 1 then
			TooltipString = "MenuTop/Find_hero2"
		elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero3) == 1 then
			TooltipString = "MenuTop/Find_hero3"
		elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero4) == 1 then
			TooltipString = "MenuTop/Find_hero4"
		elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero5) == 1 then
			TooltipString = "MenuTop/Find_hero5"
		elseif Logic.IsEntityInCategory(EntityID,EntityCategories.Hero6) == 1 then
			TooltipString = "MenuTop/Find_hero6"
		elseif Logic.GetEntityType( EntityID )	== Entities.CU_BlackKnight then
			TooltipString = "MenuTop/Find_hero7"
		elseif Logic.GetEntityType( EntityID )	== Entities.CU_Mary_de_Mortfichet then
			TooltipString = "MenuTop/Find_hero8"
		elseif Logic.GetEntityType( EntityID )	== Entities.CU_Barbarian_Hero then
			TooltipString = "MenuTop/Find_hero9"	
		end
	end
	
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString)
	XGUIEng.SetTextKeyName(gvGUI_WidgetID.TooltipBottomText, TooltipString)
	XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip)
end