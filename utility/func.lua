func = {}

function func.updateStar(star, dt) --updates the life cycle of the star(star is the star that is to be updated, dt is the time since last call.)
	if star.l == "living" then --if the star is living
		if star.t <= 0 then --if it's lifespan is over
			star.l = "dying" --tell it to die
		else --if it's life span is not over
			star.t = star.t - dt --age it
		end
	elseif star.l == "dying" then --if the star is dying
		if star.a <= 0 then --if it's life is 0
			star.x = love.math.random(0,800) --move it to a random x cord
			star.y = love.math.random(0,600) --move it to a random y cord
			star.l = "growing" --tell it to grow
		else --if it's health is not 0
			star.a = star.a - 5 --kill it more
		end
	elseif star.l == "growing" then --if the star is growing
		if star.a >= 255 then --if it is fully grown
			star.t = (love.math.random()*10)/4 --give it a random lifespan between 0-10
			star.l = "living" --tell it to live
		else --if it is not finished growing
			star.a = star.a + 5 --grow it more.
		end
	end
	return star --return the now updated star
end



function func.overImg(shape,x,y,w,h) --checks whether the point is over the image object given (shape is the table of the shape, x and y are the coordinates being checked)
	if shape.x == nil then
		sx = shape.b:getX()-w
	else
		sx = shape.x
	end
	if shape.y == nil then
		sy = shape.b:getY()-y
	else
		sy = shape.y
	end
	if ((x<sx+shape.i:getWidth())and(x>sx))and((y<sy+shape.i:getHeight())and(y>sy)) then --if the point is within the right side and within the left side and not to high and not to low.
		return true --return true
	else --if the point is not over the shape
		return false --return false
	end
end

function func.toBoolean(con)
	if con == "true" then
		return true
	elseif con == "false" then
		return false
	else
		return con
	end
end

function func.readFileLine(line, file)
	local w = 1 --set the line no to 1
	for q in love.filesystem.lines(file) do --for the number of lines
		if w == line then --if the line number is the same as requested
			return q --return the line
		end
		w = w + 1 --move to the next line
	end
	return nil --return nil
end

function func.loadBlock(length, startline, path)
	local q = {}
	for w = 1, length do --for the blocks length
		startline = startline + 1 --move to the next line
		local linedata = func.readFileLine(startline, path) --load the line
		local e = string.find(linedata,"=") --find the =
		q[w] = string.sub(linedata, e+1) --store everything after the = in the table
	end
	return q, startline
end



function func.addBall(x,y,m)
	local z = {}
	z.b = love.physics.newBody(gameworld, x, y, "dynamic")
	z.s = love.physics.newCircleShape(8)
	z.f = love.physics.newFixture(z.b,z.s)
	z.f:setRestitution(0.9)
	z.i = newAnimation(love.graphics.newImage("images/objects/ball.png"),16,16,0.15,24)
	z.v = true
	z.m = tonumber(m)
	z.f:setCategory(1)
	z.f:setMask(3)
	return z
end

function func.addWell(x,y,m,r)
	local z = {}
	z.b = love.physics.newBody(gameworld, x, y, "static")
	z.s = love.physics.newCircleShape(8)
	z.f = love.physics.newFixture(z.b,z.s)
	z.i = newAnimation(love.graphics.newImage("images/objects/well.png"),16,16,0.15,24)
	z.m = tonumber(m)
	z.r = tonumber(r)
	z.f:setCategory(3)
	z.f:setMask(1)
	return z
end

function func.addSpacewall(x,y)
	local z = {}
	z.b = love.physics.newBody(gameworld, tonumber(x), tonumber(y), "static")
	z.s = love.physics.newRectangleShape(32,32)
	z.f = love.physics.newFixture(z.b,z.s)
	z.i = newAnimation(love.graphics.newImage("images/objects/spacewall.png"),32,32,0.17,9)
	z.i:seek(love.math.random(1, 9))
	z.f:setCategory(2)
	z.f:setMask(2)
	return z
end

function func.addExit(x,y)
	local z = {}
	z.i = newAnimation(love.graphics.newImage("images/objects/exit.png"),128,128,0.17,90)
	z.x = tonumber(x)
	z.y = tonumber(y)
	return z
end

function func.addCheat(x1,y1,x2,y2)
	local z = {}
	z.x1 = x1
	z.y1 = y1
	z.x2 = x2
	z.y2 = y2
	return z
end

function func.addGarbage() --adds a garbage object to the title screen
	local z = {} --start the table
	z.b = love.physics.newBody(titleworld, love.math.random(32, 768), love.math.random(32, 568), "dynamic")--add a dynamic body at a random x and y to the title world
	z.s = love.physics.newCircleShape(16) --add a new circle shape at the same x and y as the body
	z.f = love.physics.newFixture(z.b,z.s, 1) --attach the shape and the body together
	z.f:setRestitution(0.9)
	local xv = love.math.random(5,15) --generate a random x velocity
	if love.math.random(1,2) == 1 then --basically a 50% chance to run the code
		xv = xv * -1 --flip the x velocity
	end
	local yv = love.math.random(5,15) --generate a random y velocity
	if love.math.random(1,2) == 1 then --basically a 50% chance to run the code
		yv = yv * -1 --flip the y velocity
	end
	z.b:applyLinearImpulse(xv, yv) --apply the x and y velocities
	z.i = love.graphics.newImage("images/objects/garbage.png") --add the image
	return z --return the table we just made.
end

function func.addStar() --adds a star
	local z = {} --start the table
	z.i = love.graphics.newImage("images/objects/star" .. love.math.random(1,4) .. ".png") --insert a random image
	z.x = love.math.random(0,800) --place it on a random x cord
	z.y = love.math.random(0,600) --place it on a random y cord
	z.l = "living" --set it's state to 'living'
	z.a = 255 --set it's 'health' to full
	z.t = (love.math.random()*10)/4 --set it's 'lifespan' to a random number of seconds between 0-10
	return z
end

function func.addLevel(x,c)--y,x
	local z = {}
	z.i = love.graphics.newImage("images/gui/level" .. love.math.random(1,3) .. ".png")
	z.x = 100+c*90
	z.y = x*90
	z.l = false
	return z
end
