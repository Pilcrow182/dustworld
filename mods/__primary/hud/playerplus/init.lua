--[[
	walking on ice makes player walk faster,
	stepping through snow or water slows player down,
	touching a cactus hurts player,
	stuck inside node suffocates player.

	PlayerPlus by TenPlus1 (modified by Pilcrow)
]]

-- initial variables
CONTROL_TIMER = 0.2						-- lower numbers means less input lag for sprinting, but more work for the server
SUFFOCATION_TIMER = 1						-- amount of time the mod waits before damaging a player who is inside a solid node
SUFFOCATION_DAMAGE = 1						-- amount of suffocation damage a player takes every SUFFOCATION_TIMER seconds
NORMAL_PHYSICS = {speed = 1, jump = 1, gravity = 1}		-- set the player physics to a sane default when a player is not sprinting
SPRINT_VALUES = {speed = 0.8, jump = 0.2, gravity = 0}		-- these values are added to normal speed, jump, and gravity when sprinting
SPRINT_STAMINA = 20						-- higher numbers means a player can sprint for a longer amount of time
SPRINT_TIMEOUT = 1						-- seconds allowed between the first and second button presses when double-tapping

-- compatability with Pilcrow's Wasteland mod
if minetest.get_modpath("wasteland") then
	NORMAL_PHYSICS = wasteland.playerphysics		-- when wasteland mod is present, use its physics values instead of the default ones
end

-- compatability with Wuzzy's HUDbars mod
if minetest.get_modpath("hudbars") ~= nil then
	hb.register_hudbar("sprint", 0xFFFFFF, "Stamina",
		{ bar = "playerplus_stamina_bar.png", icon = "playerplus_stamina_icon.png" },
		SPRINT_STAMINA, SPRINT_STAMINA, false)
	SPRINT_HUDBARS_USED = true
else
	SPRINT_HUDBARS_USED = false
end

pp = {}

players = {}
minetest.register_on_joinplayer(function(player)
	local playerName = player:get_player_name()
	players[playerName] = {state = 0, timeOut = 0, stamina = 20}

	if SPRINT_HUDBARS_USED then
		hb.init_hudbar(player, "sprint")
	else
		players[playerName].hud = player:hud_add({
			hud_elem_type = "statbar",
			position = {x=0.5,y=1},
			size = {x=24, y=24},
			text = "playerplus_stamina_icon.png",
			number = 20,
			alignment = {x=0,y=1},
			offset = {x=-263, y=-110},
			}
		)
	end
end)

