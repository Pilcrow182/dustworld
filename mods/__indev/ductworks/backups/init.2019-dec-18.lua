ductworks = {}
ductworks.legacy_mode = {}
ductworks.target = {}

local boxes = {
	{ 2/16, -2/16, -2/16,  8/16,  2/16,  2/16}, -- east
	{-8/16, -2/16, -2/16, -2/16,  2/16,  2/16}, -- west
	{-2/16,  2/16, -2/16,  2/16,  8/16,  2/16}, -- up
	{-2/16, -8/16, -2/16,  2/16, -2/16,  2/16}, -- down
	{-2/16, -2/16,  2/16,  2/16,  2/16,  8/16}, -- north
	{-2/16, -2/16, -8/16,  2/16,  2/16, -2/16}, -- south
	{-2/16, -2/16, -2/16,  2/16,  2/16,  2/16}  -- center
}

local dirs = {"east", "west", "up", "down", "north", "south"}
local vector_dirs = {east = "(1,0,0)", west = "(-1,0,0)", up = "(0,1,0)", down = "(0,-1,0)", north = "(0,0,1)", south = "(0,0,-1)"}
for i = 1,6 do vector_dirs[vector_dirs[dirs[i]]] = dirs[i] end -- inverse of above; sets vector_dirs["(1,0,0)"] = "east", etc.

local oppos = {north = "south", south = "north", up = "down", down = "up", east = "west", west = "east"}

local b2n = {[true] = 1, [false] = 0}

local get_tiles = function(basename, dstdir, disabled)
	local tiles = {}

	local oppos = {up = "down", down = "up", east = "west", west = "east", north = "south", south = "north"}

	local rotsets = {
		{north = 0, east = 270, south = 180, west = 90},
		{south = 0, west = 90, north = 180, east = 270},
		{up = 0, south = 90, down = 180, north = 270},
		{up = 0, north = 90, down = 180, south = 270},
		{up = 0, west = 270, down = 180, east = 90},
		{up = 0, east = 270, down = 180, west = 90}
	}

	for index, rotset in pairs(rotsets) do
		for dir, rot in pairs(rotset) do
			tiles[index] = "ductworks_base.png"
			if disabled then tiles[index] = tiles[index].."^ductworks_disabled.png" end
			if dir == dstdir then tiles[index] = tiles[index].."^ductworks_"..basename.."_output.png^[transformR"..rot.."]" break end
		end
	end

	-- NOTE: tiles order is different from coordinate order for some reason
	for i,face in ipairs({"up", "down", "east", "west", "north", "south"}) do
		if face == dstdir or face == oppos[dstdir] then tiles[i] = tiles[i].."^ductworks_"..basename.."_input.png" end
	end

	return tiles
end

local create_duct = function(basename, connects, dstdir)
	local groups = {cracky = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory = 1, ductworks = 1, [basename] = 1}
	local shape = {boxes[7]}

	local id = ""
	for index, dir in ipairs(dirs) do
		if connects[index] then
			table.insert(shape, boxes[index])
			if dir == dstdir then
				groups["duct_connect_"..dir] = 2
				id = id.."2"
			else
				groups["duct_connect_"..dir] = 1
				id = id.."1"
			end
		else
			id = id.."0"
		end
	end

	local egroups, dgroups = {}, {}
	for k,v in pairs(groups) do egroups[k], dgroups[k] = v, v end
	dgroups["disabled"] = 1

	minetest.register_node("ductworks:"..basename.."_"..id, {
		tiles = get_tiles(basename, dstdir),
		drawtype = "nodebox",
		paramtype = "light",
			node_box = {
			type = "fixed",
			fixed = shape
		},
		groups = egroups,
		drop = "ductworks:"..basename
	})

	minetest.register_node("ductworks:"..basename.."_"..id.."_disabled", {
		tiles = get_tiles(basename, dstdir, true),
		drawtype = "nodebox",
		paramtype = "light",
			node_box = {
			type = "fixed",
			fixed = shape
		},
		groups = dgroups,
		drop = "ductworks:"..basename
	})
