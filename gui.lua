function drawGeneral()
	WavesLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 23, 450, 20, "CLICK")
	DragonLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 46, 450, 20, "BLANK")
	GoldLabel = Bot:CREATE_CONTROL_FIXED_ID(1, Control.LABEL, 0, 69, 450, 20, "BLANK")
	CupsLabel = Bot:CREATE_CONTROL(Control.LABEL, 0, 92, 450, 20, "BLANK")
end

function drawMenu()
	GeneralButton = Bot:CREATE_CONTROL(Control.RADIO_BUTTON, 0, 0, 100, 20, "General")
	ConfigButton = Bot:CREATE_CONTROL(Control.RADIO_BUTTON, 110, 0, 100, 20, "Config")
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
