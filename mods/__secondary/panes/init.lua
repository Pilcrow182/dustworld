local panes = {}

panes.register_pane = function(def)
	if not minetest.registered_nodes["panes:"..def.name] then
		minetest.register_node(":panes:"..def.name, {
			description = def.desc,
			drawtype="nodebox",
			node_box = {
				type = "fixed",
				fixed = {
--	 				{-0.500000,-0.500000,-0.500000,0.500000,0.500000,-0.437500}, -- close
-- 					{-0.500000,-0.500000,-0.031250,0.500000,0.500000,0.031250}, -- middle
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
			light_source = def.glow or 0,
			walkable = true,
			groups = {cracky=2,dig_immediate=3},
			legacy_wallmounted = false,
			sounds = default.node_sound_glass_defaults()
		})
	end

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

if minetest.get_modpath("hardened_glass") then
	panes.register_pane({
		name = "glass_pane",
		desc = "Glass Pane",
		from = "hardened_glass:glass"
	})
end

if minetest.get_modpath("glowglass") then
	panes.register_pane({
		name = "glowglass_pane",
		desc = "Glowglass Pane",
		from = "glowglass:basic",
		glow = 14
	})

	panes.register_pane({
		name = "glowglass_pane",
		desc = "Glowglass Pane",
		from = "glowglass:super",
		glow = 14
	})

	panes.register_pane({
		name = "glowglass_black_pane",
		desc = "Black Glowglass Pane",
		from = "glowglass:black",
		glow = 14
	})

	panes.register_pane({
		name = "glowglass_black_pane",
		desc = "Black Glowglass Pane",
		from = "glowglass:superblack",
		glow = 14
	})
end

if minetest.get_modpath("hardened_glass") and minetest.get_modpath("glowglass") then
	panes.register_pane({
		name = "glowglass_hardened_pane",
		desc = "Hardened Glowglass Pane",
		from = "glowglass:hardened",
		glow = 14
	})

	panes.register_pane({
		name = "glowglass_hardened_pane",
		desc = "Hardened Glowglass Pane",
		from = "glowglass:superhardened",
		glow = 14
	})
end

