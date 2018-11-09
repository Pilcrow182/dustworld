local CLUMPS = false
local FEEDBACK = false

sieve = {
	wall = {
		{-6/16, 3/16, 6/16, 8/16, 8/16, 8/16}, --North
		{ 6/16, 3/16,-8/16, 8/16, 8/16, 6/16}, --East
		{-8/16, 3/16,-8/16, 6/16, 8/16,-6/16}, --South
		{-8/16, 3/16,-6/16,-6/16, 8/16, 8/16}  --West
	},
	leg = {
		{-7/16,-8/16, 6/16,-6/16, 3/16, 7/16}, --NorthWest
		{ 6/16,-8/16, 7/16, 7/16, 3/16, 6/16}, --NorthEast
		{ 6/16,-8/16,-7/16, 7/16, 3/16,-6/16}, --SouthEast
		{-7/16,-8/16,-7/16,-6/16, 3/16,-6/16}  --SouthWest
	}
}

survivalist.siftable = {}

function survivalist.check_siftable(itemname)
	local output = false
	for _,name in ipairs(survivalist.siftable) do
		if itemname == name[1] then output = name[2] end
	end
	return output
end

minetest.register_node("survivalist:sieve",{
	description = "Sieve",
	tiles = {"survivalist_sieve_bottom.png", "survivalist_sieve_bottom.png", "survivalist_barrel.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			sieve.wall[1], sieve.wall[2], sieve.wall[3], sieve.wall[4],
			sieve.leg[1], sieve.leg[2], sieve.leg[3], sieve.leg[4],
			{-6/16, 3/16,-6/16, 6/16, 4/16, 6/16}, --Mesh
		}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack then return end
		local siftable = survivalist.check_siftable(itemstack:get_name())
		if siftable ~= false then
			minetest.set_node(pos, {name="survivalist:sieve_"..siftable.."_1"})
			itemstack:take_item(1)
			return itemstack
		end
	end,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

function survivalist.give_sifted(itemstack, player, droprates, siftee)
	local j, output = nil, nil
	for i=1,#droprates do
		if math.random(1,2) == 2 then j=1+#droprates-i else j=i end
		if math.random(1,droprates[j].rarity) == math.ceil(droprates[j].rarity/2) then output = droprates[j].items[1] break end
	end
	if not output and FEEDBACK == true and math.random(1,2) == 2 then output = siftee end
	if output then survivalist.hacky_give_item(player, output, 1, itemstack) end
	return itemstack
end

function survivalist.register_siftable(longname, def)
	local nicename, changes = string.gsub(longname, ":", "_")

	table.insert(survivalist.siftable, {longname, nicename})

	local base_image = "survivalist_seed_planted.png"
	if minetest.registered_items[longname] and minetest.registered_items[longname].tiles then base_image = minetest.registered_items[longname].tiles[1] end

	local droprates = {}
	for _,name in ipairs(def.droprates) do
		table.insert(droprates, {items = {name[1]}, rarity = name[2]})
	end

	local fullness = {9, 7, 5}

	for i=1,2 do
		minetest.register_node(":survivalist:sieve_"..nicename.."_"..i,{
			tiles = {base_image.."^survivalist_sieve_top.png", base_image.."^survivalist_sieve_bottom.png", base_image.."^survivalist_sieve_side.png"},
			drawtype = "nodebox",
			paramtype = "light",
			node_box = {
				type = "fixed",
				fixed = {
					sieve.wall[1], sieve.wall[2], sieve.wall[3], sieve.wall[4],
					sieve.leg[1], sieve.leg[2], sieve.leg[3], sieve.leg[4],
					{-6/16, 3/16,-6/16, 6/16, fullness[i]/16, 6/16}
				}
			},
			on_rightclick = function(pos, node, clicker)
				if CLUMPS == true and math.random(1,4) < 3 then return end
				minetest.set_node(pos, {name="survivalist:sieve_"..nicename.."_"..i+1})
			end,
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		})
	end

	minetest.register_node(":survivalist:sieve_"..nicename.."_3",{
		tiles = {base_image.."^survivalist_sieve_top.png", base_image.."^survivalist_sieve_bottom.png", base_image.."^survivalist_sieve_side.png"},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				sieve.wall[1], sieve.wall[2], sieve.wall[3], sieve.wall[4],
				sieve.leg[1], sieve.leg[2], sieve.leg[3], sieve.leg[4],
				{-6/16, 3/16,-6/16, 6/16, fullness[3]/16, 6/16}
			}
		},
		on_rightclick = function(pos, node, clicker, itemstack)
			if CLUMPS == true and math.random(1,4) < 3 then return end
			survivalist.give_sifted(itemstack, clicker, droprates, longname) -- minetest.node_dig(pos, node, clicker)
			minetest.set_node(pos, {name="survivalist:sieve"})
		end,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		drop = {
			max_items = 1,
			items = droprates
		},
	})
end

survivalist.register_siftable("default:dirt", {
	droprates = {
		{'survivalist:acorn', 5},
		{'default:mese_crystal_fragment', 5},
		{'animalmaterials:bone', 6},
		{'survivalist:apple_core', 7},
		{'survivalist:rock', 9},
		{'survivalist:grass_seed', 10},
		{'survivalist:copper_fragment', 15},
		{'survivalist:iron_fragment', 20}
	}
})

survivalist.register_siftable("wasteland:dust", {
	droprates = {
		{'bonemeal:bonemeal', 5},
		{'survivalist:rock', 6},
		{'survivalist:mese_dust', 7},
		{'survivalist:iron_fragment', 8},
		{'survivalist:copper_fragment', 12},
		{'flint:flintstone', 16},
		{'survivalist:acorn', 18},
		{'survivalist:apple_core', 20}
	}
})

survivalist.register_siftable("default:gravel", {
	droprates = {
		{'default:mese_crystal_fragment', 4},
		{'flint:flintstone', 5},
		{'survivalist:rock', 5},
		{'survivalist:iron_fragment', 6},
		{'survivalist:copper_fragment', 7},
		{'animalmaterials:bone', 14},
		{'survivalist:broken_iron_ingot', 24},
		{'survivalist:broken_copper_ingot', 28}
	}
})

survivalist.register_siftable("default:sand", {
	droprates = {
		{'survivalist:salt', 10},
		{'bonemeal:bonemeal', 10},
		{'survivalist:copper_fragment', 10},
		{'survivalist:mese_dust', 10},
		{'survivalist:iron_fragment', 15},
		{'animalmaterials:bone', 20},
		{'survivalist:gold_fragment', 25},
		{'survivalist:rock', 30}
	}
})

survivalist.register_siftable("default:desert_sand", {
	droprates = {
		{'default:clay', 5},
		{'survivalist:copper_fragment', 7},
		{'survivalist:iron_fragment', 8},
		{'default:mese_crystal_fragment', 10},
		{'survivalist:gold_fragment', 20},
		{'animalmaterials:bone', 20},
		{'survivalist:broken_copper_ingot', 24},
		{'survivalist:broken_iron_ingot', 28}
	}
})

-- BASE DROP RATES
-- average    : 6, 7,  7,  8, 13, 17, 22, 26
-- linear     : 5, 8, 11, 14, 17, 20, 23, 26
-- curve(0.6) : 5, 6,  8, 10, 13, 17, 21, 26
