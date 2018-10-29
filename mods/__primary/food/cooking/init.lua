-- normal meat

minetest.register_craftitem("cooking:meat_cooked", {
	description = "Cooked Meat",
	inventory_image = "cooking_meat_cooked.png",
	groups = {food=2},
	on_use = minetest.item_eat(10)
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_beef",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_chicken",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_lamb",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_ostrich",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_pork",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_raw",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:meat_cooked",
	recipe = "animalmaterials:meat_venison",
	cooktime = 20
})


-- toxic meat

minetest.register_craft({
	type = "cooking",
	output = "default:scorched_stuff",
	recipe = "animalmaterials:meat_toxic",
	cooktime = 20
})

minetest.register_craft({
	type = "cooking",
	output = "default:scorched_stuff",
	recipe = "animalmaterials:meat_undead",
	cooktime = 20
})


-- fish

minetest.register_craftitem("cooking:fish_cooked", {
	description = "Cooked Fish",
	inventory_image = "cooking_fish_cooked.png",
	groups = {food=2},
	on_use = minetest.item_eat(6)
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:fish_cooked",
	recipe = "animalmaterials:fish_bluewhite",
	cooktime = 10
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:fish_cooked",
	recipe = "animalmaterials:fish_clownfish",
	cooktime = 10
})


-- eggs

minetest.register_craftitem("cooking:eggs_cooked", {
	description = "Scrambled Eggs",
	inventory_image = "cooking_eggs_cooked.png",
	groups = {food=2},
	on_use = minetest.item_eat(4)
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:eggs_cooked",
	recipe = "animalmaterials:egg",
	cooktime = 5
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:eggs_cooked 4",
	recipe = "animalmaterials:egg_big",
	cooktime = 10
})


-- chocolate

minetest.register_craftitem("cooking:chocolate", {
	description = "Chocolate",
	inventory_image = "cooking_chocolate.png",
	wield_image = "cooking_chocolate.png^[transformR0",
	groups = {food=2},
	on_use = minetest.item_eat(10)
})

minetest.register_craftitem("cooking:cocoa_powder", {
	description = "Cocoa Powder",
	inventory_image = "cooking_cocoa_powder.png",
})

minetest.register_craftitem("cooking:sugar", {
	description = "Sugar",
	inventory_image = "cooking_sugar.png",
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:cocoa_powder",
	recipe = "farming_plus:cocoa_bean",
	cooktime = 2
})

minetest.register_craft({
	type = "shapeless",
	output = "cooking:sugar 4",
	recipe = {"default:papyrus"},
})

minetest.register_craft({
	type = "shapeless",
	output = "cooking:chocolate",
	recipe = {"cooking:sugar", "cooking:cocoa_powder", "bucket:bucket_water"},
	replacements = {
		{"bucket:bucket_water", "bucket:bucket_empty"}
	}
})


-- pie

minetest.register_craftitem("cooking:pie_raw", {
	description = "Raw berry pie",
	inventory_image = "cooking_pie_raw.png",
	groups = {food=2},
	on_use = minetest.item_eat(5),
})

minetest.register_craftitem("cooking:pie_cooked", {
	description = "Cooked berry pie",
	inventory_image = "cooking_pie_cooked.png",
	groups = {food=2},
	on_use = minetest.item_eat(15),
})

minetest.register_node("cooking:pie_basket", {
    description = "Basket with pies",
    drawtype = "nodebox",
    tiles = {
        "cooking_pie_basket_top.png",
        "cooking_pie_basket_bottom.png",
        "cooking_pie_basket_side.png"
    },
    paramtype = 'light',
    node_box = {
        type = "fixed",
        fixed = {
            {0.375000,-0.500000,-0.437500,0.437500,0.125000,0.437500}, -- wall1
            {-0.437500,-0.500000,-0.437500,-0.375000,0.125000,0.437500}, -- wall2
            {-0.375000,-0.500000,-0.437500,0.375000,0.125000,-0.375000}, -- wall3
            {-0.375000,-0.500000,0.375000,0.375000,0.125000,0.437500}, -- wall4
            {-0.375000,-0.500000,-0.375000,0.375000,-0.187500,0.375000}, -- bottom
            {-0.187500,-0.250000,-0.312500,0.187500,0.000000,0.312500}, -- pie1
            {-0.312500,-0.250000,-0.187500,0.312500,0.000000,0.187500}, -- pie2
            {-0.250000,-0.250000,-0.250000,0.250000,0.000000,0.250000}, -- pie3
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.437500,-0.500000,-0.437500,0.437500,0.125000,0.437500},
    },
    sunlight_propagates = true,
    on_use = minetest.item_eat(20),
    groups = {choppy=2,dig_immediate=3,flammable=1,food=2},
})

minetest.register_craft({
	output = 'cooking:pie_raw 1',
	recipe = {
		{ 'cooking:sugar', 'default:junglegrass', 'cooking:sugar' },
		{ 'group:berry', 'group:berry', 'group:berry' },
	},
})

minetest.register_craft({
	output = 'cooking:pie_basket 1',
	recipe = {
		{ 'default:papyrus', 'cooking:pie_cooked', 'default:papyrus' },
		{ 'default:papyrus', 'default:papyrus', 'default:papyrus' },
	},
})

minetest.register_craft({
	output = 'cooking:pie_cooked 1',
	recipe = {
		{ 'cooking:pie_basket' },
	},
})

minetest.register_craft({
	type = 'cooking',
	output = 'cooking:pie_cooked',
	recipe = 'cooking:pie_raw',
	cooktime = 30,
})


-- banana bread

minetest.register_craftitem("cooking:banana_bread", {
	description = "Banana Bread",
	inventory_image = "cooking_banana_bread.png",
	groups = {food=2},
	on_use = minetest.item_eat(20)
})

minetest.register_craftitem("cooking:banana_bread_dough", {
	description = "Banana Bread Dough",
	inventory_image = "cooking_banana_bread_dough.png",
})

minetest.register_craft({
	output = "cooking:banana_bread_dough",
	type = "shapeless",
	recipe = {"farming:dough", "farming_plus:banana"}
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:banana_bread",
	recipe = "cooking:banana_bread_dough",
	cooktime = 10
})


-- cactus

minetest.register_craftitem("cooking:cactus_cooked", {
	description = "Cooked Cactus",
	inventory_image = "cooking_cactus_cooked.png",
	groups = {food=2},
	on_use = minetest.item_eat(4)
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:cactus_cooked",
	recipe = "default:cactus",
	cooktime = 10
})

-- worms

minetest.register_craftitem("cooking:worm_cooked", {
	description = "Cooked Worm",
	inventory_image = "cooking_worm_cooked.png",
	groups = {food=2},
	on_use = minetest.item_eat(2)
})

minetest.register_craftitem("cooking:worm_flour", {
	description = "Worm Flour",
	inventory_image = "cooking_worm_flour.png",
})

minetest.register_craft({
	output = 'cooking:worm_flour 1',
	recipe = {
		{ 'survivalist:salt', 'survivalist:salt', 'survivalist:salt' },
		{ 'cooking:worm_cooked', 'cooking:worm_cooked', 'cooking:worm_cooked' },
		{ 'bonemeal:bonemeal', 'bonemeal:bonemeal', 'bonemeal:bonemeal' },
	},
})

minetest.register_craft({
	type = "cooking",
	output = "cooking:worm_cooked",
	recipe = "survivalist:silkworm",
	cooktime = 5
})

minetest.register_craft({
	type = "cooking",
	output = "farming:bread",
	recipe = "cooking:worm_flour",
	cooktime = 15
})
