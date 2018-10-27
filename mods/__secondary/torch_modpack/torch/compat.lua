if not minetest.registered_nodes["homedecor:torch_wall"] then
	minetest.register_node(":homedecor:torch_wall", {
		description = "Steel Torch",
		drawtype = "plantlike",
		tiles = {"torch_torch_steel_inv.png"},
		inventory_image = "torch_torch_steel_inv.png",
		wield_image = "torch_torch_steel_inv.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {
			{-0.0696325,-0.5,-0.0638297,0.0638297,0.1,0.0696325}
			}
		},
		groups = {dig_immediate=3}
	})
end

minetest.register_craft({
	output = "homedecor:torch_wall 4",
	recipe = {
		{"default:coal_lump"},
		{"default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "homedecor:torch_wall 2",
	recipe = {
		{"charcoal:charcoal"},
		{"default:steel_ingot"}
	}
})

if not minetest.registered_nodes["gloopores:kalite_torch"] then
	minetest.register_node(":gloopores:kalite_torch",{
		description = "Kalite Torch",
		drawtype = "plantlike",
		tiles = {"torch_torch_kalite_inv.png"},
		inventory_image = "torch_torch_kalite_inv.png",
		wield_image = "torch_torch_kalite_inv.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {
			{-0.0696325,-0.5,-0.0638297,0.0638297,0.1,0.0696325}
			}
		},
		groups = {dig_immediate=3}
	})
end

minetest.register_craft({
	output = "gloopores:kalite_torch 4",
	recipe = {
		{"gloopores:kalite_lump"},
		{"group:stick"}
	}
})
