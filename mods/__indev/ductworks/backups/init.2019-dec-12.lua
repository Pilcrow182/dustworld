ductworks = {}
ductworks.legacy_mode = {}

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

	-- NOTE: tiles order is different from coordinate order for some reason
	local oppos = {up = "down", down = "up", east = "west", west = "east", north = "south", south = "north"}

	for i,face in ipairs({"up", "down", "east", "west", "north", "south"}) do
		if face == dstdir then tiles[i] = "ductworks_base.png" end
		if face == oppos[dstdir] then tiles[i] = "ductworks_base.png" end
	end

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
			if dir == dstdir then tiles[index] = tiles[index].."^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
		end
	end

	return tiles
end

local create_duct = function(basename, connects, dstdir)
	local groups = {cracky = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory = 1, [basename] = 1}
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

	minetest.register_node("ductworks:"..basename.."_"..id, {
		tiles = get_tiles(basename, dstdir),
		drawtype = "nodebox",
		paramtype = "light",
			node_box = {
			type = "fixed",
			fixed = shape
		},
		groups = groups,
		drop = "ductworks:"..basename
	})

	groups["disabled"] = 1

	minetest.register_node("ductworks:"..basename.."_"..id.."_disabled", {
		tiles = get_tiles(basename, dstdir, true),
		drawtype = "nodebox",
		paramtype = "light",
			node_box = {
			type = "fixed",
			fixed = shape
		},
		groups = groups,
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
		elseif duct_type == "liquiduct" and minetest.get_item_group(node.name, "liquid_storage") then
			return true
		elseif duct_type == "powerduct" and minetest.get_item_group(node.name, "power_storage") then
			return true
		end
	end
	return false
end

local node_lookup = function(connects, basename)
	local basename = basename or "itemduct"
	local node_name = "ductworks:"..basename.."_"
	for _,dir in ipairs(dirs) do node_name = node_name..tostring(connects["duct_connect_"..dir] or 0) end
	return node_name
end

ductworks.register_duct = function(basename, description)
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
		description = description,
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

			if ductworks.legacy_mode[placer:get_player_name()] then
				local pointed = vector_dirs[minetest.pos_to_string(dir)]
				if not pointed then return itemstack end

				-- scan for surrounding ducts that point into self
				local newgroups = {}
				for _,dirname in ipairs(dirs) do
					local v = minetest.string_to_pos(vector_dirs[dirname])
					local p = {x = pointed_thing.above.x + v.x, y = pointed_thing.above.y + v.y, z = pointed_thing.above.z + v.z}
					if minetest.get_item_group(minetest.get_node(p).name, "duct_connect_"..oppos[dirname]) > 0 then newgroups["duct_connect_"..dirname] = 1 end
				end
				newgroups["duct_connect_"..pointed] = 1
				newgroups["duct_connect_"..oppos[pointed]] = 2

				local to_place = node_lookup(newgroups)
				if not to_place then return itemstack end
				minetest.set_node(pointed_thing.above, {name = to_place})

				-- bend the target to ouput into self, if possible
				local node_under = minetest.get_node(pointed_thing.under)
				if ( node_under and node_under.name and minetest.get_item_group(node_under.name, basename) > 0 ) then
					local oldgroups, newgroups = minetest.registered_nodes[under.name].groups, {}
					for _,dirname in pairs(dirs) do if oldgroups["duct_connect_"..dirname] == 1 then newgroups["duct_connect_"..dirname] = 1 end end
					newgroups["duct_connect_"..oppos[pointed]] = 2
					minetest.swap_node(pointed_thing.under, {name=node_lookup(newgroups)})
				end

				--add self to output node's inputs
			else
				-- scan for directions to immediately connect to
				local pushdir, newgroups = "", {}
				for _,dirname in ipairs(dirs) do
					if vector_dirs[dirname] == minetest.pos_to_string(dir) then
						pushdir, newgroups["duct_connect_"..dirname] = dirname, 2
					else
						local v = minetest.string_to_pos(vector_dirs[dirname])
						local p = pointed_thing.above
						p = {x = p.x + v.x, y = p.y + v.y, z = p.z + v.z}
						if valid_src(p, oppos[dirname], basename) then
							newgroups["duct_connect_"..dirname] = 1
						end
					end
				end

				local to_place = node_lookup(newgroups)
				if not to_place then return itemstack end
				minetest.set_node(pointed_thing.above, {name = to_place})

				-- add self as an input dir of pointed_thing.under, if possible
				local node_under = minetest.get_node(pointed_thing.under)
				if ( node_under and node_under.name and minetest.get_item_group(node_under.name, basename) > 0 ) then
					local groups = {}
					for k,v in pairs(minetest.registered_nodes[under.name].groups) do groups[k]=v end
					groups["duct_connect_"..oppos[pushdir]] = groups["duct_connect_"..oppos[pushdir]] or 1
					minetest.swap_node(pointed_thing.under, {name=node_lookup(groups)})
				end
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
		for _,dirname in ipairs(dirs) do
			local v = minetest.string_to_pos(vector_dirs[dirname])
			local p = {x = pos.x + v.x, y = pos.y + v.y, z = pos.z + v.z}
			local node = minetest.get_node(p)
			if minetest.get_item_group(node.name, "duct_connect_"..oppos[dirname]) == 1 then
				local oldgroups, newgroups = minetest.registered_nodes[node.name].groups, {}
				for _,dirname in pairs(dirs) do newgroups["duct_connect_"..dirname] = oldgroups["duct_connect_"..dirname] end
				newgroups["duct_connect_"..oppos[dirname]] = nil
				minetest.swap_node(p, {name=node_lookup(newgroups)})
			end
		end
	end)
end

ductworks.register_duct("itemduct", "Itemduct")
ductworks.register_duct("fuelduct", "Itemduct (fuel)")
ductworks.register_duct("powerduct", "Powerduct")
ductworks.register_duct("liquiduct", "Liquiduct")

minetest.register_craftitem("ductworks:pipe_wrench", {
	description = "Pipe Wrench",
	inventory_image = "ductworks_pipe_wrench.png",
	wield_image = "ductworks_pipe_wrench.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	on_use = function(itemstack, user, pointed_thing)
		if not pointed_thing.under then return end

		local node = minetest.get_node(pointed_thing.under)
		local name, param2 = node.name, node.param2

		local basename = nil
		for _,duct in pairs({"itemduct", "fuelduct", "liquiduct", "powerduct"}) do
			if minetest.get_item_group(name, duct) then
				basename = duct
				break
			end
		end
		if not basename then return end

		if user:get_player_control().sneak then
			local pushdir, oldgroups, newgroups = "", minetest.registered_nodes[name].groups, {}
			for _,dirname in ipairs(dirs) do
				if oldgroups["duct_connect_"..dirname] == 2 then
					newgroups["duct_connect_"..dirname] = 2
				else
					local v = minetest.string_to_pos(vector_dirs[dirname])
					local p = pointed_thing.under
					p = {x = p.x + v.x, y = p.y + v.y, z = p.z + v.z}
					if valid_src(p, oppos[dirname], basename) then
						newgroups["duct_connect_"..dirname] = 1
					end
				end
			end

			local to_place = node_lookup(newgroups, basename)
			if not to_place then return itemstack end
			minetest.swap_node(pointed_thing.under, {name = to_place})
		else
			if string.find(name, "_disabled") then
				minetest.swap_node(pointed_thing.under, {name = string.gsub(name, "_disabled", "")})
			else
				minetest.swap_node(pointed_thing.under, {name = name.."_disabled"})
			end
		end
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing.under then return end

		local node = minetest.get_node(pointed_thing.under)
		local name, param2 = node.name, node.param2

		-- TODO: finish this, of course (see duct_config_mockup.png)
		local config = "size[10,10]"
		minetest.show_formspec(placer:get_player_name(), "duct_config", config)
--		minetest.chat_send_all("This should bring up the config screen for "..minetest.pos_to_string(pointed_thing.under).."; does nothing for now...")
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

-- TODO: add ABM to actually move the items from input dirs (duct_connect 1) to output dir (duct_connect 2)

-- TODO: add ABM to transform mechanism itemducts/fuelducts into ductworks itemducts/fuelducts

