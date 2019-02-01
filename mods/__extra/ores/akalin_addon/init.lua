akalin_addon = {}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/stairs.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/doors.lua")

if minetest.get_modpath("carts") ~= nil then
	dofile(minetest.get_modpath(minetest.get_current_modname()).."/carts.lua")
end

minetest.register_craft({
	output = 'bucket:bucket_empty 1',
	recipe = {
		{'gloopores:akalin_ingot', '', 'gloopores:akalin_ingot'},
		{'', 'gloopores:akalin_ingot', ''},
	}
})

minetest.register_alias("moreores:silver_ingot", "gloopores:akalin_ingot")

