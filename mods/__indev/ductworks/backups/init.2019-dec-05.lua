ductworks = {}

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
for i = 1,6 do dirs[dirs[i]], vector_dirs[vector_dirs[dirs[i]]] = i, dirs[i] end

local oppos = {north = "south", south = "north", up = "down", down = "up", east = "west", west = "east"}

local b2n = {[true] = 1, [false] = 0}

local get_tiles = function(basename, dstdir, is_dynamic)
	local tiles = {}

	 -- NOTE: tiles order is different from coordinate order for some reason
	local oppos = {up = "down", down = "up", east = "west", west = "east", north = "south", south = "north"}

	for i,face in ipairs({"up", "down", "east", "west", "north", "south"}) do
		if face == dstdir then tiles[i] = "ductworks_base.png" end
		if face == oppos[dstdir] then tiles[i] = "ductworks_base.png" end
	end

	for dir,rot in pairs({north = 0, east = 270, south = 180, west = 90}) do
		if dir == dstdir then tiles[1] = "ductworks_base.png^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
	end
	for dir,rot in pairs({south = 0, west = 90, north = 180, east = 270}) do
		if dir == dstdir then tiles[2] = "ductworks_base.png^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
	end
	for dir, rot in pairs({up = 0, south = 90, down = 180, north = 270}) do
		if dir == dstdir then tiles[3] = "ductworks_base.png^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
	end
	for dir, rot in pairs({up = 0, north = 90, down = 180, south = 270}) do
		if dir == dstdir then tiles[4] = "ductworks_base.png^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
	end
	for dir, rot in pairs({up = 0, west = 270, down = 180, east = 90}) do
		if dir == dstdir then tiles[5] = "ductworks_base.png^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
	end
	for dir, rot in pairs({up = 0, east = 270, down = 180, west = 90}) do
		if dir == dstdir then tiles[6] = "ductworks_base.png^ductworks_"..basename.."_arrow.png^[transformR"..rot.."]" break end
	end

	if is_dynamic then
		for i,_ in pairs(tiles) do
			tiles[i] = tiles[i].."^ductworks_dynamic.png"
		end
	end

	return tiles
end

local create_duct = function(basename, connects, dstdir)
	local groups = {cracky = 2, oddly_breakable_by_hand = 1, not_in_creative_inventory = 1}
	groups[basename] = 1
	local id = ""

	local shape = {boxes[7]}

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

	groups["dynamic"] = 1

	minetest.register_node("ductworks:"..basename.."_"..id.."_dynamic", {
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
	if minetest.get_item_group(node.name, duct_type) > 0 and minetest.get_item_group(node.name, "dynamic") > 0 or minetest.get_item_group(node.name, "duct_connect_"..dstdir) == 2 then
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

ductworks.register_duct = function(basename, description)
	-- NOTE: This function registers 186 different shapes for each kind of duct, in both dynamic and static modes
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

	local vector_to_nodename = {
		["(1,0,0)"] = "ductworks:"..basename.."_210000_dynamic",
		["(-1,0,0)"] = "ductworks:"..basename.."_120000_dynamic",
		["(0,1,0)"] = "ductworks:"..basename.."_002100_dynamic",
		["(0,-1,0)"] = "ductworks:"..basename.."_001200_dynamic",
		["(0,0,1)"] = "ductworks:"..basename.."_000021_dynamic",
		["(0,0,-1)"] = "ductworks:"..basename.."_000012_dynamic"
	}

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

			local dir = vector.direction(pointed_thing.under, pointed_thing.above)

			local to_place = vector_to_nodename[minetest.pos_to_string(dir)]
			if not to_place then return itemstack end

			minetest.set_node(pointed_thing.above, {name = to_place})

			-- transform pointed_thing.under, if possible
			-- TODO: Split this block out to make a transform_duct(pos, newdst) function
			local node_under = minetest.get_node(pointed_thing.under)
			if ( node_under and node_under.name and minetest.get_item_group(node_under.name, basename) > 0 and minetest.get_item_group(node_under.name, "dynamic") > 0 ) then
				local connects = {}
				local cdir = vector_dirs[minetest.pos_to_string(dir)]
				local newname = "ductworks:"..basename.."_"
				for _,dirname in ipairs(dirs) do
					if dirname == cdir then
						newname = newname.."2"
					else
						local connect_to_dir = minetest.get_item_group(node_under.name, "duct_connect_"..dirname)
						if connect_to_dir == 2 then
							local v = minetest.string_to_pos(vector_dirs[dirname])
							local checkpos = {x = pointed_thing.under.x + v.x, y = pointed_thing.under.y + v.y, z = pointed_thing.under.z + v.z}
							if valid_src(checkpos, oppos[dirname], basename) then
								newname = newname.."1"
							else
								newname = newname.."0"
							end
						elseif connect_to_dir == 1 then
							newname = newname.."1"
						else
							newname = newname.."0"
						end
					end
				end
				newname =  newname.."_dynamic"
				minetest.set_node(pointed_thing.under, {name = newname})
			end

			-- transform self, if possible (create i/o arm toward adjacent dynamic nodes and/or nodes pointed at self)
			-- let the eventual minetest.register_on_placenode function handle transforming surrounding nodes

			itemstack:take_item()
			return itemstack
		end
	})
end

ductworks.register_duct("itemduct", "Itemduct")
ductworks.register_duct("fuelduct", "Itemduct (fuel)")
ductworks.register_duct("powerduct", "Powerduct")
ductworks.register_duct("liquiduct", "Liquiduct")

