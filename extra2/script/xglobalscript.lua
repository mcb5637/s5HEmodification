--------------------------------------------------------------------------------
-- Global script
--------------------------------------------------------------------------------
-- Set default values 

function GameCallback_SetDefaultValues()
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Summer
--------------------------------------------------------------------------------

function GlobalScript_InitSummer()
	Logic.StopPrecipitation()
	Logic.SetWeatherState( 0 )
	Display.SetSnowStatusVelocity(-0.6)	
end

--------------------------------------------------------------------------------
-- Winter
--------------------------------------------------------------------------------
function GlobalScript_InitWinter()
	Logic.StartSnow()
	Display.SetSnowStatusVelocity(0.2)
	Logic.SetWeatherState( 2 )	
end