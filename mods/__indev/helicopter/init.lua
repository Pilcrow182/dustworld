helicopter = {}

helicopter.speed = minetest.settings:get("helicopter_speed") or 8
minetest.settings:set("helicopter_speed", helicopter.speed)

helicopter.passive_stop = minetest.settings:get_bool("helicopter_passive_stop", false)
minetest.settings:set_bool("helicopter_passive_stop", helicopter.passive_stop)

helicopter.using_heli = {}

helicopter.stopped = {}

local debug_msg = function(message)
	minetest.chat_send_all(message)
	minetest.log("action", message)
end

local get_state = function(gravity)
	if gravity < 0 then
		return "jumping"
	elseif gravity > 0 then
		return "sneaking"
	else
		return "idle"
	end
end

local stopping_player = ""
minetest.register_entity("helicopter:stopper_entity", {
	textures = {"helicopter_stopper_entity.png"},
	collisionbox = {0,0,0,0,0,0},
	is_visible = true,
	makes_footstep_sound = false,
	on_activate = function(self, staticdata)
		local player = minetest.get_player_by_name(stopping_player)
		if not player then return end
		helicopter.stopped[stopping_player] = true
		player:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=-player:get_look_horizontal()*180/math.pi,z=0})
		minetest.after(0.2, function(obj) obj:remove() end, self.object)
	end,
})

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 0.2 then
		timer = 0
		for name,_ in pairs(helicopter.using_heli) do
			local player = minetest.get_player_by_name(name)
			if player then
				local ctrl = player:get_player_control()
				local velocity = player:get_player_velocity()
				local heli_speed = helicopter.speed
				local physics = {speed = heli_speed/4, jump = 0, gravity = 0, sneak = false, sneak_glitch = false}

				if ctrl.jump then
					helicopter.stopped[stopping_player] = false
					physics.gravity = -(heli_speed-velocity.y)/10
					player:set_physics_override(physics)
				elseif ctrl.sneak then
					helicopter.stopped[stopping_player] = false
					physics.gravity =  (heli_speed+velocity.y)/10
					player:set_physics_override(physics)
				elseif (ctrl.aux1 or helicopter.passive_stop) and not helicopter.stopped[name] then
					stopping_player = name
					minetest.add_entity(player:get_pos(), "helicopter:stopper_entity")
					player:set_physics_override(physics)
				end

-- 				debug_msg("player '"..name.."' is "..get_state(physics.gravity).." (physics="..minetest.pos_to_string({x=physics.speed, y=physics.jump,z=physics.gravity})..", velocity="..minetest.pos_to_string(velocity)..")...")
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
			user:set_physics_override({speed = 2, jump = 0, gravity = 0, sneak = false, sneak_glitch = false})
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

for _,glass in pairs({
	"default:glass", "default:obsidian_glass",
	"hardened_glass:glass",
	"glowglass:basic", "glowglass:super", "glowglass:black", "glowglass:superblack", "glowglass:hardened", "glowglass:superhardened",
	"flolands:floatglass"}) do

	minetest.register_craft({
		output = 'helicopter:cabin',
		recipe = {
			{'', 'group:wood', ''},
			{'group:wood', 'default:mese_crystal',glass},
			{'group:wood','group:wood','group:wood'},
		}
	})
end

minetest.register_craft({
	output = 'helicopter:heli',
	recipe = {
		{'', 'helicopter:blades', ''},
		{'helicopter:blades', 'helicopter:cabin',''},
	}
})
