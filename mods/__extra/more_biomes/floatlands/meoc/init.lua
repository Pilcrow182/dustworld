dofile(minetest.get_modpath("meoc").."/tools.lua")

--[[
if minetest.get_modpath("3d_armor") ~= nil then
	dofile(minetest.get_modpath("meoc").."/armors.lua")
end
--]]

minetest.register_node("meoc:block", {
	description = "Meoc Block",
	tiles = {"meoc_block.png"}, 
	groups = {cracky=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_craftitem("meoc:crystal", {
	description = "Meoc Crystal",
	inventory_image = "meoc_crystal.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "meoc:block",
	recipe = {"flolands:floatcrystalblock", "default:mese"},
})

minetest.register_craft({
	type = "shapeless",
	output = "meoc:crystal",
	recipe = {"flolands:floatcrystal", "default:mese_crystal"},
})

minetest.register_craft({
	output = "meoc:block",
	recipe = {
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
		{"meoc:crystal", "meoc:crystal", "meoc:crystal"},
	}
})

minetest.register_craft({
	output = "meoc:crystal 9",
	recipe = {
		{"meoc:block"},
	}
})
