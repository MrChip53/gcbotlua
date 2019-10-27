function array_size(array)
	local size = 0

	for k,v in pairs(resultTable) do
		size = size + 1
	end

	return size
end

function create_array(dataString)
	local firstArray = split_string(dataString, ";")
	--local firstSize = array_size(firstArray)

	local newArray = {}

	for key,value in pairs(firstArray) do
		local secondArray = split_string(value, "|")
		newArray[key] = {}
		newArray[key][1] = secondArray[1]
		newArray[key][2] = secondArray[2]
	end

	return newArray
end

function correct_direction(mainCup, cup) -- 1 = NORTH/EAST, 2 = SOUTH/WEST
	if mainCup[5] == 2 then
		if (mainCup[1] - tonumber(cup[1]) > 0) then
			return true
		else
			return false
		end
	elseif mainCup[5] == 1 then
		if (mainCup[1] - tonumber(cup[1]) < 0) then
			return true
		else
			return false
		end
	elseif mainCup[5] == 0 then
		if mainCup[1] == tonumber(cup[1]) and mainCup[2] == tonumber(cup[2]) then
			return true
		end
	end
	return false
end
