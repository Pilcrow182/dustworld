--[[

  Alternative falling nodes ('shifting') mod for Minetest

  Copyright (C) 2019 Pilcrow182

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY
  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
  OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

]]--

shifting = {}

shifting.speed = tonumber(minetest.settings:get("falling_node_speed") or 5)
minetest.settings:set("falling_node_speed", shifting.speed)

shifting.disable_entity = minetest.settings:get_bool("disable_falling_node_animation", false)
minetest.settings:set_bool("disable_falling_node_animation", shifting.disable_entity)

minetest.register_entity("shifting:entity", {
	initial_properties = {
		visual = "wielditem",
		visual_size = {x = 0.667, y = 0.667},
		textures = {},
		physical = true,
		is_visible = false,
		collide_with_objects = true,
		collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	},

	lifespan = nil,

	set_details = function(self, node_name, lifespan)
		self.object:set_properties({
			is_visible = true,
			textures = {node_name},
		})
		self.object:setvelocity({x = 0, y = -2, z = 0})
		self.lifespan = lifespan
	end,

	on_activate = function(self, staticdata)
		self.object:set_armor_groups({immortal = 1})
	end,

	life = 0,

	on_step = function(self, dtime)
		local velocity = self.object:getvelocity()
		if velocity.y ~= -shifting.speed then
			velocity.y = -shifting.speed
			self.object:setvelocity(velocity)
		end

		self.life = self.life + dtime
		self.lifespan = self.lifespan or 0
		if self.life >= self.lifespan then
			self.object:remove()
			return
		end
	end
})

shifting.reserve = {}
shifting.start_fall = function(pos)
	local node = minetest.get_node(pos)
	if not ( node and node.name and minetest.get_item_group(node.name, "falling_node") > 0 ) then return end

	local distance = 1
	local checkpos = {x = pos.x, y = pos.y - distance, z = pos.z}
	local checknode = minetest.get_node(checkpos)
	local checkstr = minetest.pos_to_string(checkpos)
	while ( shifting.queue[checkstr] or ( checknode and checknode.name and checknode.name == "air" ) ) and not shifting.reserve[checkstr] do
		distance = distance + 1
		checkpos.y = pos.y - distance
		checknode = minetest.get_node(checkpos)
		checkstr = minetest.pos_to_string(checkpos)
	end
	distance = distance - 1
	if distance <= 0 then return end

	local underpos = {x = pos.x, y = pos.y - distance, z = pos.z}
	local undernode = minetest.get_node(underpos)

	local destpos = {x = pos.x, y = pos.y - distance, z = pos.z}
	local deststr = minetest.pos_to_string(destpos)
	local lifespan = distance / shifting.speed

	if not shifting.disable_entity then
		local entity = minetest.add_entity(pos, "shifting:entity")
		if entity then entity:get_luaentity():set_details(node.name, lifespan) end
	end

	shifting.reserve[deststr] = true
	minetest.remove_node(pos)

	minetest.after(lifespan, function(pos, distance, deststr)
		minetest.set_node(destpos, node)
		shifting.reserve[deststr] = nil
		minetest.check_for_falling(pos)
	end, pos, distance, deststr)
end

shifting.queue = {}
minetest.check_for_falling = function(pos)
	for xoff = -1, 1 do
		for zoff = -1, 1 do
			for yoff = -1, 1 do
				local checkpos = {x = pos.x + xoff, y = pos.y + yoff, z = pos.z + zoff}
				local checknode = minetest.get_node(checkpos)
				local checkstr = minetest.pos_to_string(checkpos)
				if not shifting.queue[checkstr] and checknode and checknode.name and minetest.get_item_group(checknode.name, "falling_node") > 0 then
					shifting.queue[checkstr] = true
					minetest.after(0, function(pos) minetest.check_for_falling(pos) end, checkpos)
				end
			end
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		timer = 0
		if next(shifting.queue) == nil then return end

		local pos, minp, maxp = {}, {}, {}
		for strpos,_ in pairs(shifting.queue) do
			pos = minetest.string_to_pos(strpos)
			if not minp.x or pos.x < minp.x then minp.x = pos.x end
			if not minp.y or pos.y < minp.y then minp.y = pos.y end
			if not minp.z or pos.z < minp.z then minp.z = pos.z end

			if not maxp.x or pos.x > maxp.x then maxp.x = pos.x end
			if not maxp.y or pos.y > maxp.y then maxp.y = pos.y end
			if not maxp.z or pos.z > maxp.z then maxp.z = pos.z end
		end

		local strpos = ""
		for y = minp.y, maxp.y do
			for x = minp.x, maxp.x do
				for z = minp.z, maxp.z do
					strpos = minetest.pos_to_string({x = x, y = y, z = z})
					if shifting.queue[strpos] then
						shifting.queue[strpos] = nil
						shifting.start_fall(minetest.string_to_pos(strpos))
					end
				end
			end
		end
	end
end)

minetest.register_node("shifting:air", {
	drawtype = "airlike",
	paramtype = "light",
	sunlight_permeates = true,
	groups = {not_in_creative_inventory = 1}
})

minetest.register_abm{
	label = "deleteme",
	nodenames = {"shifting:air"},
	interval = 1,
	chance = 1,
	action = function(pos)
		minetest.remove_node(pos)
	end,
}