end

local valid_src = function(pos, dstdir, duct_type)
	local node = minetest.get_node(pos)
	if not ( node and node.name ) then return false end
	if minetest.get_item_group(node.name, duct_type) > 0 and minetest.get_item_group(node.name, "duct_connect_"..dstdir) == 2 then
		return true
	else
		-- TODO: Include valid storage types in the call to ductworks.register_duct and figure out where to store/recall that info instead of hard-coding
		local inv = minetest.get_meta(pos):get_inventory()
		if duct_type == "itemduct" and ( inv:get_list("main") or inv:get_list("src") or minetest.get_item_group(node.name, "metastorage") > 0 ) then
			return true
		elseif duct_type == "fuelduct" and ( inv:get_list("fuel") or inv:get_list("main") or minetest.get_item_group(node.name, "metastorage") > 0 ) then
			return true
		elseif duct_type == "liquiduct" and minetest.get_item_group(node.name, "liquid_storage") > 0 then
			return true
		elseif duct_type == "powerduct" and minetest.get_item_group(node.name, "power_storage") > 0 then
			return true
		end
	end
	return false
end

local node_lookup = function(connects, basename, disabled)
	local node_name = "ductworks:"..basename.."_"
	for _,dir in ipairs(dirs) do node_name = node_name..tostring(connects["duct_connect_"..dir] or 0) end
	if disabled then node_name = node_name.."_disabled" end
	return node_name
end

local rescan = function(pos, promiscuous)
	local node = minetest.get_node(pos)
	if not node.name then return end

	local oldgroups, newgroups = minetest.registered_nodes[node.name].groups, {}
	
	local basename = nil
	for _,duct in pairs({"itemduct", "fuelduct", "liquiduct", "powerduct"}) do
		if minetest.get_item_group(node.name, duct) > 0 then basename = duct end
	end
	if not basename then return end

	for _,dir in ipairs(dirs) do
		local v = minetest.string_to_pos(vector_dirs[dir])
		local p = {x = pos.x + v.x, y = pos.y + v.y, z = pos.z + v.z}
		local pname = minetest.get_node(p).name

		if oldgroups["duct_connect_"..dir] == 2 then
			newgroups["duct_connect_"..dir] = 2
		elseif minetest.get_item_group(pname, basename) > 0 and minetest.get_item_group(pname, "duct_connect_"..oppos[dir]) == 2 then
			newgroups["duct_connect_"..dir] = 1
		elseif ( promiscuous or ( oldgroups["duct_connect_"..dir] == 1 ) ) and valid_src(p, oppos[dir], basename) then
			newgroups["duct_connect_"..dir] = 1
		end
	end

	local to_place = node_lookup(newgroups, basename)
	if not to_place then return end
	minetest.swap_node(pos, {name = to_place})
end

