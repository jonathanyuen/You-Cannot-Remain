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
	imageSrc = "sprites/deathScreenAnimations.png",
	defaultState = "splatSkeletonReveal",
	states = {
		-- 1st line
		splatSkeletonReveal = { -- the name of the state is arbitrary
			frameCount = 12,
			offsetX = 0,
			offsetY = 0,
			frameW = 320,
			frameH = 180,
			switchDelay = 0.1
		},
		gameOverFadeIn = { -- the name of the state is arbitrary
			frameCount = 3,
			offsetX = 0,
			offsetY = 180,
			frameW = 320,
			frameH = 180,
			switchDelay = 0.1
		},
		gameOverFadeOut = { -- the name of the state is arbitrary
			frameCount = 4,
			offsetX = 0,
			offsetY = 360,
			frameW = 320,
			frameH = 180,
			switchDelay = 0.1
		},
		mantra1 = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 540,
			frameW = 320,
			frameH = 180,
			nextState = "mantra2",
			switchDelay = 2
		},
		mantra2 = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 720,
			frameW = 320,
			frameH = 180,
			nextState = "mantra3",
			switchDelay = 2
		},
		mantra3 = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 900,
			frameW = 320,
			frameH = 180,
			nextState = "mantraHighlight",
			switchDelay = 2
		},
		mantraHighlight = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 1080,
			frameW = 320,
			frameH = 180,
			nextState = "black",
			switchDelay = 2
		},
		black = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 1260,
			frameW = 320,
			frameH = 180,
			nextState = "you",
			switchDelay = 2
		},
		you = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 1440,
			frameW = 320,
			frameH = 180,
			nextState = "cannot",
			switchDelay = 1.5
		},
		cannot = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 1620,
			frameW = 320,
			frameH = 180,
			nextState = "remain",
			switchDelay = 1.5
		},
		remain = { -- the name of the state is arbitrary
			frameCount = 1,
			offsetX = 0,
			offsetY = 1800,
			frameW = 320,
			frameH = 180,
			switchDelay = 4
		}
	}
}