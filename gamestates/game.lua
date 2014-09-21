game = {} --start the gamestate
function game:enter(current, lvlno, try)
	gameworld:destroy()
	gameworld = love.physics.newWorld() --create a new world
	TEsound.stop("voice") --stop all the voice sounds
	lvldata = "levels/" .. lvlno .. ".level" --load the level file
	q = 1 --set the line to 1
	obj = {} --start the object table
	obj.ball = {} --create the ball table
	obj.spacewall = {} --create the spacewall table
	obj.exit = {} --create the exit table
	obj.well = {} --create the well table
	obj.cheat = {} --create the well table
	while func.readFileLine(q, lvldata) ~= nil do --while there are still lines
		line = func.readFileLine(q, lvldata) --load the line
		
		if line == "exit" then --if the line starts an exit block
			block, q = func.loadBlock(2, q, lvldata) --load the block into the meta table
			obj.exit[#obj.exit+1] = func.addExit(block[1],block[2]) --add the exit
			
		elseif line == "well" then --if the line starts a well block
			block, q = func.loadBlock(4, q, lvldata) --load the block into the meta table
			obj.well[#obj.well+1] = func.addWell(block[1],block[2],block[3],block[4]) --add the well
			
		elseif line == "ball" then --if the line starts a ball block
			block, q = func.loadBlock(3, q, lvldata) --load the block into the meta table
			obj.ball[#obj.ball+1] = func.addBall(block[1],block[2],block[3]) --add the ball
			
		elseif line == "spacewall" then --if the line starts a spacewall block
			block, q = func.loadBlock(2, q, lvldata) --load the block into the meta table
			obj.spacewall[#obj.spacewall+1] = func.addSpacewall(block[1],block[2]) --add the spacewall
			
		elseif line == "cheat" then --if the line starts a spacewall block
			block, q = func.loadBlock(4, q, lvldata) --load the block into the meta table
			obj.cheat[#obj.cheat+1] = func.addCheat(block[1],block[2],block[3],block[4]) --add the spacewall
			
		else --if the line has nothing interesting on it
			q = q + 1 --move to the next line
		end
	end
	meta = {} --create the meta table
	meta.levelnum = lvlno --remember the level number
	meta.paused = false --set the state to not paused
	meta.try = try --load the number of tries so far
	w = 1 --counter = 1
	meta.lines = {} --start the table
	for q in love.filesystem.lines("files/speech.orbit") do --for all the lines of speech
		meta.lines[w] = q --record them
		w = w + 1 --increment the counter
	end
	meta.linenum = 1 --set the line number to 1
	meta.canspeak = true --let the game speak
	meta.voicegoing = false --record that there is nobody speaking
end

function game:draw()
	if not meta.paused then
		gameworld:update(love.timer.getDelta()) --update the game world
	end
	
	for q = 1, #star do --loop for the stars
		if conf[2].v then --if dynamic stars are on
			star[q] = func.updateStar(star[q], love.timer.getDelta())--update the star
		end
		love.graphics.setColor(255,255,255,star[q].a) --set the transparency to the stars 'health'
		love.graphics.draw(star[q].i,star[q].x,star[q].y) --draw the star at the x and y stored in the table for the star.
	end
	love.graphics.setColor(255,255,255,255)
	for q = 1, #obj.well do --for all the wells
		if ((love.mouse.getX()>obj.well[q].b:getX()-8)and(love.mouse.getX()<obj.well[q].b:getX()-8+16))and((love.mouse.getY()>obj.well[q].b:getY()-8)and(love.mouse.getY()<obj.well[q].b:getY()-8+16)) then --if the mouse is over the well
			love.graphics.setColor(255,255,255,100)
			love.graphics.circle("fill",obj.well[q].b:getX(),obj.well[q].b:getY(),obj.well[q].r) --draw the region of influence
		end
		love.graphics.setColor(255,255,255,255) --set the colour to opaque
		obj.well[q].i:update(love.timer.getDelta()) --update the well animation
		obj.well[q].i:draw(obj.well[q].b:getX()-8,obj.well[q].b:getY()-8) --draw the well
	end
	
	for q = 1, #obj.ball do --for all the balls
		obj.ball[q].i:update(love.timer.getDelta()) --update the animation
		obj.ball[q].i:draw(obj.ball[q].b:getX()-8,obj.ball[q].b:getY()-8) --draw it
		
		for w = 1, #obj.exit do --for all the exits
			if math.sqrt((obj.ball[q].b:getX()-(obj.exit[w].x+64))^2+(obj.ball[q].b:getY()-(obj.exit[w].y+64))^2) < 64 then --if the ball overlaps the exit
				gamestate.switch(win, meta.levelnum) --switch to the win gamestate
				return --end the draw function here
			end
		end
		
		if (obj.ball[q].b:getX()+8<0 or obj.ball[q].b:getX()-8>800 or obj.ball[q].b:getY()+8<0 or obj.ball[q].b:getY()-8>600) and meta.canspeak then --if the ball is outside the window and this is the first time it has happened
			meta.linenum = love.math.random(1,3) --pick a random line
			meta.voicegoing = true --remember to write the line
			meta.canspeak = false --stop the game from speaking
			TEsound.play("music/speech/outofbounds" .. meta.linenum .. ".mp3",{"voice","gamesound"},1,1, function()meta.canspeak=true;meta.voicegoing=false;end) --play the out of bounds sound and then let the game speak
			return
		end
		for w = 1, #obj.well do
			if math.sqrt((obj.ball[q].b:getX()-obj.well[w].b:getX())^2+(obj.ball[q].b:getY()-obj.well[w].b:getY())^2) < obj.well[w].r then --if the ball is in the area of influence
				local m1 = obj.well[w].m --record m1
				local m2 = obj.ball[q].m --record m2
				local xd = obj.well[w].b:getX()-obj.ball[q].b:getX() --record the x distance
				local yd = obj.well[w].b:getY()-obj.ball[q].b:getY() --record the y distance
				local a = math.atan2(xd,yd)*108/math.pi --record the angle
				local dist = love.physics.getDistance(obj.well[w].f,obj.ball[q].f) --record the direct distance
				local f = ((m1+m2)/dist^2) --calculate the force using newtons law of gravity.
				local xsign = 1 --set the y sign to 1
				local ysign = 1 --set the y sign to 1
				if xd < 0 then --if we are to the right of the well
					xsign = -1 --flip the sign so that it is pushed left
				end
				if yd < 0 then --if we are below the well
					ysign = -1 --flip the force to push up
				end
				if f > 30 then --if the force is larger than 30
					f = 30 --stop it at 30
				end
				obj.ball[q].b:applyForce((f*(90-math.cos(a)))*xsign,(f*(90-math.sin(a)))*ysign) --split the force into x and y components and apply the force to the ball
			end
		end
	end
	
	for q = 1, #obj.spacewall do --for all the spacewalls
		obj.spacewall[q].i:update(love.timer.getDelta()) --update the animation
		obj.spacewall[q].i:draw(obj.spacewall[q].b:getX()-16,obj.spacewall[q].b:getY()-16) --draw it
	end
	
	for q = 1, #obj.exit do --for all the exits
		obj.exit[q].i:update(love.timer.getDelta()) --update the animation
		obj.exit[q].i:draw(obj.exit[q].x, obj.exit[q].y) --draw it
	end
	
	if meta.mousepressed then --if a ball is being dragged
		love.graphics.line(love.mouse.getX(),love.mouse.getY(),obj.ball[meta.ballno].b:getX(),obj.ball[meta.ballno].b:getY()) --draw a visual representation of the amount
	end
	
	love.graphics.draw(love.graphics.newImage("images/gui/window.png"))
	love.graphics.print("Level " .. meta.levelnum, 12,12) --write the current level
	love.graphics.print("Try " .. meta.try, 70, 12) --write the current level
	if meta.voicegoing then
		love.graphics.printf(meta.lines[meta.linenum],12,24,96) --print the line
	end
	if conf[5].v then --is cheats are on
		for q = 1, #obj.cheat do --for all the guidelines
			love.graphics.line(obj.cheat[q].x1, obj.cheat[q].y1, obj.cheat[q].x2, obj.cheat[q].y2) --draw the guideline
		end
	end
	
end

function game:mousepressed(x,y,button) --if the mouse is pressed
	for q = 1, #obj.ball do --for all the balls
		if obj.ball[q].v then --if the ball has not already been moved
			if ((x>obj.ball[q].b:getX()-8)and(x<obj.ball[q].b:getX()-8+16))and((y>obj.ball[q].b:getY()-8)and(y<obj.ball[q].b:getY()-8+16)) then --if the mouse is over the ball
				meta.mousepressed = true --tell the game the ball is being moved
				meta.ballno = q --remember the ball number
				obj.ball[q].v = false --stop the ball form moving again
				return
			end
		end
	end
	for q = 1, #obj.spacewall do
		if ((x > obj.spacewall[q].b:getX()-16)and(x<obj.spacewall[q].b:getX() + 16))and((y>obj.spacewall[q].b:getY()-16)and(y<obj.spacewall[q].b:getY()+16))then
			obj.well[#obj.well+1] = func.addWell(x,y,30100,200)
		end
	end
end

function game:mousereleased(x,y,button) --if the mouse is released
	if meta.mousepressed then --if a ball is being moved
		obj.ball[meta.ballno].b:applyLinearImpulse(obj.ball[meta.ballno].b:getX()-x,obj.ball[meta.ballno].b:getY()-y) --push it an amount based on how far the mouse was dragged
		meta.mousepressed = false --tell the game we have stopped moving the ball
	end
end

function game:keypressed(key)
	if key == 'r' then
		gamestate.switch(game,meta.levelnum, meta.try + 1, meta.voicegoing, linenum)
	elseif key == 'p' then
		meta.paused = not meta.paused
	end
end