DOORS = true

fakes = {}
dofile(minetest.get_modpath("fakes").."/extenders.lua")
if DOORS then dofile(minetest.get_modpath("fakes").."/doors.lua") end

local function clone_node(name)
	node2={}
	node=minetest.registered_nodes[name]
	for k,v in pairs(node) do
		node2[k]=v
	end
	return node2
end

fakes.make_fake = function(name)
	local realblock=clone_node(name)
		local fakeblock={
			tiles = realblock.tiles,
			special_tiles = realblock.special_tiles,
			description = "Fake "..(realblock.description or "Block").." (cheater!)",
			light_source = realblock.light_source,
			sunlight_propagates = realblock.sunlight_propagates,
			selection_box = realblock.selection_box,
			drawtype = realblock.drawtype,
			mesh = realblock.mesh,
			node_box = realblock.node_box,
			alpha = realblock.alpha,
--			paramtype = realblock.paramtype,
			paramtype = "light",
			paramtype2 = realblock.paramtype2,
			walkable = false,
			climbable = true,
			is_ground_content = true,
			groups = {snappy=1, oddly_breakable_by_hand=3, not_in_creative_inventory=1},
			sounds = default.node_sound_leaves_defaults(),
			drop="fakes:camoblock",
		}
	if not realblock.drawtype or realblock.drawtype == "normal" then
			fakeblock.drawtype = 'nodebox'
			fakeblock.node_box = {
				type = "fixed",
				fixed = {-0.500000,-0.500000,-0.500000,0.500000,0.500000,0.500000},
			}
	end
	minetest.register_node(":"..name.."__fake", fakeblock)

	if DOORS then fakes.make_doors(name, realblock.tiles) end
end

for name,_ in pairs(minetest.registered_nodes) do
	if string.find(name, "__fake") == nil then
		fakes.make_fake(name)
	end
end

minetest.register_craftitem("fakes:camoblock", {
	description = "Camo Block",
	inventory_image = minetest.inventorycube("fakes_camoblock.png"),
	wield_image = "fakes_camoblock.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_place = function(itemstack, placer, pointed_thing)
		if not minetest.registered_nodes[minetest.get_node(pointed_thing.under).name] then
			return itemstack
		elseif minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack)
		end
		local above = pointed_thing.above
		local under = pointed_thing.under
		if minetest.registered_nodes[minetest.get_node(above).name].buildable_to then
			if string.find(minetest.get_node(under).name, "__extended") ~= nil then return end
			if string.find(minetest.get_node(under).name, "__fake") ~= nil then
				minetest.add_node(above, {name = minetest.get_node(under).name, param2 = minetest.get_node(under).param2})
				if not minetest.setting_getbool("creative_mode") then
					itemstack:take_item()
				end
			else
				if not minetest.registered_nodes[minetest.get_node(under).name.."__fake"] then
					print("WARNING: "..minetest.get_node(under).name.."__fake does not exist!")
					minetest.chat_send_all("that node is unsupported by the fakes mod")
					return
				end

				local node = minetest.get_node(under)
				node.name = node.name.."__fake"
				minetest.add_node(above, node)
				if not minetest.setting_getbool("creative_mode") then
					itemstack:take_item()
				end
			end
		end
		return itemstack
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
