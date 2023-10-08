--------------------------------------------------------------------------------
-- Speech system
--------------------------------------------------------------------------------
-- Constants

-- Seconds between two feedbacks
gcSpeechSecondsToWaitLimit = 4

-- Settler feedback ban time MS
gcFeedbackSettlerBanTimeMS = 30 * 1000


gvSpeech = {}

--------------------------------------------------------------------------------
-- Init speech variables - needed for (re-) starting system
-- Private function to be called internally in this script
function Speech_Privat_InitGlobals()
	
	
	-- Clear reset flag
	gvSpeech.ResetGlobalsFlag = 0

	-- Number of seconds to wait before checking speech again
	gvSpeech.SecondsToWait = 0

	-- External sample; needed for mission scripting tutors
	gvSpeech.ExternalSampleName = nil
	gvSpeech.ExternalSampleLength = 0


	-- Limits - 1 if limit is reached - 0 if not
	gvSpeech.SoundFlagAttractionLimitReachedFlag = 0
	gvSpeech.SoundFlagResidenceLimitReachedFlag = 0
	gvSpeech.SoundFlagFarmLimitReachedFlag = 0


	-- Generic messages - game time last message was presented
	gvSpeech.LastGenericNoMoneyMessageGameTimeMS = 0
	gvSpeech.LastGenericPaydayGameTimeMS = 0
	gvSpeech.LastGenericAttackGameTimeMS = 0
	gvSpeech.LastGenericAttackedGameTimeMS = 0


	-- Grievance ban time - game time until no grievance is allowed
	gvSpeech.GrievanceSadNoWorkBanGameTimeMS = 0
	gvSpeech.GrievanceAngryNoWorkBanGameTimeMS = 0
	gvSpeech.GrievanceLeavingNoWorkBanGameTimeMS = 0
	gvSpeech.GrievanceSadNoFoodBanGameTimeMS = 0
	gvSpeech.GrievanceAngryNoFoodBanGameTimeMS = 0
	gvSpeech.GrievanceLeavingNoFoodBanGameTimeMS = 0
	gvSpeech.GrievanceSadNoRestBanGameTimeMS = 0
	gvSpeech.GrievanceAngryNoRestBanGameTimeMS = 0
	gvSpeech.GrievanceLeavingNoRestBanGameTimeMS = 0
	gvSpeech.GrievanceSadNoPayBanGameTimeMS = 0
	gvSpeech.GrievanceAngryNoPayBanGameTimeMS = 0
	gvSpeech.GrievanceLeavingNoPayBanGameTimeMS = 0
	gvSpeech.GrievanceSadTaxesBanGameTimeMS = 0
	gvSpeech.GrievanceAngryTaxesBanGameTimeMS = 0
	gvSpeech.GrievanceLeavingTaxesBanGameTimeMS = 0
	gvSpeech.GrievanceSadTooMuchWorkBanGameTimeMS = 0
	gvSpeech.GrievanceAngryTooMuchWorkBanGameTimeMS = 0
	gvSpeech.GrievanceLeavingTooMuchWorkBanGameTimeMS = 0

	-- Entity types - 1 if attracted - 0 if not
	gvSpeech.SoundFarmerAttractedFlag = 0
	gvSpeech.SoundMinerAttractedFlag = 0
	gvSpeech.SoundCoinerAttractedFlag = 0
	gvSpeech.SoundSmithAttractedFlag = 0
	gvSpeech.SoundTraderAttractedFlag = 0
	gvSpeech.SoundScholarAttractedFlag = 0
	gvSpeech.SoundPriestAttractedFlag = 0


	-- Resource running out messages - game time last message was presented
	gvSpeech.LastSilverResourceRunningOutMessageGameTimeMS = 0
	gvSpeech.LastIronResourceRunningOutMessageGameTimeMS = 0
	gvSpeech.LastStoneResourceRunningOutMessageGameTimeMS = 0
	gvSpeech.LastStulfurResourceRunningOutMessageGameTimeMS = 0


end


