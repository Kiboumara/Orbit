title = {} --initialise the gamestate

function title:init() --called when the gamestate is first entered
	gameworld = love.physics.newWorld() --create a new world
	titleworld = love.physics.newWorld() --create the world
	garb = {} --start the table that will hold all the garbage
	for q = 1, love.math.random(20,30) do --loop a random number of times between 20 and 30
		garb[q] = func.addGarbage() --add a garbage to the table we just started
	end
	star = {}
	for q = 1, love.math.random(100,120) do
		star[q] = func.addStar()
	end
	w = 1
	conf = {}
	for q in love.filesystem.lines("config.conf") do
		e = string.find(q,'=')
		conf[w] = {}
		conf[w].t = string.sub(q,0,e-1)
		conf[w].v = func.toBoolean(string.sub(q,e+1))
		w = w + 1
	end
	musicstarted = false
	TEsound.play("music/background/menu.wav",{"backgroundmusic","titlesound"},1,1,function () TEsound.playLooping("music/background/menuloop.wav",{"backgroundmusic","titlesound"});musicstarted = true;end)
end

function title:enter() --called when the gamestate is entered
	images = {}
	images[1] = {}
	images[1].i = love.graphics.newImage("images/gui/logo.png")
	images[1].x = 350
	images[1].y = 20
	images[2] = {}
	images[2].x = 5
	images[2].y = 531
	images[2].i = love.graphics.newImage("images/gui/conf.png")
	images[3] = {}
	images[3].x = 667
	images[3].y = 531
	images[3].i = love.graphics.newImage("images/gui/levels.png")
end

function title:update(dt) --called every frame (dt is the time since the last call in seconds)
	
end

function title:draw() --called every frame
	for q = 1, #star do --loop for the stars
		if conf[2].v and musicstarted then
			star[q] = func.updateStar(star[q], love.timer.getDelta()) --This was placed here to avoid having to loop twice per frame.
		end
		love.graphics.setColor(255,255,255,star[q].a) --set the transparency to the stars 'health'
		love.graphics.draw(star[q].i,star[q].x,star[q].y) --draw the star at the x and y stored in the table for the star.
	end
	love.graphics.setColor(255,255,255,255) --reset the colour to avoid drawing other stuff transparent.
	if conf[1].v then
		titleworld:update(love.timer.getDelta()) --update the physics world created on line 4
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
end

function title:mousepressed(x,y,button) --called when the mouse is (x is the x cord of the mouse, y is the y cord, button is the button that was pressed)
	if func.overImg(images[2],x,y) then
		gamestate.switch(options)
		return
	elseif func.overImg(images[3],x,y) then
		gamestate.switch(levels)
		return
	end
end