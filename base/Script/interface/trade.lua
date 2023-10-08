--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Market
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function GUIAction_Market_Init()
	gvGUI.MarketMoneyToBuy = 0
	gvGUI.MarketClayToBuy = 0
	gvGUI.MarketWoodToBuy = 0
	gvGUI.MarketStoneToBuy = 0
	gvGUI.MarketIronToBuy = 0
	gvGUI.MarketSulfurToBuy = 0
end
--------------------------------------------------------------------------------
-- Toggle Ressource amount to buy
--------------------------------------------------------------------------------

function
GUIAction_MarketToggleResource(_value, _resource)
	
	if XGUIEng.IsModifierPressed( Keys.ModifierControl ) == 1 then
		_value = _value * 5
	end
	
	--calculate new amount of resource to buy
	_resource = _resource + _value
	
	--minus is forbidden
	if _resource <= 0 then
		_resource = 0
	end
	
	--Return new amount of resource to buy
	return _resource
	
end

--------------------------------------------------------------------------------
-- Update amount of resources to buy
--------------------------------------------------------------------------------

function
GUIUpdate_MarketGetAmountOfResourceToBuy(_resource)

	XGUIEng.SetTextByValue( XGUIEng.GetCurrentWidgetID(), _resource, 1 )		
	
end

--------------------------------------------------------------------------------
-- Update the price for the given resource
--------------------------------------------------------------------------------

function
GUIUpdate_MarketPrice(_SellResourceType)
	
	local SellAmount = InterfaceTool_MarketGetSellAmount(_SellResourceType)
	XGUIEng.SetTextByValue( XGUIEng.GetCurrentWidgetID(), SellAmount, 1 )
	
end

--------------------------------------------------------------------------------
-- Toolfunction to get the resource type and amount to buy
--------------------------------------------------------------------------------

function
InterfaceTool_MarketGetBuyResourceTypeAndAmount()
	
	local PlayerID = GUI.GetPlayerID()
	local BuyResourceType = 0
	local BuyResourceAmount = 0
	
	if	gvGUI.MarketMoneyToBuy > 0 then
		BuyResourceType = ResourceType.Gold
		BuyResourceAmount = gvGUI.MarketMoneyToBuy
	elseif gvGUI.MarketStoneToBuy > 0 then
		BuyResourceType = ResourceType.Stone
		BuyResourceAmount = gvGUI.MarketStoneToBuy
	elseif gvGUI.MarketIronToBuy > 0 then
		BuyResourceType = ResourceType.Iron
		BuyResourceAmount = gvGUI.MarketIronToBuy
	elseif gvGUI.MarketSulfurToBuy > 0 then
		BuyResourceType = ResourceType.Sulfur
		BuyResourceAmount = gvGUI.MarketSulfurToBuy		
	elseif gvGUI.MarketClayToBuy > 0 then
		BuyResourceType = ResourceType.Clay
		BuyResourceAmount = gvGUI.MarketClayToBuy
	elseif gvGUI.MarketWoodToBuy > 0 then
		BuyResourceType = ResourceType.Wood
		BuyResourceAmount = gvGUI.MarketWoodToBuy
	else
		return
	end
	
	return BuyResourceType, BuyResourceAmount
	
end

--------------------------------------------------------------------------------
-- Tool function to get the sell amount for a given sell resource type
--------------------------------------------------------------------------------

function
InterfaceTool_MarketGetSellAmount(_SellResourceType)

	local PlayerID = GUI.GetPlayerID()
	
	local BuyResourceType, BuyResourceAmount = InterfaceTool_MarketGetBuyResourceTypeAndAmount()
	local SellAmount = 0
	
	if BuyResourceType ~= nil then
		SellAmount = Logic.GetSellAmount(PlayerID, _SellResourceType, BuyResourceType, BuyResourceAmount)	
	end
	
	return SellAmount 
end

--------------------------------------------------------------------------------
-- Clear deal
--------------------------------------------------------------------------------

function
GUIAction_MarketClearDeals()

	gvGUI.MarketMoneyToBuy = 0
	gvGUI.MarketClayToBuy = 0
	gvGUI.MarketWoodToBuy = 0
	gvGUI.MarketStoneToBuy = 0
	gvGUI.MarketIronToBuy = 0
	gvGUI.MarketSulfurToBuy = 0

