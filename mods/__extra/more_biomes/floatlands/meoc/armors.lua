dofile(minetest.get_modpath(minetest.get_current_modname()).."/armor_api.lua")

local time = 0
local update_time = tonumber(minetest.setting_get("3d_armor_update_time"))
if not update_time then
	update_time = 1
	minetest.setting_set("3d_armor_update_time", tostring(update_time))
end

minetest.register_tool("meoc:armor_helmet", {
	description = "Meoc Helmet",
	inventory_image = "meoc_armor_inv_helmet.png",
	groups = {armor_head=15, armor_heal=15, armor_use=50},
	wear = 0,
})

minetest.register_tool("meoc:armor_chestplate", {
	description = "Meoc Chestplate",
	inventory_image = "meoc_armor_inv_chestplate.png",
	groups = {armor_torso=25, armor_heal=15, armor_use=50},
	wear = 0,
})

minetest.register_tool("meoc:armor_leggings", {
	description = "Meoc Leggings",
	inventory_image = "meoc_armor_inv_leggings.png",
	groups = {armor_legs=20, armor_heal=15, armor_use=50},
	wear = 0,
})

minetest.register_tool("meoc:armor_shield", {
	description = "Meoc Shield",
	inventory_image = "meoc_armor_inv_shield.png",
	groups = {armor_shield=25, armor_heal=15, armor_use=50},
	wear = 0,
})

minetest.register_craft({
	output = "meoc:armor_helmet",
	recipe = {
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"meoc:crystal", "", "meoc:crystal"},
		{"", "", ""},
	},
})

minetest.register_craft({
	output = "meoc:armor_chestplate",
	recipe = {
		{"meoc:crystal", "", "meoc:crystal"},
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
	},
})

minetest.register_craft({
	output = "meoc:armor_leggings",
	recipe = {
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"meoc:crystal", "", "meoc:crystal"},
		{"meoc:crystal", "", "meoc:crystal"},
	},
})

minetest.register_craft({
	output = "meoc:armor_shield",
	recipe = {
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"", "meoc:crystal", ""},
	},
})
