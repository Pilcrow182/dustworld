fakes.make_extender = function(name)
	local realblock = minetest.registered_nodes[name]
	if not realblock then return end
	if realblock.paramtype2 == "none" and realblock.drawtype == "normal" then
		local fakeblock={
			tiles = realblock.tiles,
			description = "Extended "..(realblock.description or "Block").." (cheater!)",
			light_source = realblock.light_source,
			sunlight_propagates = realblock.sunlight_propagates,
			drawtype = 'nodebox',
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5,  0.5, -0.5, 0.5, 1.5, 0.5}, -- extension
					{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- node
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {
					{-0.5,  0.5, -0.5, 0.5, 1.5, 0.5}, -- extension
					{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, -- node
				},
			},
			paramtype = "light",
			paramtype2 = "facedir",
			walkable = true,
			is_ground_content = true,
			groups = {snappy=1, oddly_breakable_by_hand=3, not_in_creative_inventory=1},
			on_dig = function(pos, node, player)
				local oldmeta = minetest.get_meta(pos):to_table()
				minetest.node_dig(pos, node, player)
				minetest.swap_node(pos, {name=node.name:gsub("__extended", "")})
				local meta = minetest.get_meta(pos)
				meta:from_table(oldmeta)
			end,
			sounds = default.node_sound_leaves_defaults(),
			drop="fakes:extender"
		}
		minetest.register_node(":"..name.."__extended", fakeblock)
	end
end

for name,_ in pairs(minetest.registered_nodes) do
	if string.find(name, "__fake") == nil then
		fakes.make_extender(name)
	end
end

minetest.register_craftitem("fakes:extender", {
	description = "Camo Extender",
	inventory_image = "fakes_camoextender_inv.png",
	wield_image = "fakes_camoblock.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	liquids_pointable = true,
	on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing or pointed_thing.type ~= "node" then return itemstack end
		local node_under = minetest.get_node(pointed_thing.under)
		if not node_under.name or not minetest.registered_nodes[node_under.name] then
			return itemstack
		elseif minetest.registered_nodes[node_under.name].on_rightclick and not placer:get_player_control().sneak then
			return minetest.registered_nodes[node_under.name].on_rightclick(pointed_thing.under, node_under, placer, itemstack)
		end

		local rotation = {
			from_0 = 6,
			from_1 = 15,
			from_2 = 8,
			from_3 = 17,
			from_4 = 22,
			from_8 = 0
		}

		if placer and pointed_thing.above and pointed_thing.under then
			if node_under and minetest.registered_nodes[node_under.name.."__extended"] then
				local param2 = rotation["from_"..minetest.dir_to_facedir(vector.subtract(pointed_thing.above, pointed_thing.under), true)]
				minetest.swap_node(pointed_thing.under, {name=node_under.name.."__extended", param2=param2})
				itemstack:take_item()
				return itemstack
			end
		end
	end
})

minetest.register_craft({
	output = "fakes:extender",
	recipe = {
		{"fakes:camoblock"},
		{"fakes:camoblock"}
	}
})

minetest.register_craft({
	output = "fakes:camoblock 2",
	recipe = {
		{"fakes:extender"},
	}
})

