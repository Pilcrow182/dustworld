local function overwrite(name, def)
	local item = {}
	local olditem = minetest.registered_items[name]
	if not olditem then return false end
	for k,v in pairs(olditem) do item[k]=v end
	for k,v in pairs(def) do item[k]=v end
	minetest.register_item(":"..name, item)
end

for _,fencename in pairs({"default:fence_wood", "homedecor:fence_brass", "homedecor:fence_wrought_iron"}) do
	overwrite(fencename, {
		on_place = function(itemstack, placer, pointed_thing)
			local node_under = minetest.get_node(pointed_thing.under)
			if (not placer:get_player_control().sneak) and minetest.registered_nodes[node_under.name] and minetest.registered_nodes[node_under.name].on_rightclick then
				return minetest.registered_nodes[node_under.name].on_rightclick(pointed_thing.under, node_under, placer, itemstack)
			end
			if (not homedecor.node_is_owned(pointed_thing.above, placer)) and minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to then
				minetest.add_node(pointed_thing.above, {name = fencename, param2 = minetest.dir_to_facedir(placer:get_look_dir())})
				if not homedecor.expect_infinite_stacks then itemstack:take_item() end
				placer:set_wielded_item(itemstack)
				return itemstack
			end
		end,
		after_destruct = function(pos, oldnode)
			for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1.5)) do
				if object:get_luaentity() and object:get_luaentity().name == "signs:text" then
					object:remove()
				end
			end
		end
	})
end

--  "default:sign_wall" from homedecor's signs_lib.lua, line 125
