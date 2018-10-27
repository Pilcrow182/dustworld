local itemduct = {}

local node_to_io = {  -- i/o lookup. the first three values are input direction(+1), the last three are output(+1). example: "112110" expands to input={0,0,1} output={0,0,-1}
	["mechanism:itemduct_straight"] = {
		 [0] = "112110",  --	north	south
		 [1] = "211011",  --	east	west
		 [2] = "110112",  --	south	north
		 [3] = "011211",  --	west	east
		 [4] = "101121",  --	down	up
		 [8] = "121101",  --	up	down
	},
	["mechanism:itemduct_bent"] = {
		 [0] = "112211",  --	north	east
		 [1] = "211110",  --	east	north
		 [2] = "110011",  --	south	east
		 [3] = "011112",  --	west	south
		 [4] = "101211",  --	down	east
		 [5] = "211121",  --	east	up
		 [6] = "121011",  --	up	west
		 [7] = "011101",  --	west	down
		 [8] = "121211",  --	up	east
		 [9] = "211101",  --	east	down
		[10] = "101011",  --	down	west
		[11] = "011121",  --	west	up
		[12] = "112101",  --	north	down
		[13] = "101110",  --	down	south
		[14] = "110121",  --	south	up
		[15] = "121112",  --	up	north
		[16] = "112121",  --	north	up
		[17] = "121110",  --	up	south
		[18] = "110101",  --	south	down
		[19] = "101112",  --	down	north
		[20] = "112011",  --	north	west
		[21] = "011110",  --	west	south
		[22] = "110211",  --	south	east
		[23] = "211112",  --	east	north
	},
}

local io_to_node = {}
for name,p2_to_io in pairs(node_to_io) do for param2,io in pairs(p2_to_io) do io_to_node[io] = {name=name, param2=param2} end end

-- print(minetest.serialize(io_to_node))

itemduct.tables_to_io = function(tin, tout)
	local x0 = tin.x + 1
	local y0 = tin.y + 1
	local z0 = tin.z + 1
	local x1 = tout.x + 1
	local y1 = tout.y + 1
	local z1 = tout.z + 1
	return x0..y0..z0..x1..y1..z1
end

itemduct.io_to_tables = function(io)
	if not io then return false, false end
	local x0 = tonumber(io:sub(1,1)) - 1
	local y0 = tonumber(io:sub(2,2)) - 1
	local z0 = tonumber(io:sub(3,3)) - 1
	local x1 = tonumber(io:sub(4,4)) - 1
	local y1 = tonumber(io:sub(5,5)) - 1
	local z1 = tonumber(io:sub(6,6)) - 1
	return {x = x0, y = y0, z = z0},{x = x1, y = y1, z = z1}
end

itemduct.postables_to_dirtable = function(tin, tout)
	return {x = tout.x - tin.x, y = tout.y - tin.y, z = tout.z - tin.z}
end

itemduct.dirtable_to_postables = function(pos, tdir)
	return {x = pos.x + tdir.x, y = pos.y + tdir.y, z = pos.z + tdir.z}
end

itemduct.get_pipe = function(io)
	if io_to_node[io] ~= nil then return io_to_node[io] end
	return {name = "mechanism:itemduct_straight", param2 = 0}
end

itemduct.update_output = function(pos, outpos)
	if minetest.get_item_group(minetest.get_node(pos).name, "hopper") ~= 3 then return false end
	local node = minetest.get_node(pos)
	local name = node.name
	local param2 = node.param2

	if (not node_to_io[name]) or (not node_to_io[name][param2]) then return false end

	local indir, oldoutdir = itemduct.io_to_tables(node_to_io[name][param2])
	local outdir = itemduct.postables_to_dirtable(pos, outpos)
	if minetest.pos_to_string(indir) == minetest.pos_to_string(outdir) then indir = oldoutdir end
	local newio = itemduct.tables_to_io(indir, outdir)

	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	minetest.set_node(pos, itemduct.get_pipe(newio))
	meta:from_table(meta0)
end

