win = {}
function win:enter(current, lvlno)
	level[lvlno+1].l = false
	levelnumber = lvlno
end

function win:keypressed(key)
	if key == " " then
		gamestate.switch(game,levelnumber+1, 1)
	elseif key == "b" then
		gamestate.switch(levels)
	end
end

function win:draw()
	
end