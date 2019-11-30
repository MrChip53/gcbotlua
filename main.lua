if IS_LOCAL then
	require("scripts.local.gcbotlua.functions")
	require("scripts.local.gcbotlua.gui")
else
	require("scripts.gcbotlua.functions")
	require("scripts.gcbotlua.gui")
end

--[[
****TODO
-Improve diamond solving
-Add seasons
-Add hell
-Add wave skipping
-Add advertisement watching
-Add "lost" functionality
]]

--Globals
Events = {}
ReplayEvent = 0
RunWaveEvent = 1
DragonEvent = 2
RunSeasonEvent = 3
RunHellEvent = 4

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
CastleButton = 0
CastleBool = false

--General
CupsLabel = 0
WavesLabel = 0
DragonLabel = 0
GoldLabel = 0
ScreenBtn = 0

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

--Castle
ScanCastleBtn = 0
TopCastleLabel = 0
MiddleCastleLabel = 0
BottomCastleLabel = 0
BaseCastleLabel = 0
CastleTopLevels = 0
CastleMiddleLevels = 0
CastleBottomLevels = 0
CastleBaseLevels = 0

CastleBaseText = {"Frozen", "Lightning", "Poison", "Fire"}
CastleText = {"Cannon", "Minigun", "Poison", "Lightning", "Ballista"}

CastleBase = 0 --Frozen = 1; lightning = 2; poison = 3; fire = 4
CastleTop = 0 --Cannon = 1; Minigun = 2; Poison = 3; Lightning = 4; Ballista = 5
CastleMiddle = 0
CastleBottom = 0

bScanCastle = true
bUpgradeCastle = true

bRunWaves = true
bReplayWaves = true
bRunDragons = true

bGreenDragon = true
bRedDragon = true
bBlackDragon = true
bSpecialDragon = false
bLegendDragon = false
bSkipWaves = false
bSpamAbilities = true
bRunHell = false
bRunSeason = false
bWatchAds = false

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

function upgradeCastle(castle)
	local found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_base_"..CastleBase..".bmp")
	if found then
		Bot:CLICK_XY(x, y)
		Bot:WAIT(500)
		local found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_"..castle..".bmp")
		if found then
			Bot:CLICK_XY(x, y)
			Bot:WAIT(500)
			found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_btn_"..castle..".bmp")
			if found then
				Bot:CLICK_XY(x, y)
				Bot:WAIT(500)
				found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "lvlup_castle.bmp")
				if found then
					for i=1,60,1
					do
						Bot:CLICK_XY(x, y)
						Bot:WAIT(5)
					end
					return true
				end
			else
				Bot:PRINT(Bot:GET_GUI_WINDOW(), "Could not find castle part in menu!\n", Bot.CONSOLE)
			end
		else
			Bot:PRINT(Bot:GET_GUI_WINDOW(), "Could not find castle part "..castle.."!\n", Bot.CONSOLE)
		end
	else
		Bot:PRINT(Bot:GET_GUI_WINDOW(), "Could not find castle base!\n", Bot.CONSOLE)
	end
	return false
end

function buildDragonTable()
	Dragons = {}
	if bGreenDragon then
		table.insert(Dragons, GreenDragon)
	end
	if bBlackDragon then
		table.insert(Dragons, BlackDragon)
	end
	if bRedDragon then
		table.insert(Dragons, RedDragon)
	end
	if bSpecialDragon then
		table.insert(Dragons, SinDragon)
	end
	if bLegendDragon then
		table.insert(Dragons, LegendDragon)
	end
end

function buildEventTable()
	Events = {}
	if bReplayWaves then
		table.insert(Events, ReplayEvent)
	end
	if bRunWaves then
		table.insert(Events, RunWaveEvent)
	end
	if bRunDragons then
		table.insert(Events, DragonEvent)
	end
	if bRunHell then
		table.insert(Events, RunHellEvent)
	end
	if bRunSeason then
		table.insert(Events, RunSeasonEvent)
	end
