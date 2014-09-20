win = {}
function win:enter(current, lvlno)
	level[lvlno+1].l = false
	levelnumber = lvlno
	
	images = {}
	images[1] = {}
	images[1].i = love.graphics.newImage("images/gui/logo.png")
	images[1].x = 350
	images[1].y = 20
	images[2] = {}
	images[2].x = 5
	images[2].y = 531
	images[2].i = love.graphics.newImage("images/gui/levels.png")
	images[3] = {}
	images[3].x = 667
	images[3].y = 531
	images[3].i = love.graphics.newImage("images/gui/next.png")
	images[4] = {}
	images[4].x = 100
	images[4].y = 20
	images[4].i = love.graphics.newImage("images/gui/panel.png")
	
	text = {}
	text[1] = "Number of attempts: " .. meta.try
end

function win:mousepressed(x,y,button)
	if func.overImg(images[2],x,y) then
		TEsound.stop("titlesound") --stop all the title sounds
		TEsound.stop("gamesound") --stop all the title sounds
		TEsound.play("music/background/menu.wav",{"backgroundmusic","titlesound"},1,1,function () TEsound.playLooping("music/background/menuloop.wav",{"backgroundmusic","titlesound"});musicstarted = true;end)
		gamestate.switch(levels)
		return
	elseif func.overImg(images[3],x,y) then
		gamestate.switch(game,levelnumber+1,1)
		return
	end
end

function win:draw()
	for q = 1, #star do --loop for the stars
		if conf[2].v then --if dynamic stars are on
			star[q] = func.updateStar(star[q], love.timer.getDelta())--update the star
		end
		love.graphics.setColor(255,255,255,star[q].a) --set the transparency to the stars 'health'
		love.graphics.draw(star[q].i,star[q].x,star[q].y) --draw the star at the x and y stored in the table for the star.
	end
	love.graphics.setColor(255,255,255,255)
	
	for q = 1, #images do --for all the images
		love.graphics.draw(images[q].i,images[q].x,images[q].y) --draw them at the x and y stored in their table
	end
	
	for q = 1, #text do
		love.graphics.print(text[1],200,120+20*q)
	end
end