ductworks.register_duct = function(basename)
	-- NOTE: This function registers 186 different shapes for each kind of duct
	for _,east in pairs({true, false}) do
		for _,west in pairs({true, false}) do
			for _,up in pairs({true, false}) do
				for _,down in pairs({true, false}) do
					for _,north in pairs({true, false}) do
						for _,south in pairs({true, false}) do
							if b2n[east] + b2n[west] + b2n[up] + b2n[down] + b2n[north] + b2n[south] > 0 then
								local connects = {east, west, up, down, north, south}
								for index,dst in ipairs(connects) do
									if dst then
										create_duct(basename, connects, dirs[index])
									end
								end
							end
						end
					end
				end
			end
		end
	end

	minetest.register_craftitem("ductworks:"..basename, {
		description = basename:gsub("^%l", string.upper),
		inventory_image = "ductworks_"..basename..".png",
		wield_image = "ductworks_"..basename..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if not ( pointed_thing and pointed_thing.type == "node" ) then return itemstack end
			local under = minetest.get_node(pointed_thing.under)
			if placer and not placer:get_player_control().sneak and minetest.registered_nodes[under.name] and minetest.registered_nodes[under.name].on_rightclick then
				return minetest.registered_nodes[under.name].on_rightclick(pointed_thing.under, under, placer, itemstack) or itemstack, false
			end
			if not minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to then return itemstack end

			local dir = vector.direction(pointed_thing.above, pointed_thing.under)
			local pointed = vector_dirs[minetest.pos_to_string(dir)]
			if not pointed then return itemstack end

			if ductworks.legacy_mode[placer:get_player_name()] then
				-- place the duct stub, to be updated later
				local to_place = node_lookup({["duct_connect_"..oppos[pointed]] = 2, ["duct_connect_"..pointed] = 1}, basename)
				if not to_place then return itemstack end
				minetest.set_node(pointed_thing.above, {name = to_place})

				-- bend the target to ouput into the stub, if possible
				local node_under, oldout = minetest.get_node(pointed_thing.under), nil
				if ( node_under and node_under.name and minetest.get_item_group(node_under.name, basename) > 0 ) then
					local oldgroups, newgroups = minetest.registered_nodes[under.name].groups, {}
					for _,dirname in pairs(dirs) do
						if oldgroups["duct_connect_"..dirname] == 1 then
							newgroups["duct_connect_"..dirname] = 1
						elseif oldgroups["duct_connect_"..dirname] == 2 then
							local v = minetest.string_to_pos(vector_dirs[dirname])
							oldout = {x = pointed_thing.under.x + v.x, y = pointed_thing.under.y + v.y, z = pointed_thing.under.z + v.z}
						end
					end
					newgroups["duct_connect_"..oppos[pointed]] = 2
					minetest.swap_node(pointed_thing.under, {name=node_lookup(newgroups, basename)})
				end

				-- look for available connections in all affected ducts, including the stub (do not auto-connect to storage nodes)
				rescan(pointed_thing.under)
				rescan(pointed_thing.above)
				rescan({x = pointed_thing.above.x - dir.x, y = pointed_thing.above.y - dir.y, z = pointed_thing.above.z - dir.z})
				if oldout then rescan(oldout) end
			else
				-- place the duct stub, to be updated later
				local to_place = node_lookup({["duct_connect_"..pointed] = 2}, basename)
				if not to_place then return itemstack end
				minetest.set_node(pointed_thing.above, {name = to_place})

				-- look for available connections in all affected ducts, including the stub (DO auto-connect to storage nodes)
				rescan(pointed_thing.above, true)
				rescan(pointed_thing.under)
			end

			itemstack:take_item()
			return itemstack
		end,
		on_use = function(itemstack, user, pointed_thing)
			if user:get_player_control().sneak then
				local name = user:get_player_name()
				ductworks.legacy_mode[name] = not ductworks.legacy_mode[name]
				local mode = {["true"] = "legacy", ["false"] = "modern"}
				minetest.chat_send_player(name, "Duct placement mode: "..mode[tostring(ductworks.legacy_mode[name])])
			end
		end
	})

	minetest.register_on_dignode(function(pos, oldnode, digger)
		for _,dir in ipairs(dirs) do
			local v = minetest.string_to_pos(vector_dirs[dir])
			local p = {x = pos.x + v.x, y = pos.y + v.y, z = pos.z + v.z}
			if minetest.get_item_group(minetest.get_node(p).name, "duct_connect_"..oppos[dir]) == 1 then rescan(p) end
		end
	end)
end

ductworks.register_duct("itemduct")
ductworks.register_duct("fuelduct")
ductworks.register_duct("powerduct")
ductworks.register_duct("liquiduct")

local capitalize = function(word)
	return string.gsub(word, "^%l", string.upper)
end