end

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
	--Bot:KILL_PLATFORM();
	--Bot:WAIT(500);
	
	Bot:BOOT_PLATFORM() --BOOT PLATFORM(BLUESTACKS 2)
	Bot:WAIT(10*1000) --Wait 10sec for android to load
	--TODO Check adb has connected
	Bot:CONNECT_ADB() --CONNECT ADB
	Bot:START_APP("com.raongames.growcastle") --START APP
	Bot:CREATE_THREAD("AbilityThread", true)
	Bot:CREATE_THREAD("GnDThread", true)
	--Create controls
	GeneralBool = true
	drawMenu()
	drawGeneral()
	Bot:UPDATE_GUI()
	Bot:TOGGLE_CONTROL(GeneralButton, GeneralBool)
	
	Bot:SET_CONTROL_TEXT(CupsLabel, "Cup Stats will go here.")
	Bot:SET_CONTROL_TEXT(WavesLabel, "Wave Stats will go here.")
	Bot:SET_CONTROL_TEXT(GoldLabel, "Gold Stats will go here.")
	Bot:SET_CONTROL_TEXT(DragonLabel, "Dragon Stats will go here.")
	
	buildDragonTable()
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
			CastleBool = false
			Bot:UPDATE_GUI()
			updateToggles()
			Bot:SET_CONTROL_TEXT(WavesLabel, WavesReplayed.." waves replayed; "..WavesCleared.." waves cleared.")
			Bot:SET_CONTROL_TEXT(DragonLabel, DragonsFought.." dragons fought.")
		end
	elseif NextEvent == ConfigButton then
		if not ConfigBool then
			drawMenu()
			drawConfig()
			GeneralBool = false
			ConfigBool = true
			CastleBool = false
			Bot:UPDATE_GUI()
			updateToggles()
		end
	elseif NextEvent == CastleButton then
		if not CastleBool then
			drawMenu()
			drawCastle()
			GeneralBool = false
			ConfigBool = false
			CastleBool = true
			Bot:UPDATE_GUI()
			updateToggles()
			updateCastleText()
		end
	elseif NextEvent == RunWavesButton then
		bRunWaves = not bRunWaves
		buildEventTable()
	elseif NextEvent == ScanCastleBtn then
		bScanCastle = true
	elseif NextEvent == GreenButton then
		bGreenDragon = not bGreenDragon
		buildDragonTable()
	elseif NextEvent == BlackButton then
		bBlackDragon = not bBlackDragon
		buildDragonTable()
	elseif NextEvent == RedButton then
		bRedDragon = not bRedDragon
		buildDragonTable()
	elseif NextEvent == SpecialButton then
		bSpecialDragon = not bSpecialDragon
		buildDragonTable()
	elseif NextEvent == LegendButton then
		bLegendDragon = not bLegendDragon
		buildDragonTable()
	elseif NextEvent == ReplayWavesButton then
		bReplayWaves = not bReplayWaves
		buildEventTable()
	elseif NextEvent == SkipWavesButton then
		bSkipWaves = not bSkipWaves
	elseif NextEvent == SpamAbilityButton then
		bSpamAbilities = not bSpamAbilities
	elseif NextEvent == RunHellButton then
		bRunHell = not bRunHell
		buildEventTable()
	elseif NextEvent == RunSeasonButton then
		bRunSeason = not bRunSeason
		buildEventTable()
	elseif NextEvent == AdButton then
		bWatchAds = not bWatchAds
		buildEventTable()
	elseif NextEvent == DragonsButton then
		bRunDragons = not bRunDragons
		buildEventTable()
	elseif NextEvent == ScreenBtn then
		Misc:CAPTURE_SCREEN(Bot:GET_WINDOW(), "Capture.bmp")
		Bot:PRINT(Bot:GET_GUI_WINDOW(), "Screenshot saved to ./Captures/Capture.bmp\n", Bot.CONSOLE)
	end
	updateToggles()
	Bot:SET_STATUS_MSG(0, "Running for "..Bot:GET_RUN_TIME().."...")
	
	if Bot.IS_PLAYING then
		if Bot:FIND_IMAGE("replay.bmp") then --IF TRUE WE ARE ON MAIN MENU(CASTLE SCREEN)
			Bot:SET_STATUS_MSG(1, "At castle...")
			if bScanCastle then
				Bot:PRINT(Bot:GET_GUI_WINDOW(), "Scanning castle\n", Bot.CONSOLE)
				Bot:WAIT(200)
				--Scan base
				bScanCastle = false
				for i=1,4,1
				do
					local found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_base_"..i..".bmp")
					if found then
						CastleBase = i
						Bot:CLICK_XY(x, y)
					end
				end
				Bot:WAIT(100)
				--Scan other castle
				for i=1,5,1
				do
					local found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_"..i..".bmp")
					if found then
						if y > 340 then --CastleBottom
							CastleBottom = i
						elseif y > 275 then --CastleMiddle
							CastleMiddle = i
						else --CastleTop
							CastleTop = i
						end
					end
				end
				if CastleBool then
					updateCastleText()
				end
				bScanCastle = false
			end
			local diamonds = Bot:GET_GLOBAL("DIAMOND")
			if bUpgradeCastle then
				if tonumber(diamonds) == 60 then
					Bot:SET_STATUS_MSG(1, "Upgrading castle...")
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Upgrading castle. Diamonds: "..diamonds.."\n", Bot.CONSOLE)
					Bot:WAIT(200)
					local randCastle = math.random(1, 4)
					if randCastle == 1 then --upgrade base
						local found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_base_"..CastleBase..".bmp")
						if found then
							Bot:CLICK_XY(x, y)
							Bot:WAIT(250)
							Bot:CLICK_XY(x, y)
							found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "castle_base_btn_"..CastleBase..".bmp")
							if found then
								Bot:CLICK_XY(x, y)
								Bot:WAIT(250)
								found, x, y = OpenCV:TEMPLATE_MATCH(Bot:GET_WINDOW(), "lvlup_castle.bmp")
								for i=1,60,1
								do
									Bot:CLICK_XY(x, y)
									Bot:WAIT(5)
								end
								CastleBaseLevels = CastleBaseLevels + 60
								if CastleBool then
									updateCastleText()
								end
							else
								Bot:PRINT(Bot:GET_GUI_WINDOW(), "Could not find castle base "..CastleBase.." in menu!\n", Bot.CONSOLE)
							end
						else
							Bot:PRINT(Bot:GET_GUI_WINDOW(), "Could not find castle base!\n", Bot.CONSOLE)
						end
					elseif randCastle == 2 then --upgrade bottom
						if upgradeCastle(CastleBottom) then
							CastleBottomLevels = CastleBottomLevels + 60
							if CastleBool then
								updateCastleText()
							end
						end
					elseif randCastle == 3 then --upgrade middle
						if upgradeCastle(CastleMiddle) then
							CastleMiddleLevels = CastleMiddleLevels + 60
							if CastleBool then
								updateCastleText()
							end
						end
					elseif randCastle == 4 then --upgrade top
						if upgradeCastle(CastleTop) then
							CastleTopLevels = CastleTopLevels + 60
							if CastleBool then
								updateCastleText()
							end
						end
					end
					Bot:SET_GLOBAL("DIAMOND", "0")
				end
			end
			local thisTime = Bot:GET_TIME()
			--Bot:PRINT(Bot:GET_GUI_WINDOW(), thisTime.." - "..lastRan.."\n", Bot.CONSOLE)
			if thisTime - lastRan < 7 then
				Bot:SET_STATUS_MSG(1, "Restarting android...")
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
			lastRan = thisTime
			
			if table.getn(Events) > 0 then
				local randEvent = math.random(1, table.getn(Events)) -- RANDOMLY PICK NEXT EVENT
				if Events[randEvent] == ReplayEvent then
					Bot:WAIT(75)
					if Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("replay.bmp", 2) then --START REPLAY
						--Bot:WAIT(25)
						Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("100_replay.bmp", 5) --WAIT FOR 100% TO SHOW AND CLICK
						Bot:PRINT(Bot:GET_GUI_WINDOW(), "Replaying last wave.\n", Bot.CONSOLE)
						Bot:SET_STATUS_MSG(1, "Replaying wave...")
						WavesReplayed = WavesReplayed + 1
						if GeneralBool then
							Bot:SET_CONTROL_TEXT(WavesLabel, WavesReplayed.." waves replayed; "..WavesCleared.." waves cleared.")
						end
					end
					Bot:WAIT(1000)
				elseif Events[randEvent] == RunWaveEvent then
					Bot:SET_STATUS_MSG(1, "Running wave...")
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Running next wave\n", Bot.CONSOLE)
					Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("battle_btn.bmp", 2) --START BATTLE
					WavesCleared = WavesCleared + 1 --TODO Check if victory then add 1
					if GeneralBool then
						Bot:SET_CONTROL_TEXT(WavesLabel, WavesReplayed.." waves replayed; "..WavesCleared.." waves cleared.")
					end
					Bot:WAIT(1000)
				elseif Events[randEvent] == DragonEvent then
					if table.getn(Dragons) > 0 then
						if Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("dragon_shrine.bmp", 2) then --START DRAGON
							local randDragon = math.random(1, table.getn(Dragons))
							if(Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("dragon_"..Dragons[randDragon]..".bmp", 5)) then
								local dTol = 5
								local found, x, y = Bot:FIND_IMAGE_WITH_XY("dragon_battle.bmp", dTol)
								while not found and dTol < 255 do
									dTol = dTol + 1
									found, x, y = Bot:FIND_IMAGE_WITH_XY("dragon_battle.bmp", dTol)
								end
								if found then
									Bot:CLICK_XY(x, y)
									Bot:PRINT(Bot:GET_GUI_WINDOW(), "Fighting dragon\n", Bot.CONSOLE)	
									Bot:SET_STATUS_MSG(1, "Fighting dragon...")
									DragonsFought = DragonsFought + 1
								end
								
								if GeneralBool then
									Bot:SET_CONTROL_TEXT(DragonLabel, DragonsFought.." dragons fought.")
								end
							end
						end
						Bot:WAIT(1000)
					end
				elseif Events[randEvent] == RunHellEvent then
					if Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("hell_btn.bmp", 2) then
						if(Bot:WAIT_CLICK_IMAGE_WITH_TIMEOUT("hell_battle.bmp", 5)) then
							Bot:PRINT(Bot:GET_GUI_WINDOW(), "Enetering hell\n", Bot.CONSOLE)		
							Bot:SET_STATUS_MSG(1, "Running hell...")
						end
					end
					Bot:WAIT(1000)
				elseif Events[randEvent] == RunSeasonEvent then
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Running season\n", Bot.CONSOLE)
					Bot:SET_STATUS_MSG(1, "Running season...")
					Bot:WAIT(1000)
				end
			end
		else
			if Bot:FIND_IMAGE("event_back.bmp") or Bot:FIND_IMAGE("2x.bmp") then --IF TRUE WE ARE IN AN EVENT(BATTLE, REPLAY, DRAGON, ETC)
				--Running Event/Wave/Dragon
			elseif Bot:FIND_IMAGE("mat2_btn.bmp") then
				local found, x, y = Bot:FIND_IMAGE_WITH_XY("mat2_btn.bmp", Bot.DEFAULT_TOLERANCE)
				if found then
					Bot:SET_STATUS_MSG(1, "Collecting material...")
					Bot:CLICK_XY(x, y)
					Bot:CLICK_XY(x, y)
				end
			elseif Bot:FIND_IMAGE("victory.bmp") then
				--Wave completed
			elseif Bot:FIND_IMAGE("start.bmp") and not Bot:FIND_IMAGE("left_time.bmp") then
				Bot:SET_STATUS_MSG(1, "Solving diamond...")
				Bot:START_RECORD()
				Bot:WAIT(1000) --Wait for recording to start
				Bot:FIND_CLICK_IMAGE("start.bmp")
				Bot:WAIT(1800) --Wait for cups to move
				Bot:STOP_RECORD()
				Bot:WAIT(1000) --Wait for recording to stop
				
				--Solve
				OpenCV:OPEN_VIDEO("run1.mp4")

				if OpenCV:IS_VIDEO_OPEN() then
							
					--Find Diamond	
					local dfound, dx, dy
					repeat
						dfound, dx, dy = OpenCV:TEMPLATE_MATCH_VIDEO("ab_d.bmp")
					until(dfound == true)
					--[[if OpenCV:CAPTURE_NEXT_FRAME() then
						dfound, dx, dy = Bot:FIND_IMAGE_IN_IMAGE("frame.bmp", "ab_d.bmp")
						while not dfound do
							if OpenCV:CAPTURE_NEXT_FRAME() then
								dfound, dx, dy = Bot:FIND_IMAGE_IN_IMAGE("frame.bmp", "ab_d.bmp")
							else
								break
							end
						end
					end]]
							
					--Find Cups
					local dCup = {["set"] = false, ["x"] = 0, ["y"] = 0}
					
					
					local success, boxes = OpenCV:MULTI_TEMPLATE_MATCH_VIDEO("cup.bmp", 5, 0.8)
					repeat
						local numEntries, boxTable = OpenCV:RECT_ARRAY_TO_TABLE(boxes)
						
						if dCup["set"] == false then
						
							--Find closest cup to diamond
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
							
							--Set to dCup variable
							if closestBox > 0 then
								dCup["set"] = true
								dCup["x"] = boxTable[closestBox]["x"]
								dCup["y"] = boxTable[closestBox]["y"]
							else
								MsgBox("Error finding diamond cup")
							end
						else
							--Track movement of cup
							local closestBox = -1
							local closestDist = -1
									
							for i = 1,numEntries,1
							do 
								local xval = (boxTable[i]["x"] - dCup["x"])^2
								
								local yval = (boxTable[i]["y"] - dCup["y"])^2
										
								local dist = math.sqrt(xval + yval)
										
								if closestDist == -1 or closestDist > dist then
									closestDist = dist
									closestBox = i
								end
										
							end
							
							if closestBox > 0 then
								dCup["x"] = boxTable[closestBox]["x"]
								dCup["y"] = boxTable[closestBox]["y"]
							else
								MsgBox("Error finding diamond cup")
							end
							
						end
						
						success, boxes = OpenCV:MULTI_TEMPLATE_MATCH_VIDEO("cup.bmp", 5, 0.8)
					until (success == false)
					
					--[[local numEntries, boxTable = OpenCV:RECT_ARRAY_TO_TABLE(boxes)
							
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
					local multiTracker = OpenCV:RUN_MULTI_TRACKER(boxes)]]
					OpenCV:CLOSE_VIDEO()		
					
					--[[
						TODO make sure cup location is where a cup should be
							incase MultiTracker lost track of cups; if cup is lost
							pick random cup
					]]
					
					--Bot:CLICK_XY(multiTracker[closestBox]["x"], multiTracker[closestBox]["y"])
					Bot:CLICK_XY(dCup["x"], dCup["y"])
				end
				
				Bot:WAIT(500)
					
				if not Bot:FIND_IMAGE("event_back.bmp") and not Bot:FIND_IMAGE("2x.bmp") then
					Bot:CLICK_XY(500, 450) --If we are stuck click first cup
				end
				
			else
				--I AM LOST; this code needs work, doesn't always find X button
				lastRan = 0
				local xf, xx, xy = Bot:FIND_IMAGE_WITH_XY("x1.bmp", LostTol)
				repeat
					if Bot:FIND_IMAGE("replay.bmp") or Bot:FIND_IMAGE("mat2_btn.bmp") then
						break
					end
					LostTol = LostTol + 1
					xf, xx, xy = Bot:FIND_IMAGE_WITH_XY("x1.bmp", LostTol)
				until(xf == true or LostTol == 255)
				if xf then
					Bot:CLICK_XY(xx, xy)
					Bot:PRINT(Bot:GET_GUI_WINDOW(), "Clicked X\n", Bot.CONSOLE)
					Bot:WAIT(50)
				else
					if not Bot:FIND_IMAGE("replay.bmp") or Bot:FIND_IMAGE("mat2_btn.bmp") then
						Bot:PRINT(Bot:GET_GUI_WINDOW(), "I'm Lost!\n", Bot.CONSOLE)
					end
				end
				LostTol = 5
			end
		end
	end
	Bot:WAIT(100)
end