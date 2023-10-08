--------------------------------------------------------------------------------
-- Key bindings
--------------------------------------------------------------------------------

function AOOfficialKeyBindings_Init()

	-----------------------------------------------------------------------------------------------
	-- Select buildings
	-----------------------------------------------------------------------------------------------
	Input.KeyBindDown(Keys.ModifierControl + Keys[XGUIEng.GetStringTableText( "AOKeyBindings/SelectTavern" )], 		"KeyBindings_SelectUnit(UpgradeCategories.Tavern,1)", 2)			
	Input.KeyBindDown(Keys.ModifierControl + Keys[XGUIEng.GetStringTableText( "AOKeyBindings/SelectGunsmith" )], 	"KeyBindings_SelectUnit(UpgradeCategories.GunsmithWorkshop,1)", 2)			
	Input.KeyBindDown(Keys.ModifierControl + Keys[XGUIEng.GetStringTableText( "AOKeyBindings/SelectMasterBuilderWorkshop" )], 	"KeyBindings_SelectUnit(UpgradeCategories.MasterBuilderWorkshop,1)", 2)			
	
end

