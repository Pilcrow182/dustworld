ductworks.legacy_mode = {}
ductworks.target = {}
ductworks.duct_types = {}

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
		description = basename:gsub("^%l", string.upper),
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

ductworks.valid_src = function(pos, dstdir, duct_type)
	local node = minetest.get_node(pos)
	if not ( node and node.name ) then return false end
	if dstdir and minetest.get_item_group(node.name, duct_type) > 0 and minetest.get_item_group(node.name, "duct_connect_"..dstdir) == 2 then
		return true
	else
		local inv = minetest.get_meta(pos):get_inventory()
		if duct_type == "hopper" then
			return {"inventory", "src"}
		elseif duct_type == "ejector" then
			return {"inventory", "tmp"}
		elseif duct_type == "itemduct" then
			if inv:get_list("dst") then return {"inventory", "dst"} end
			if inv:get_list("main") then return {"inventory", "main"} end
			if minetest.get_item_group(node.name, "metastorage") > 0 then return {"meta", ""} end
			return false
		elseif duct_type == "fuelduct" then
			if inv:get_list("dst") then return {"inventory", "dst"} end
			if inv:get_list("main") then return {"inventory", "main"} end
			if minetest.get_item_group(node.name, "metastorage") > 0 then return {"meta", ""} end
			return false
		elseif duct_type == "liquiduct" and minetest.get_item_group(node.name, "liquid_storage") > 0 then
			return true
		elseif duct_type == "powerduct" and minetest.get_item_group(node.name, "power_storage") > 0 then
			return true
		end
	end
	return false
end

ductworks.valid_dst = function(pos, duct_type)
	local node = minetest.get_node(pos)
	if not ( node and node.name ) then return false end
	local inv = minetest.get_meta(pos):get_inventory()
	if duct_type == "hopper" then duct_type = "itemduct" end
	if duct_type == "itemduct" then
		if inv:get_list("main") then return {"inventory", "main"} end
		if inv:get_list("src") then return {"inventory", "src"} end
		if inv:get_list("tmp") then return {"inventory", "tmp"} end
		if minetest.get_item_group(node.name, "metastorage") > 0 then return {"meta", ""} end
		if minetest.registered_nodes[node.name].walkable == false then return {"air", ""} end
		return false
	elseif duct_type == "fuelduct" then
		if inv:get_list("fuel") then return {"inventory", "fuel"} end
		if inv:get_list("tmp") then return {"inventory", "tmp"} end
		return false
	elseif duct_type == "liquiduct" and minetest.get_item_group(node.name, "liquid_storage") > 0 then
		return true
	elseif duct_type == "powerduct" and minetest.get_item_group(node.name, "power_storage") > 0 then
		return true
	end
	return false
end

ductworks.node_lookup = function(connects, basename, disabled)
	local node_name = "ductworks:"..basename.."_"
	for _,dir in ipairs(dirs) do node_name = node_name..tostring(connects["duct_connect_"..dir] or 0) end
	if disabled then node_name = node_name.."_disabled" end
	return node_name
end

ductworks.rescan = function(pos, promiscuous)
	local node = minetest.get_node(pos)
	if not node.name then return end

	local oldgroups, newgroups = minetest.registered_nodes[node.name].groups, {}
	
	local basename = nil
	for _,duct in pairs(ductworks.duct_types) do
		if minetest.get_item_group(node.name, duct) > 0 then basename = duct end
	end
	if not basename then return end

	for _,dir in ipairs(dirs) do
		local v = minetest.string_to_pos(vector_dirs[dir])
		local p = vector.add(pos, v)
		local pname = minetest.get_node(p).name

		if oldgroups["duct_connect_"..dir] == 2 then
			newgroups["duct_connect_"..dir] = 2
		elseif minetest.get_item_group(pname, basename) > 0 and minetest.get_item_group(pname, "duct_connect_"..oppos[dir]) == 2 then
			newgroups["duct_connect_"..dir] = 1
		elseif minetest.get_item_group(pname, "hopper") > 0 and vector_dirs[minetest.get_meta(p):get_string("output")] == oppos[dir] then
			newgroups["duct_connect_"..dir] = 1
		elseif ( promiscuous or ( oldgroups["duct_connect_"..dir] == 1 ) ) and pname == "ductworks:ejector" then
			newgroups["duct_connect_"..dir] = 1
		elseif ( promiscuous or ( oldgroups["duct_connect_"..dir] == 1 ) ) and ductworks.valid_src(p, oppos[dir], basename) then
			newgroups["duct_connect_"..dir] = 1
		end
	end

	local to_place = ductworks.node_lookup(newgroups, basename)
	if not to_place then return end
	minetest.swap_node(pos, {name = to_place})
