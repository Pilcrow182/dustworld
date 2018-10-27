bed = {}
bed.sleeping_players = {}


-- player physics values to be set upon getting out of bed

if minetest.get_modpath("wasteland") then
	bed.playerphysics = wasteland.playerphysics
else
	bed.playerphysics = {speed = 1, jump = 1, gravity = 1}
end


-- main functions

bed.count_sleepers = function()
	local count = 0
	for player,is_sleeping in pairs(bed.sleeping_players) do
		if is_sleeping then count = count + 1 end
	end
	return count
end

bed.set_sleeper = function(player, bedpos)
	local p2 = minetest.get_node(bedpos).param2
	local dir = minetest.facedir_to_dir(p2)
	local pillow = {x = bedpos.x + (dir.x / 2), y = bedpos.y - 0.5, z = bedpos.z + (dir.z / 2)}
	if minetest.get_node(bedpos).name == "bed:minibed" then pillow=bedpos end
	bed.sleeping_players[player:get_player_name()] = player:getpos()

	-- move player into bed and make sure he can't just walk out
	minetest.after(0, function() player:moveto(pillow) end)
	player:set_physics_override(0, 0, 0)
end

bed.kick_sleeper = function(player)
	local spawnpoint = bed.sleeping_players[player:get_player_name()]
	bed.sleeping_players[player:get_player_name()] = nil

	-- move player out of bed and let him walk again
	if spawnpoint then
		playerspawn.set(player:get_player_name(), spawnpoint, true)
		player:moveto(spawnpoint)
	end
	player:set_physics_override(bed.playerphysics.speed, bed.playerphysics.jump, bed.playerphysics.gravity)
end

bed.skip_night = function(sleepers, players)
	if sleepers/players < 1 or bed.delay == true then return end
	bed.delay = true
	minetest.after(2, function()
		minetest.set_timeofday(0.23)
		for _,player in ipairs(minetest.get_connected_players()) do bed.kick_sleeper(player) end
		bed.sleeping_players = {}
		minetest.chat_send_all("Good morning!")
		bed.delay = false
	end)
end

bed.on_rightclick = function(pos, clicker)
	local name = clicker:get_player_name()
	local tod = minetest.get_timeofday()

	if tod >= 0.23 and tod <= 0.8 then -- don't sleep if it's daytime
		minetest.chat_send_player(clicker:get_player_name(), "You can only sleep at night!", false)
		return false
	end

	if bed.sleeping_players[name] then
		bed.kick_sleeper(clicker)
	else
		bed.set_sleeper(clicker, pos)
		local sleepers = bed.count_sleepers()
		local players = #minetest.get_connected_players()
		minetest.chat_send_player(clicker:get_player_name(), "Players in bed: "..sleepers.."/"..players, false)
		bed.skip_night(sleepers, players)
	end
end


-- helper functions

local function remove_top(pos)
	local n = minetest.get_node_or_nil(pos)
	if not n then return end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z}
	local n2 = minetest.get_node(p)
	if minetest.get_item_group(n2.name, "bed") == 2 and n.param2 == n2.param2 then
		minetest.remove_node(p)
	end
end

local function add_top(pos)
	local n = minetest.get_node_or_nil(pos)
	if not n or not n.param2 then
		minetest.remove_node(pos)
		return true
	end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z}
	local n2 = minetest.get_node_or_nil(p)
	local def = minetest.registered_items[n2.name] or nil
	if not n2 or not def or not def.buildable_to then
		minetest.remove_node(pos)
		return true
	end
	minetest.set_node(p, {name = n.name:gsub("%_bottom", "_top"), param2 = n.param2})
	return false
end


-- node registry

function bed.register_bed(name, def)
	minetest.register_node(name .. "_bottom", {
		description = def.description,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		drawtype = "nodebox",
		tiles = def.tiles.bottom,
		paramtype = "light",
		paramtype2 = "facedir",
		stack_max = 1,
		groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1},
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = def.nodebox.bottom,
		},
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox,
				
		},
		after_place_node = function(pos, placer, itemstack)
			return add_top(pos)
		end,	
		on_destruct = function(pos)
			remove_top(pos)
		end,
		on_rightclick = function(pos, node, clicker)
			bed.on_rightclick(pos, clicker)
		end,
	})

	minetest.register_node(name .. "_top", {
		drawtype = "nodebox",
		tiles = def.tiles.top,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2, not_in_creative_inventory = 1},
		sounds = default.node_sound_wood_defaults(),
		node_box = {
			type = "fixed",
			fixed = def.nodebox.top,
		},
		selection_box = {
			type = "fixed",
			fixed = {0, 0, 0, 0, 0, 0},
		},
	})

	minetest.register_alias(name, name .. "_bottom")

	-- register recipe
	minetest.register_craft({
		output = name,
		recipe = def.recipe
	})
end

bed.register_bed("bed:bed", {
	description = "Bed",
	inventory_image = "bed_bed.png",
	wield_image = "bed_bed.png",
	tiles = {
	    bottom = {
		"bed_bed_top1.png",
		"default_wood.png",
		"bed_bed_side1.png",
		"bed_bed_side1.png^[transformFX",
		"default_wood.png",
		"bed_bed_foot.png",
	    },
	    top = {
		"bed_bed_top2.png",
		"default_wood.png",
		"bed_bed_side2.png",
		"bed_bed_side2.png^[transformFX",
		"bed_bed_head.png",
		"default_wood.png",
	    }
	},
	nodebox = {
	    bottom = {
		{-8/16, -8/16, -8/16, -6/16, -1/16, -7/16},
		{ 6/16, -8/16, -8/16,  8/16, -1/16, -7/16},
		{-8/16, -6/16, -8/16,  8/16, -2/16, -7/16},
		{-8/16, -6/16, -8/16, -7/16, -2/16,  8/16},
		{ 7/16, -6/16, -8/16,  8/16, -2/16,  8/16}, --mattress
		{-7/16, -5/16, -7/16,  7/16, -1/16,  8/16}, --blanket
	      },
	      top = {
		{-8/16, -8/16,  7/16, -6/16,  3/16,  8/16},
		{ 6/16, -8/16,  7/16,  8/16,  3/16,  8/16},
		{-8/16,  0/16,  7/16,  8/16,  2/16,  8/16},
		{-8/16, -6/16,  7/16,  8/16, -2/16,  8/16},
		{-8/16, -6/16, -8/16, -7/16, -2/16,  8/16},
		{ 7/16, -6/16, -8/16,  8/16, -2/16,  8/16},
		{-7/16, -5/16,  0/16,  7/16, -2/16,  7/16}, --mattress
		{-7/16, -5/16, -8/16,  7/16, -1/16,  0/16}, --blanket
		{-6/16, -5/16,  0/16,  6/16, -1/16,  6/16}, --pillow
	      }
	},
	selectionbox = {-8/16, -8/16, -8/16, 8/16, 3/16, 24/16},
	recipe = {
		{"group:wool", "group:wool", "group:wool"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

-- easteregg
dofile(minetest.get_modpath("bed").."/minibed.lua")

-- legacy support
dofile(minetest.get_modpath("bed").."/legacy.lua")
