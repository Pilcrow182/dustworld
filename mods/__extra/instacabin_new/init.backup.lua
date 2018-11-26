instacabin_new = {}

minetest.register_node(":instacabin:void", {
	tiles = {VOID},
	inventory_image = "instacabin_void_inv.png",
	wield_image = "instacabin_void_inv.png",
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {-0.05, -0.05, -0.05, 0.05, 0.05, 0.05},
	},
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {0, 0, 0, 0, 0, 0},
	},
	groups = {dig_immediate=3,not_in_creative_inventory=1},
	drop = ''
})

local instabuild_list = {
	{name = "instacabin_new:shack", x = -3, y = -1, z = 0},
}

for _,def in pairs(instabuild_list) do
	dofile(minetest.get_modpath("instacabin_new")..def.name:gsub(".*:", "/")..".lua")
	local filename = def.name:gsub(":", "_")
	minetest.register_craftitem(def.name, {
		description = string.gsub(" Instant "..def.name:gsub(".*:", ""), "%W%l", string.upper):sub(2), --def.desc,
		inventory_image = filename..".png",
		on_place = function(itemstack, placer, pointed_thing)
			if not ( pointed_thing and pointed_thing.under and pointed_thing.above ) then return end
			local node_under = minetest.get_node(pointed_thing.under)
			if minetest.registered_nodes[node_under.name].on_rightclick then
				return minetest.registered_nodes[node_under.name].on_rightclick(pointed_thing.under, node_under, placer, itemstack)
			else
				local pos = pointed_thing.above
				pos.x, pos.y, pos.z = pos.x + def.x, pos.y + def.y, pos.z + def.z

				local message = "Spawning building at pos "..minetest.pos_to_string(pos)..". Please wait..."
				minetest.chat_send_player(placer:get_player_name(), message)
				minetest.log("action", message)

				minetest.place_schematic(pos, instacabin_new.schems[def.name:gsub(".*:", "")], 0, nil, true)
				itemstack:take_item()
			end
			return itemstack
		end,
	})
end