--------------------------------------------------------------------------------
-- Init speech variables - needed for (re-) starting system
-- Public function to be called by local script, ...

function Speech_Init()

	-- Set flag to reset globals next update
	gvSpeech.ResetGlobalsFlag = 1
	
end


--------------------------------------------------------------------------------
-- Update speech - called every second
-- Public function to be called by trigger

function SpeechTrigger_UpdateEverySecond()
	
	return 0
end

function	bla()
    -----------------------------------------------------------------------------------------------
	-- Need to reset globals?
	if gvSpeech.ResetGlobalsFlag == 1 then
		Speech_Privat_InitGlobals()
		return
	end
	
	
    -----------------------------------------------------------------------------------------------
    -- Get current game time
    local GameTimeMS = Logic.GetTimeMs()
    
    	
    -----------------------------------------------------------------------------------------------
    -- Get player ID
    local PlayerID = GUI.GetPlayerID()
    
    	
    -----------------------------------------------------------------------------------------------
	-- Direct feedback stuff
	do
	
        -------------------------------------------------------------------------------------------
    	-- 'No money' message
    	do
    		local LastMessageTime, EntityID = Logic.FeedbackGetLastMessageGameTimeMS( PlayerID, Feedback.MessageNoMoney )
    		if			LastMessageTime ~= 0
    				and	LastMessageTime ~= gvSpeech.LastGenericNoMoneyMessageGameTimeMS
    		then
    			if GameTimeMS > ( gvSpeech.LastGenericNoMoneyMessageGameTimeMS + 1000 ) then
	      			Sound.PlayFeedbackSound( Sounds.Speech_INFO_NotEnoughMoney_1, 0 )
	      		end

    			gvSpeech.LastGenericNoMoneyMessageGameTimeMS = LastMessageTime
    		end
    	end
    
        -------------------------------------------------------------------------------------------
    	-- 'Attack' message
    	do
    		local LastMessageTime, EntityID = Logic.FeedbackGetLastMessageGameTimeMS( PlayerID, Feedback.MessageAttack )
    		if			LastMessageTime ~= 0
    				and	LastMessageTime ~= gvSpeech.LastGenericAttackGameTimeMS
    		then
	   			if GameTimeMS > ( gvSpeech.LastGenericAttackGameTimeMS + 1000 ) then
    				if Logic.GetEntityType( EntityID )  == Entities.PU_Hero1 then				
    					Sound.PlayFeedbackSound( Sounds.Hero1_HERO1_Attack_rnd_01, 0 )
    				elseif 	Logic.GetEntityType( EntityID )  == Entities.PU_Hero2 then
    					Sound.PlayFeedbackSound( Sounds.HERO2_Attack_rnd_01, 0 )
    				elseif 	Logic.GetEntityType( EntityID )  == Entities.PU_Hero3 then
    					Sound.PlayFeedbackSound( Sounds.Hero3_HERO3_Attack_rnd_01, 0 )
    				else
    					Sound.PlayFeedbackSound( Sounds.Leader_LEADER_Attack_rnd_01 , 0)
    				end
        		end

    			gvSpeech.LastGenericAttackGameTimeMS = LastMessageTime
    		end
    	end
    
        -------------------------------------------------------------------------------------------
    	-- 'Attacked' message
    	do
    		local LastMessageTime, EntityID = Logic.FeedbackGetLastMessageGameTimeMS( PlayerID, Feedback.MessageAttacked )
    		if			LastMessageTime ~= 0
    				and	LastMessageTime ~= gvSpeech.LastGenericAttackedGameTimeMS
    		then
	   			if GameTimeMS > ( gvSpeech.LastGenericAttackedGameTimeMS + 5000 ) then
	       			Sound.PlayFeedbackSound( Sounds.Speech_INFO_UnderAttack_rnd_1, 0 )
	       		end

    			gvSpeech.LastGenericAttackedGameTimeMS = LastMessageTime
    		end
    	end
    
	end
	
	
	
    -----------------------------------------------------------------------------------------------
    -- System stuff
    
	-- Decrement wait counter; return when time to wait bigger than 0	
    if gvSpeech.SecondsToWait ~= 0 then
		gvSpeech.SecondsToWait = gvSpeech.SecondsToWait - 1
		if gvSpeech.SecondsToWait > 0 then
			return
        end
        gvSpeech.SecondsToWait = 0
	end
	

	--Don't play speeches during cinematics
	if gvInterfaceCinematicFlag == 1 then
		return
	end

	
  	-- External sample; check for external sample to be started
	if      gvSpeech.ExternalSampleName ~= nil 
    then
		Sound.PlayFeedbackSound( Sounds[ gvSpeech.ExternalSampleName ], 0 )	
		gvSpeech.SecondsToWait = gvSpeech.ExternalSampleLength			
		gvSpeech.ExternalSampleName = nil
		gvSpeech.ExternalSampleLength = 0
		return
	end
	

	
    -----------------------------------------------------------------------------------------------
    -- Check speech system
    -----------------------------------------------------------------------------------------------
	-- Attraction limit
	do
	
		-- Full?
		if			gvSpeech.SoundFlagAttractionLimitReachedFlag == 0
				and Logic.GetNumberOfAttractedSettlers( PlayerID ) ~= 0
				and Logic.GetNumberOfAttractedSettlers( PlayerID ) >= Logic.GetPlayerAttractionLimit( PlayerID )			
		then
			gvSpeech.SoundFlagAttractionLimitReachedFlag = 1

            if GameTimeMS > 1000 then
    			Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_NoMoreSettlersInVC_2, 0 )
    			gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
    			
    			return
            end
   		end
		
		-- Empty again?
		if			gvSpeech.SoundFlagAttractionLimitReachedFlag == 1
				and	Logic.GetNumberOfAttractedSettlers( PlayerID ) < Logic.GetPlayerAttractionLimit( PlayerID ) 
		then
			gvSpeech.SoundFlagAttractionLimitReachedFlag = 0
		end
		
	end
	
	
    -----------------------------------------------------------------------------------------------
	-- Residence limit
	do
	
		-- Full?
		if			gvSpeech.SoundFlagResidenceLimitReachedFlag == 0
				and Logic.GetPlayerSleepPlaceUsage( PlayerID ) ~= 0
				and Logic.GetPlayerSleepPlaceUsage( PlayerID ) >= Logic.GetPlayerSleepPlacesLimit( PlayerID )				
		then
			gvSpeech.SoundFlagResidenceLimitReachedFlag = 1

			Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_FullResidences , 0 )
			gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
			return
		end
		
		-- Empty again?
		if			gvSpeech.SoundFlagResidenceLimitReachedFlag == 1
				and	Logic.GetPlayerSleepPlaceUsage( PlayerID ) < Logic.GetPlayerSleepPlacesLimit( PlayerID ) 
		then
			gvSpeech.SoundFlagResidenceLimitReachedFlag = 0
		end
		
	end
	
	
    -----------------------------------------------------------------------------------------------
	-- Farm limit
	do
	
		-- Full?
		if			gvSpeech.SoundFlagFarmLimitReachedFlag == 0
				and Logic.GetPlayerEatPlaceUsage( PlayerID ) ~= 0
				and	Logic.GetPlayerEatPlaceUsage( PlayerID ) >= Logic.GetPlayerEatPlacesLimit( PlayerID ) 
		then
			gvSpeech.SoundFlagFarmLimitReachedFlag = 1

			Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_NotEnoughFood, 0 )
			gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
			return
		end
		
		-- Empty again?
		if			gvSpeech.SoundFlagFarmLimitReachedFlag == 1
				and	Logic.GetPlayerEatPlaceUsage( PlayerID ) < Logic.GetPlayerEatPlacesLimit( PlayerID ) 
		then
			gvSpeech.SoundFlagFarmLimitReachedFlag = 0
		end
	
	end
	

    -----------------------------------------------------------------------------------------------
	-- 'Payday' message
	do
		local LastMessageTime, EntityID = Logic.FeedbackGetLastMessageGameTimeMS( PlayerID, Feedback.MessagePayday )
		if			LastMessageTime ~= 0
				and	LastMessageTime ~= gvSpeech.LastGenericPaydayGameTimeMS
		then
			gvSpeech.LastGenericPaydayGameTimeMS = LastMessageTime

            if Logic.GetPlayerPaydayCost( PlayerID ) ~= 0 then
    			Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_PaydayNow_1, 0 )
    			gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
    			return
            end
		end
	end


    -----------------------------------------------------------------------------------------------
    -- Settler grievance
    do
		-------------------------------------------------------------------------------------------
		-- No work
		
		-- Settler is leaving, because of no work
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoWork )
 			if LastGrievanceMS > gvSpeech.GrievanceLeavingNoWorkBanGameTimeMS then
				gvSpeech.GrievanceLeavingNoWorkBanGameTimeMS = GameTimeMS 
				gvSpeech.GrievanceAngryNoWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoWork )
				return
			end
		end
	
		-- Settler is angry, because of no work
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoWork )
 			if LastGrievanceMS > gvSpeech.GrievanceAngryNoWorkBanGameTimeMS then
				gvSpeech.GrievanceAngryNoWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoWork )
				return
			end
		end
		
		-- Settler is sad, because of no work
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateSad, Feedback.SettlerReasonNoWork )
 			if LastGrievanceMS > gvSpeech.GrievanceSadNoWorkBanGameTimeMS then
				gvSpeech.GrievanceSadNoWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateSad, Feedback.SettlerReasonNoWork )
				return
			end
		end
		
		-------------------------------------------------------------------------------------------
		-- No food
		
		-- Settler is leaving, because of no food
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoFood )
 			if LastGrievanceMS > gvSpeech.GrievanceLeavingNoFoodBanGameTimeMS then
				gvSpeech.GrievanceLeavingNoFoodBanGameTimeMS = GameTimeMS 
				gvSpeech.GrievanceAngryNoFoodBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoFoodBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoFood )
				return
			end
		end
	
		-- Settler is angry, because of no food
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoFood )
 			if LastGrievanceMS > gvSpeech.GrievanceAngryNoFoodBanGameTimeMS then
				gvSpeech.GrievanceAngryNoFoodBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoFoodBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoFood )
				return
			end
		end
		
		-- Settler is sad, because of no food
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateSad, Feedback.SettlerReasonNoFood )
 			if LastGrievanceMS > gvSpeech.GrievanceSadNoFoodBanGameTimeMS then
				gvSpeech.GrievanceSadNoFoodBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateSad, Feedback.SettlerReasonNoFood )
				return
			end
		end
		
		-------------------------------------------------------------------------------------------
		-- No rest
		
		-- Settler is leaving, because of no rest
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoRest )
 			if LastGrievanceMS > gvSpeech.GrievanceLeavingNoRestBanGameTimeMS then
				gvSpeech.GrievanceLeavingNoRestBanGameTimeMS = GameTimeMS 
				gvSpeech.GrievanceAngryNoRestBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoRestBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoRest )
				return
			end
		end
	
		-- Settler is angry, because of no rest
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoRest )
 			if LastGrievanceMS > gvSpeech.GrievanceAngryNoRestBanGameTimeMS then
				gvSpeech.GrievanceAngryNoRestBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoRestBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoRest )
				return
			end
		end
		
		-- Settler is sad, because of no rest
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateSad, Feedback.SettlerReasonNoRest )
 			if LastGrievanceMS > gvSpeech.GrievanceSadNoRestBanGameTimeMS then
				gvSpeech.GrievanceSadNoRestBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateSad, Feedback.SettlerReasonNoRest )
				return
			end
		end
		
		-------------------------------------------------------------------------------------------
		-- No pay
		
		-- Settler is leaving, because of no pay
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoPay )
 			if LastGrievanceMS > gvSpeech.GrievanceLeavingNoPayBanGameTimeMS then
				gvSpeech.GrievanceLeavingNoPayBanGameTimeMS = GameTimeMS 
				gvSpeech.GrievanceAngryNoPayBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoPayBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateLeaving, Feedback.SettlerReasonNoPay )
				return
			end
		end
	
		-- Settler is angry, because of no pay
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoPay )
 			if LastGrievanceMS > gvSpeech.GrievanceAngryNoPayBanGameTimeMS then
				gvSpeech.GrievanceAngryNoPayBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadNoPayBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateAngry, Feedback.SettlerReasonNoPay )
				return
			end
		end
		
		-- Settler is sad, because of no pay
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateSad, Feedback.SettlerReasonNoPay )
 			if LastGrievanceMS > gvSpeech.GrievanceSadNoPayBanGameTimeMS then
				gvSpeech.GrievanceSadNoPayBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateSad, Feedback.SettlerReasonNoPay )
				return
			end
		end
		
		-------------------------------------------------------------------------------------------
		-- Taxes
		
		-- Settler is leaving, because of taxes
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateLeaving, Feedback.SettlerReasonTaxes )
 			if LastGrievanceMS > gvSpeech.GrievanceLeavingTaxesBanGameTimeMS then
				gvSpeech.GrievanceLeavingTaxesBanGameTimeMS = GameTimeMS 
				gvSpeech.GrievanceAngryTaxesBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadTaxesBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateLeaving, Feedback.SettlerReasonTaxes )
				return
			end
		end
	
		-- Settler is angry, because of taxes
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateAngry, Feedback.SettlerReasonTaxes )
 			if LastGrievanceMS > gvSpeech.GrievanceAngryTaxesBanGameTimeMS then
				gvSpeech.GrievanceAngryTaxesBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadTaxesBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateAngry, Feedback.SettlerReasonTaxes )
				return
			end
		end
		
		-- Settler is sad, because of taxes
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateSad, Feedback.SettlerReasonTaxes )
 			if LastGrievanceMS > gvSpeech.GrievanceSadTaxesBanGameTimeMS then
				gvSpeech.GrievanceSadTaxesBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateSad, Feedback.SettlerReasonTaxes )
				return
			end
		end
		
		-------------------------------------------------------------------------------------------
		-- Too much work
		
		-- Settler is leaving, because of too much work
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateLeaving, Feedback.SettlerReasonTooMuchWork )
 			if LastGrievanceMS > gvSpeech.GrievanceLeavingTooMuchWorkBanGameTimeMS then
				gvSpeech.GrievanceLeavingTooMuchWorkBanGameTimeMS = GameTimeMS 
				gvSpeech.GrievanceAngryTooMuchWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadTooMuchWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS

				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateLeaving, Feedback.SettlerReasonTooMuchWork )
				return
			end
		end
	
		-- Settler is angry, because of too much work
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateAngry, Feedback.SettlerReasonTooMuchWork )
 			if LastGrievanceMS > gvSpeech.GrievanceAngryTooMuchWorkBanGameTimeMS then
				gvSpeech.GrievanceAngryTooMuchWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				gvSpeech.GrievanceSadTooMuchWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateAngry, Feedback.SettlerReasonTooMuchWork )
				return
			end
		end
		
		-- Settler is sad, because of too much work
		do
			local LastGrievanceMS, EntityType = Logic.FeedbackGetLastGrievanceGameTimeMS( PlayerID, Feedback.SettlerStateSad, Feedback.SettlerReasonTooMuchWork )
 			if LastGrievanceMS > gvSpeech.GrievanceSadTooMuchWorkBanGameTimeMS then
				gvSpeech.GrievanceSadTooMuchWorkBanGameTimeMS = GameTimeMS + gcFeedbackSettlerBanTimeMS
				
				Speech_Private_StartSettlerFeedback( EntityType, Feedback.SettlerStateSad, Feedback.SettlerReasonTooMuchWork )
				return
			end
		end
		
	end
    
    

    -----------------------------------------------------------------------------------------------
	-- New type of settler arrived
	do
	
		-- Farmer
		do
			if			gvSpeech.SoundFarmerAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Farmer ) ~= 0
			then
				gvSpeech.SoundFarmerAttractedFlag = 1

	            if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Farmer, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundFarmerAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Farmer ) == 0
			then
				gvSpeech.SoundFarmerAttractedFlag = 0
			end
		end
		
		
		-- Miner
		do
			if			gvSpeech.SoundMinerAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Miner ) ~= 0
			then
				gvSpeech.SoundMinerAttractedFlag = 1

	            if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Miner, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundMinerAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Miner ) == 0
			then
				gvSpeech.SoundMinerAttractedFlag = 0
			end
		end
		
		-- Coiner
		do
			if			gvSpeech.SoundCoinerAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Coiner ) ~= 0
			then
				gvSpeech.SoundCoinerAttractedFlag = 1

		        if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Coiner, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundCoinerAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Coiner ) == 0
			then
				gvSpeech.SoundCoinerAttractedFlag = 0
			end
		end
		
		-- Smith
		do
			if			gvSpeech.SoundSmithAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Smith ) ~= 0
			then
				gvSpeech.SoundSmithAttractedFlag = 1

	            if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Smith, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundSmithAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Smith ) == 0
			then
				gvSpeech.SoundSmithAttractedFlag = 0
			end
		end
		
		-- Trader
		do
			if			gvSpeech.SoundTraderAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Trader ) ~= 0
			then
				gvSpeech.SoundTraderAttractedFlag = 1

	            if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Trader, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundTraderAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Trader ) == 0
			then
				gvSpeech.SoundTraderAttractedFlag = 0
			end
		end
		
		-- Scholar
		do
			if			gvSpeech.SoundScholarAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Scholar ) ~= 0
			then
				gvSpeech.SoundScholarAttractedFlag = 1

	            if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Scholar, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundScholarAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Scholar ) == 0
			then
				gvSpeech.SoundScholarAttractedFlag = 0
			end
		end
		
		-- Priest
		do
			if			gvSpeech.SoundPriestAttractedFlag == 0
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Priest ) ~= 0
			then
				gvSpeech.SoundPriestAttractedFlag = 1

	            if GameTimeMS > 10000 then
					Sound.PlayQueuedFeedbackSound( Sounds.Speech_JOIN_Monk, 0 )
					gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
					return
				end
			end
			
			if			gvSpeech.SoundPriestAttractedFlag == 1
					and	Logic.GetNumberOfPlayersWorkerOfType( PlayerID, Entities.PU_Priest ) == 0
			then
				gvSpeech.SoundPriestAttractedFlag = 0
			end
		end
	end
	
	
    -----------------------------------------------------------------------------------------------
	-- Resource Silver running out message
	do
		local LastMessageTime, X, Y = Logic.FeedbackGetLastRunningOutOfResourceMessageGameTimeMS( PlayerID, ResourceType.SilverRaw )
		if			LastMessageTime ~= 0
				and	LastMessageTime ~= gvSpeech.LastSilverResourceRunningOutMessageGameTimeMS
		then
			gvSpeech.LastSilverResourceRunningOutMessageGameTimeMS = LastMessageTime

    		Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_SilverMineRunningLow_rnd_01, 0 )
    		gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
    		return

		end
	end


    -----------------------------------------------------------------------------------------------
	-- Resource iron running out message
	do
		local LastMessageTime, X, Y = Logic.FeedbackGetLastRunningOutOfResourceMessageGameTimeMS( PlayerID, ResourceType.IronRaw )
		if			LastMessageTime ~= 0
				and	LastMessageTime ~= gvSpeech.LastIronResourceRunningOutMessageGameTimeMS
		then
			gvSpeech.LastIronResourceRunningOutMessageGameTimeMS = LastMessageTime

    		Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_IronMineRunningLow_rnd_01, 0 )
    		gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
    		return

		end
	end
	
	-----------------------------------------------------------------------------------------------
	-- Resource stone running out message
	do
		local LastMessageTime, X, Y = Logic.FeedbackGetLastRunningOutOfResourceMessageGameTimeMS( PlayerID, ResourceType.StoneRaw )
		if			LastMessageTime ~= 0
				and	LastMessageTime ~= gvSpeech.LastStoneResourceRunningOutMessageGameTimeMS
		then
			gvSpeech.LastStoneResourceRunningOutMessageGameTimeMS = LastMessageTime

    		Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_StoneMineRunningLow_rnd_01, 0 )
    		gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
    		return

		end
	end
	
	-----------------------------------------------------------------------------------------------
	-- Resource sulfur running out message
	do
		local LastMessageTime, X, Y = Logic.FeedbackGetLastRunningOutOfResourceMessageGameTimeMS( PlayerID, ResourceType.SulfurRaw )
		if			LastMessageTime ~= 0
				and	LastMessageTime ~= gvSpeech.LastSulfurResourceRunningOutMessageGameTimeMS
		then
			gvSpeech.LastSulfurResourceRunningOutMessageGameTimeMS = LastMessageTime

    		Sound.PlayQueuedFeedbackSound( Sounds.Speech_INFO_SulfurMineRunningLow_rnd_01, 0 )
    		gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
    		return

		end
	end

	
