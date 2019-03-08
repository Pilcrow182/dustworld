--[[

  Flying Saucer vehicle ('flying_saucer') mod for Minetest

  Copyright (C) 2018 Pilcrow182

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

flying_saucer = {}

flying_saucer.delay = tonumber(minetest.settings:get("flying_saucer_delay") or 0.2)
minetest.settings:set("flying_saucer_delay", flying_saucer.delay)

flying_saucer.speed = tonumber(minetest.settings:get("flying_saucer_speed") or 10)
minetest.settings:set("flying_saucer_speed", flying_saucer.speed)

flying_saucer.passive_stop = minetest.settings:get_bool("flying_saucer_passive_stop", false)
minetest.settings:set_bool("flying_saucer_passive_stop", flying_saucer.passive_stop)

flying_saucer.storage = {}

local DEBUG = false
local debug_msg = function(message)
	if DEBUG then
		minetest.chat_send_all(message)
		minetest.log("action", message)
	end
end

local bubble_tiles = (DEBUG and {"flying_saucer_bubble.png"}) or nil
local bubble_drawtype = (DEBUG and "allfaces_optional") or "airlike"
minetest.register_node("flying_saucer:bubble", {
	description = "Climbable Air",
	inventory_image = "flying_saucer_bubble.png",
	wield_image = "flying_saucer_bubble.png",
	tiles = bubble_tiles,
	drawtype = bubble_drawtype,
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	climbable = true,
	pointable = false,
	diggable = false,
	buildable_to = true,
	floodable = true,
	air_equivalent = true,
	drop = "",
	groups = {not_in_creative_inventory=1},
})

local activate_flying_saucer = function(player, name)
	minetest.chat_send_player(name, "Saucer mode enabled")
	flying_saucer.storage[name] = {}
	flying_saucer.storage[name].physics = player:get_physics_override()
	flying_saucer.storage[name].properties = player:get_properties()
	player:set_physics_override({speed = flying_saucer.speed/4, jump = 0, gravity = 0, sneak = false, sneak_glitch = false})
	player:set_properties({
		visual_size = {x = 1, y = 1},
		visual = "mesh",
		mesh = "flying_saucer.x",
		textures = {"flying_saucer.png"},
		collisionbox = {-1.49,  0.00, -1.49,  1.49, 1.98,  1.49},
	})
	if pp and pp.disable then pp.disable[name] = true end
end

local deactivate_flying_saucer = function(player, name)
	minetest.chat_send_player(name, "Saucer mode disabled")
	player:set_physics_override(flying_saucer.storage[name].physics)
	player:set_properties(flying_saucer.storage[name].properties)
	flying_saucer.storage[name] = nil
	if pp and pp.disable then pp.disable[name] = nil end
end

local stopping_player = ""
minetest.register_entity("flying_saucer:stopper_entity", {
	textures = {"flying_saucer_stopper.png"},
	collisionbox = {0,0,0,0,0,0},
	is_visible = true,
	makes_footstep_sound = false,
	on_activate = function(self, staticdata)
		local player = minetest.get_player_by_name(stopping_player)
		if not player then return end
		flying_saucer.storage[stopping_player].state = "idle"
		player:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=-player:get_look_horizontal()*180/math.pi,z=0})
		minetest.after(0.2, function(obj) obj:remove() end, self.object)
	end,
})

local bubble = {size = {x = 7, y = 9, z = 7}, data = {}}
for x = 1, bubble.size.x do
	for y = 1, bubble.size.y do
		for z = 1, bubble.size.z do
			table.insert(bubble.data, { name = "flying_saucer:bubble" })
		end
	end
end

