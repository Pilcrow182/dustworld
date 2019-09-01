-- flolands 0.2.1 by paramat.
-- VoxelManip adaptation by Pilcrow.
-- License WTFPL, see license.txt.

-- Editable parameters.

local FLOLANDS = true -- Enable floating island generation (true/false).
local FLOYMIN = 768 -- 768 -- Approximate minimum altitude, lowest level of islands will generate in chunks that contain this altitude.
local FLOLEV = 3 -- 3 -- Number of island levels.
local FLOXMIN = -16384 -- -16384 -- Approximate edges of island area.
local FLOXMAX = 16384 -- 16384
local FLOZMIN = -16384 -- -16384
local FLOZMAX = 16384 -- 16384
local RAR = 0.4 -- 0.4 -- Island rarity in chunk layer. -0.4 = thick layer with holes, 0 = 50%, 0.4 = desert rarity, 0.7 = very rare.
local AMPY = 24 -- 24 -- Amplitude of island centre y variation.
local TGRAD = 24 -- 24 -- Noise gradient to create top surface. Tallness of island top.
local BGRAD = 24 -- 24 -- Noise gradient to create bottom surface. Tallness of island bottom.
local MATCHA = 2197 -- 2197 = 13^3 -- 1/x chance of rare material.
local FLOCHA = 3 -- 23 -- 1/x chance rare material is floatcrystalblock.
local DEBUG = false -- Enable debugging output (true/false).
local VERBOSE = false -- Enable MORE debugging output (true/false).

local SEEDDIFF1 = 3683 -- 3D perlin1 for island generation.
local OCTAVES1 = 5 -- 5
local PERSISTENCE1 = 0.5 -- 0.5
local SCALE1 = 64 -- 64 -- Approximate scale of floating islands, if you double this add 1 to OCTAVES1.

local SEEDDIFF2 = 9292 -- 3D perlin2 for caves.
local OCTAVES2 = 2 -- 2
local PERSISTENCE2 = 0.5 -- 0.5
local SCALE2 = 8 -- 8

local SEEDDIFF3 = 6412 -- 2D perlin3 for island centre y variation.
local OCTAVES3 = 2 -- 2
local PERSISTENCE3 = 0.5 -- 0.5
local SCALE3 = 128 -- 128 -- Approximate horizontal distance over which island centre y varies.

-- Stuff.

flolands = {}

local floyminq = 80 * math.floor((FLOYMIN + 32) / 80) - 32

-- Nodes.

