local panes = {}

panes.register_pane = function(def)
	minetest.register_node(":panes:"..def.name, {
		description = def.desc,
		drawtype="nodebox",
		node_box = {
			type = "fixed",
			fixed = {
-- 				{-0.500000,-0.500000,-0.500000,0.500000,0.500000,-0.437500}, -- close
-- 				{-0.500000,-0.500000,-0.031250,0.500000,0.500000,0.031250}, -- middle
				{-0.500000,-0.500000,0.437500,0.500000,0.500000,0.500000}, -- far
			}
		},
		tile_images = {
			"panes_"..def.name.."_edge.png",
			"panes_"..def.name.."_edge.png",
			"panes_"..def.name.."_edge.png",
			"panes_"..def.name.."_edge.png",
			"panes_"..def.name..".png",
		},
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		walkable = true,
		groups = {cracky=2,dig_immediate=3},
		legacy_wallmounted = false,
		sounds = default.node_sound_glass_defaults()
	})

	minetest.register_craft({
		output = "panes:"..def.name.." 16",
		recipe = {
			{def.from, def.from, def.from},
			{def.from, def.from, def.from},
		}
	})
end

panes.register_pane({
		name = "glass_pane",
		desc = "Glass Pane",
		from = "default:glass"
})

panes.register_pane({
		name = "obsidian_glass_pane",
		desc = "Obsidian Glass Pane",
		from = "default:obsidian_glass"
})
