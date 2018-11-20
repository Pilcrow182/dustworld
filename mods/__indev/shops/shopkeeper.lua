local function remove_top(pos)
	local n = minetest.get_node_or_nil(pos)
	if not n then return end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x = pos.x, y = pos.y + 1, z = pos.z}
	local n2 = minetest.get_node(p)
	if n2.name == "shops:shopkeeper_upper" then
		minetest.remove_node(p)
	end
end

local function add_top(pos)
	local n = minetest.get_node_or_nil(pos)
	if not n or not n.param2 then
		minetest.remove_node(pos)
		return true
	end
	local p = {x = pos.x, y = pos.y + 1,z = pos.z}
	local n2 = minetest.get_node_or_nil(p)
	local def = minetest.registered_items[n2.name] or nil
	if not n2 or not def or not def.buildable_to then
		minetest.remove_node(pos)
		return true
	end
	minetest.set_node(p, {name = "shops:shopkeeper_upper", param2 = n.param2})
	return false
end

minetest.register_node("shops:shopkeeper_upper", {
	tiles = {
		"shops_shopkeeper_upper_top.png",
		"shops_shopkeeper_upper_bottom.png",
		"shops_shopkeeper_upper_right.png",
		"shops_shopkeeper_upper_left.png",
		"shops_shopkeeper_upper_back.png",
		"shops_shopkeeper_upper_front.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-4/16,  0/16,-4/16, 4/16, 8/16, 4/16}, -- Head
			{-1/16,  3/16,-9/32, 1/16, 5/16,-4/16}, -- Nose
			{-8/16, -8/16,-2/16, 8/16, 0/16, 2/16}, -- Torso
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0,0,0,0,0,0}, -- None
		},
	}
})

minetest.register_node("shops:shopkeeper", {
	tiles = {
		"shops_shopkeeper_lower_top.png",
		"shops_shopkeeper_lower_bottom.png",
		"shops_shopkeeper_lower_right.png",
		"shops_shopkeeper_lower_left.png",
		"shops_shopkeeper_lower_back.png",
		"shops_shopkeeper_lower_front.png"
	},
	inventory_image = "shops_shopkeeper_inv.png",
	wield_image = "shops_shopkeeper_inv.png",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, 4/16,-2/16, 8/16, 8/16, 2/16}, -- Butt
			{-4/16,-8/16,-2/16, 4/16, 4/16, 2/16}, -- Legs
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-4/16,16/16,-4/16, 4/16,24/16, 4/16}, -- Head
			{-8/16, 4/16,-2/16, 8/16,16/16, 2/16}, -- Torso
			{-4/16,-8/16,-2/16, 4/16, 4/16, 2/16}, -- Legs
		},
	},
	after_place_node = function(pos, placer, itemstack)
		return add_top(pos)
	end,	
	on_destruct = function(pos)
		return remove_top(pos)
	end,
	on_construct = function(pos)
		shops.update_inventory(pos)
	end,
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.chat_send_player(puncher:get_player_name(), "Updated shopkeeper at "..minetest.pos_to_string(pos))
		shops.update_inventory(pos)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return shops.allow_move(pos, from_list, from_index, to_list, to_index, count, player)
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return shops.on_move(pos, from_list, from_index, to_list, to_index, count, player)
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return shops.allow_put(pos, listname, index, stack, player)
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		return shops.on_put(pos, listname, index, stack, player)
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return shops.allow_take(pos, listname, index, stack, player)
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		return shops.on_take(pos, listname, index, stack, player)
	end,
})
