require("scripts.freebrewlib.string") --REQUIRE STRING FUNCTIONS
require("scripts.local.gcbotlua.functions")
require("scripts.local.gcbotlua.gui")

--[[
****TODO
-Start implementing diamond solving
-Add other dragons
-Add seasons
-Add hell
-Reset speed variable to 1 after X amount of time (to ensure its set to 2 if somehow it reverted)
-Add wave skipping
-Add advertisement watching
-Add "lost" functionality
]]

--Globals
Events = {
	NumOfEvents = 3,
	{Event = "Replay"},
	{Event = "Battle"},
	{Event = "Dragon"},
	REPLAY = "Replay",
	BATTLE = "Battle",
	DRAGON = "Dragon"
}

GeneralButton = 0
GeneralBool = false
ConfigButton = 0
ConfigBool = false

--General
CupsLabel = 0
WavesLabel = 0
DragonLabel = 0
GoldLabel = 0

--Config
DragonsButton = 0
GreenButton = 0
BlackButton = 0
RedButton = 0
SpecialButton = 0
LegendButton = 0
RunWavesButton = 0
SkipWavesButton = 0
ReplayWavesButton = 0
RunSeasonButton = 0
RunHellButton = 0
SpamAbilityButton = 0
AdButton = 0

EAST = 1
WEST = 2
NORTH = 1
SOUTH = 2

-- X, Y, hasSettled, North/South, East/West
Cups = {
	[1] = {46, 124, false, 0, 0},
	[2] = {146, 124, false, 0, 0},
	[3] = {247, 124, false, 0, 0},
	[4] = {348, 124, false, 0, 0},
	[5] = {449, 124, false, 0, 0}
}

CupsUsed = {
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false
}

Speed = 1 --1 = 1x, 2 = 2x. If 2x do not search
LostTol = 30 --Tolerance for search of lost image

--Returns name of script
function getName()
	return "LUA GCBot v0.1"
end

--Returns script version
function getVersion()
	return 0.1
end

--Script init function
function start()
	math.randomseed(Bot:GET_TIME())
	Bot.IS_DEBUG = false -- Set debug messages to true or false; Default is false
	Bot.IS_PLAYING = true -- Not required, starts bot in "playing" state; Default is false
	--TODO Detect when platform is loaded
	Bot:BOOT_PLATFORM(Platforms.PLATFORM_BLUESTACKS2) --BOOT PLATFORM(BLUESTACKS 2)
	--TODO Check adb has connected
	Bot:CONNECT_ADB() --CONNECT ADB
	Bot:START_APP("com.raongames.growcastle") --START APP
	Bot:CREATE_THREAD("AbilityThread", true)
	--Bot:CREATE_THREAD("GnDThread", true)
	--Create controls
	GeneralBool = true
	drawMenu()
	drawGeneral()
	Bot:UPDATE_GUI()
	Bot:TOGGLE_CONTROL(GeneralButton)
end

