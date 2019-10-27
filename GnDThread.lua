function main()
	--Read gold amount
	local hwnd = Bot:GET_WINDOW()
	local hdc = Misc:GET_HDC(hwnd)
	hdc = Misc:CROP_HDC(hdc, 130, 30, 15, 0)
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(139, 124, 37), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(125, 112, 39), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(229,199, 28), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(167, 148, 34), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(224, 195, 28), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(210,184, 29), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(178, 156, 33), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(243, 211, 26), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(243, 178, 26), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(216, 160, 29), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(165, 126, 34), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(215, 159, 29), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(232, 170, 27), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(214, 159, 29), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(146, 113, 36), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(236, 173, 27), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(240, 176, 26), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(194, 145, 31), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_COLOR(hdc, Misc:GET_COLOR(175, 132, 33), Misc:GET_COLOR(255, 0, 0))
	Misc:REPLACE_ALL_COLORS_EXCEPT(hdc, Misc:GET_COLOR(255, 0, 0), Misc:GET_COLOR(0, 0, 0))
	Misc:SAVE_HDC(hdc, "gold")
	Bot:WAIT(25)
	Gold = Misc:READ_IMAGE_TEXT("gold", "gc")
	Gold = Gold:gsub("%\n", "")
	Gold = Gold:gsub("%.", ",")
	Bot:PRINT(Bot:GET_GUI_WINDOW(), Gold, Bot.CONSOLE)
	Bot:SET_CONTROL_TEXT(70001, "Gold: " .. Gold)
	Bot:WAIT(5000)
end