end


--------------------------------------------------------------------------------
-- Start speech sample
-- Public function to be called by mission script, ...

function Speech_StartExternal( _Name, _Length )

	gvSpeech.ExternalSampleName = _Name
	gvSpeech.ExternalSampleLength = _Length

end


--------------------------------------------------------------------------------
-- Tool to start settler feedback sample
-- Private function to be called internally in this script

function Speech_Private_StartSettlerFeedback( _EntityType, _Grievance, _Reason )

	-- Get entity type name
	local EntityName = "Settlers"
	if _EntityType == Entities.PU_Farmer then
		EntityName = "Farmer"
	elseif _EntityType == Entities.PU_Miner then
		EntityName = "Miner"
	elseif _EntityType == Entities.PU_Smith then
		EntityName = "Smith"
	elseif _EntityType == Entities.PU_Coiner then
		EntityName = "Coiner"
	elseif _EntityType == Entities.PU_Priest then
		EntityName = "Monk"
	elseif _EntityType == Entities.PU_Scholar then
		EntityName = "Scholar"
	elseif _EntityType == Entities.PU_Trader then
		EntityName = "Trader"
	end
	

	-- Get grievance name
	local GrievanceName = nil
	if _Grievance == Feedback.SettlerStateSad then	
		GrievanceName = "UH"
	elseif _Grievance == Feedback.SettlerStateAngry then	
		GrievanceName = "MAD"
	elseif _Grievance == Feedback.SettlerStateLeaving then	
		GrievanceName = "GO"
	end

	
	-- Valid?
	if GrievanceName == nil then
		return
	end
	
	
	-- Get reason name
	local ReasonName = nil
	if _Reason == Feedback.SettlerReasonTaxes then	
		ReasonName = "HighTaxes_4"
	elseif _Reason == Feedback.SettlerReasonTooMuchWork then	
		ReasonName = "TooMuchWork_1"
	elseif _Reason == Feedback.SettlerReasonNoWork then	
		ReasonName = "FewWorkPlaces_1"
	elseif _Reason == Feedback.SettlerReasonNoFood then	
		ReasonName = "FewFood_1"
	elseif _Reason == Feedback.SettlerReasonNoRest then	
		ReasonName = "FewSleepingPlaces_1"
	elseif _Reason == Feedback.SettlerReasonNoPay then	
		ReasonName = "Payment_4"
	end
 

	-- Start first sound
	local Sound1Name = "Speech_" .. GrievanceName .. "_" .. EntityName
	Sound.PlayQueuedFeedbackSound( Sounds[ Sound1Name ], 0 )				
	
	-- Wait
	gvSpeech.SecondsToWait = gcSpeechSecondsToWaitLimit
	
	
	-- Reason defined?
	if ReasonName ~= nil then
	
		-- Reason sound name
		local Sound2Name = "Speech_Reason_" .. ReasonName

		-- Say reason
		Sound.PlayQueuedFeedbackSound( Sounds[ Sound2Name ], 0 )				
				
	end
	
