function drawGeneral()
	WavesLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 23, 450, 20, "CLICK")
	DragonLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 46, 450, 20, "BLANK")
	GoldLabel = Bot:CREATE_CONTROL_FIXED_ID(1, Control.LABEL, 0, 69, 450, 20, "BLANK")
	CupsLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 92, 450, 20, "BLANK")
	ScreenBtn = Bot:CREATE_CONTROL(Control.BUTTON, 0, 115, 450, 20, "Take Screenshot")
end

function drawCastle()
	TopCastleLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 23, 450, 20, "Top")
	MiddleCastleLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 46, 450, 20, "Middle")
	BottomCastleLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 69, 450, 20, "Bottom")
	BaseCastleLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 92, 450, 20, "Base")
	ScanCastleBtn = Bot:CREATE_CONTROL(Control.BUTTON, 0, 115, 450, 20, "Scan Castle")
end

function updateCastleText()
	if CastleTop > 0 then
		Bot:SET_CONTROL_TEXT(TopCastleLabel, "Top:"..CastleText[CastleTop].." - Levels Gained: "..CastleTopLevels)
	end
	if CastleMiddle > 0 then
		Bot:SET_CONTROL_TEXT(MiddleCastleLabel, "Middle:"..CastleText[CastleMiddle].." - Levels Gained: "..CastleMiddleLevels)
	end
	if CastleBottom > 0 then
		Bot:SET_CONTROL_TEXT(BottomCastleLabel, "Bottom:"..CastleText[CastleBottom].." - Levels Gained: "..CastleBottomLevels)
	end
	if CastleBase > 0 then
		Bot:SET_CONTROL_TEXT(BaseCastleLabel, "Base:"..CastleBaseText[CastleBase].." - Levels Gained: "..CastleBaseLevels)
	end
end

function drawMenu()
	GeneralButton = Bot:CREATE_CONTROL(Control.RADIO_BUTTON, 0, 0, 100, 20, "General")
	ConfigButton = Bot:CREATE_CONTROL(Control.RADIO_BUTTON, 105, 0, 100, 20, "Config")
	CastleButton = Bot:CREATE_CONTROL(Control.RADIO_BUTTON, 210, 0, 100, 20, "Castle")
end

function drawConfig()
	DragonsButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 0, 30, 185, 35, "Run Dragons")
	GreenButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 10, 55, 30, 35, "G")
	BlackButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 40, 55, 30, 35, "B")
	RedButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 70, 55, 30, 35, "R")
	SpecialButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 100, 55, 30, 35, "S")
	LegendButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 130, 55, 30, 35, "L")
	RunWavesButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 0, 80, 185, 35, "Run Waves")
	SkipWavesButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 10, 105, 175, 35, "Skip Waves")
	ReplayWavesButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 0, 130, 185, 35, "Replay Waves")
	RunSeasonButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 0, 155, 185, 35, "Run Season")
	RunHellButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 185, 30, 185, 35, "Run Hell")
	SpamAbilityButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 185, 80, 185, 35, "Spam Abilities")
	AdButton = Bot:CREATE_CONTROL(Control.CHECKBOX, 185, 105, 185, 35, "Watch Ads")
end

function updateToggles()
	Bot:TOGGLE_CONTROL(GeneralButton, GeneralBool)
	Bot:TOGGLE_CONTROL(ConfigButton, ConfigBool)
	Bot:TOGGLE_CONTROL(CastleButton, CastleBool)
	if ConfigBool then
		Bot:TOGGLE_CONTROL(RunWavesButton, bRunWaves)
		Bot:TOGGLE_CONTROL(DragonsButton, bRunDragons)
		Bot:TOGGLE_CONTROL(ReplayWavesButton, bReplayWaves)
		Bot:TOGGLE_CONTROL(GreenButton, bGreenDragon)
		Bot:TOGGLE_CONTROL(RedButton, bRedDragon)
		Bot:TOGGLE_CONTROL(BlackButton, bBlackDragon)
		Bot:TOGGLE_CONTROL(SpecialButton, bSpecialDragon)
		Bot:TOGGLE_CONTROL(LegendButton, bLegendDragon)
		Bot:TOGGLE_CONTROL(SkipWavesButton, bSkipWaves)
		Bot:TOGGLE_CONTROL(SpamAbilityButton, bSpamAbilities)
		Bot:TOGGLE_CONTROL(RunHellButton, bRunHell)
		Bot:TOGGLE_CONTROL(RunSeasonButton, bRunSeason)
		Bot:TOGGLE_CONTROL(AdButton, bWatchAds)
	elseif GeneralBool then
		--Nothing to update
	end
end