end

ductworks.find_dst = function(pos, basename)
	local p, groups, scanned = {x = pos.x, y = pos.y, z = pos.z}, {}, {}
	while true do
		if scanned[minetest.pos_to_string(p)] then return false end
		if ductworks.valid_dst(p, basename) then break end
		scanned[minetest.pos_to_string(p)] = true
		groups = minetest.registered_nodes[minetest.get_node(p).name].groups
		if groups["disabled"] or not groups[basename] then return false end
		for _,dir in pairs(dirs) do
			if groups["duct_connect_"..dir] == 2 then
				local offset = minetest.string_to_pos(vector_dirs[dir])
				p = vector.add(p, offset)
				break
			end
		end
	end
	return p
end

local metastorage = function(action, pos, stack)
	local stack = ItemStack(stack)

	local node = minetest.get_node(pos)
	if not (node and node.name) then return false end

	if minetest.get_item_group(node.name, "metastorage") == 0 then return false end

	local meta = minetest.get_meta(pos)
	local stored = meta:get_string("stored")
	stored = ((stored == "") and stack:get_name()) or stored
	local amount = tonumber(meta:get_string("amount")) or 0
	local wear = tonumber(meta:get_string("wear")) or 0
	wear = ((amount == 0) and stack:get_wear()) or wear

	if action == "to stack" then
		return ItemStack({name = stored, count = amount, wear = wear})

	elseif action == "is empty" then
		return (stored == "")

	elseif action == "room for item" then
		if amount > 0 and stored ~= stack:get_name() then return false end
		if amount > 9999 - stack:get_count() then return false end
		if amount > 0 and wear ~= stack:get_wear() then return false end
		return true

	elseif action == "add item" then
		amount = math.min(9999, amount + stack:get_count())
		meta:set_string("stored", stored)
		meta:set_string("amount", amount)
		meta:set_string("wear", wear)
		meta:set_string("infotext", stored.." "..amount)
		return true

	elseif action == "remove item" then
		amount = math.max(0, amount - stack:get_count())
		if amount == 0 then stored, wear = "", 0 end
		meta:set_string("stored", stored)
		meta:set_string("amount", amount)
		meta:set_string("wear", wear)
		meta:set_string("infotext", ((amount > 0) and stored.." "..amount) or "")
		return true
	end
end

ductworks.room_for_item = function(unit, dstpos, dst)
	local out = false
	out = minetest.get_meta(dstpos):get_inventory():room_for_item(dst[2], unit) or out
	out = metastorage("room for item", dstpos, unit) or out
	out = (dst[1] == "air") or out
	return out
end

