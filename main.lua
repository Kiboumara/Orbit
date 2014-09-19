gamestate = require 'libraries/gamestate' --add the gamestate library
AnAL = require 'libraries/AnAL' --add the animations library
require 'libraries/TEsound' --add the sound library

require 'gamestates/title' --add the title file
require 'gamestates/options' --add the options file
require 'gamestates/levels' --add the levels file
require 'gamestates/game' --add the game file
require 'gamestates/win' --add the win file

require 'utility/func'--add the functions file

function love.load() --called when the game is started
	gamestate.switch(title) --start the title
	love.graphics.setFont(love.graphics.newFont("files/Consolas.ttf", 12))
end

function love.update(dt) --called every frame
	TEsound.cleanup() --sound stuff
	gamestate.update(dt) --call the same function in the current gamestate.
end

function love.draw() --called every frame
	gamestate.draw() --call the same function in the current gamestate.
end

function love.keypressed(key) --called when a key is pressed (key is the key pressed)
	gamestate.keypressed(key) --call the same function in the current gamestate.
end

function love.mousepressed(x,y,button) --called when a mouse button is pressed( x and y are the coordinates of the mouse, button is the button pressed)
	gamestate.mousepressed(x,y,button) --call the same function in the current gamestate.
end

function love.keyreleased(key) --called when a key is released (key is the key released)
	gamestate.keyreleased(key) --call the same function in the current gamestate.
end

function love.mousereleased(x,y,button) --called when a mouse button is released( x and y are the coordinates of the mouse, button is the button released)
	gamestate.mousereleased(x,y,button) --call the same function in the current gamestate.
end