local shipspawn = false
local time = 0
local time2 = 0
minetest.register_globalstep(function(dtime)
	time = time + dtime
	time2 = time2 + dtime
	local def = {}

	-- compatability with Pilcrow's Crash Site mod
	if shipspawn == false and minetest.get_modpath("crash_site") then
		local check = io.open(minetest.get_worldpath() .. "/crash_site.txt","r")
		if not check then
			return
		else
			shipspawn = true
			io.close(check)
		end
	end

	--loop through all connected players
	for playerName,playerInfo in pairs(players) do
		local player = minetest.get_player_by_name(playerName)
		if player then
			local control = player:get_player_control()
			local playerMovement = control.up or control.down or control.left or control.right
			local playerForward = control.up

-- 			if playerInfo["state"] == 2 then
-- 				players[playerName]["timeOut"] = players[playerName]["timeOut"] + 1
-- 				if playerInfo["timeOut"] >= SPRINT_TIMEOUT*10 then
-- 					players[playerName]["timeOut"] = 0
-- 					players[playerName]["state"] = 0
-- 				end
-- 			else
-- 				players[playerName]["timeOut"] = 0
-- 			end
			

			if playerMovement == true and control.aux1 and not control.sneak then				-- sprinting (pressed e)
				players[playerName]["state"] = 4
				pp.sprint = 1
			elseif playerInfo["state"] == 4 and not control.aux1 then					-- moving (un-pressed e)
				players[playerName]["state"] = 1
				pp.sprint = 0
			elseif playerMovement == false and playerInfo["state"] >= 3 then				-- stopped
				players[playerName]["state"] = 0
				pp.sprint = 0
			elseif playerForward == true and playerInfo["state"] == 0 and not control.sneak then		-- moving
				players[playerName]["state"] = 1
				pp.sprint = 0
-- 			elseif playerMovement == false and playerInfo["state"] == 1 then				-- primed
-- 				players[playerName]["state"] = 2
-- 				pp.sprint = 0
-- 			elseif playerForward == true and playerInfo["state"] == 2 then					-- sprinting
-- 				players[playerName]["state"] = 3
-- 				pp.sprint = 1
			end
		end
	end

	-- every CONTROL_TIMER seconds
	if time >= CONTROL_TIMER then
		-- reset time for next check
		time = 0

		-- check players
		for _,player in ipairs(minetest.get_connected_players()) do
			-- what are my stats?
			local playerInfo = players[player:get_player_name()]
			
			-- where am I?
			local pos = player:getpos()
				
			-- what is around me?
			pos.y = pos.y - 0.1 -- standing on
			local nod_stand = minetest.get_node(pos).name

			pos.y = pos.y + 1.5 -- head level
			local nod_head = minetest.get_node(pos).name
	
			pos.y = pos.y - 1.2 -- feet level
			local nod_feet = minetest.get_node(pos).name
	
			pos.y = pos.y - 0.2 -- reset pos

			-- is 3d_armor mod active? if so make armor physics default
			if minetest.get_modpath("3d_armor") and armor and armor.def then
				def = armor.def[player:get_player_name()] or nil
			end

			-- set to armor physics or defaults
			pp.speed = def.speed or NORMAL_PHYSICS["speed"]
			pp.jump = def.jump or NORMAL_PHYSICS["jump"]
			pp.gravity = def.gravity or NORMAL_PHYSICS["gravity"]

			-- check if sprinting and add increase to player physics
			if pp.sprint == 1 then
				-- do I have enough stamina to run?
				if playerInfo["stamina"] > 0 then
					pp.speed = pp.speed + SPRINT_VALUES["speed"]
					pp.jump = pp.jump + SPRINT_VALUES["jump"]
					pp.gravity = pp.gravity + SPRINT_VALUES["gravity"]
					
				-- if not, stop sprinting
				else
					playerInfo["state"] = 1
					pp.sprint = 0
				end
				
				-- reduce my stamina if it is more than 0 and I am sprinting
				playerInfo["stamina"] = math.max(playerInfo["stamina"] - CONTROL_TIMER, 0)
			else
				-- increase my stamina if it is less than SPRINT_STAMINA and I am not sprinting
				playerInfo["stamina"] = math.min(playerInfo["stamina"] + CONTROL_TIMER, SPRINT_STAMINA)
			end

			--Update my hud to display my stamina
			if SPRINT_HUDBARS_USED then
				hb.change_hudbar(player, "sprint", playerInfo["stamina"])
			else
				local numBars = (playerInfo["stamina"]/SPRINT_STAMINA)*20
				player:hud_change(playerInfo["hud"], "number", numBars)
			end

			-- standing on ice? if so walk faster
			if nod_stand == "default:ice" then
				pp.speed = pp.speed + 0.4
			end

			-- standing on snow? if so walk slower
			if nod_stand == "default:snow"
			or nod_stand == "default:snowblock"
			-- wading in water? if so walk slower
			or nod_feet == "default:water_flowing"
			or nod_feet ==  "default:water_source" then
				pp.speed = pp.speed - 0.4
			end

			-- inside mining beam? if so, reverse gravity
			if nod_head == "mining_laser:beam"
			or nod_feet == "mining_laser:beam" then
				pp.gravity = -0.1
			end

			-- set player physics
			player:set_physics_override(pp.speed, pp.jump, pp.gravity)
			--print ("Speed:", pp.speed, "Jump:", pp.jump, "Gravity:", pp.gravity)

			-- every SUFFOCATION_TIMER seconds
			if time2 >= SUFFOCATION_TIMER then
				-- reset time for next check
				time2 = 0

				-- am I suffocating inside node? (only walkable nodes with drawtype normal or glasslike)
				local nod_head_def = minetest.registered_nodes[nod_head]
				if nod_head_def and nod_head_def.walkable and (
					nod_head_def.drawtype == "normal" or string.find(nod_head_def.drawtype, "glasslike")
				)
				and not minetest.check_player_privs(player:get_player_name(), {noclip=true}) then
					if player:get_hp() > 0 then
						player:set_hp(player:get_hp()-SUFFOCATION_DAMAGE)
					end
				end
			end
		end
	end
end)

-- make cacti damage players and other entities (such as mobs)
minetest.register_abm({
	nodenames = {"default:cactus"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		for _,object in ipairs(minetest.get_objects_inside_radius(pos, 15.1/16)) do
			if object:get_hp() > 0 then
				object:set_hp(object:get_hp()-1)
			elseif not object:is_player() and object:get_hp() == 0 and object:get_luaentity().name ~= "__builtin:item" then
				object:remove()
			end
		end
	end
})