end

--------------------------------------------------------------------------------
-- Update tarde window with a invisible controller
--------------------------------------------------------------------------------

function
GUAction_MarketAcceptDeal(_SellResourceType)

	local SellAmount = InterfaceTool_MarketGetSellAmount(_SellResourceType)	
	local Costs = { }
	
	Costs[_SellResourceType] = SellAmount

	if InterfaceTool_HasPlayerEnoughResources_Feedback( Costs ) == 1 then			
		local BuildingID = GUI.GetSelectedEntity()
		local BuyResourceType, BuyResourceAmount = InterfaceTool_MarketGetBuyResourceTypeAndAmount()
		
		GUI.StartTransaction(BuildingID, _SellResourceType, BuyResourceType, BuyResourceAmount )		
		
		--Sound.PlayGUISound( Sounds.klick_rnd_1, 0 )
		--Activate the  progress here
		XGUIEng.ShowWidget(gvGUI_WidgetID.TradeInProgress,1)		
	end	
	
end

--------------------------------------------------------------------------------
-- Cancle current Trade
--------------------------------------------------------------------------------

function
GUIAction_CancelTrade()
	
	local BuildingID = GUI.GetSelectedEntity()
	
	if BuildingID == nil then
		return
	end
	
	GUI.CancelTransaction(BuildingID)
	GUIAction_MarketClearDeals()
	XGUIEng.ShowWidget(gvGUI_WidgetID.TradeInProgress,0)		
	
end

--------------------------------------------------------------------------------
-- Update tarde window with a invisible controller
--------------------------------------------------------------------------------

