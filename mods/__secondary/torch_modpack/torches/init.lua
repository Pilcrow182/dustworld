-- wooden torches
minetest.register_alias("torches:torch_floor", "torch:torch_wood_floor")
minetest.register_alias("torches:torch_ceiling", "torch:torch_wood_ceiling")

minetest.register_abm({
	nodenames = {"torches:torch_wall"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local convert_facedir={
			[0]=1,
			[1]=2,
			[2]=3,
			[3]=0
			
		}
		minetest.set_node(pos, {name="torch:torch_wood_wall",param2=convert_facedir[node.param2]})
	end,
})

-- steel torches
minetest.register_alias("torches:torch_steel_floor", "torch:torch_steel_floor")
minetest.register_alias("torches:torch_steel_ceiling", "torch:torch_steel_ceiling")

minetest.register_abm({
	nodenames = {"torches:torch_steel_wall"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local convert_facedir={
			[0]=1,
			[1]=2,
			[2]=3,
			[3]=0
			
		}
		minetest.set_node(pos, {name="torch:torch_steel_wall",param2=convert_facedir[node.param2]})
	end,
})

-- kalite torches
minetest.register_alias("torches:torch_kalite_floor", "torch:torch_kalite_floor")
minetest.register_alias("torches:torch_kalite_ceiling", "torch:torch_kalite_ceiling")

minetest.register_abm({
	nodenames = {"torches:torch_kalite_wall"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local convert_facedir={
			[0]=1,
			[1]=2,
			[2]=3,
			[3]=0
			
		}
		minetest.set_node(pos, {name="torch:torch_kalite_wall",param2=convert_facedir[node.param2]})
	end,
})
