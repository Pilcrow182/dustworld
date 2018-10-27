minetest.register_tool("flint:pick", {
	description = "Flint Pickaxe",
	inventory_image = "flint_pick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			cracky = {times={[2]=2.0, [3]=1.20}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})

minetest.register_tool("flint:shovel", {
	description = "Flint Shovel",
	inventory_image = "flint_shovel.png",
	wield_image = "flint_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=0,
		groupcaps={
			crumbly = {times={[1]=1.80, [2]=1.20, [3]=0.50}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})

minetest.register_tool("flint:axe", {
	description = "Flint Axe",
	inventory_image = "flint_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			choppy={times={[1]=3.00, [2]=2.00, [3]=1.50}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
})

minetest.register_tool("flint:sword", {
	description = "Flint Sword",
	inventory_image = "flint_sword.png",
	tool_capabilities = {
		full_punch_interval = 1,
		max_drop_level=0,
		groupcaps={
			snappy={times={[2]=1.4, [3]=0.40}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=3},
	}
})

minetest.register_craft({
	output = 'flint:pick',
	recipe = {
		{'flint:flintstone', 'flint:flintstone', 'flint:flintstone'},
		{'', 'group:stick', ''},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'flint:shovel',
	recipe = {
		{'flint:flintstone'},
		{'group:stick'},
		{'group:stick'},
	}
})

minetest.register_craft({
	output = 'flint:axe',
	recipe = {
		{'flint:flintstone', 'flint:flintstone'},
		{'flint:flintstone', 'group:stick'},
		{'', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'flint:sword',
	recipe = {
		{'flint:flintstone'},
		{'flint:flintstone'},
		{'group:stick'},
	}
})
