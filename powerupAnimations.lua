--[[

The MIT License (MIT)

Copyright (c) 2013 Patrick Rabier

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

--
-- LOVE2D ANIMATION
--

--
-- This file will be loaded through love.filesystem.load
-- This file describes the different states and frames of the animation
--

--[[

	Each sprite sheet contains one or multiple states
	Each states is represented as a line in the image file
	The following object describes the different states
	Switching between different states can be done through code

	members ->
		imageSrc : path to the image (png, tga, bmp or jpg)
		defaultState : the first state
		states : a table containing each state

	(State)
	Each state contains the following members ->
		frameCount : the number of frames in the state
		offsetX : starting from the left, the position (in px) of the first frame of the state (aka on the line)
		offsetY : starting from the top, the position of the line (px)
		framwW : the width of each frame in the state
		frameH : the height of each frame in the state
		nextState : the state which will follow after the last frame is reached
		switchDelay : the time between each frame (seconds as floating point)

]]

-- the return statement is mandatory
return {
	imageSrc = "sprites/power-ups.png",
	defaultState = "pspd",
	states = {
		-- 1st line
		pspd = { -- the name of the state is arbitrary
			frameCount = 2,
			offsetX = 0,
			offsetY = 0,
			frameW = 20,
			frameH = 24,
			nextState = "pspd",
			switchDelay = 0.25
		},
		spd = { -- the name of the state is arbitrary
			frameCount = 2,
			offsetX = 0,
			offsetY = 24*1,
			frameW = 20,
			frameH = 24,
			nextState = "spd",
			switchDelay = 0.25
		},
		dmg = { -- the name of the state is arbitrary
			frameCount = 2,
			offsetX = 0,
			offsetY = 24*2,
			frameW = 20,
			frameH = 24,
			nextState = "dmg",
			switchDelay = 0.25
		},
		rad = { -- the name of the state is arbitrary
			frameCount = 2,
			offsetX = 0,
			offsetY = 24*3,
			frameW = 20,
			frameH = 24,
			nextState = "rad",
			switchDelay = 0.25
		}
	}
}