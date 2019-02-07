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

local falling_nodes = {
	"default:desert_sand",
	"default:gravel",
	"default:sand",
	"default:silver_sand",
	"default:snow",
	"flolands:floatsand",
	"pyramids:trap_2",
	"snow:snow_block",
	"wasteland:dust"
}

for _,name in pairs(falling_nodes) do
	local node = minetest.registered_nodes[name]
	if node then
		node.groups.falling_node = nil
		node.groups.shifting = 1
		minetest.override_item(name, {groups = node.groups})
	end
end

minetest.register_entity("shifting:entity", {
	initial_properties = {
		visual = "wielditem",
		visual_size = {x = 0.667, y = 0.667},
		textures = {},
		physical = false,
		is_visible = false,
		collide_with_objects = false,
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

shifting.queue = {}
shifting.start_fall = function(pos)
		local node = minetest.get_node(pos)
		if not ( node and node.name and minetest.get_item_group(node.name, "shifting") > 0 ) then return end

		local distance = 1
		local checkpos = {x = pos.x, y = pos.y - distance, z = pos.z}
		local checknode = minetest.get_node(checkpos)
		if not ( checknode and checknode.name and checknode.name == "air" ) then return end
		while checknode and checknode.name and checknode.name == "air" and not shifting.queue[minetest.pos_to_string(checkpos)] do
			distance = distance + 1
			checkpos.y = pos.y - distance
			checknode = minetest.get_node(checkpos)
		end
		distance = distance - 1
		if distance <= 0 then return end

		local q = minetest.pos_to_string({x = pos.x, y = pos.y - distance, z = pos.z})
		local lifespan = distance / shifting.speed

		if not shifting.disable_entity then
			local entity = minetest.add_entity(pos, "shifting:entity")
			if entity then entity:get_luaentity():set_details(node.name, lifespan) end
		end

		shifting.queue[q] = true
		minetest.remove_node(pos)

		minetest.after(lifespan, function(pos, distance, q)
			minetest.set_node({x = pos.x, y = pos.y - distance, z = pos.z}, node)
			shifting.queue[q] = nil
		end, pos, distance, q)

		minetest.check_for_falling(pos)
end

minetest.register_abm{
	label = "shifting",
	nodenames = {"group:shifting"},
	interval = 1,
	chance = 1,
	action = function(pos)
		shifting.start_fall(pos)
	end,
}

