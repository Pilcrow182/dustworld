schemsave.marker1 = {}
schemsave.marker2 = {}

--marks schemsave region position 1
schemsave.mark_spos1 = function(name)
	local pos = schemsave.spos1[name]
	if schemsave.marker1[name] ~= nil then --marker already exists
		schemsave.marker1[name]:remove() --remove marker
		schemsave.marker1[name] = nil
	end
	if pos ~= nil then --add marker
		schemsave.marker1[name] = minetest.env:add_entity(pos, "schemsave:spos1")
		schemsave.marker1[name]:get_luaentity().active = true
	end
end

--marks schemsave region position 2
schemsave.mark_spos2 = function(name)
	local pos = schemsave.spos2[name]
	if schemsave.marker2[name] ~= nil then --marker already exists
		schemsave.marker2[name]:remove() --remove marker
		schemsave.marker2[name] = nil
	end
	if pos ~= nil then --add marker
		schemsave.marker2[name] = minetest.env:add_entity(pos, "schemsave:spos2")
		schemsave.marker2[name]:get_luaentity().active = true
	end
end

minetest.register_entity(":schemsave:spos1", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.1, y=1.1},
		textures = {"schemsave_spos1.png", "schemsave_spos1.png",
			"schemsave_spos1.png", "schemsave_spos1.png",
			"schemsave_spos1.png", "schemsave_spos1.png"},
		collisionbox = {-0.55, -0.55, -0.55, 0.55, 0.55, 0.55},
	},
	on_step = function(self, dtime)
		if self.active == nil then
			self.object:remove()
		end
	end,
	on_punch = function(self, hitter)
		self.object:remove()
		local name = hitter:get_player_name()
		schemsave.marker1[name] = nil
	end,
})

minetest.register_entity(":schemsave:spos2", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.1, y=1.1},
		textures = {"schemsave_spos2.png", "schemsave_spos2.png",
			"schemsave_spos2.png", "schemsave_spos2.png",
			"schemsave_spos2.png", "schemsave_spos2.png"},
		collisionbox = {-0.55, -0.55, -0.55, 0.55, 0.55, 0.55},
	},
	on_step = function(self, dtime)
		if self.active == nil then
			self.object:remove()
		end
	end,
	on_punch = function(self, hitter)
		self.object:remove()
		local name = hitter:get_player_name()
		schemsave.marker2[name] = nil
	end,
})
