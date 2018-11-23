dofile(minetest.get_modpath(minetest.get_current_modname()).."/compat.lua")

function clone_node(name)
	local node2={}
	local node=minetest.registered_nodes[name]
	for k,v in pairs(node) do
		node2[k]=v
	end
	return node2
end

local chest = clone_node("default:chest")
	chest.description = "Mese Chest"
	chest.tiles = {"chestplus_mese_top.png", "chestplus_mese_top.png", "chestplus_mese_side.png",
		"chestplus_mese_side.png", "chestplus_mese_side.png", "chestplus_mese_front.png"}
	chest.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
			"size[10,10]"..
			"list[current_name;main;0,0;10,5;]"..
			"list[current_player;main;0,6;10,4;]")
		meta:set_string("infotext", "Mese Chest")
		local inv = meta:get_inventory()
		inv:set_size("main",10*5)
	end
	if minetest.get_modpath("pipeworks") ~= nil then
		chest.tiles = {"chestplus_mese_top.png", "chestplus_mese_top.png", "chestplus_mese_side_pipeworks.png",
			"chestplus_mese_side_pipeworks.png", "chestplus_mese_side_pipeworks.png", "chestplus_mese_front.png"}
		chest.groups.tubedevice=1
		chest.groups.tubedevice_receiver=1
		chest.tube={insert_object = function(pos,node,stack,direction)
			local meta=minetest.get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("main",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("main",stack)
		end,
		input_inventory="main",
		connect_sides={left=1, right=1, back=1, bottom=1, top=1}}
		chest.after_place_node = function(pos)
			tube_scanforobjects(pos)
		end
		chest.after_dig_node = function(pos)
			tube_scanforobjects(pos)
		end
	end
minetest.register_node("chestplus:mese", chest)

local chest_locked = clone_node("default:chest_locked")
	chest_locked.description = "Locked Mese Chest"
	chest_locked.tiles = {"chestplus_mese_top.png", "chestplus_mese_top.png", "chestplus_mese_side.png",
		"chestplus_mese_side.png", "chestplus_mese_side.png", "chestplus_mese_front_locked.png"}
	chest_locked.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec",
			"size[10,10]"..
			"list[current_name;main;0,0;10,5;]"..
			"list[current_player;main;0,6;10,4;]")
		meta:set_string("infotext", "Locked Mese Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main",10*5)
	end
	if minetest.get_modpath("pipeworks") ~= nil then
		chest_locked.tiles = {"chestplus_mese_top.png", "chestplus_mese_top.png", "chestplus_mese_side_pipeworks.png",
			"chestplus_mese_side_pipeworks.png", "chestplus_mese_side_pipeworks.png", "chestplus_mese_front_locked.png"}
		chest_locked.groups.tubedevice=1
		chest_locked.groups.tubedevice_receiver=1
		chest_locked.tube={insert_object = function(pos,node,stack,direction)
			local meta=minetest.get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("main",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("main",stack)
		end,
		connect_sides={left=1, right=1, back=1, bottom=1, top=1}}
		chest_locked.after_place_node = function(pos, placer)
			tube_scanforobjects(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("owner", placer:get_player_name() or "")
			meta:set_string("infotext", "Locked Mese Chest (owned by "..
			meta:get_string("owner")..")")
		end
		chest_locked.after_dig_node = function(pos)
			tube_scanforobjects(pos)
		end
	end
minetest.register_node("chestplus:mese_locked", chest_locked)

minetest.register_craft({
	output = 'chestplus:mese',
	recipe = {
		{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
		{'default:mese_crystal', '', 'default:mese_crystal'},
		{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
	}
})

minetest.register_craft({
	output = 'chestplus:mese_locked',
	recipe = {
		{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
		{'default:mese_crystal', 'default:steel_ingot', 'default:mese_crystal'},
		{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
	}
})

minetest.register_craft( {
	type = 'shapeless',
	output = 'chestplus:mese_locked',
	recipe = {'chestplus:mese', 'default:steel_ingot'},
})