local show_config = function(pos, playername)
	local node = minetest.get_node(pos)
	local name = node.name

	local basename = nil
	for _,duct in pairs({"itemduct", "fuelduct", "liquiduct", "powerduct"}) do
		if minetest.get_item_group(name, duct) > 0 then
			basename = duct
			break
		end
	end
	if not basename then return end

	ductworks.target[playername] = minetest.pos_to_string(pos)

	local groups, outputs, connects = minetest.registered_nodes[node.name].groups, {}, {}
	for _,dir in ipairs(dirs) do
		connects[dir] = (groups["duct_connect_"..dir] and "ductworks_naught.png") or "ductworks_cross.png"
		outputs[dir] = (groups["duct_connect_"..dir] == 2 and "ductworks_star.png") or ""
	end

	local ductlist, selected = "", 0
	for index, dtype in ipairs({"itemduct", "fuelduct", "liquiduct", "powerduct"}) do
		if dtype == basename then selected = index end
		ductlist = ( ductlist == "" and dtype:gsub("^%l", string.upper) ) or ductlist..","..dtype:gsub("^%l", string.upper)
	end

	local config = "size[4,6.5;]"
	for i, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
		config = config..
		"image_button[0,"..tostring(i-1)..";1,1;"..outputs[dir]..";output_"..dir..";]"..
		"image[1,"..tostring(i-1)..";2.25,1;ductworks_labelbox.png]"..
		"label[1.625,"..tostring(i-1+0.25)..";"..dir:gsub("^%l", string.upper).."]"..
		"image_button[3,"..tostring(i-1)..";1,1;"..connects[dir]..";connect_"..dir..";]"
	end
	config = config.."dropdown[0,6;4.125,1;duct_type;"..ductlist..";"..selected.."]"

	minetest.show_formspec(playername, "ductworks:config", config)
end

minetest.register_craftitem("ductworks:pipe_wrench", {
	description = "Pipe Wrench",
	inventory_image = "ductworks_pipe_wrench.png",
	wield_image = "ductworks_pipe_wrench.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	on_use = function(itemstack, user, pointed_thing)
		if not pointed_thing.under then return end

		local node = minetest.get_node(pointed_thing.under)
		local name = node.name

		local basename = nil
		for _,duct in pairs({"itemduct", "fuelduct", "liquiduct", "powerduct"}) do
			if minetest.get_item_group(name, duct) > 0 then
				basename = duct
				break
			end
		end
		if not basename then return end
		if user:get_player_control().sneak then
			rescan(pointed_thing.under, true)
		elseif string.find(name, "_disabled") then
			minetest.swap_node(pointed_thing.under, {name = string.gsub(name, "_disabled", "")})
		else
			minetest.swap_node(pointed_thing.under, {name = name.."_disabled"})
		end
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing.under then return end
		show_config(pointed_thing.under, placer:get_player_name())
	end,
	stack_max = 1
})

minetest.register_craft({
	output = 'ductworks:pipe_wrench',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot'},
		{'', 'default:steel_ingot'},
	}
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "ductworks:config" then
		if fields.quit == "true" then ductworks.target[player:get_player_name()] = nil return end

		local pos = minetest.string_to_pos(ductworks.target[player:get_player_name()])
		local node = minetest.get_node(pos)
		if minetest.get_item_group(node.name, "ductworks") == 0 then return end
		local oldgroups = minetest.registered_nodes[node.name].groups
		print(dump(oldgroups))

		local basename, newgroups, oldout, newout = fields.duct_type:lower(), {}, nil, nil
		for i, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
			if oldgroups["duct_connect_"..dir] then newgroups["duct_connect_"..dir] = 1 end
			if fields["connect_"..dir] then
				if oldgroups["duct_connect_"..dir] then
					newgroups["duct_connect_"..dir] = nil
				else
					newgroups["duct_connect_"..dir] = 1
				end
			end
			if oldgroups["duct_connect_"..dir] == 2 then oldout = dir end
			if fields["output_"..dir] then newout = dir end
		end

		local output = newout or oldout or "north"
		newgroups["duct_connect_"..output] = 2

		local to_place = node_lookup(newgroups, basename, oldgroups["disabled"] or nil)
		if not to_place then return end
		minetest.swap_node(pos, {name = to_place})

		show_config(pos, player:get_player_name())
	end
end)

-- TODO: add ABM to actually move the items from input dirs (duct_connect 1) to output dir (duct_connect 2)

-- TODO: add ABM to transform mechanism itemducts/fuelducts into ductworks itemducts/fuelducts

