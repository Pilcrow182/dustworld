if minetest.get_modpath("gloopores") then
	minetest.register_craft({
		output = 'digilines:wire_std_00000000 6',
		recipe = {
			{'gloopores:akalin_ingot'},
			{'gloopores:akalin_ingot'},
			{'gloopores:akalin_ingot'},
		}
	})
end

