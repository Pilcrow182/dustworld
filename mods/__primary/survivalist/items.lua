minetest.register_craftitem("survivalist:motor",{
	description = "Motor",
	inventory_image = "survivalist_motor.png"
})

minetest.register_craftitem("survivalist:gear_wood",{
	description = "Wooden Gear",
	inventory_image = "survivalist_gear_wood.png"
})

minetest.register_craftitem("survivalist:gear_stone",{
	description = "Stone Gear",
	inventory_image = "survivalist_gear_stone.png"
})

minetest.register_craftitem("survivalist:gear_steel",{
	description = "Steel Gear",
	inventory_image = "survivalist_gear_steel.png"
})

minetest.register_craftitem("survivalist:gear_gold",{
	description = "Gold Gear",
	inventory_image = "survivalist_gear_gold.png"
})

minetest.register_craftitem("survivalist:gear_diamond",{
	description = "Diamond Gear",
	inventory_image = "survivalist_gear_diamond.png"
})

minetest.register_craftitem("survivalist:silkworm",{
	description = "Silkworm",
	inventory_image = "survivalist_silkworm.png"
})

minetest.register_craftitem("survivalist:iron_fragment",{
	description = "Iron Fragment",
	inventory_image = "survivalist_iron_fragment.png"
})

minetest.register_craftitem("survivalist:broken_iron_ingot",{
	description = "Broken Iron Ingot",
	inventory_image = "survivalist_broken_iron_ingot.png"
})

minetest.register_craftitem("survivalist:copper_fragment",{
	description = "Copper Fragment",
	inventory_image = "survivalist_copper_fragment.png"
})

minetest.register_craftitem("survivalist:broken_copper_ingot",{
	description = "Broken Copper Ingot",
	inventory_image = "survivalist_broken_copper_ingot.png"
})

minetest.register_craftitem("survivalist:gold_fragment",{
	description = "Gold Fragment",
	inventory_image = "survivalist_gold_fragment.png"
})

minetest.register_craftitem("survivalist:broken_gold_ingot",{
	description = "Broken Gold Ingot",
	inventory_image = "survivalist_broken_gold_ingot.png"
})

minetest.register_craftitem("survivalist:mese_dust",{
	description = "Mese Dust",
	inventory_image = "survivalist_mese_dust.png"
})

minetest.register_craftitem("survivalist:grass_seed",{
	description = "Grass Seed",
	inventory_image = "survivalist_grass_seed.png"
})

minetest.register_craftitem("survivalist:rock",{
	description = "Small Rock",
	inventory_image = "survivalist_rock.png"
})

minetest.register_craftitem("survivalist:salt",{
	description = "Salt",
	inventory_image = "survivalist_salt.png"
})

minetest.register_node("survivalist:salt_block",{
	description = "Salt Block",
	tiles = {"survivalist_salt_block.png"},
	groups = {crumbly=2,cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("survivalist:silk_string",{
	description = "Silk String",
	inventory_image = "survivalist_silk_string.png"
})

minetest.register_craftitem("survivalist:silk_mesh",{
	description = "Silk Mesh",
	inventory_image = "survivalist_silk_mesh.png"
})

minetest.register_node("survivalist:silk",{
	description = "Silk",
	tiles = {"survivalist_silk.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,wool=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_craftitem("survivalist:silkworm",{
	description = "Silkworm",
	inventory_image = "survivalist_silkworm.png"
})

minetest.register_tool("survivalist:shears", {
	description = "Shears",
	inventory_image = "survivalist_shears.png",
})

minetest.register_tool("survivalist:crook", {
	description = "Crook",
	inventory_image = "survivalist_crook.png",
})

survivalist.clone_item("default:leaves", "default:leaves", {
	description = "Oak Leaves",
	tiles = {"default_leaves.png"},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'survivalist:oak_sapling'},
				rarity = 20,
			}
		}
	},
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	on_punch = function(pos, node, puncher)
		if not puncher then return end
		local itemstack = puncher:get_wielded_item()
		local wielded = itemstack:get_name()
		if wielded == "survivalist:shears" then
			minetest.remove_node(pos)
			local drop = "default:leaves"
			if math.random(1,20) == 10 then drop = "survivalist:oak_sapling" end
			minetest.add_item(pos, drop)
			itemstack:add_wear(65535/297)
			puncher:set_wielded_item(itemstack)
		elseif wielded == "survivalist:crook" then
			minetest.remove_node(pos)
			local drop = "survivalist:oak_sapling"
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
	after_place_node = function() return end,
})

minetest.register_alias("survivalist:oak_leaves", "default:leaves")

minetest.register_alias("survivalist:apple_item", "default:apple")

