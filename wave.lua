Wave = Object:extend()

function Wave:new(waveNum, numAnts, numFalcons, numSquirrels, numIce, numRock, numPowerUps, numKillsToClear)
	--coordinates/attributes
	self.waveNum = waveNum
	self.numAnts = numAnts
	self.numFalcons = numFalcons
	self.numSquirrels = numSquirrels
	self.numIce = numIce
	self.numRock = numRock
	self.numPowerUps = numPowerUps
	self.numKillsToClear = numKillsToClear
end