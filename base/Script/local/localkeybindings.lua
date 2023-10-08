
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- DebugKeyBindings_Init
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function DebugKeyBindings_Init()
		
		-----------------------------------------------------------------------------------------------
		-- Camera debug
		-----------------------------------------------------------------------------------------------
		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.NumPad9, "Camera_ToggleDefault()")			
		Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad4, "Camera_IncreaseAngle()")	
		Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad1, "Camera_DecreaseAngle()")
		Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad5, "Camera_IncreaseZoom()")
		Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad2, "Camera_DecreaseZoom()")
		Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad7, "Camera_DecreaseFOV()")
		Input.KeyBindDown(Keys.ModifierControl + Keys.NumPad8, "Camera_IncreaseFOV()")
		
		-----------------------------------------------------------------------------------------------
		-- Game functions
		-----------------------------------------------------------------------------------------------
		
		Input.KeyBindDown(Keys.Multiply, "Game.GameTimeReset()")
		Input.KeyBindDown(Keys.Subtract, "Game.GameTimeSlowDown()")
		Input.KeyBindDown(Keys.Add,      "Game.GameTimeSpeedUp()")		
		
		-----------------------------------------------------------------------------------------------
		-- GUI 
		-----------------------------------------------------------------------------------------------	
		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D1, "GUI.SetControlledPlayer(1)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D2, "GUI.SetControlledPlayer(2)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D3, "GUI.SetControlledPlayer(3)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D4, "GUI.SetControlledPlayer(4)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D5, "GUI.SetControlledPlayer(5)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D6, "GUI.SetControlledPlayer(6)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D7, "GUI.SetControlledPlayer(7)")		
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierAlt + Keys.D8, "GUI.SetControlledPlayer(8)")		
		-----------------------------------------------------------------------------------------------
		-- Cheats
		-----------------------------------------------------------------------------------------------
		
		Input.KeyBindDown(Keys.ModifierControl + Keys.F1, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.GoldRaw, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F2, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.ClayRaw, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F3, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.WoodRaw, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F4, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.StoneRaw, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F5, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.IronRaw, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F6, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.SulfurRaw, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F7, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.Faith, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F8, "Logic.AddToPlayersGlobalResource(GUI.GetPlayerID(),ResourceType.WeatherEnergy, 100)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.F9, "CheatTechnologies(1)")
	
		-----------------------------------------------------------------------------------------------
		-- Render settings (use always Ctrl + Shift key)
		-----------------------------------------------------------------------------------------------
	
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.D1,  "Game.ShowFPS(-1)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.F,   "LocalKeyBindings_ToggleFoW()")	
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.G,   "Game.GUIActivate(-1)")
		Input.KeyBindDown(Keys.ModifierControl + Keys.ModifierShift + Keys.Y,   "Display.SetRenderSky(-1)")
		
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- CheatTechnologies
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

gvKeyBinding_CheatTechnologies = 0

function CheatTechnologies(_PlayerID)
	
	if XNetwork.Manager_DoesExist() ~= 1 then
	
		if gvKeyBinding_CheatTechnologies == 1 then
			return
		end
	
		gvKeyBinding_CheatTechnologies = 1
		
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Mercenaries,3)	
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_StandingArmy,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Tactics,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Strategies,3)
		
		Logic.SetTechnologyState(_PlayerID,Technologies.T_ChangeWeather,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.T_WeatherForecast,3)

		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Construction,3)	
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_ChainBlock,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_GearWheel,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Architecture,3)

		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Alchemy,3)	
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Alloying,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Metallurgy,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Chemistry,3)

		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Taxation,3)	
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Trading,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Banking,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Gilds,3)

		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Literacy,3)	
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Printing,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Laws,3)
		Logic.SetTechnologyState(_PlayerID,Technologies.GT_Library,3)
	end
end

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- LocalKeyBindings_ToggleFoW
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function LocalKeyBindings_ToggleFoW()

	if XNetwork.Manager_DoesExist() ~= 1 then
		Display.SetRenderFogOfWar(-1) 
		GUI.MiniMap_SetRenderFogOfWar(-1)
		GameCallback_GUI_ChatStringInputDone( " cheated the fog of war", 0 )
	end
end
