abstract_trees.trees_register_nodes_tree = function(name, sapling_rarity)


	minetest.register_node("trees:leaves_"..name, {
		description = name.." Leaves",
		drawtype = "allfaces_optional",
		tiles = {"trees_leaves_"..name..".png"},
		paramtype = "light",
		groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
		drop = {
			max_items = 1,
			items = {
				{
					-- player will get sapling with 1/sapling_rarity chance
					items = {'trees:sapling_'..name},
					rarity = sapling_rarity,
				},
				{
					-- player will get leaves only if he get no saplings,
					-- this is because max_items is 1
					items = {"trees:leaves_"..name},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
	})

	minetest.register_node("trees:tree_"..name, {
		description = name.." Tree",
		tiles = {"trees_tree_top_"..name..".png", "trees_tree_top_"..name..".png", "trees_tree_"..name..".png"},
		groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
		sounds = default.node_sound_wood_defaults(),
	})
	
	minetest.register_node("trees:wood_"..name, {
		description = name.." Wood",
		tiles = {"trees_wood_"..name..".png"},
		groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
		sounds = default.node_sound_wood_defaults(),
	})

	minetest.register_craft({
		output = 'trees:wood_'..name..' 4',
		recipe = {
			{'trees:tree_'..name},
		}
	})
	
	minetest.register_node("trees:sapling_"..name, {
		description = name.." sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles = { "trees_sapling_"..name..".png" },
		inventory_image = "trees_sapling_"..name..".png",
		wield_image = "trees_sapling_"..name..".png",
		paramtype = "light",
		walkable = false,
		groups = {
			snappy = 2,
			dig_immediate = 3,
			flammable = 2,
			sapling = 1,
		},
		sounds = default.node_sound_defaults(),
	})
	
	stairs.register_stair_and_slab(name, "trees:wood_"..name,
		{snappy=2,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		{"trees_wood_"..name..".png"},
		name.." Stair",
		name.." Slab",
		default.node_sound_wood_defaults())

	default.register_leafdecay({
		trunks = {"trees:tree_"..name},
		leaves = {"trees:leaves_"..name},
		radius = 4,
	})

	if minetest.get_modpath("survivalist") then
		minetest.override_item("trees:leaves_"..name, {
			drop = {
				max_items = 1,
				items = {
					{
						-- player will get sapling with 1/sapling_rarity chance
						items = {'trees:sapling_'..name},
						rarity = sapling_rarity,
					}
				}
			},
			on_punch = function(pos, node, puncher)
				if not puncher then return end
				local itemstack = puncher:get_wielded_item()
				local wielded = itemstack:get_name()
				if wielded == "survivalist:shears" then
					minetest.remove_node(pos)
					local drop = "trees:leaves_"..name
					if math.random(1,20) == 10 then drop = "trees:sapling_"..name end
					minetest.add_item(pos, drop)
					itemstack:add_wear(65535/297)
					puncher:set_wielded_item(itemstack)
				elseif wielded == "survivalist:crook" then
					minetest.remove_node(pos)
					local drop = "trees:leaves_"..name
					if math.random(1,3) >= 2 then drop = "survivalist:silkworm" end
					if math.random(1,5) == 3 then minetest.add_item(pos, drop) end
					itemstack:add_wear(65535/99)
					puncher:set_wielded_item(itemstack)
				elseif wielded == "survivalist:silkworm" then
					minetest.set_node(pos, {name="survivalist:silk_leaves"})
					itemstack:take_item(1)
					puncher:set_wielded_item(itemstack)
				end
			end,
		})
	end

end

abstract_trees.trees_register_nodes_tree("palm", 8)
abstract_trees.trees_register_nodes_tree("mangrove", 10)
abstract_trees.trees_register_nodes_tree("conifer", 20)
abstract_trees.trees_register_nodes_tree("birch", 15)
