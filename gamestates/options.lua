options = {} --start the gamestate

function options:init()
	
end

function options:enter()
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

function options:update(dt)

end

function options:leave()
	love.filesystem.write("config.conf","")
	for q = 1, #conf do
		love.filesystem.append("config.conf",conf[q].t .. "=" .. tostring(conf[q].v) .. '\n')
	end
end

function options:draw()
	for q = 1, #star do --loop for the stars
		if conf[2].v then
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
	 
	for q = 1, #conf do
		love.graphics.print(conf[q].t .. " = " .. tostring(conf[q].v),150,q*14+40)
	end
end

function options:mousepressed(x,y,button)
	if func.overImg(images[3],x,y) then
		gamestate.switch(title)
		return
	end
	for q = 1, #conf do
		if ((x>6.5*string.len(conf[q].t)+186)and(x<6.5*string.len(conf[q].t)+186+6.5*string.len(tostring(conf[q].v))))and((y>q*12+40)and(y<q*12+60)) then
				if q == 1 or q == 2 or q==5 then
					conf[q].v = not conf[q].v
				end
			return
		end
	end
end