end


--------------------------------------------------------------------------------
-- Simple feedback system
--------------------------------------------------------------------------------
-- Called for simple logic feedback stuff

function
GameCallback_GUI_SimpleFeedback( _Type, _Reason, _EntityID )

	-- Game started? Do not give feedback when game is just starting, ...
	if Logic.GetTime() == 0 then
		return
	end
	
	
	-- Table inited?
	if gvSimpleFeedback == nil then
	
		-- Create table
		gvSimpleFeedback = {}
		
		-- Init table values
		gvSimpleFeedback.LastYesNoMessageTime = 0
		
	end
	
	
	-- Handle 'Yes' and 'No'
	do
	
		-- 'Yes'?
		if _Type == FeedbackSimple.TypeYes then
		
			-- Entity passed?
			if _EntityID ~= 0 then
				
				-- Valid player
				if Logic.EntityGetPlayer(_EntityID) == GUI.GetPlayerID() then
				
					-- Get system time
					local CurrentTime = GUI.GetTime()
			
					-- Avoid overlapping
					if CurrentTime > ( gvSimpleFeedback.LastYesNoMessageTime + 0.5 ) then
					
						-- Start sample
						local EntityType = Logic.GetEntityType( _EntityID )
						if EntityType  == Entities.PU_Hero1 then				
							Sound.PlayFeedbackSound( Sounds.Hero1_HERO1_Yes_rnd_01, 0 )
						elseif 	EntityType  == Entities.PU_Hero2 then
							Sound.PlayFeedbackSound( Sounds.Hero2_HERO2_Yes_rnd_01, 0 )
						elseif 	EntityType  == Entities.PU_Hero3 then
							Sound.PlayFeedbackSound( Sounds.Hero3_HERO3_Yes_rnd_01, 0 )
						elseif 	EntityType  == Entities.PU_Serf then
							Sound.PlayFeedbackSound( Sounds.Serf_SERF_Yes_rnd_01, 0 )
						else
							Sound.PlayFeedbackSound( Sounds.Leader_LEADER_Yes_rnd_01 , 0)
						end
		
						-- Save time
						gvSimpleFeedback.LastYesNoMessageTime = CurrentTime    			
						
					end
				
				end
		
			end
			
		-- 'No'?
		elseif _Type == FeedbackSimple.TypeNo then
		
			-- Entity passed?
			if _EntityID ~= 0 then
				
				-- Valid player
				if Logic.EntityGetPlayer(_EntityID) == GUI.GetPlayerID() then

					-- Get system time
					local CurrentTime = GUI.GetTime()
			
					-- Avoid overlapping
					if CurrentTime > ( gvSimpleFeedback.LastYesNoMessageTime + 0.5 ) then
					
						-- Start sample
						local EntityType = Logic.GetEntityType( _EntityID )
						if EntityType  == Entities.PU_Hero1 then				
							Sound.PlayFeedbackSound( Sounds.Hero1_HERO1_NO_rnd_01, 0 )
						elseif 	EntityType  == Entities.PU_Hero2 then
							Sound.PlayFeedbackSound( Sounds.Hero2_HERO2_NO_rnd_01, 0 )
						elseif 	EntityType  == Entities.PU_Hero3 then
							Sound.PlayFeedbackSound( Sounds.Hero3_HERO3_NO_rnd_01, 0 )
						elseif 	EntityType  == Entities.PU_Serf then
							Sound.PlayFeedbackSound( Sounds.Serf_SERF_No_rnd_01, 0 )
						else
							Sound.PlayFeedbackSound( Sounds.Leader_LEADER_NO_rnd_01 , 0)
						end
		
						-- Save time
						gvSimpleFeedback.LastYesNoMessageTime = CurrentTime    			
						
					end
				
				end
			
			end
			
		end

	end
	
end

--------------------------------------------------------------------------------