ductworks.transfer = function(srcpos, dstpos, basename, itemstack)
	local src, dst = ductworks.valid_src(srcpos, nil, (itemstack and "ejector") or basename), ductworks.valid_dst(dstpos, basename)

	local srcinv = minetest.get_meta(srcpos):get_inventory()
	local dstinv = minetest.get_meta(dstpos):get_inventory()

	local skip = not (src and dst)
	skip = skip or (src[1] == "inventory" and srcinv:is_empty(src[2]))
	skip = skip or (src[1] == "meta" and metastorage("is empty", srcpos))

	if not skip then
		local stacklist = (itemstack and {itemstack}) or srcinv:get_list(src[2]) or {metastorage("to stack", srcpos)}
		for _,stack in ipairs(stacklist) do
			if not stack:is_empty() then
				local unit = {}
				for k,v in pairs(stack:to_table()) do unit[k] = v end
				unit["count"] = (itemstack and itemstack:get_count()) or 1
				for count = 1, stack:get_count(), unit["count"] do
					if ductworks.room_for_item(unit, dstpos, dst) then
						if src[1] == "inventory" then srcinv:remove_item(src[2], unit) end
						if src[1] == "meta" then metastorage("remove item", srcpos, unit) end

						if dst[1] == "inventory" then dstinv:add_item(dst[2], unit) end
						if dst[1] == "meta" then metastorage("add item", dstpos, unit) end
						if dst[1] == "air" then minetest.add_item(dstpos, unit) end

						local delay = (minetest.get_node(dstpos).name == "ductworks:ejector" and 0.0) or 1.0
						minetest.get_node_timer(dstpos):start(delay)
					end
				end
			end
		end
	end
end

ductworks.register_duct = function(basename)
	table.insert(ductworks.duct_types, basename)

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
				local to_place = ductworks.node_lookup({["duct_connect_"..oppos[pointed]] = 2, ["duct_connect_"..pointed] = 1}, basename)
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
							oldout = vector.add(pointed_thing.under, v)
						end
					end
					newgroups["duct_connect_"..oppos[pointed]] = 2
					minetest.swap_node(pointed_thing.under, {name=ductworks.node_lookup(newgroups, basename)})
				end

				-- look for available connections in all affected ducts, including the stub (do not auto-connect to storage nodes)
				ductworks.rescan(pointed_thing.under)
				ductworks.rescan(pointed_thing.above)
				ductworks.rescan(vector.subtract(pointed_thing.above, dir))
				if oldout then ductworks.rescan(oldout) end
			else
				-- place the duct stub, to be updated later
				local to_place = ductworks.node_lookup({["duct_connect_"..pointed] = 2}, basename)
				if not to_place then return itemstack end
				minetest.set_node(pointed_thing.above, {name = to_place})

				-- look for available connections in all affected ducts, including the stub (DO auto-connect to storage nodes)
				ductworks.rescan(pointed_thing.above, true)
				ductworks.rescan(pointed_thing.under)
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
			elseif pointed_thing and pointed_thing.type == "node" then
				local node = minetest.get_node(pointed_thing.under)
				if minetest.registered_nodes[node.name] then minetest.registered_nodes[node.name].on_punch(pointed_thing.under, node, user, itemstack) end
			end
		end
	})

	minetest.register_on_dignode(function(pos, oldnode, digger)
		for _,dir in ipairs(dirs) do
			local v = minetest.string_to_pos(vector_dirs[dir])
			local p = vector.add(pos, v)
			if minetest.get_item_group(minetest.get_node(p).name, "duct_connect_"..oppos[dir]) == 1 then ductworks.rescan(p) end
		end
	end)

	minetest.register_abm({
		nodenames = {"group:"..basename},
		interval = 1,
		chance = 1,
		action = function(pos)
			local groups = minetest.registered_nodes[minetest.get_node(pos).name].groups

			--get all input and output directions for processing
			local inputs, output = {}, {}
			for _,dir in ipairs(dirs) do
				local v = minetest.string_to_pos(vector_dirs[dir])
				local p = vector.add(pos, v)
				if groups["duct_connect_"..dir] == 1 and ductworks.valid_src(p, nil, basename) then
					table.insert(inputs, p)
				elseif groups["duct_connect_"..dir] == 2 then
					output = p
				end
			end

			--follow the output direction to find its final destination
			local dstpos = ductworks.find_dst(pos, basename)
			if not dstpos then return end

			--pull content from all inputs and push to the destination
			for _,srcpos in pairs(inputs) do ductworks.transfer(srcpos, dstpos, basename) end
		end
	})
end

