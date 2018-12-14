instacabin = {}
instacabin.schems = {}

local file_exists = function(filename)
	local file = io.open(filename,"r")
	if file ~= nil then
		io.close(file)
		return true
	else
		return false
	end
end

instacabin.register_cabin = function(name, entrance)
	local schem = minetest.get_modpath("instacabin")..name:gsub(".*:", "/models/")..".lua"
	if schem and file_exists(schem) then
		dofile(schem)
	else
		minetest.log("action", "[MOD] instacabin -- Error loading schematic for "..name)
		return false
	end

	local size = instacabin.schems[name:gsub(".*:", "")].size
	local spawn_transform = {
		  ["0"] = {x = -entrance.x,          y = -entrance.y, z = -entrance.z         },
		 ["90"] = {x = -entrance.z,          y = -entrance.y, z =  entrance.x-size.x+1},
		["180"] = {x =  entrance.x-size.x+1, y = -entrance.y, z =  entrance.z-size.z+1},
		["270"] = {x =  entrance.z-size.z+1, y = -entrance.y, z = -entrance.x         }
	}

	local size_transform = {
		  ["0"] = {x =  size.x-1, y =  size.y-1, z =  size.z-1},
		 ["90"] = {x =  size.z-1, y =  size.y-1, z =  size.x-1},
		["180"] = {x =  size.x-1, y =  size.y-1, z =  size.z-1},
		["270"] = {x =  size.z-1, y =  size.y-1, z =  size.x-1}
	}

	local filename = name:gsub(":", "_")
	minetest.register_craftitem(name, {
		description = string.gsub(" Instant "..name:gsub(".*:", ""):gsub("_", " "), "%W%l", string.upper):sub(2),
		inventory_image = filename..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if not ( pointed_thing and pointed_thing.under and pointed_thing.above ) then return end
			local node_under = minetest.get_node(pointed_thing.under)
			if minetest.registered_nodes[node_under.name].on_rightclick then
				return minetest.registered_nodes[node_under.name].on_rightclick(pointed_thing.under, node_under, placer, itemstack)
			else
				local pos = pointed_thing.above
				local rotation = 0
				local look_dir = placer:get_look_dir()
				if math.abs(look_dir.z) >  math.abs(look_dir.x) and look_dir.z >  0 then rotation =   0 end
				if math.abs(look_dir.x) >= math.abs(look_dir.z) and look_dir.x >  0 then rotation =  90 end
				if math.abs(look_dir.z) >  math.abs(look_dir.x) and look_dir.z <= 0 then rotation = 180 end
				if math.abs(look_dir.x) >= math.abs(look_dir.z) and look_dir.x <= 0 then rotation = 270 end

				local offset = spawn_transform[tostring(rotation)]
				pos = {x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z + offset.z}

				local playername = placer:get_player_name()
				minetest.log("action", "[MOD] instacabin -- Spawning building at pos "..minetest.pos_to_string(pos)..". Please wait...")

				minetest.place_schematic(pos, instacabin.schems[name:gsub(".*:", "")], rotation, nil, true)

				local endoffset = size_transform[tostring(rotation)]
				endpos = {x = pos.x + endoffset.x, y = pos.y + endoffset.y, z = pos.z + endoffset.z}

				for x = math.min(pos.x, endpos.x), math.max(pos.x, endpos.x) do
					for y = math.min(endpos.y, pos.y), math.max(endpos.y, pos.y) do
						for z = math.min(pos.z, endpos.z), math.max(pos.z, endpos.z) do
							local node = minetest.get_node({x = x, y = y, z = z})
							if minetest.registered_nodes[node.name].on_construct then
								minetest.registered_nodes[node.name].on_construct({x = x, y = y, z = z})
							end
						end
					end
				end

				itemstack:take_item()
			end
			return itemstack
		end
	})
end

local buildlist = {
	["instacabin:shack"]           = {x =  3, y = 1, z = 0},

	["instacabin:tower"]           = {x =  4, y = 0, z = 0},
	["instacabin:large_tower"]     = {x =  4, y = 0, z = 0},
	["instacabin:apartment"]       = {x =  4, y = 1, z = 0},

	["instacabin:warehouse"]       = {x =  3, y = 0, z = 1},
	["instacabin:large_warehouse"] = {x =  5, y = 0, z = 1},
	["instacabin:vault"]           = {x =  7, y = 0, z = 1},

	["instacabin:house"]           = {x =  4, y = 1, z = 1},
	["instacabin:large_house"]     = {x =  3, y = 7, z = 1},
	["instacabin:mansion"]         = {x = 17, y = 2, z = 1},

	["instacabin:garden"]          = {x =  3, y = 2, z = 0},
	["instacabin:large_garden"]    = {x =  4, y = 2, z = 0},
	["instacabin:greenhouse"]      = {x =  8, y = 1, z = 1}
}

for name, entrance in pairs(buildlist) do
	instacabin.register_cabin(name, entrance)
end

dofile(minetest.get_modpath("instacabin").."/crafting.lua")

