helicopter = {}

helicopter.using_heli = {}

local DEBUG = false
local debug_msg = function(message)
	if DEBUG then
		minetest.chat_send_all(message)
		minetest.log("action", message)
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 0.1 then
		timer = 0
		for name,_ in pairs(helicopter.using_heli) do
			debug_msg("processing player '"..name.."'...")
			local player = minetest.get_player_by_name(name)
			local velocity = player:get_player_velocity()
			local ctrl = player:get_player_control()
			if ctrl.jump and velocity.y < 10 then
				player:set_physics_override({speed = 2, jump = 0, gravity = -1.0})
				debug_msg("player '"..name.."' is jumping (vertical velocity is "..velocity.y..")")
			elseif ctrl.sneak and velocity.y > -10 then
				player:set_physics_override({speed = 2, jump = 0, gravity = 1.0})
				debug_msg("player '"..name.."' is sneaking (vertical velocity is "..velocity.y..")")
			else
				if velocity.y > 0.9 then
					player:set_physics_override({speed = 2, jump = 0, gravity = 0.3})
				elseif velocity.y < -0.9 then
					player:set_physics_override({speed = 2, jump = 0, gravity = -0.3})
				else
					if velocity.y > 0.6 then
						player:set_physics_override({speed = 2, jump = 0, gravity = 0.1})
					elseif velocity.y < -0.6 then
						player:set_physics_override({speed = 2, jump = 0, gravity = -0.1})
					else
						if velocity.y > 0 then
							player:set_physics_override({speed = 2, jump = 0, gravity = 0.01})
						elseif velocity.y < 0 then
							player:set_physics_override({speed = 2, jump = 0, gravity = -0.01})
						else
							player:set_physics_override({speed = 2, jump = 0, gravity = 0})
						end
					end
				end
				debug_msg("player '"..name.."' is idle (vertical velocity is "..velocity.y..")")
			end
		end
	end
end)

minetest.register_on_respawnplayer(function(player)
	local playername = player:get_player_name()
	if helicopter.using_heli[playername] then
		player:set_physics_override(helicopter.using_heli[playername])
		helicopter.using_heli[playername] = nil
		if pp and pp.disable then pp.disable[playername] = nil end
	end
end)

minetest.register_craftitem("helicopter:blades",{
	description = "Blades for heli",
	inventory_image = "helicopter_blades.png",
	wield_image = "helicopter_blades.png",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_craftitem("helicopter:cabin",{
	description = "Cabin for heli",
	inventory_image = "helicopter_cabin.png",
	wield_image = "helicopter_cabin.png",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_craftitem("helicopter:heli", {
	description = "Helicopter",
	inventory_image = "helicopter_heli.png",
	wield_image = "helicopter_heli.png",
	wield_scale = {x=1, y=1, z=1},
	liquids_pointable = false,
	on_use = function(itemstack, user, pointed_thing)
	local username = user:get_player_name()
	if helicopter.using_heli[username] then
		minetest.chat_send_player(username, "Heli mode disabled")
		user:set_physics_override(helicopter.using_heli[username])
		helicopter.using_heli[username] = nil
		if pp and pp.disable then pp.disable[username] = nil end
	else
		minetest.chat_send_player(username, "Heli mode enabled")
		helicopter.using_heli[username] = user:get_physics_override()
		if pp and pp.disable then pp.disable[username] = true end
	end
	end
})

minetest.register_craft({
	output = 'helicopter:blades',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'default:stick', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})

minetest.register_craft({
	output = 'helicopter:cabin',
	recipe = {
		{'', 'group:wood', ''},
		{'group:wood', 'default:mese_crystal','default:glass'},
		{'group:wood','group:wood','group:wood'},
	}
})

minetest.register_craft({
	output = 'helicopter:heli',
	recipe = {
		{'', 'helicopter:blades', ''},
		{'helicopter:blades', 'helicopter:cabin',''},
	}
})

