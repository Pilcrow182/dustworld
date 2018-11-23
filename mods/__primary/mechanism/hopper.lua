local hopper = {}

hopper.shapes = {
	{-5/16,  3/16,  5/16,  8/16,  8/16,  8/16}, --top-north
	{ 5/16,  3/16, -8/16,  8/16,  8/16,  5/16}, --top-south
	{-8/16,  3/16, -8/16,  5/16,  8/16, -5/16}, --top-east
	{-8/16,  3/16, -5/16, -5/16,  8/16,  8/16}, --top-west
	{-5/16, -3/16, -5/16,  5/16,  3/16,  5/16}, --middle
	{-2/16, -8/16, -2/16,  2/16, -3/16,  2/16}, --spout-down
	{-2/16, -2/16,  5/16,  2/16,  2/16,  8/16}, --spout-side
}

hopper.rev_shapes = {}
hopper.rev_side_shapes = {}
for i=1,#hopper.shapes do
	local x1, y1, z1 = hopper.shapes[i][1], hopper.shapes[i][2], hopper.shapes[i][3]
	local x2, y2, z2 = hopper.shapes[i][4], hopper.shapes[i][5], hopper.shapes[i][6]
	hopper.rev_shapes[i] = {x1, 0 - y1, z1, x2, 0 - y2, z2}
	hopper.rev_side_shapes[i] = {x1, z1, y1, x2, z2, y2}
end

function hopper.place_hopper(itemstack, placer, pointed_thing, topnode, sidenode)
	if not pointed_thing then return end
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if pointed_thing.type ~= "node" then
		return itemstack
	end

	if placer and not placer:get_player_control().sneak then
		local n = minetest.get_node(p0)
		local nn = n.name
		if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
			return minetest.registered_nodes[nn].on_rightclick(p0, n, placer, itemstack) or itemstack, false
		end
	end

	if not minetest.registered_nodes[minetest.get_node(p1).name].buildable_to then
		return itemstack
	end
	
	local dir = {
		x = p1.x - p0.x,
		y = p1.y - p0.y,
		z = p1.z - p0.z
	}
	param2 = minetest.dir_to_facedir(dir,false)
	local correct_rotation={
		[0]=2,
		[1]=3,
		[2]=0,
		[3]=1
	}
	if dir.y == 0 then
		minetest.set_node(p1, {name=sidenode,param2=correct_rotation[param2]})		--point hopper sideways
	else
		minetest.set_node(p1, {name=topnode})						--point hopper down
	end
	itemstack:take_item()
	return itemstack
end

hopper.make_inventory = function(pos)
	hopper.inv_formspec = 
		"size[10,7]"..
		"list[current_name;main;2.5,1;5,1;]"..
		"list[current_player;main;0,3;10,4;]"

	local meta = minetest.get_meta(pos)
	meta:set_string("formspec",hopper.inv_formspec)
	meta:set_string("infotext", "Hopper")
	local inv = meta:get_inventory()
	inv:set_size("main", 5*1)
end

hopper.dig_hopper = function(pos,player) return minetest.get_meta(pos):get_inventory():is_empty("main") end

hopper.item_pickup = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for _,object in ipairs(minetest.get_objects_inside_radius({x = pos.x, y = pos.y + 0.5, z = pos.z}, 1)) do
		if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
			if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
				inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
				object:get_luaentity().itemstring = ""
				object:remove()
			end
		end
	end
end

hopper.get_dstpos = function(pos)
	local name = minetest.get_node(pos).name
	if name == "mechanism:hopper" then return {x = pos.x, y = pos.y - 1, z = pos.z} end
	local dir_to_pos = {
		[0] = {x = pos.x, y = pos.y, z = pos.z + 1},
		[1] = {x = pos.x + 1, y = pos.y, z = pos.z},
		[2] = {x = pos.x, y = pos.y, z = pos.z - 1},
		[3] = {x = pos.x - 1, y = pos.y, z = pos.z}
	}
	return dir_to_pos[minetest.get_node(pos).param2]
end

minetest.register_node("mechanism:hopper", {
	description = "Hopper",
	drawtype = "nodebox",
	tiles = {"mechanism_hopper.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			hopper.shapes[1], hopper.shapes[2],
			hopper.shapes[3], hopper.shapes[4],
			hopper.shapes[5], hopper.shapes[6]
		},
	},
	on_place = function(itemstack, placer, pointed_thing) return hopper.place_hopper(itemstack, placer, pointed_thing, "mechanism:hopper", "mechanism:hopper_side") end,
	on_construct = function(pos) return hopper.make_inventory(pos) end,
	can_dig = function(pos,player) return hopper.dig_hopper(pos,player) end,
	groups = {hopper=1,cracky=2,oddly_breakable_by_hand=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("mechanism:hopper_side", {
	description = "Hopper",
	drawtype = "nodebox",
	tiles = {"mechanism_hopper.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			hopper.shapes[1], hopper.shapes[2],
			hopper.shapes[3], hopper.shapes[4],
			hopper.shapes[5], hopper.shapes[7]
		},
	},
	on_construct = function(pos) return hopper.make_inventory(pos) end,
	can_dig = function(pos,player) return hopper.dig_hopper(pos,player) end,
	groups = {hopper=1,cracky=2,oddly_breakable_by_hand=1,not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
	drop = "mechanism:hopper"
})

minetest.register_craft({
	output = 'mechanism:hopper',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:chest', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})

if minetest.get_modpath("flint") ~= nil then
	minetest.register_craft({
		output = 'mechanism:hopper',
		recipe = {
			{'flint:flintstone', '', 'flint:flintstone'},
			{'flint:flintstone', 'default:chest', 'flint:flintstone'},
			{'', 'flint:flintstone', ''},
		}
	})
end

minetest.register_abm({
	nodenames = {"mechanism:hopper", "mechanism:hopper_side"},
	interval = 2,
	chance = 1,
	action = function(pos)
		minetest.after(0, function()
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local src = {x = pos.x, y = pos.y + 1, z = pos.z}
			local dst = hopper.get_dstpos(pos)
			local pickup = not minetest.registered_nodes[minetest.get_node(src).name].walkable

			if minetest.get_item_group(minetest.get_node(src).name, "hopper") == 0 then	-- make sure source node is not a hopper
				local pull = mechanism.pushpull(src, pos)				-- pull item from source inventory
				if pickup then hopper.item_pickup(pos) end				-- pick up loose items dropped onto hopper
			end
			minetest.after(1, function()							-- wait one second, to prevent infinite loops
				mechanism.pushpull(pos, dst, true)					-- push item into destination inventory
			end)
		end)
	end
})