local remove_bubble = function(schempos, delay)
	debug_msg("removing bubble at "..minetest.pos_to_string(schempos))
	for xoff = 0, bubble.size.x-1 do
		for yoff = 0, bubble.size.y-1 do
			for zoff = 0, bubble.size.z-1 do
				minetest.after(delay, function(schempos, xoff, yoff, zoff)
					local nodepos = {x = schempos.x + xoff, y = schempos.y + yoff, z = schempos.z + zoff}
					local node = minetest.get_node(nodepos)
					if node and node.name and node.name == "flying_saucer:bubble" then minetest.remove_node(nodepos) end
				end, schempos, xoff, yoff, zoff)
			end
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	local delay = flying_saucer.delay
	timer = timer + dtime
	if timer >= delay then
		timer = 0
		for name,_ in pairs(flying_saucer.storage) do
			local player = minetest.get_player_by_name(name)
			if player then
				local pos = player:get_pos()
				local ctrl = player:get_player_control()
				local velocity = player:get_player_velocity()
				local physics = player:get_physics_override()
				local schempos = {x = pos.x - (bubble.size.x-1)/2, y = pos.y - (bubble.size.y-1)/2, z = pos.z - (bubble.size.z-1)/2}

				local state = flying_saucer.storage[name].state or "idle"
				debug_msg("player '"..name.."' is "..state.." (physics="..minetest.pos_to_string({x=physics.speed, y=physics.jump,z=physics.gravity})..", velocity="..minetest.pos_to_string(velocity)..")...")

				if velocity.y < -flying_saucer.speed then
					minetest.chat_send_player(name, "Flying Saucer to "..name..": unsafe speeds detected; halting vertical movement.")
					stopping_player = name
					minetest.add_entity(player:get_pos(), "flying_saucer:stopper_entity")
				elseif ((velocity.y ~= 0 and (ctrl.aux1 or flying_saucer.passive_stop)) or (velocity.y == 0 and flying_saucer.storage[name].state ~= "idle")) and not (ctrl.jump or ctrl.sneak) then
					flying_saucer.storage[name].state = "idle"
					minetest.place_schematic(schempos, bubble, 0, nil, false)
					remove_bubble(schempos, delay)
				elseif ctrl.jump and (flying_saucer.storage[name].state ~= "ascending" or velocity.y < flying_saucer.speed*0.75) and not ctrl.sneak then
					flying_saucer.storage[name].state = "ascending"
					minetest.place_schematic(schempos, bubble, 0, nil, false)
					remove_bubble(schempos, delay)
				elseif ctrl.sneak and (flying_saucer.storage[name].state ~= "descending" or velocity.y > -flying_saucer.speed*0.75) then
					flying_saucer.storage[name].state = "descending"
					minetest.place_schematic(schempos, bubble, 0, nil, false)
					remove_bubble(schempos, delay)
				end
			end
		end
	end
end)

minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	if flying_saucer.storage[name] and flying_saucer.storage[name].physics then
		deactivate_flying_saucer(player, name)
	end
end)

minetest.register_craftitem("flying_saucer:saucer", {
	description = "Flying saucer",
	inventory_image = "flying_saucer_saucer.png",
	wield_image = "flying_saucer_saucer.png",
	wield_scale = {x=1, y=1, z=1},
	liquids_pointable = false,
	on_use = function(itemstack, user, pointed_thing)
		local username = user:get_player_name()
		if flying_saucer.storage[username] then
			deactivate_flying_saucer(user, username)
		else
			activate_flying_saucer(user, username)
		end
	end
})

minetest.register_craft({
	output = "flying_saucer:saucer",
	recipe = {
		{"", "default:diamondblock", ""},
		{"default:copperblock", "default:steelblock","default:copperblock"},
	}
})

minetest.register_abm{
        label = "bubble cleanup",
	nodenames = {"flying_saucer:bubble"},
	interval = 2,
	chance = 1,
	action = function(pos)
		local despawn = true
		for _,obj in ipairs(minetest.get_objects_inside_radius(pos, (math.max(bubble.size.x, bubble.size.y, bubble.size.z)-1)/2)) do
			if obj:is_player() and flying_saucer.storage[obj:get_player_name()] then despawn = false end
		end
		if despawn then minetest.remove_node(pos) end
	end
}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/compat.lua")

