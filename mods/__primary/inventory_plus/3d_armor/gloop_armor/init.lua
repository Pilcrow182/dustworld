-- Regisiter Head Armor

minetest.register_tool("gloop_armor:helmet_alatro", {
	description = "Alatro Helmet",
	inventory_image = "gloop_armor_inv_helmet_alatro.png",
	groups = {armor_head=13, armor_heal=8, armor_use=150},
	wear = 0,
})

minetest.register_craft({
	output = "gloop_armor:helmet_alatro",
	recipe = {
		{"gloopores:alatro_ingot", "gloopores:alatro_ingot", "gloopores:alatro_ingot"},
		{"gloopores:alatro_ingot", "", "gloopores:alatro_ingot"},
		{"", "", ""},
	},
})

-- Regisiter Torso Armor

minetest.register_tool("gloop_armor:chestplate_alatro", {
	description = "Alatro Chestplate",
	inventory_image = "gloop_armor_inv_chestplate_alatro.png",
	groups = {armor_torso=20, armor_heal=8, armor_use=150},
	wear = 0,
})

minetest.register_craft({
	output = "gloop_armor:chestplate_alatro",
	recipe = {
		{"gloopores:alatro_ingot", "", "gloopores:alatro_ingot"},
		{"gloopores:alatro_ingot", "gloopores:alatro_ingot", "gloopores:alatro_ingot"},
		{"gloopores:alatro_ingot", "gloopores:alatro_ingot", "gloopores:alatro_ingot"},
	},
})

-- Regisiter Leg Armor

minetest.register_tool("gloop_armor:leggings_alatro", {
	description = "Alatro Leggings",
	inventory_image = "gloop_armor_inv_leggings_alatro.png",
	groups = {armor_legs=13, armor_heal=8, armor_use=150},
	wear = 0,
})

minetest.register_craft({
	output = "gloop_armor:leggings_alatro",
	recipe = {
		{"gloopores:alatro_ingot", "gloopores:alatro_ingot", "gloopores:alatro_ingot"},
		{"gloopores:alatro_ingot", "", "gloopores:alatro_ingot"},
		{"gloopores:alatro_ingot", "", "gloopores:alatro_ingot"},
	},
})

-- Regisiter Shields

minetest.register_tool("gloop_armor:shield_alatro", {
	description = "Alatro Shield",
	inventory_image = "gloop_armor_inv_shield_alatro.png",
	groups = {armor_shield=23, armor_heal=8, armor_use=150},
	wear = 0,
})

minetest.register_craft({
	output = "gloop_armor:shield_alatro",
	recipe = {
		{"gloopores:alatro_ingot", "gloopores:alatro_ingot", "gloopores:alatro_ingot"},
		{"gloopores:alatro_ingot", "gloopores:alatro_ingot", "gloopores:alatro_ingot"},
		{"", "gloopores:alatro_ingot", ""},
	},
})

