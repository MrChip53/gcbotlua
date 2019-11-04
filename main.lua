require("scripts.freebrewlib.string") --REQUIRE STRING FUNCTIONS

if IS_LOCAL then
	require("scripts.local.gcbotlua.functions")
	require("scripts.local.gcbotlua.gui")
else
	require("scripts.gcbotlua.functions")
	require("scripts.gcbotlua.gui")
end

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

Dragons = {}
GreenDragon = 0
BlackDragon = 1
RedDragon = 2
SinDragon = 3
LegendDragon = 4


--Stats
DragonsFought = 0
WavesReplayed = 0
WavesCleared = 0

--Tabs
GeneralButton = 0
GeneralBool = false
ConfigButton = 0
ConfigBool = false

--General
CupsLabel = 0
WavesLabel = 0
DragonLabel = 0
GoldLabel = 0

lastRan = 0

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

bRunWaves = true

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
LostTol = 5 --Tolerance for search of lost image

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
	--[[]]

	math.randomseed(Bot:GET_TIME())
	Bot.IS_DEBUG = false -- Set debug messages to true or false; Default is false
	Bot.IS_PLAYING = true -- Not required, starts bot in "playing" state; Default is false
	--TODO Detect when platform is loaded
	Bot:BOOT_PLATFORM() --BOOT PLATFORM(BLUESTACKS 2)
	Bot:WAIT(10*1000) --Wait 10sec for android to load
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
	
	Bot:SET_CONTROL_TEXT(CupsLabel, "Cup Stats will go here.")
	Bot:SET_CONTROL_TEXT(WavesLabel, "Wave Stats will go here.")
	Bot:SET_CONTROL_TEXT(GoldLabel, "Gold Stats will go here.")
	Bot:SET_CONTROL_TEXT(DragonLabel, "Dragon Stats will go here.")
	
	table.insert(Dragons, GreenDragon)
	table.insert(Dragons, BlackDragon)
	table.insert(Dragons, RedDragon)
end

