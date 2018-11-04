helicopter = {}

helicopter.using_heli = {}

helicopter.player_state = {}

local debug_msg = function(message)
	minetest.chat_send_all(message)
	minetest.log("action", message)
end

local timer = 0
minetest.register_globalstep(function(dtime)
	for name,_ in pairs(helicopter.using_heli) do
		if not helicopter.player_state[name] then helicopter.player_state[name] = {} end
		helicopter.player_state[name].old = helicopter.player_state[name].current or "idle"
		local ctrl = minetest.get_player_by_name(name):get_player_control()
		local state = "idle"
		if ctrl.jump then
			state = "jumping"
		elseif ctrl.sneak then
			state = "sneaking"
		end
		helicopter.player_state[name].current = state
	end
	timer = timer + dtime
	if timer >= 0.2 then
		timer = 0
		for name,_ in pairs(helicopter.using_heli) do
			local player = minetest.get_player_by_name(name)
			local velocity = player:get_player_velocity()
			local player_state = helicopter.player_state[name].current
			local physics = {speed = 2, jump = 0, gravity = 0}
			if player_state == "jumping" and velocity.y < 8 then
				physics = {speed = 2, jump = 0, gravity = -0.5}
			elseif player_state == "sneaking" and velocity.y > -8 then
				physics = {speed = 2, jump = 0, gravity =  0.5}
-- 			elseif player_state == "idle" and velocity.y > -1 and velocity.y < 1 then
-- 				physics = {speed = 2, jump = 0, gravity = velocity.y/8}
			end
			player:set_physics_override(physics)
-- 			debug_msg("player '"..name.."' is "..player_state.." (physics="..minetest.pos_to_string({x=physics.speed, y=physics.jump,z=physics.gravity})..", velocity="..minetest.pos_to_string(velocity)..")...")
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
		user:set_physics_override({speed = 2, jump = 0, gravity = 0})
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