minetest.register_node("flolands:floatstone", {
	description = "Floatstone",
	tiles = {"flolands_floatstone.png"},
	groups = {cracky=3, stone=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:floatstonebrick", {
	description = "Floatstone Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"flolands_floatstone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:floatstone_block", {
	description = "Floatstone Block",
	tiles = {"flolands_floatstone_block.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:talinite_ore", {
	description = "Talinite Ore",
	tiles = {"flolands_floatstone.png^gloopores_mineral_talinite.png"},
	is_ground_content = true,
	light_source = 8,
	groups = {cracky=3},
	drop = 'gloopores:talinite_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:floatsand", {
	description = "Turquoise Sand",
	tiles = {"flolands_floatsand.png"},
	groups = {crumbly=3, falling_node=1, sand=1},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("flolands:floatsandstone", {
	description = "Turquoise Sandstone",
	tiles = {"flolands_floatsandstone.png"},
	groups = {crumbly=2, cracky=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:floatsandstonebrick", {
	description = "Turquoise Sandstone Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"flolands_floatsandstone_brick.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:floatsandstone_block", {
	description = "Turquoise Sandstone Block",
	tiles = {"flolands_floatsandstone_block.png"},
	is_ground_content = false,
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("flolands:floatcrystalblock", {
	description = "Floc Block",
	tiles = {"flolands_floatcrystalblock.png"}, 
	groups = {cracky=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("flolands:floatglass", {
	description = "High Quality Glass",
	drawtype = "glasslike",
	tiles = {"flolands_floatglass.png"},
	inventory_image = minetest.inventorycube("flolands_floatglass.png"),
	paramtype = "light",
	sunlight_propagates = true,
	groups = {snappy=2,cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
})

-- Item.

minetest.register_craftitem("flolands:floatcrystal", {
	description = "Floc Crystal",
	inventory_image = "flolands_floatcrystal.png",
})

-- Crafting.

minetest.register_craft({
	output = 'flolands:floatstonebrick 4',
	recipe = {
		{'flolands:floatstone', 'flolands:floatstone'},
		{'flolands:floatstone', 'flolands:floatstone'},
	}
})

minetest.register_craft({
	output = 'flolands:floatstone_block 9',
	recipe = {
		{'flolands:floatstone', 'flolands:floatstone', 'flolands:floatstone'},
		{'flolands:floatstone', 'flolands:floatstone', 'flolands:floatstone'},
		{'flolands:floatstone', 'flolands:floatstone', 'flolands:floatstone'},
	}
})

minetest.register_craft({
	output = "flolands:floatsandstone",
	recipe = {
		{"flolands:floatsand", "flolands:floatsand"},
		{"flolands:floatsand", "flolands:floatsand"},
	}
})

minetest.register_craft({
	output = "flolands:floatsandstonebrick 4",
	recipe = {
		{"flolands:floatsandstone", "flolands:floatsandstone"},
		{"flolands:floatsandstone", "flolands:floatsandstone"},
	}
})

minetest.register_craft({
	output = "flolands:floatsandstone_block 9",
	recipe = {
		{"flolands:floatsandstone", "flolands:floatsandstone", "flolands:floatsandstone"},
		{"flolands:floatsandstone", "flolands:floatsandstone", "flolands:floatsandstone"},
		{"flolands:floatsandstone", "flolands:floatsandstone", "flolands:floatsandstone"},
	}
})

minetest.register_craft({
	output = "flolands:floatsand 4",
	recipe = {
		{"flolands:floatsandstone"},
	}
})

minetest.register_craft({
	output = "flolands:floatcrystalblock",
	recipe = {
		{"flolands:floatcrystal", "flolands:floatcrystal", "flolands:floatcrystal"},
		{"flolands:floatcrystal", "flolands:floatcrystal", "flolands:floatcrystal"},
		{"flolands:floatcrystal", "flolands:floatcrystal", "flolands:floatcrystal"},
	}
})

minetest.register_craft({
	output = "flolands:floatcrystal 9",
	recipe = {
		{"flolands:floatcrystalblock"},
	}
})

-- Cooking.

minetest.register_craft({
	type = "cooking",
	output = "flolands:floatglass",
	recipe = "flolands:floatsand",
})

-- On generated function.

if FLOLANDS then
	minetest.register_on_generated(function(minp, maxp, seed)
		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
		local data = vm:get_data()
		
		local c_floatstone = minetest.get_content_id("flolands:floatstone")
		local c_talinite = minetest.get_content_id("flolands:talinite_ore")
		local c_mese = minetest.get_content_id("default:mese")
		local c_floc = minetest.get_content_id("flolands:floatcrystalblock")
		
		local get_perlin = minetest.get_perlin
		local get_node = minetest.get_node
		local add_node = minetest.add_node
		
		local tree_spawner = {}

		if minp.y >= floyminq and minp.y <= floyminq + (FLOLEV - 1) * 80
		and minp.x >= FLOXMIN and maxp.x <= FLOXMAX
		and minp.z >= FLOZMIN and maxp.z <= FLOZMAX then
			local fl_starttime = os.clock()
			if DEBUG then
				local message = "[flolands] Lag warning: Generating structure"
				if VERBOSE then
					message = message.." at ("..math.ceil((minp.x+maxp.x)/2)..","..math.ceil((minp.y+maxp.y)/2)..","..math.ceil((minp.z+maxp.z)/2)..")"
				end
				minetest.log("action", message)
				minetest.chat_send_all(message)
			end
			-- Generate Structure.
			local perlin1 = get_perlin(SEEDDIFF1 + minp.y * 100, OCTAVES1, PERSISTENCE1, SCALE1)
			local perlin2 = get_perlin(SEEDDIFF2 + minp.y * 100, OCTAVES2, PERSISTENCE2, SCALE2)
			local perlin3 = get_perlin(SEEDDIFF3 + minp.y * 100, OCTAVES3, PERSISTENCE3, SCALE3)
			local xl = maxp.x - minp.x
			local yl = maxp.y - minp.y
			local zl = maxp.z - minp.z
			local x0 = minp.x
			local y0 = minp.y
			local z0 = minp.z
			local midy = y0 + yl * 0.5
			-- Loop through columns in chunk.
			for i = 0, xl do
				local x = x0 + i
				for k = 0, zl do
					local z = z0 + k
					local noise3 = perlin3:get2d({x=x,y=z})
					local pmidy = midy + noise3 / 1.5 * AMPY
					-- Loop through nodes in column.
					for j = 0, yl do
						local y = y0 + j
						local vi = area:index(x, y, z)
						local noise1 = perlin1:get3d({x=x,y=y,z=z})
						local offset = 0
						if y > pmidy then
							offset = (y - pmidy) / TGRAD
						else
							offset = (pmidy - y) / BGRAD
						end
						-- Add floatstone or mese block.
						local noise1off = noise1 - offset - RAR
						if noise1off > 0 and noise1off < 0.7 then
							local noise2 = perlin2:get3d({x=x,y=y,z=z})
							if noise2 - noise1off > -0.7 then
								if math.random(1,MATCHA) ~= 23 then
									if math.random(1, 6) ~= 3 then
										data[vi] = c_floatstone
									else
										data[vi] = c_talinite
									end
								else
									if math.random(1,FLOCHA) ~= math.ceil(FLOCHA/2) then
										data[vi] = c_mese
									else
										data[vi] = c_floc
									end
								end
							end
						end
					end
				end
			end

			local c_air = minetest.get_content_id("air")
			local c_ignore = minetest.get_content_id("ignore")
			local c_sand = minetest.get_content_id("flolands:floatsand")
			local c_grass = minetest.get_content_id("flolife:floatgrass")
			local c_leaves = minetest.get_content_id("flolife:leaves")

			for i = 0, xl do
				local x = x0 + i
				for k = 0, zl do
					local z = z0 + k
					-- Find ground level.
					local ground_y = nil
					for y=maxp.y,minp.y,-1 do
						local vi = area:index(x, y, z)
						if data[vi] ~= c_air and data[vi] ~= c_ignore then
							ground_y = y
							break
						end
					end
					-- Add 1 or 2 nodes depth of floatsand and possibly floatgrass/floatoak.
					if ground_y then
						local y = ground_y
						local vi = area:index(x, y, z)
						local nodesbelow = {
							area:index(x, y-1, z),
							area:index(x, y-2, z),
							area:index(x, y-3, z),
							area:index(x, y-4, z)
						}
						if data[nodesbelow[1]] ~= c_air and data[nodesbelow[1]] ~= c_ignore and data[nodesbelow[1]] ~= c_leaves
						and data[nodesbelow[2]] ~= c_air and data[nodesbelow[2]] ~= c_ignore and data[nodesbelow[2]] ~= c_leaves then
							data[vi] = c_sand
							if data[nodesbelow[3]] ~= c_air and data[nodesbelow[3]] ~= c_ignore and data[nodesbelow[3]] ~= c_leaves
							and data[nodesbelow[4]] ~= c_air and data[nodesbelow[4]] ~= c_ignore and data[nodesbelow[4]] ~= c_leaves then
								data[area:index(x, y-1, z)] = c_sand
							end
							if data[area:index(x, y+1, z)] == c_air
							and math.random(0, 20) == 10 then
								if math.random(0, 8) ~= 4 then
									data[area:index(x, y+1, z)] = c_grass
								else
									tree_spawner[minetest.pos_to_string({x = x, y = y + 1, z = z})] = true
								end
							end
						end
					end
				end
			end

			vm:set_data(data)
			vm:set_lighting({day=0, night=0})
			vm:calc_lighting()
			vm:write_to_map()

			for p,_ in pairs(tree_spawner) do
				minetest.after(0.2, function(pos)
					farming:generate_tree(pos, "flolife:tree", "flolife:leaves", {"flolands:floatsand"}, {["flolife:fruit"]=20})
				end, minetest.string_to_pos(p))
			end

			local fl_gentime = (os.clock() - fl_starttime)
			if DEBUG then
				local message = "[flolands] Structure completed"
				if VERBOSE then
					message = message.." in "..fl_gentime.." seconds"
				end
				minetest.log("action", message)
				minetest.chat_send_all(message)
			end
		end
	end)
end

dofile(minetest.get_modpath("flolands").."/stairs.lua")
dofile(minetest.get_modpath("flolands").."/survivalist.lua")
