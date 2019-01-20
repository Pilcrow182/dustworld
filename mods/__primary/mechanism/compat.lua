local clone_node = function(name)
	node2={}
	node=minetest.registered_nodes[name]
	for k,v in pairs(node) do
		node2[k]=v
	end
	return node2
end

if minetest.get_modpath("pipeworks") ~= nil then
	minetest.log("action", "Adding pipeworks compatibility to chomper")
	for _,state in pairs({"", "_on"}) do
		local def = clone_node("mechanism:chomper"..state)
		def.groups.tubedevice = 1
		def.groups.tubedevice_receiver = 1
		def.tube = {
			insert_object = function(pos, node, stack, direction)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				return inv:add_item("main", stack)
			end,
			can_insert = function(pos, node, stack, direction)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				return inv:room_for_item("main", stack)
			end,
			input_inventory = "main",
			connect_sides = {left = 1, right = 1, back = 1, front = 1, bottom = 1, top = 1}
		}
		def.after_place_node = function(pos)
			tube_scanforobjects(pos)
		end
		def.after_dig_node = function(pos)
			tube_scanforobjects(pos)
		end
		minetest.register_node("mechanism:chomper"..state, def)
	end
end

