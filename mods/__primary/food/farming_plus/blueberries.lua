minetest.register_craftitem("farming_plus:blueberry_seed", {
	description = "Blueberry Seeds",
	inventory_image = "farming_blueberry_seed.png",
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick then
			return minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack)
		end
		local above = minetest.get_node(pointed_thing.above)
		if above.name == "air" then
			above.name = "farming_plus:blueberry_1"
			minetest.set_node(pointed_thing.above, above)
			itemstack:take_item(1)
			return itemstack
		end
	end
})

minetest.register_node("farming_plus:blueberry_1", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	drop = "",
	tiles = {"farming_blueberry_1.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+9/16, 0.5}
		},
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("farming_plus:blueberry_2", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	drop = "",
	tiles = {"farming_blueberry_2.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+12/16, 0.5}
		},
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("farming_plus:blueberry_3", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	drop = "",
	tiles = {"farming_blueberry_3.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+14/16, 0.5}
		},
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("farming_plus:blueberry", {
	paramtype = "light",
	walkable = false,
	drawtype = "plantlike",
	tiles = {"farming_blueberry_4.png"},
	drop = {
		max_items = 6,
		items = {
			{ items = {'farming_plus:blueberry_seed'} },
			{ items = {'farming_plus:blueberry_seed'}, rarity = 2},
			{ items = {'farming_plus:blueberry_seed'}, rarity = 5},
			{ items = {'farming_plus:blueberry_item'} },
			{ items = {'farming_plus:blueberry_item'}, rarity = 2 },
			{ items = {'farming_plus:blueberry_item'}, rarity = 5 }
		}
	},
	groups = {snappy=3, flammable=2, not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_craftitem("farming_plus:blueberry_item", {
	description = "Blueberry",
	inventory_image = "farming_blueberry.png",
	groups = {berry=1,food=2},
	on_use = minetest.item_eat(3),
})

if minetest.get_modpath("dye") ~= nil then
	minetest.register_craft({
		output = "dye:blue 4",
		recipe = {{"farming_plus:blueberry_item"}},
	})
end

farming:add_plant("farming_plus:blueberry", {"farming_plus:blueberry_1", "farming_plus:blueberry_2", "farming_plus:blueberry_3"}, 50, 20)

