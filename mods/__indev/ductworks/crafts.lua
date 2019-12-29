minetest.register_craft({
	output = 'ductworks:itemduct 8',
	recipe = {
		{'default:copper_ingot', '', 'default:copper_ingot'},
		{'default:copper_ingot', '', 'default:copper_ingot'},
		{'default:copper_ingot', '', 'default:copper_ingot'},
	}
})

minetest.register_craft({
	output = 'ductworks:hopper',
	recipe = {
		{'default:copper_ingot', '',                     'default:copper_ingot'},
		{'default:copper_ingot', 'default:chest',        'default:copper_ingot'},
		{'',                     'default:copper_ingot', ''                    },
	}
})

minetest.register_craft({
	output = 'ductworks:ejector',
	recipe = {
		{'',                     'default:diamond',      ''                   },
		{'default:copper_ingot', 'ductworks:hopper',     'default:steel_ingot'},
		{'',                     'default:mese_crystal', ''                   },
	}
})

for i, duct in ipairs(ductworks.duct_types) do
	minetest.register_craft({
		output = "ductworks:"..ductworks.duct_types[((i + 1 > #ductworks.duct_types) and 1) or (i + 1)],
		recipe = {{"ductworks:"..duct}}
	})
end