function
GUIUpdate_MarketTradeWindow()
	
	--Container names
	local SellContainerName = "Trade_Market_Sell"
	
	local SellStem = "Trade_Market_Sell"
	local BuyStem = "Trade_Market_Buy"
	
	
	--Container status
	local SellContainerStatus 		= 0
	
	local SellMoneyContainerStatus  = 1
	local SellClayContainerStatus 	= 1
	local SellWoodContainerStatus	= 1
	local SellStoneContainerStatus  = 1
	local SellIronContainerStatus  	= 1
	local SellSulfurContainerStatus = 1
	        
	local BuyMoneyContainerStatus 	= 1	
	local BuyClayContainerStatus	= 1
	local BuyWoodContainerStatus	= 1
	local BuyStoneContainerStatus 	= 1	
	local BuyIronContainerStatus 	= 1	
	local BuySulfurContainerStatus 	= 1
	
	
	if gvGUI.MarketMoneyToBuy > 0 then	
		SellContainerStatus = 1				
		SellMoneyContainerStatus  	= 0		
		BuyStoneContainerStatus = 0
		BuyIronContainerStatus = 0
		BuySulfurContainerStatus = 0
		BuyClayContainerStatus	= 0
		BuyWoodContainerStatus	= 0
		
	elseif gvGUI.MarketStoneToBuy > 0 then		
		SellContainerStatus = 1
		SellStoneContainerStatus  	= 0	
		BuyMoneyContainerStatus = 0	
		BuyIronContainerStatus = 0
		BuySulfurContainerStatus = 0
		BuyClayContainerStatus	= 0
		BuyWoodContainerStatus	= 0
	
	elseif gvGUI.MarketIronToBuy > 0 then		
		SellContainerStatus = 1
		SellIronContainerStatus  	= 0	
		BuyMoneyContainerStatus = 0
		BuyStoneContainerStatus = 0			
		BuySulfurContainerStatus = 0
		BuyClayContainerStatus	= 0
		BuyWoodContainerStatus	= 0
	
	elseif gvGUI.MarketSulfurToBuy > 0 then		
		SellContainerStatus = 1
		SellSulfurContainerStatus 	= 0
		BuyMoneyContainerStatus = 0
		BuyStoneContainerStatus = 0	
		BuyIronContainerStatus = 0
		BuyClayContainerStatus	= 0
		BuyWoodContainerStatus	= 0
		
	elseif gvGUI.MarketClayToBuy > 0 then		
		SellContainerStatus = 1
		SellClayContainerStatus 	= 0
		BuyMoneyContainerStatus = 0
		BuyStoneContainerStatus = 0	
		BuyIronContainerStatus = 0		
		BuyWoodContainerStatus	= 0
		BuySulfurContainerStatus = 0
		
	elseif gvGUI.MarketWoodToBuy > 0 then		
		SellContainerStatus = 1
		SellWoodContainerStatus 	= 0
		BuyMoneyContainerStatus = 0
		BuyStoneContainerStatus = 0	
		BuyIronContainerStatus = 0
		BuyClayContainerStatus	= 0
		BuySulfurContainerStatus = 0
	
	end
	
	XGUIEng.ShowWidget(SellContainerName	,SellContainerStatus)		
	
	
	if Logic.GetTechnologyState(GUI.GetPlayerID(), Technologies.T_MarketGold) == 0 then
		SellMoneyContainerStatus = 0
		BuyMoneyContainerStatus = 0
	end
	
	if Logic.GetTechnologyState(GUI.GetPlayerID(), Technologies.T_MarketStone) == 0 then	
		BuyStoneContainerStatus = 0 
		SellStoneContainerStatus = 0
	end
		
	if Logic.GetTechnologyState(GUI.GetPlayerID(), Technologies.T_MarketIron) == 0 	then		
		BuyIronContainerStatus  = 0 
		SellIronContainerStatus = 0 
	end
		
	if Logic.GetTechnologyState(GUI.GetPlayerID(), Technologies.T_MarketSulfur) == 0 then
		BuySulfurContainerStatus = 0
		SellSulfurContainerStatus = 0
	end
		
	if Logic.GetTechnologyState(GUI.GetPlayerID(), Technologies.T_MarketClay) == 0 then
		BuyClayContainerStatus = 0
		SellClayContainerStatus = 0
	end
	
	if Logic.GetTechnologyState(GUI.GetPlayerID(), Technologies.T_MarketWood) == 0 then
		SellWoodContainerStatus = 0
		BuyWoodContainerStatus = 0
	end
	
	
	XGUIEng.ShowWidget(BuyStem .. "Stone" 	,BuyStoneContainerStatus)	
	XGUIEng.ShowWidget(BuyStem .. "Money" 	,BuyMoneyContainerStatus )		
	XGUIEng.ShowWidget(BuyStem .. "Iron" 	,BuyIronContainerStatus )
	XGUIEng.ShowWidget(BuyStem .. "Clay" 	,BuyClayContainerStatus )
	XGUIEng.ShowWidget(BuyStem .. "Wood" 	,BuyWoodContainerStatus )
	XGUIEng.ShowWidget(BuyStem .. "Sulfur" 	,BuySulfurContainerStatus)   
	
	XGUIEng.ShowWidget(SellStem .. "Sulfur" ,SellSulfurContainerStatus)       
	XGUIEng.ShowWidget(SellStem .. "Money" 	,SellMoneyContainerStatus )	
	XGUIEng.ShowWidget(SellStem .. "Stone" 	,SellStoneContainerStatus)	   
	XGUIEng.ShowWidget(SellStem .. "Iron" 	,SellIronContainerStatus )	    
	XGUIEng.ShowWidget(SellStem .. "Clay" 	,SellClayContainerStatus )
	XGUIEng.ShowWidget(SellStem .. "Wood" 	,SellWoodContainerStatus )
	
	
end

--------------------------------------------------------------------------------
-- Update Progressbar
--------------------------------------------------------------------------------

function
GUIUpdate_MarketTradeProgress()
	
	local CurrentWidgetID = XGUIEng.GetCurrentWidgetID()
	
	local BuildingID = GUI.GetSelectedEntity()
	
	if BuildingID == nil then
		return
	end
	
	local value = Logic.GetTransactionProgress(BuildingID)
	
	XGUIEng.SetProgressBarValues(CurrentWidgetID,value, 100)
	
end
--------------------------------------------------------------------------------
-- Called by program when deal is finsihed
--------------------------------------------------------------------------------
function
GameCallback_OnTransactionComplete(_BuildingID, _empty )
	
	local BuildingID = GUI.GetSelectedEntity()
	
	if _BuildingID == BuildingID then
		XGUIEng.ShowWidget(gvGUI_WidgetID.TradeInProgress,0)							
	end
	GUIAction_MarketClearDeals()
--	Sound.PlayFeedbackSound( Sounds.Speech_INFO_Deal_rnd_01, 0 )
	
end