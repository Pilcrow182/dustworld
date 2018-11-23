bonemeal = {}

dofile(minetest.get_modpath("bonemeal").."/compat.lua")
dofile(minetest.get_modpath("bonemeal").."/multinode.lua")
dofile(minetest.get_modpath("bonemeal").."/tree.lua")

bonemeal.grow = function(pointed_thing)
	local trunkgen = ""
	local leavesgen = ""
	local fruitgen = ""
	local pos = pointed_thing.under
	local n = minetest.get_node(pos)
	if n.name == "" or string.find(n.name, "__fake") ~= nil then return end
	print("BONEMEAL:: Player tried growing "..n.name)
	if n.name == "default:sapling" then
		trunkgen = "default:tree"
		leavesgen = "default:leaves"
		fruitgen = "default:apple"
		minetest.set_node(pos, {name="air"})
		bonemeal.generate_tree(pos, trunkgen, leavesgen, fruitgen)

	elseif n.name == "farming_plus:banana_sapling" then
		trunkgen = "default:tree"
		leavesgen = "farming_plus:banana_leaves"
		fruitgen = "farming_plus:banana"
		minetest.set_node(pos, {name="air"})
		bonemeal.generate_tree(pos, trunkgen, leavesgen, fruitgen)

	elseif n.name == "farming_plus:cocoa_sapling" then
		trunkgen = "default:tree"
		leavesgen = "farming_plus:cocoa_leaves"
		fruitgen = "farming_plus:cocoa"
		minetest.set_node(pos, {name="air"})
		bonemeal.generate_tree(pos, trunkgen, leavesgen, fruitgen)

	elseif n.name == "flolife:sapling" then
		trunkgen = "flolife:tree"
		leavesgen = "flolife:leaves"
		fruitgen = "flolife:fruit"
		minetest.set_node(pos, {name="air"})
		bonemeal.generate_tree(pos, trunkgen, leavesgen, fruitgen)

	elseif n.name == "apple_tree:sapling" then
		trunkgen = "default:tree"
		leavesgen = "apple_tree:leaves"
		fruitgen = "apple_tree:apple"
		minetest.set_node(pos, {name="air"})
		bonemeal.generate_tree(pos, trunkgen, leavesgen, fruitgen)

	elseif n.name == "apple_tree:iron_sapling" then
		if math.random(0,2) == 1 then
			trunkgen = "apple_tree:iron_tree"
			leavesgen = "apple_tree:iron_leaves"
			fruitgen = "apple_tree:iron_apple"
			minetest.set_node(pos, {name="air"})
			bonemeal.generate_tree(pos, trunkgen, leavesgen, fruitgen)
		end

	elseif n.name == "survivalist:oak_sapling" and minetest.get_modpath("survivalist") ~= nil then
		if math.random(0,2) == 1 then
			trunkgen = "default:tree"
			leavesgen = "survivalist:oak_leaves"
			fruitgen = "survivalist:oak_leaves"
			survivalist.grow_tree(pos, trunkgen, leavesgen, fruitgen)
		end

	elseif n.name == "survivalist:apple_sapling" and minetest.get_modpath("survivalist") ~= nil then
		if math.random(0,2) == 1 then
			trunkgen = "default:tree"
			leavesgen = "survivalist:apple_leaves"
			fruitgen = "survivalist:apple"
			survivalist.grow_tree(pos, trunkgen, leavesgen, fruitgen)
		end

	elseif n.name == "snow:sapling_pine" then
		minetest.set_node(pos, {name="air"})
		snow.make_pine(pos,false)

	elseif n.name == "snow:xmas_tree" then
		minetest.set_node(pos, {name="air"})
		snow.make_pine(pos,false,true)

	elseif n.name == "ferns:sapling_tree_fern" then
		pos.y = pos.y - 1
		if math.random(0,1) == 1 then
			abstract_ferns.grow_giant_tree_fern(pos)
		else
			abstract_ferns.grow_tree_fern(pos)
		end

	elseif n.name == "ferns:sapling_giant_tree_fern" then
		pos.y = pos.y - 1
		abstract_ferns.grow_giant_tree_fern(pos)

	elseif n.name == "jungletree:sapling" or n.name == "trees:jungletree_sapling" then
		abstract_trees.grow_jungletree(pos)

	elseif n.name == "trees:sapling_palm" then
		if minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			abstract_trees.grow_palmtree(pos)
		end

	elseif n.name == "trees:sapling_mangrove" then
		local above = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		if above.name == "air" or above.name == "default:water_source" then
			abstract_trees.grow_mangrovetree(pos)
		end

	elseif n.name == "trees:sapling_conifer" then
		if minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			abstract_trees.grow_conifertree(pos)
		end

	elseif n.name == "trees:sapling_birch" then
		if minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			abstract_trees.grow_birchtree(pos)
		end

	elseif string.find(n.name, "junglegrass") ~= nil then
		minetest.set_node(pos, {name="default:junglegrass"})

	elseif string.find(n.name, "default:grass") ~= nil then
		minetest.set_node(pos, {name="default:grass_5"})

	elseif n.name == "default:dirt" then
		minetest.set_node(pos, {name="default:dirt_with_grass"})

	elseif n.name == "default:dry_shrub" then
		minetest.set_node(pos, {name="default:junglegrass"})

	elseif n.name == "poisonivy:seedling" then
		minetest.set_node(pos, {name="poisonivy:sproutling"})

	elseif n.name == "farming:weed" then
		minetest.set_node(pos, {name="default:junglegrass"})

	elseif n.name == "snow:snow" then
		node_below = minetest.get_node({x = pos.x, y = pos.y-1, z = pos.z}).name
		if node_below == "snow:dirt_with_snow" or node_below == "default:dirt_with_grass" or node_below == "default:dirt" then
			minetest.set_node(pos, {name="default:dry_shrub"})
			minetest.set_node({x = pos.x, y = pos.y-1, z = pos.z}, {name="snow:dirt_with_snow"})
		end

	elseif n.name == "flolands:floatsand" then
		plantpos = {x = pos.x, y = pos.y+1, z = pos.z}
		if minetest.get_node(plantpos).name == "air" then
			minetest.set_node(plantpos, {name="flolife:floatgrass"})
		end

	elseif n.name == "snow:dirt_with_snow" then
		plantpos = {x = pos.x, y = pos.y+1, z = pos.z}
		if minetest.get_node(plantpos).name == "air" or minetest.get_node(plantpos).name == "snow:snow" then
			minetest.set_node(plantpos, {name="default:dry_shrub"})
			minetest.set_node(pos, {name="snow:dirt_with_snow"})
		end

	elseif n.name == "default:desert_sand" then
		plantpos = {x = pos.x, y = pos.y+1, z = pos.z}
		if minetest.get_node(plantpos).name == "air" then
			spawnplants = {"default:dry_shrub", "default:cactus"}
			minetest.set_node(plantpos, {name=spawnplants[math.random(1, #spawnplants)]})
		end

	elseif n.name == "default:dirt_with_grass" then
		plantpos = {x = pos.x, y = pos.y+1, z = pos.z}
		if minetest.get_node(plantpos).name == "air" then
			spawnplants = {"default:junglegrass", "default:grass_5", "poisonivy:sproutling"}
			minetest.set_node(plantpos, {name=spawnplants[math.random(1, #spawnplants)]})
		end

	elseif string.find(n.name, "farming") ~= nil then
		farmplants = {"farming:cotton", "farming:pumpkin", "farming:wheat", "farming_plus:blueberry", "farming_plus:carrot", "farming_plus:orange", "farming_plus:potatoe", "farming_plus:rhubarb", "farming_plus:strawberry", "farming_plus:tomato"}
		for i, plant in ipairs(farmplants) do
			if string.find(n.name, plant.."_") ~= nil then
				minetest.set_node(pos, {name=plant})
			end
		end

	elseif n.name == "poisonivy:climbing" then
		p2 = minetest.get_node(pos).param2
		plantpos = {x = pos.x, y = pos.y+1, z = pos.z}
		if minetest.get_node(plantpos).name == "air" then
			minetest.set_node(plantpos, {name="poisonivy:climbing", param2=p2})
		end

	elseif n.name == "default:cactus" then
		bonemeal.multinode_grow(pos, n.name)

	elseif n.name == "default:papyrus" then
		bonemeal.multinode_grow(pos, n.name)

	else
		 return false
	end
end

minetest.register_craftitem("bonemeal:bonemeal", {
	description = "Bone Meal",
	inventory_image = "bonemeal_bonemeal.png",
	liquids_pointable = false,
	stack_max = 99,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" and minetest.get_node(pointed_thing.under).name ~= "air" then
			bonemeal.grow(pointed_thing)
			itemstack:take_item(1)
			user:set_wielded_item(itemstack)
			return itemstack
		end
	end,
})

minetest.register_node("bonemeal:bonemeal_block",{
	description = "Bonemeal Block",
	tiles = {"bonemeal_bonemeal_block.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=2},
	sounds = default.node_sound_defaults(),
})

minetest.register_craft({
	output = 'bonemeal:bonemeal 5',
	recipe = {{'animalmaterials:bone'}}
})

minetest.register_craft({
	output = 'bonemeal:bonemeal_block',
	recipe = {
		{'bonemeal:bonemeal', 'bonemeal:bonemeal'},
		{'bonemeal:bonemeal', 'bonemeal:bonemeal'},
	}
})

minetest.register_craft({
	output = 'bonemeal:bonemeal 4',
	recipe = {{'bonemeal:bonemeal_block'}}
})

minetest.register_craft({
	type = "fuel",
	recipe = "bonemeal:bonemeal",
	burntime = 4,
})

minetest.register_craft({
	type = "fuel",
	recipe = "bonemeal:bonemeal_block",
	burntime = 16,
})
