----------------------------------------------------------------------------------------------------
-- Init load screen

function 
LoadScreen_Init( _LoadSaveGameFlag, _MapName, _MapType, _MapCampaignName )

	-- Set texture
	do
		local PictureNumber = 1 + XGUIEng.GetRandom( 5 )
		local PictureName = "data\\graphics\\textures\\gui\\mainmenu\\loadscreen0" .. PictureNumber .. ".png"
		XGUIEng.SetMaterialTexture( "LoadScreenPic01", 0, PictureName )
	end
	
	-- Show load screen
	XGUIEng.ShowAllSubWidgets( "Screens", 0 )
	XGUIEng.ShowWidget( "LoadScreen", 1 )
	
	-- Set mouse
	Mouse.CursorSet( 2 )
		
	-- Set headline
	do
		-- Loading save game
		if _LoadSaveGameFlag == 0 then
		
			-- Nope: get map name
			local MapNameString, MapDescString = Framework.GetMapNameAndDescription( _MapName, _MapType, _MapCampaignName )
			XGUIEng.SetText( "LoadScreen_MapInfo", MapNameString )
			
		else
		
			-- Yes: get save game description
			local Description = Framework.GetSaveGameString( _MapName )
			XGUIEng.SetText( "LoadScreen_MapInfo", Description )
			
		end
	end
	
	-- Set dev news
	do
		XGUIEng.SetTextFromFile( "LoadScreen_ReadMe", "00DevNews.txt", false )
		XGUIEng.LimitTextLines( "LoadScreen_ReadMe", 40, 0 )
	end
	
end

----------------------------------------------------------------------------------------------------