--Script main loop
function loop()
	NextEvent = Bot:PROCESS_NEXT_UI_EVENT()
	if NextEvent == GeneralButton then
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
			if bRunWaves then
				Bot:TOGGLE_CONTROL(RunWavesButton)
			end
		end
	elseif NextEvent == RunWavesButton then
		if bRunWaves then
			bRunWaves = false
		else
			bRunWaves = true
		end
	end

	if Bot.IS_PLAYING then
		if Bot:FIND_IMAGE("replay.bmp") then --IF TRUE WE ARE ON MAIN MENU(CASTLE SCREEN)
			--[[local thisTime = Bot:GET_TIME()
			if thisTime - lastRan < 7 then
				Bot.IS_PLAYING = false
				Bot:WAIT(2*1000)
				Bot:PRINT(Bot:GET_GUI_WINDOW(), "Running too fast... did ADB/BlueStacks fail? Restarting android...\n", Bot.CONSOLE)
				Bot:KILL_PLATFORM();
				Bot:WAIT(3*1000);
				Bot:BOOT_PLATFORM() --BOOT PLATFORM(BLUESTACKS 2)
				Bot:WAIT(10*1000) --Wait 10sec for android to load
				Bot:CONNECT_ADB() --CONNECT ADB
				Bot:START_APP("com.raongames.growcastle") --START APP
				Bot.IS_PLAYING = true
			end
			lastRan = thisTime]]

			Bot:WAIT(100)
			local randEvent = math.random(1, Events.NumOfEvents) -- RANDOMLY PICK NEXT EVENT
			if Events[randEvent].Event == Events.REPLAY then
				Bot:WAIT(75)
				if Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("replay.bmp", 5) then --START REPLAY
					Bot:WAIT(25)
					Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("100_replay.bmp", 5) --WAIT FOR 100% TO SHOW AND CLICK
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Replaying last wave.\n", Bot.CONSOLE)
					WavesReplayed = WavesReplayed + 1
					Bot:SET_CONTROL_TEXT(WavesLabel, WavesReplayed.." waves replayed; "..WavesCleared.." waves cleared.")
				end
				Bot:WAIT(1000)
			elseif Events[randEvent].Event == Events.BATTLE then
				if bRunWaves then
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Running next wave\n", Bot.CONSOLE)
					Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("battle_btn.bmp", 5) --START BATTLE
					WavesCleared = WavesCleared + 1 --TODO Check if victory then add 1
					Bot:SET_CONTROL_TEXT(WavesLabel, WavesReplayed.." waves replayed; "..WavesCleared.." waves cleared.")
					Bot:WAIT(1000)
				end
			elseif Events[randEvent].Event == Events.DRAGON then
				Bot:PRINT(Bot:GET_GUI_WINDOW(), "Fighting dragon\n", Bot.CONSOLE)
				if(Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("dragon_shrine.bmp", 5)) then --START DRAGON
					local randDragon = math.random(0, table.getn(Dragons) - 1)
					if(Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("dragon_"..Dragons[randDragon]..".bmp", 5)) then
						local dTol = 5
						local found, x, y = Bot:FIND_IMAGE_WITH_XY("dragon_battle.bmp", dTol)
						while not found and dTol < 255 do
							dTol = dTol + 1
							found, x, y = Bot:FIND_IMAGE_WITH_XY("dragon_battle.bmp", dTol)
						end
						if found then
							Bot:CLICK_XY(x, y)
						end
						DragonsFought = DragonsFought + 1
						Bot:SET_CONTROL_TEXT(DragonLabel, DragonsFought.." dragons fought.")
					end
				end
				Bot:WAIT(1000)
			end
		else
			if Bot:FIND_IMAGE("event_back.bmp") or Bot:FIND_IMAGE("2x.bmp") then --IF TRUE WE ARE IN AN EVENT(BATTLE, REPLAY, DRAGON, ETC)
				--Running Event/Wave/Dragon
			elseif Bot:FIND_IMAGE("mat2_btn.bmp") then
				local found, x, y = Bot:FIND_IMAGE_WITH_XY("mat2_btn.bmp", Bot.DEFAULT_TOLERANCE)
				if found then
					Bot:CLICK_XY(x, y)
					Bot:CLICK_XY(x, y)
				end
			elseif Bot:FIND_IMAGE("start.bmp") and not Bot:FIND_IMAGE("left_time.bmp") then
				Bot:START_RECORD()
				Bot:WAIT(1000) --Wait for recording to start
				Bot:FIND_CLICK_IMAGE("start.bmp")
				Bot:WAIT(2200) --Wait for cups to move
				Bot:STOP_RECORD()
				
				--Solve
				OpenCV:OPEN_VIDEO("run1.mp4")

				if OpenCV:IS_VIDEO_OPEN() then
							
					--Find Diamond
					OpenCV:CAPTURE_NEXT_FRAME()
					local dfound, dx, dy = Bot:FIND_IMAGE_IN_IMAGE("frame.bmp", "ab_d.bmp")
					while not dfound do
						OpenCV:CAPTURE_NEXT_FRAME()
						dfound, dx, dy = Bot:FIND_IMAGE_IN_IMAGE("frame.bmp", "ab_d.bmp")
					end
							
					--Find Cups
					local boxes = OpenCV:MULTI_TEMPLATE_MATCH("cup.bmp", 5, 0.8)
							
					local numEntries, boxTable = OpenCV:RECT_ARRAY_TO_TABLE(boxes)
							
					local closestBox = -1
					local closestDist = -1
							
					for i = 1,numEntries,1
					do 
						local xval = (boxTable[i]["x"] - dx)^2
						
						local yval = (boxTable[i]["y"] - dy)^2
								
						local dist = math.sqrt(xval + yval)
								
						if closestDist == -1 or closestDist > dist then
							closestDist = dist
							closestBox = i
						end
								
					end
							
							--Track cups
					local multiTracker = OpenCV:RUN_MULTI_TRACKER(boxes)
					OpenCV:CLOSE_VIDEO()		
					
					--[[
						TODO make sure cup location is where a cup should be
							incase MultiTracker lost track of cups; if cup is lost
							pick random cup
					]]
					
					Bot:CLICK_XY(multiTracker[closestBox]["x"], multiTracker[closestBox]["y"])
				end
				
			else

				--I AM LOST; this code needs work, doesn't always find X button
				local xf, xx, xy = Bot:FIND_IMAGE_WITH_XY("x1.bmp", LostTol)
				if xf then
					LostTol = 5
					Bot:CLICK_XY(xx, xy)
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Cicked X\n", Bot.CONSOLE)
					Bot:WAIT(50)
				else
					LostTol = LostTol + 1
				end
			end
		end
	end
	Bot:WAIT(100)
end