--Script main loop
function loop()
	NextEvent = Bot:PROCESS_NEXT_UI_EVENT()
	if NextEvent == GeneralButton then
		local file = "snap.bmp"
		Misc:CAPTURE_SCREEN(Bot:GET_WINDOW(), file)
		if not GeneralBool then
			drawMenu()
			drawGeneral()
			GeneralBool = true
			ConfigBool = false
			Bot:UPDATE_GUI()
			Bot:TOGGLE_CONTROL(GeneralButton)
		end
	elseif NextEvent == ConfigButton then
		if not ConfigBool then
			drawMenu()
			drawConfig()
			GeneralBool = false
			ConfigBool = true
			Bot:UPDATE_GUI()
			Bot:TOGGLE_CONTROL(ConfigButton)
		end
	end

	if Bot.IS_PLAYING then
		if Bot:FIND_IMAGE("replay.bmp") then --IF TRUE WE ARE ON MAIN MENU(CASTLE SCREEN)

			--Bot:SET_CONTROL_TEXT(CupsLabel, "Cups Stats will go here.")

			Bot:WAIT(100)
			local randEvent = math.random(1, Events.NumOfEvents) -- RANDOMLY PICK NEXT EVENT
			if Events[randEvent].Event == Events.REPLAY then
				Bot:WAIT(75)
				if Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("replay.bmp", 5) then --START REPLAY
					Bot:WAIT(25)
					Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("100_replay.bmp", 5) --WAIT FOR 100% TO SHOW AND CLICK
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Replaying last wave\n", Bot.CONSOLE)
				end

				--Captures HDC and turns cups red
				--TODO
				--Find diamond cup
				--[[
				for i=0,50
				do

				end
				]]
				Bot:WAIT(1000)
			elseif Events[randEvent].Event == Events.BATTLE then
				Bot:PRINT(Bot:GET_GUI_WINDOW(), "Running next wave\n", Bot.CONSOLE)
				Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("battle_btn.bmp", 5) --START BATTLE
				Bot:WAIT(1000)
			elseif Events[randEvent].Event == Events.DRAGON then
				Bot:PRINT(Bot:GET_GUI_WINDOW(), "Fighting dragon\n", Bot.CONSOLE)
				if(Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("dragon_shrine.bmp", 5)) then --START DRAGON
					if(Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("black_dragon.bmp", 5)) then
						Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("dragon_battle.bmp", 5)
					end
				end
				Bot:WAIT(1000)
			end
		else
			if Bot:FIND_IMAGE("event_back.bmp") then --IF TRUE WE ARE IN AN EVENT(BATTLE, REPLAY, DRAGON, ETC)
				--Running Event/Wave/Dragon
			elseif Bot:FIND_IMAGE("mat2_btn.bmp") then
				local found, x, y = Bot:FIND_IMAGE_WITH_XY("mat2_btn.bmp", Bot.DEFAULT_TOLERANCE)
				if found then
					Bot:CLICK_XY(x, y)
					Bot:CLICK_XY(x, y)
				end
			elseif Bot:FIND_IMAGE("start.bmp") and not Bot:FIND_IMAGE("left_time.bmp") then
				Bot:FIND_CLICK_IMAGE("start.bmp")
				local diamondCup = -1
				for i=0,40
				do
					local file = "snap"..tostring(i)..".bmp"
					Misc:CAPTURE_SCREEN(Bot:GET_WINDOW(), file)
					Bot:WAIT(30)
				end
				local i2 = 0
				for i=0,40
				do
					local file = "snap"..tostring(i)..".bmp"
					local f, xx, yy = Bot:FIND_IMAGE_IN_IMAGE(file, "ab_d.bmp")
					local f2, xx2, yy2 = Bot:FIND_IMAGE_IN_IMAGE(file, "start.bmp")
					if f then
						local found, x, y = Bot:FIND_IMAGE_IN_IMAGE(file, "ab_d.bmp")
						MsgBox(tostring(x).."-"..tostring(y))
						if x < 250 then
							diamondCup = 0
						elseif x < 350 then
							diaomndCup = 1
						elseif x < 450 then
							diaomndCup = 2
						elseif x < 550 then
							diaomndCup = 3
						elseif x < 650 then
							diaomndCup = 4
						end
						--Get cup diamond is under
					elseif not f2 then
						local imgHDC = Misc:LOAD_IMAGE(file, true, 130, 290, 530, 320)
						Misc:REPLACE_COLOR_WITH_TOL(imgHDC, Misc:GET_COLOR(180, 158, 121), Misc:GET_COLOR(255, 0, 0), 30)
						Misc:REPLACE_COLOR_WITH_TOL(imgHDC, Misc:GET_COLOR(189, 165, 127), Misc:GET_COLOR(255, 0, 0), 30)
						Misc:REPLACE_COLOR_WITH_TOL(imgHDC, Misc:GET_COLOR(165, 144, 111), Misc:GET_COLOR(255, 0, 0), 30)
						Misc:REPLACE_COLOR_WITH_TOL(imgHDC, Misc:GET_COLOR(165, 144, 111), Misc:GET_COLOR(255, 0, 0), 30)
						Misc:REPLACE_ALL_COLORS_EXCEPT(imgHDC, Misc:GET_COLOR(255, 0, 0), Misc:GET_COLOR(0, 0, 0))

						Misc:COPY_HDC_TO_SCREEN(imgHDC)
						--Save Image as snap#_edit.bmp
						local newFile = "snap"..tostring(i2).."_edit"
						Misc:SAVE_HDC(imgHDC, newFile)
						Misc:DELETE_HDC(imgHDC)
						i2 = i2 + 1
						Bot:WAIT(500)
					end
				end
				--Find diampnd cup function
				--Bot:FIND_DIAMOND(0, 39, diamondCup)
			else

				--I AM LOST
				--[[if Bot:FIND_CLICK_IMAGE_WITH_TOL("", LostTol)
					LostTol = 30;
					Bot:WAIT(50);
				else
					LostTol++;
				end]]
			end
		end
	end
	Bot:WAIT(100)
end
