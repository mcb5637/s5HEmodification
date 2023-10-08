--------------------------------------------------------------------------------
-- Display 
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--Default
--------------------------------------------------------------------------------
function Display_SetDefaultValues()

    Display.SetGlobalLightDirection(50, -20, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000,28000)
    Display.SetRenderFog (1)
    
    gvDisplaySkybox = 0
    
end

--------------------------------------------------------------------------------
-- Enable/disable skybox
--------------------------------------------------------------------------------
function
Display_ToggleSkybox()

	gvDisplaySkybox = 1 - gvDisplaySkybox
	Display.SetRenderSky( gvDisplaySkybox )
	
end


--------------------------------------------------------------------------------
--Spring
--------------------------------------------------------------------------------
function Display_SetSpringValues()

    Display.SetGlobalLightDirection(40,-15,-40)
    Display.SetGlobalLightDiffuse(255,254,160)
    Display.SetGlobalLightAmbient(90,90,150)
    Display.SetGammaRamp(1.125, 1.325, 1, 1)

end

--------------------------------------------------------------------------------
--Sommer
--------------------------------------------------------------------------------
function Display_SetSummerValues()


    Display.SetGlobalLightDirection(40, -15, -30)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1.1, 1.425, 1, 1)
end

--------------------------------------------------------------------------------
--Fall
--------------------------------------------------------------------------------
function Display_SetFallValues()

    Display.SetGlobalLightDirection(40, -15, -75)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1.1, 1.425, 1, 1)
end

--------------------------------------------------------------------------------
--Winter
--------------------------------------------------------------------------------
function Display_SetWinterValues()

    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1.12, 1.475, 1, 1)

end

--------------------------------------------------------------------------------
--Fog 1
--------------------------------------------------------------------------------
function Display_SetFog1()
    Display.SetFogColor (122,122,122)
end

--------------------------------------------------------------------------------
--Fog 2
--------------------------------------------------------------------------------
function Display_SetFog2()
    Display.SetFogColor (152,147,132)
end

--------------------------------------------------------------------------------
--Fog 3
--------------------------------------------------------------------------------
function Display_SetFog3()
    Display.SetFogColor (82,102,112)
end

--------------------------------------------------------------------------------
--Fog 4
--------------------------------------------------------------------------------
function Display_SetFog4()
    Display.SetFogColor (62,82,92)
end

--------------------------------------------------------------------------------
--Fog 5
--------------------------------------------------------------------------------
function Display_SetFog5()
    Display.SetFogColor (152,172,182)
end

--------------------------------------------------------------------------------
-- Lightning/Fog Settings for LandscapeSets
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Mordor Summer
--------------------------------------------------------------------------------
function Display_LandscapeSetMordorSummer()
    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (132,122,102)
    Display.SetFogStartAndEnd (4000,15000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Mordor Winter
--------------------------------------------------------------------------------
function Display_LandscapeSetMordorWinter()
    Display.SetGlobalLightDirection(40, -15, -75)
    Display.SetGlobalLightDiffuse(150,150,150)
    Display.SetGlobalLightAmbient(50,50,80)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (102,122,132)
    Display.SetFogStartAndEnd (5000,15000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Highland Summer
--------------------------------------------------------------------------------
function Display_LandscapeSetHighlandSummer()
    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (132,122,102)
    Display.SetFogStartAndEnd (5000,12000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Highland Winter
--------------------------------------------------------------------------------
function Display_LandscapeSetHighlandWinter()
    Display.SetGlobalLightDirection(40, -15, -75)
    Display.SetGlobalLightDiffuse(250,250,250)
    Display.SetGlobalLightAmbient(100,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (102,122,132)
    Display.SetFogStartAndEnd (4000,10000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Europe Summer
--------------------------------------------------------------------------------
function Display_LandscapeSetEuropeSummer()
    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000,25000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Europe Winter
--------------------------------------------------------------------------------
function Display_LandscapeSetEuropeWinter()
    Display.SetGlobalLightDirection(40, -15, -75)
    Display.SetGlobalLightDiffuse(250,250,250)
    Display.SetGlobalLightAmbient(100,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (4000,18000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Mediterran Summer
--------------------------------------------------------------------------------
function Display_LandscapeSetMediterranSummer()
    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (5000,28000)
    Display.SetRenderFog (1)
end

--------------------------------------------------------------------------------
-- Mediterran Winter
--------------------------------------------------------------------------------
function Display_LandscapeSetMediterranWinter()
    Display.SetGlobalLightDirection(40, -15, -75)
    Display.SetGlobalLightDiffuse(250,250,250)
    Display.SetGlobalLightAmbient(100,110,110)
    Display.SetGammaRamp(1, 1.2, 1.25, 1)

    Display.SetFogColor (152,172,182)
    Display.SetFogStartAndEnd (4000,18000)
    Display.SetRenderFog (1)

end