survivalist.clone_item("default:apple", "survivalist:apple", {
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2, leafdecay = 3, food = 2, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{
				items = {'default:apple'},
				rarity = 1,
			}
		}
	},
})

survivalist.clone_item("default:apple", "default:apple", {
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"},
	wield_image = "default_apple.png",
	paramtype = "light",
	selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}},
	groups = {snappy=3, leafdecay=3, flammable=2, leafdecay_drop = 1},
-- 	groups = {fleshy = 3, dig_immediate = 3, flammable = 2, leafdecay = 3, leafdecay_drop = 1, food = 2},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'default:sapling'},
				rarity = 20,
			}
		}
	},
	on_punch = function(pos, node, puncher)
		if not puncher then return end
		local itemstack = puncher:get_wielded_item()
		local wielded = itemstack:get_name()
		if wielded == "survivalist:shears" then
			minetest.remove_node(pos)
			local drop = "default_leaves"
			if math.random(1,20) == 10 then drop = "survivalist:oak_sapling" end
			minetest.add_item(pos, drop)
			itemstack:add_wear(65535/297)
			puncher:set_wielded_item(itemstack)
		elseif wielded == "survivalist:crook" then
			minetest.remove_node(pos)
			local drop = "survivalist:oak_sapling"
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
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.registered_nodes[minetest.env:get_node(pointed_thing.under).name].on_rightclick then
			return minetest.registered_nodes[minetest.env:get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.env:get_node(pointed_thing.under), placer, itemstack)
		else
			minetest.env:set_node(pointed_thing.above, {name="survivalist:apple"})
			itemstack:take_item()
			return itemstack
		end
	end
})

survivalist.clone_item("default:leaves", "survivalist:apple_leaves", {
	description = "Apple Tree Leaves",
	tiles = {"default_leaves.png"},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'survivalist:apple_sapling'},
				rarity = 20,
			}
		}
	},
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	on_punch = function(pos, node, puncher)
		if not puncher then return end
		local itemstack = puncher:get_wielded_item()
		local wielded = itemstack:get_name()
		if wielded == "survivalist:shears" then
			minetest.remove_node(pos)
			local drop = "survivalist:apple_leaves"
			if math.random(1,20) == 10 then drop = "survivalist:apple_sapling" end
			minetest.add_item(pos, drop)
			itemstack:add_wear(65535/297)
			puncher:set_wielded_item(itemstack)
		elseif wielded == "survivalist:crook" then
			minetest.remove_node(pos)
			local drop = "survivalist:apple_sapling"
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
	after_place_node = function() return end,
})

survivalist.clone_item("default:leaves", "survivalist:silk_leaves", {
	description = "Silky Leaves",
	tiles = {"survivalist_silk_leaves.png"},
	drop = {
		max_items = 1,
		items = {
				{
					-- player will get sapling with 1/sapling_rarity chance
					items = {'survivalist:silkworm'},
					rarity = 10,                                               -- 10% chance for worms
				},
				{
					-- player will get silk only if he get no worms,
					-- this is because max_items is 1
					items = {'survivalist:silk_string'},
					rarity = 10,                                               -- 10% chance for string
				}
		}
	},
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	on_punch = function(pos, node, puncher)
		if not puncher then return end
		local itemstack = puncher:get_wielded_item()
		local wielded = itemstack:get_name()
		if wielded == "survivalist:shears" then
			minetest.remove_node(pos)
			local drop = "survivalist:silk_string"
			if math.random(1,5) == 3 then drop = "survivalist:silkworm" end            -- 4% chance for worms
			if math.random(1,5) == 3 then minetest.add_item(pos, drop) end             -- 16% chance for string
			minetest.add_item(pos, drop)
			itemstack:add_wear(65535/297)
			puncher:set_wielded_item(itemstack)
		elseif wielded == "survivalist:crook" then
			minetest.remove_node(pos)
			local drop = "survivalist:silkworm"
			if math.random(1,3) == 2 then drop = "survivalist:silk_string" end         -- 6.67% chance for string
			if math.random(1,5) == 3 then minetest.add_item(pos, drop) end             -- 13.33% chance for worms
			itemstack:add_wear(65535/99)
			puncher:set_wielded_item(itemstack)
		end
	end,
	after_place_node = function() return end,
})

minetest.register_node("survivalist:acorn",{
	description = "Acorn",
	inventory_image = "survivalist_acorn.png",
	wield_image = "survivalist_acorn.png",
	tiles = {"survivalist_seed_planted.png"},
	drawtype="nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-1/16,-8/16,-1/16,1/16,-7/16,1/16},
		}
	},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	on_place = function(itemstack, placer, pointed_thing)
		local surface = minetest.get_node(pointed_thing.under)
		local sname = surface.name
		if not minetest.registered_nodes[sname] then
			return itemstack
		elseif minetest.registered_nodes[sname].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[sname].on_rightclick(pointed_thing.under, surface, placer, itemstack)
		end
		if sname == "survivalist:mulch_block" or sname == "default:clay" or sname == "default:dirt" or sname == "default:dirt_with_grass" then
			minetest.item_place(itemstack, placer, pointed_thing)
		end
		return itemstack
	end,
})