itemduct.place_pipe = function(itemstack, placer, pointed_thing)
	if ( not pointed_thing ) or ( pointed_thing.type ~= "node" ) then return itemstack end
	local p0, p1 = pointed_thing.under, pointed_thing.above

	if placer and not placer:get_player_control().sneak then
		local n = minetest.get_node(p0)
		local nn = n.name
		if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
			return minetest.registered_nodes[nn].on_rightclick(p0, n, placer, itemstack) or itemstack, false
		end
	end

	if not minetest.registered_nodes[minetest.get_node(p1).name].buildable_to then return itemstack end
	
	local input = itemduct.postables_to_dirtable(p1, p0)
	local output = itemduct.postables_to_dirtable(p0, p1)
	local io = itemduct.tables_to_io(input, output)
	
	minetest.set_node(p1, itemduct.get_pipe(io))
	itemduct.update_output(p0, p1)

	itemstack:take_item()
	return itemstack
end

itemduct.dig_pipe = function(pos, player)
	local meta = minetest.get_meta(pos)
	local stored = meta:get_string("stored")
	local amount = tonumber(meta:get_string("amount")) or 0
	local wear = tonumber(meta:get_string("wear")) or 0
	if stored ~= "" then
		minetest.add_item(pos, {name=stored, count=amount, wear=wear})
		meta:set_string("stored", "")
		meta:set_string("amount", "0")
		meta:set_string("wear", "0")
		meta:set_string("infotext", "")
	end
	return true
end

