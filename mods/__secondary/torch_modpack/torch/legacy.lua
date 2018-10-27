minetest.register_alias("3d_torch:torch_wall", "torch:torch_wood_wall")
minetest.register_alias("3d_torch:torch_floor", "torch:torch_wood_floor")
minetest.register_alias("3d_torch:torch_ceiling", "torch:torch_wood_ceiling")

minetest.register_alias("torch:torch_wall", "torch:torch_wood_wall")
minetest.register_alias("torch:torch_floor", "torch:torch_wood_floor")
minetest.register_alias("torch:torch_ceiling", "torch:torch_wood_ceiling")

--abm that converts existing default torches into 3d ones
minetest.register_abm({
	nodenames = {"default:torch", "default:torch_wall", "default:torch_ceiling"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local convert_facedir={
			[2]=2,
			[3]=0,
			[4]=1,
			[5]=3
		}
		if node.param2 == 1 then
		minetest.set_node(pos, {name="torch:torch_wood_floor"})
		elseif node.param2 == 0 then
		minetest.set_node(pos, {name="torch:torch_wood_ceiling"})
		else
		minetest.set_node(pos, {name="torch:torch_wood_wall",param2=convert_facedir[node.param2]})
		end
	end,
})
