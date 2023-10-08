--------------------------------------------------------------------------------
-- Statistics window stuff
--------------------------------------------------------------------------------

function StatisticsWindow_SelectGroup( _Index )
	
	-- Hide all
	XGUIEng.ShowAllSubWidgets( "Statistics_SubButtons", 0 )
	
	-- Enable right container
	if _Index == 0 then
		XGUIEng.ShowWidget( "Statistics_Sub_MenuHouses", 1 )
		GUI.StatisticsWindow_SelectStatistics(30)
	elseif _Index == 1 then
		XGUIEng.ShowWidget( "Statistics_Sub_MenuMilitary", 1 )
		GUI.StatisticsWindow_SelectStatistics(21)
	elseif _Index == 2 then
		XGUIEng.ShowWidget( "Statistics_Sub_MenuResources", 1 )
		GUI.StatisticsWindow_SelectStatistics(40)
	elseif _Index == 3 then
		XGUIEng.ShowWidget( "Statistics_Sub_MenuSettlers", 1 )
		GUI.StatisticsWindow_SelectStatistics(12)
	elseif _Index == 4 then
		XGUIEng.ShowWidget( "Statistics_Sub_MenuTechnology", 1 )
		GUI.StatisticsWindow_SelectStatistics(50)
	elseif _Index == 5 then
		XGUIEng.ShowWidget( "Statistics_Sub_MenuScores", 1 )
		GUI.StatisticsWindow_SelectStatistics(60)
	end
	
end

--------------------------------------------------------------------------------
