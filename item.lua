Item = Object:extend()

function Item:new(id, name, effect, desc, rarity)
	--coordinates/attributes
	self.id = id
	self.name = name
	self.effect = effect
	self.desc = desc
	self.rarity = rarity
	self.proficiency = 0
	self.cost = 0
end

function Item:draw()
	--i imagine this is where you could call this and it would draw the information card?

end