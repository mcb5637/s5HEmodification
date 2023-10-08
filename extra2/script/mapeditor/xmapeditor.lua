--------------------------------------------------------------------------------
-- mapeditor scripting
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- MapEditorCallBack_F1
--------------------------------------------------------------------------------
function MapEditorCallback_F1()

	Logic.CreateEntity(Entities.PB_Blacksmith1,1600,1600,0,1);

end

--------------------------------------------------------------------------------
-- MapEditorCallBack_F2
--------------------------------------------------------------------------------
function MapEditorCallback_F2()

end

--------------------------------------------------------------------------------
-- MapEditorCallBack_F3
--------------------------------------------------------------------------------
function MapEditorCallback_F3()

end

--------------------------------------------------------------------------------
-- MapEditorCallBack_F4
--------------------------------------------------------------------------------
function MapEditorCallback_F4()

end

--------------------------------------------------------------------------------
-- MapEditorCallBack_F5
--------------------------------------------------------------------------------
function MapEditorCallback_F5()
	Logic.CheckBuildingPlacement()
	Logic.CheckSettlerPlacement()
end

--------------------------------------------------------------------------------
-- Camera scripting
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Game Lighting
--------------------------------------------------------------------------------

function MapEditorCallback_GameLighting_InitParams()

    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1.12, 1.475, 1, 1)

end

--------------------------------------------------------------------------------
-- MapEditor CalculateZoom
--------------------------------------------------------------------------------
function MapEditorCallback_MapEditorCamera_CalculateZoom( _ZoomFactor )

	local ZoomFactorEx = _ZoomFactor
   
	Camera.ZoomSetFOV(gvCameraZoomFOVMin + (gvCameraZoomFOVMax - gvCameraZoomFOVMin) * ZoomFactorEx)
	Camera.ZoomSetAngle(gvCameraZoomAngleMin + (gvCameraZoomAngleMax - gvCameraZoomAngleMin) * ZoomFactorEx)
	Camera.ZoomSetDistance(gvCameraZoomDistanceMin + (gvCameraZoomDistanceMax - gvCameraZoomDistanceMin) * 0.45 * ( _ZoomFactor + _ZoomFactor * _ZoomFactor ) )

end

--------------------------------------------------------------------------------
-- MapEditor Init camera
--------------------------------------------------------------------------------

function MapEditorCallback_MapEditorCamera_InitParams()

	-- Variables needed for GameCallback_Camera_CalculateZoom
	gvCameraZoomAngleMin = 40
	gvCameraZoomAngleMax = 40
	gvCameraZoomDistanceMin = 1500
	gvCameraZoomDistanceMax = 15000
	gvCameraZoomFOVMin = 42
	gvCameraZoomFOVMax = 42
	
	
	-- Manual camera values
	gvCameraManualAngle = 36
	gvCameraManualZoom = 3000
	gvCameraManualFOV = 50

	-- Set camera to the center of the map
 	local WorldSizeX, WorldSizeY = Logic.WorldGetSize() 	
	Camera.ScrollSetLookAt(WorldSizeX * 0.5, WorldSizeX * 0.5)
	
 	
	Camera.ScrollUpdateZMode(0)
	Camera.ScrollSetSpeed(2600)
	Camera.ScrollSetBorderFlag(1)
	
	Camera.RotSetSpeed(90)

	Camera.RotSetFlipBack(0)
	Camera.RotSetFlipBackSpeed(250)
	Camera.ZoomSetSpeed(1)
	Camera.RotSetMaxAngle(180)
	Camera.ZoomSetFactor(5.0)

end

--------------------------------------------------------------------------------
-- MapEditor Lighting
--------------------------------------------------------------------------------

function MapEditorCallback_MapEditorLighting_InitParams()

    Display.SetGlobalLightDirection(40, -15, -50)
    Display.SetGlobalLightDiffuse(255,254,230)
    Display.SetGlobalLightAmbient(120,110,110)
    Display.SetGammaRamp(1.12, 1.475, 1, 1)

end

--------------------------------------------------------------------------------
-- Topdown CalculateZoom
--------------------------------------------------------------------------------
function MapEditorCallback_TopdownCamera_CalculateZoom( _ZoomFactor )

	local ZoomFactorEx = _ZoomFactor
 
	Camera.ZoomSetAngle(90)
	Camera.ZoomSetDistance(gvCameraZoomDistanceMin + (gvCameraZoomDistanceMax - gvCameraZoomDistanceMin) * 0.45 * ( _ZoomFactor + _ZoomFactor * _ZoomFactor ) )

end

--------------------------------------------------------------------------------
-- Topdown Init camera
--------------------------------------------------------------------------------

function MapEditorCallback_TopdownCamera_InitParams()

	-- Variables needed for GameCallback_Camera_CalculateZoom
	gvCameraZoomAngleMin = 40
	gvCameraZoomAngleMax = 40
	gvCameraZoomDistanceMin = 1000
	gvCameraZoomDistanceMax = 10000
	gvCameraZoomFOVMin = 42
	gvCameraZoomFOVMax = 42
	
	
	-- Manual camera values
	gvCameraManualAngle = 36
	gvCameraManualZoom = 3000
	gvCameraManualFOV = 50

	-- Set camera to the center of the map
 	local WorldSizeX, WorldSizeY = Logic.WorldGetSize() 	
	Camera.ScrollSetLookAt(WorldSizeX * 0.5, WorldSizeX * 0.5)
	
 	
	Camera.ScrollUpdateZMode(0)
	Camera.ScrollSetSpeed(2600)
	Camera.ScrollSetBorderFlag(1)
	
	Camera.RotSetSpeed(90)

	Camera.RotSetFlipBack(0)
	Camera.RotSetFlipBackSpeed(250)
	Camera.ZoomSetSpeed(1)
	Camera.RotSetMaxAngle(180)
	Camera.ZoomSetFactor(5.0)

end

--------------------------------------------------------------------------------
-- Topdown Lighting
--------------------------------------------------------------------------------

function MapEditorCallback_TopdownLighting_InitParams()

    Display.SetGlobalLightDirection(1, -0, -1)
    Display.SetGlobalLightDiffuse(77,77,77)
    Display.SetGlobalLightAmbient(255,255,255)
    Display.SetGammaRamp(1.12, 1.475, 1, 1)

end

--------------------------------------------------------------------------------
-- Fake functions 
--------------------------------------------------------------------------------

Script = {}
Script.Load = function() end
IncludeGlobals = function() end
IncludeLocals = function() end 

Folders = {}
Folders.MapTools = ""