minetest.register_node("survivalist:apple_core",{
	description = "Dried Apple Core",
	inventory_image = "survivalist_apple_core.png",
	wield_image = "survivalist_apple_core.png",
	tiles = {"survivalist_seed_planted.png"},
	drawtype="nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-1/16,-8/16,-1/16,1/16,-7/16,1/16},
		}
	},
	groups = {oddly_breakable_by_hand=3},
	on_place = function(itemstack, placer, pointed_thing)
		local surface = minetest.get_node(pointed_thing.under)
		local sname = surface.name
		if not minetest.registered_nodes[sname] then
			return itemstack
		elseif minetest.registered_nodes[sname].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[sname].on_rightclick(pointed_thing.under, surface, placer, itemstack)
		end
		if sname == "survivalist:mulch_block" or sname == "default:clay" or sname == "default:dirt" or sname == "default:dirt_with_grass" then
			minetest.item_place(itemstack, placer, pointed_thing)
		end
		return itemstack
	end,
})

minetest.register_node("survivalist:oak_sapling", {
	description = "Oak Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local surface = minetest.get_node(pointed_thing.under)
		local sname = surface.name
		if not minetest.registered_nodes[sname] then
			return itemstack
		elseif minetest.registered_nodes[sname].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[sname].on_rightclick(pointed_thing.under, surface, placer, itemstack)
		end
		if sname == "survivalist:mulch_block" or sname == "default:clay" or sname == "default:dirt" or sname == "default:dirt_with_grass" then
			minetest.item_place(itemstack, placer, pointed_thing)
		end
		return itemstack
	end,
})

minetest.register_node("survivalist:apple_sapling", {
	description = "Apple Tree Sapling",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"default_sapling.png"},
	inventory_image = "default_sapling.png",
	wield_image = "default_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1},
	sounds = default.node_sound_leaves_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
		local surface = minetest.get_node(pointed_thing.under)
		local sname = surface.name
		if not minetest.registered_nodes[sname] then
			return itemstack
		elseif minetest.registered_nodes[sname].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[sname].on_rightclick(pointed_thing.under, surface, placer, itemstack)
		end
		if sname == "survivalist:mulch_block" or sname == "default:clay" or sname == "default:dirt" or sname == "default:dirt_with_grass" then
			minetest.item_place(itemstack, placer, pointed_thing)
		end
		return itemstack
	end,
})

minetest.register_craftitem("survivalist:mulch", {
	description = "Mulch",
	inventory_image = "survivalist_mulch.png",
	liquids_pointable = false,
	stack_max = 99,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type == "node" and minetest.get_node(pointed_thing.under).name ~= "air" then
			if math.random(0,3) == 2 then
				local growing = minetest.get_node(pointed_thing.under).name
				if growing == "survivalist:oak_sapling" then
					survivalist.grow_tree(pointed_thing.under, "default:tree", "survivalist:oak_leaves", "survivalist:oak_leaves")
				elseif growing == "survivalist:apple_sapling" then
					survivalist.grow_tree(pointed_thing.under, "default:tree", "survivalist:apple_leaves", "survivalist:apple")
				elseif growing == "default:sapling" then
					survivalist.grow_tree(pointed_thing.under, "default:tree", "default:leaves", "default:apple")
				elseif minetest.get_modpath("bonemeal") ~= nil then
					bonemeal.grow(pointed_thing)
				end
			end
			itemstack:take_item()
			return itemstack
		end
	end,
})

minetest.register_node("survivalist:mulch_block",{
	description = "Mulch Block",
	tiles = {"survivalist_mulch_block.png"},
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3},
	sounds = default.node_sound_defaults(),
})

minetest.register_abm({
	nodenames = {"survivalist:mulch_block"},
	interval = 40,
	chance = 10,
	action = function(pos)
		minetest.set_node(pos, {name="default:dirt_with_grass"})
	end
})

local leaves = {"default:apple", "survivalist:apple", "survivalist:oak_leaves", "survivalist:apple_leaves"}

if minetest.get_modpath("farming_plus") ~= nil then
	leaves = {"default:apple", "survivalist:apple", "survivalist:oak_leaves", "survivalist:apple_leaves", "farming_plus:banana", "farming_plus:banana_leaves", "farming_plus:cocoa", "farming_plus:cocoa_leaves"}
end

default.register_leafdecay({
	trunks = {"default:tree"},
	leaves = leaves,
	radius = 3,
})
