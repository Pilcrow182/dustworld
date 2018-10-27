local function clone_node(name)
	node2={}
	node=minetest.registered_nodes[name]
	for k,v in pairs(node) do
		node2[k]=v
	end
	return node2
end

for key,val in pairs(minetest.registered_nodes) do
	if minetest.registered_nodes[key].walkable then
		local tiles = {}
		newfake=clone_node(key)
			if not newfake.description then
				newfake.description = "Block"
			end
			newfake.description = "Fake "..newfake.description.." (cheater!)"
			if newfake.drawtype ~= 'glasslike' and newfake.drawtype ~= 'allfaces_optional' and newfake.drawtype ~= 'nodebox' then
				newfake.sunlight_propagates = true
				newfake.drawtype = 'nodebox'
				newfake.node_box = {
					type = "fixed",
					fixed = {
						{0.490000,-0.500000,-0.500000,0.500000,0.500000,0.500000},
						{-0.500000,-0.500000,-0.500000,-0.490000,0.500000,0.500000},
						{-0.500000,-0.500000,0.490000,0.500000,0.500000,0.500000},
						{-0.500000,-0.500000,-0.500000,0.500000,0.500000,-0.490000},
						{-0.500000,0.490000,-0.500000,0.500000,0.500000,0.500000},
						{-0.500000,-0.500000,-0.500000,0.500000,-0.490000,0.500000},
					},
				}
				newfake.selection_box = {
					type = "fixed",
					fixed = {-0.500000,-0.500000,-0.500000,0.500000,0.500000,0.500000},
				}
			end
			newfake.paramtype = 'light'
			newfake.walkable = false
			newfake.climbable = true
			newfake.is_ground_content = true
			newfake.groups = {dig_immediate=2, not_in_creative=1}
			newfake.sounds = default.node_sound_stone_defaults()
			newfake.drop="fakes:camoblock"
		minetest.register_node(":"..key.."__fake", newfake)
	end
end

minetest.register_craftitem("fakes:camoblock", {
	description = "Camo Block",
	inventory_image = minetest.inventorycube("fakes_camoblock.png"),
	wield_image = "fakes_camoblock.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = false,
	on_place = function(itemstack, placer, pointed_thing)
		if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick then
			return minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack)
		end
		if pointed_thing.type ~= "node" then
			return itemstack
		else
			local above = pointed_thing.above
			local under = pointed_thing.under
			if minetest.registered_nodes[minetest.get_node(above).name].buildable_to then
				if minetest.registered_nodes[minetest.get_node(under).name].walkable then
					minetest.add_node(above, {name = minetest.get_node(under).name.."__fake", param2 = minetest.get_node(under).param2})
					if not minetest.setting_getbool("creative_mode") then
						itemstack:take_item()
					end
				elseif string.find(minetest.get_node(under).name, "__fake") ~= nil then
					minetest.add_node(above, {name = minetest.get_node(under).name, param2 = minetest.get_node(under).param2})
					if not minetest.setting_getbool("creative_mode") then
						itemstack:take_item()
					end
				end
			end
			return itemstack
		end
	end
})

minetest.register_craft({
	output = "fakes:camoblock 4",
	recipe = {
		{"group:wool", "group:wool", "group:wool"},
		{"group:wool", "default:cobble", "group:wool"},
		{"group:wool", "group:wool", "group:wool"},
	}
})

minetest.register_alias("fakeblocks:concrete_concrete", "concrete:concrete__fake")
minetest.register_alias("fakeblocks:default_glass", "default:glass__fake")
minetest.register_alias("fakeblocks:default_obsidian", "default:obsidian__fake")
minetest.register_alias("fakeblocks:default_sand", "default:sand__fake")
minetest.register_alias("fakeblocks:default_dirt", "default:dirt__fake")
minetest.register_alias("fakeblocks:default_desert_sand", "default:desert_sand__fake")
minetest.register_alias("fakeblocks:default_sandstone", "default:sandstone__fake")
minetest.register_alias("fakeblocks:default_tree", "default:tree__fake")
minetest.register_alias("fakeblocks:default_bookshelf", "default:bookshelf__fake")
minetest.register_alias("fakeblocks:default_stone", "default:stone__fake")
minetest.register_alias("fakeblocks:default_desert_stone", "default:desert_stone__fake")
minetest.register_alias("fakeblocks:default_wood", "default:wood__fake")
minetest.register_alias("fakeblocks:default_cobble", "default:cobble__fake")
