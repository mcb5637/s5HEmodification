--------------------------------------------------------------------------------
-- Buy hero window stuff
--------------------------------------------------------------------------------

function BuyHeroWindow_UpdateInfoLine()

	local PlayerID = GUI.GetPlayerID()
	local NumberOfHerosToBuy = Logic.GetNumberOfBuyableHerosForPlayer( PlayerID )
	
	local Text = XGUIEng.GetStringTableText( "WindowMisc/BuyHeroMessageLine" ) .. NumberOfHerosToBuy
	
	XGUIEng.SetText( XGUIEng.GetCurrentWidgetID(), Text )
	
end

--------------------------------------------------------------------------------

function BuyHeroWindow_Action_BuyHero( _HeroEntityType )

	local PlayerID = GUI.GetPlayerID()

	GUI.BuyHero( PlayerID, _HeroEntityType, 0 )
	
	XGUIEng.ShowWidget( gvGUI_WidgetID.BuyHeroWindow, 0 )
	
	--Update all buttons in the visible container
	XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
	
end

--------------------------------------------------------------------------------

function BuyHeroWindow_Update_BuyHero( _HeroEntityType )

	local PlayerID = GUI.GetPlayerID()
	local NumberOfHerosToBuy = Logic.GetNumberOfBuyableHerosForPlayer( PlayerID )

	local DisableFlag = 0
	
	if NumberOfHerosToBuy == 0 then
		DisableFlag = 1
	end
	
	if Logic.GetPlayerEntities( PlayerID, _HeroEntityType, 1 ) ~= 0 then
		DisableFlag = 1
	end
	
	XGUIEng.DisableButton( XGUIEng.GetCurrentWidgetID(), DisableFlag )


end

--------------------------------------------------------------------------------