itemduct.register_pipe = function(name, def)
	minetest.register_node("mechanism:itemduct"..name,{
		description = "Item Pipe",
		drawtype = "nodebox",
		inventory_image = "mechanism_itemduct_inv.png",
		wield_image = "mechanism_itemduct_inv.png",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		is_ground_content = false,
		node_box = {type = "fixed", fixed = def.model},
		on_place = function(itemstack, placer, pointed_thing) return itemduct.place_pipe(itemstack, placer, pointed_thing) end,
		can_dig = function(pos,player) return itemduct.dig_pipe(pos,player) end,
		groups = {hopper=3,metastorage=1,cracky=2,oddly_breakable_by_hand=1,not_in_creative_inventory=def.no_creative},
		sounds = default.node_sound_stone_defaults(),
		drop = "mechanism:itemduct"
	})
	
	local fuelduct_tiles = {}
	for k,v in ipairs(def.tiles) do
		fuelduct_tiles[k] = v:gsub("mechanism_itemduct.png", "mechanism_fuelduct.png")
	end

	minetest.register_node("mechanism:fuelduct"..name,{
		description = "Fuel Pipe",
		drawtype = "nodebox",
		inventory_image = "mechanism_itemduct_inv.png",
		wield_image = "mechanism_itemduct_inv.png",
		tiles = fuelduct_tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		is_ground_content = false,
		node_box = {type = "fixed", fixed = def.model},
		on_place = function(itemstack, placer, pointed_thing) return itemduct.place_pipe(itemstack, placer, pointed_thing) end,
		can_dig = function(pos,player) return itemduct.dig_pipe(pos,player) end,
		groups = {hopper=3,metastorage=1,cracky=2,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
		sounds = default.node_sound_stone_defaults(),
		drop = "mechanism:itemduct"
	})
end

itemduct.register_pipe("",{
	tiles = {"mechanism_hopper.png"},
	fixed = {
		{-0.125,-0.125,-0.125,0.125,0.125,0.125},
	},
	no_creative = 0
})

itemduct.register_pipe("_straight", {
	tiles = {
		"mechanism_itemduct.png^[transformR270",
		"mechanism_itemduct.png^[transformR90",
		"mechanism_itemduct.png^[transformR180",
		"mechanism_itemduct.png^[transformR0",
		"mechanism_itemduct_out.png^[transformR180",
		"mechanism_itemduct_in.png^[transformR0",
	},
	model = {
		{-0.125,-0.125,-0.5,0.125,0.125,0.5}, --north_south
	},
	no_creative = 1
})

itemduct.register_pipe("_bent", {
	tiles = {
		"mechanism_itemduct.png",
		"mechanism_itemduct.png",
		"mechanism_itemduct_in.png",
		"mechanism_itemduct.png",
		"mechanism_itemduct_out.png",
		"mechanism_itemduct.png",
	},
	model = {
		{-0.125,-0.125,-0.125,0.125,0.125,0.5}, --north
		{-0.125,-0.125,-0.125,0.5,0.125,0.125}, --east
	},
	no_creative = 1
})

minetest.register_craft({
	output = 'mechanism:itemduct 8',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		{'', '', ''},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

if minetest.get_modpath("flint") ~= nil then
	minetest.register_craft({
		output = 'mechanism:itemduct 4',
		recipe = {
			{'flint:flintstone', 'flint:flintstone', 'flint:flintstone'},
			{'', '', ''},
			{'flint:flintstone', 'flint:flintstone', 'flint:flintstone'},
		}
	})
end

minetest.register_abm({
	nodenames = {"mechanism:itemduct_straight", "mechanism:itemduct_bent"},
	interval = 2,
	chance = 1,
	action = function(pos)
		minetest.after(0, function()
			local node = minetest.get_node(pos)
			local name = node.name
			local param2 = node.param2

-- 			if (not node_to_io[name]) or (not node_to_io[name][param2]) then return false end

			local indir, outdir = itemduct.io_to_tables(node_to_io[name][param2])
			if not indir or not outdir then return false end

			local inpos = itemduct.dirtable_to_postables(pos, indir)
			local outpos = itemduct.dirtable_to_postables(pos, outdir)

			if minetest.get_item_group(minetest.get_node(inpos).name, "hopper") == 0 then	-- make sure source node is not a hopper
				mechanism.pushpull(inpos, pos)						-- pull items from source inventory
			end
			minetest.after(1, function()							-- wait one second, to prevent infinite loops
				mechanism.pushpull(pos, outpos)						-- push items into destination inventory
			end)
		end)
	end
})

minetest.register_abm({
	nodenames = {"mechanism:fuelduct_straight", "mechanism:fuelduct_bent"},
	interval = 2,
	chance = 1,
	action = function(pos)
		minetest.after(0, function()
			local node = minetest.get_node(pos)
			local name = node.name
			local id_name = name:gsub("fuelduct", "itemduct")
			local param2 = node.param2

-- 			if (not node_to_io[id_name]) or (not node_to_io[id_name][param2]) then return false end

			local indir, outdir = itemduct.io_to_tables(node_to_io[id_name][param2])
			if not indir or not outdir then return false end

			local inpos = itemduct.dirtable_to_postables(pos, indir)
			local outpos = itemduct.dirtable_to_postables(pos, outdir)

			if minetest.get_item_group(minetest.get_node(inpos).name, "hopper") == 0 then	-- make sure source node is not a hopper
				mechanism.pushpull(inpos, pos)						-- pull items from source inventory
			end
			minetest.after(1, function()							-- wait one second, to prevent infinite loops
				mechanism.pushpull(pos, outpos, false, true)				-- push items/fuel into destination inventory
			end)
		end)
	end
})

minetest.register_craftitem("mechanism:pipe_wrench", {
	description = "Pipe Wrench",
	inventory_image = "mechanism_pipe_wrench.png",
	wield_image = "mechanism_pipe_wrench.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	on_use = function(itemstack, user, pointed_thing)
		if not pointed_thing.under then return end

		local node = minetest.get_node(pointed_thing.under)
		local name, param2 = node.name, node.param2

		if minetest.get_item_group(name, "hopper") ~= 3 then return end

		local id_name = name:gsub("fuelduct", "itemduct")
		local indir, outdir = itemduct.io_to_tables(node_to_io[id_name][param2])
		local newio = itemduct.tables_to_io(outdir, indir)

		local meta = minetest.get_meta(pointed_thing.under)
		local meta0 = meta:to_table()
		minetest.set_node(pointed_thing.under, itemduct.get_pipe(newio))
		meta:from_table(meta0)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing.under then return end

		local node = minetest.get_node(pointed_thing.under)
		local name, param2 = node.name, node.param2

		if minetest.get_item_group(name, "hopper") ~= 3 then return end

		local newname = name:gsub("itemduct", "fuelduct")
		if name:find("fuelduct") then
			newname = name:gsub("fuelduct", "itemduct")
		end

		local meta = minetest.get_meta(pointed_thing.under)
		local meta0 = meta:to_table()
		minetest.set_node(pointed_thing.under, {name=newname, param2=param2})
		meta:from_table(meta0)
	end,
	stack_max = 1
})

minetest.register_craft({
	output = 'mechanism:pipe_wrench',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot'},
		{'', 'default:steel_ingot'},
	}
})
