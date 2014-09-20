levels = {} --start the gamestate

function levels:init()
	local levelnum = love.filesystem.getDirectoryItems("levels")
	local e = 1
	level = {}
	for q = 1, #levelnum/5 do
		for w = 1, 5 do
			level[e] = func.addLevel(q,w)
			e = e + 1
		end
	end
	level[1].l = false
end

function levels:enter()
	images = {}
	images[1] = {}
	images[1].i = love.graphics.newImage("images/gui/logo.png")
	images[1].x = 350
	images[1].y = 20
	images[2] = {}
	images[2].x = 100
	images[2].y = 20
	images[2].i = love.graphics.newImage("images/gui/panel.png")
	images[3] = {}
	images[3].x = 336
	images[3].y = 531
	images[3].i = love.graphics.newImage("images/gui/back.png")
end

function levels:draw()
	for q = 1, #star do --loop for the stars
		if conf[2].v then
			star[q] = func.updateStar(star[q], love.timer.getDelta()) --This was placed here to avoid having to loop twice per frame.
		end
		love.graphics.setColor(255,255,255,star[q].a) --set the transparency to the stars 'health'
		love.graphics.draw(star[q].i,star[q].x,star[q].y) --draw the star at the x and y stored in the table for the star.
	end
	love.graphics.setColor(255,255,255,255) --reset the colour to avoid drawing other stuff transparent.
	if conf[1].v then
		titleworld:update(love.timer.getDelta()) --update the physics world created on line 4 of the title 
		for q = 1, #garb do --loop for every garbage
			if garb[q].b:getX() < -32 then --if the body is off the left side of the screen
				garb[q].b:setX(832) --move it to the far right
			elseif garb[q].b:getX() > 832 then --likewise, if the body is off the right side of the screen
				garb[q].b:setX(-32) --move it to the left.
			end
			if garb[q].b:getY() < -32 then  --same as above. If the body is off the top
				garb[q].b:setY(632) --move it to the bottom
			elseif  garb[q].b:getY() > 632 then --if it is off the bottom
				garb[q].b:setY(-32) --move it to the top.
			end --I put this in the draw function instead of the update function because I wanted to avoid having to loop through the garb table twice per frame.
			love.graphics.draw(garb[q].i, garb[q].b:getPosition()) --draw the image stored in the "i" field at the position of the body.
		end
	end
	
	for q = 1, #images do --for all the images
		love.graphics.draw(images[q].i,images[q].x,images[q].y) --draw them at the x and y stored in their table
	end
	 
	for q = 1, #level do
		love.graphics.draw(level[q].i,level[q].x,level[q].y)
		if level[q].l then
			love.graphics.draw(love.graphics.newImage("images/gui/locked.png"),level[q].x,level[q].y)
		end
	end
end

function levels:mousepressed(x,y,button)
	if func.overImg(images[3],x,y) then
		gamestate.switch(title)
		return
	end
	for q = 1, #level do
		if func.overImg(level[q],x,y) and not level[q].l then
			TEsound.stop("titlesound") --stop all the title sounds
			TEsound.stop("gamesound") --stop all the title sounds
			TEsound.play("music/background/game.wav",{"backgroundmusic","gamesound"},1,1,function () TEsound.playLooping("music/background/gameloop.wav",{"backgroundmusic","gamesound"}) end) --play the intro and then the loop.
			gamestate.switch(game, q, 1)
			return
		end
	end
end