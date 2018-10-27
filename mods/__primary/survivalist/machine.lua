machine = {
	{-0.5,-0.5,-0.5,0.5,0.5,0.5}, --Machine_Core
	{-0.0625,0.5,-0.0625,0.0625,0.9375,0.0625}, --Handle_Center
	crank = {
		{-0.0625,0.8125,0.0625,0.0625,0.9375,0.25}, --Handle_North
		{0.0625,0.8125,-0.0625,0.25,0.9375,0.0625}, --Handle_East
		{-0.0625,0.8125,-0.25,0.0625,0.9375,-0.0625}, --Handle_South
		{-0.25,0.8125,-0.0625,-0.0625,0.9375,0.0625}, --Handle_West
	}
}

function survivalist.get_machine_active_formspec(pos, percent)
	local formspec =
		"size[8,9]"..
		"image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
		(100-percent)..":default_furnace_fire_fg.png]"..
		"list[current_name;fuel;2,3;1,1;]"..
		"list[current_name;src;2,1;1,1;]"..
		"list[current_name;dst;5,1;2,2;]"..
		"list[current_player;main;0,5;8,4;]"
	return formspec
end

survivalist.machine_inactive_formspec =
	"size[8,9]"..
	"image[2,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2,3;1,1;]"..
	"list[current_name;src;2,1;1,1;]"..
	"list[current_name;dst;5,1;2,2;]"..
	"list[current_player;main;0,5;8,4;]"


function survivalist.swap_machine(pos, machine_type)
	local n=minetest.get_node(pos)
	local nn = n.name
	local meta=minetest.get_meta(pos)
	local meta0=meta:to_table()

	for i=1,3 do
		if nn == "survivalist:machine_"..machine_type.."_"..i then becomes = "survivalist:machine_"..machine_type.."_"..i+1 end
	end
	if nn == "survivalist:machine_"..machine_type.."_4" then becomes = "survivalist:machine_"..machine_type.."_1" end

	minetest.set_node(pos, {name=becomes})
	local meta=minetest.get_meta(pos)
	meta:from_table(meta0)
end

function survivalist.register_machine(machine_type, itemtable)
	local function check_input(input)
		local conversion = nil
		for i=1,#itemtable do
			if input == itemtable[i][1] then conversion = itemtable[i] end
		end
		return conversion
	end

	for i = 1,4 do
		minetest.register_node("survivalist:machine_"..machine_type.."_"..i,{
			description = machine_type,
			tiles = {"survivalist_machine_"..machine_type.."_top.png", "survivalist_machine_"..machine_type.."_top.png", "survivalist_machine_"..machine_type.."_"..i..".png"},
			drawtype = "nodebox",
			paramtype = "light",
			node_box = {
				type = "fixed",
				fixed = {machine[1], machine[2], machine.crank[i]}
			},
			on_rightclick = function(pos, node, clicker, itemstack)
				if not clicker then return end
				local meta = minetest.get_meta(pos)
				local wielded = itemstack:get_name()
				local processing = meta:get_string("processing")
				local worktime = meta:get_int("worktime") or 0
				local conv1 = check_input(wielded)
				local conv2 = check_input(processing)
				if conv2 then
					worktime = worktime + 1
					meta:set_string("worktime", tostring(worktime));
					if worktime >= 3 then
						meta:set_string("worktime", "0");
						meta:set_string("processing", nil);
						survivalist.hacky_give_item(clicker, conv2[2], 1, itemstack) -- clicker:get_inventory():add_item("main", conv2[2])
					end
				elseif conv1 then
					meta:set_string("worktime", "0");
					meta:set_string("processing", conv1[1]);
					itemstack:take_item(1)
				end
				survivalist.swap_machine(pos, machine_type)
				return itemstack
			end,
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
			drop = "survivalist:machine_"..machine_type.."_1"
		})
	end

	local automachine_on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", survivalist.machine_inactive_formspec)
		meta:set_string("infotext", "Auto"..machine_type)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 4)
	end
	local automachine_can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end
	local automachine_allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end
	local automachine_allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end

	minetest.register_node("survivalist:machine_auto"..machine_type,{
		description = "auto"..machine_type,
		tiles = {"survivalist_machine_"..machine_type.."_top.png", "survivalist_machine_"..machine_type.."_top.png", "survivalist_machine_auto"..machine_type..".png"},
		drawtype = "normal",
		on_construct = function(pos)
			return automachine_on_construct(pos)
		end,
		can_dig = function(pos,player)
			return automachine_can_dig(pos,player)
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			return automachine_allow_metadata_inventory_put(pos, listname, index, stack, player)
		end,
		allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			return automachine_allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
		end,
		is_ground_content = false,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		drop = "survivalist:machine_auto"..machine_type
	})

	minetest.register_node("survivalist:machine_auto"..machine_type.."_on",{
		description = "auto"..machine_type.." (on)",
		tiles = {
			"survivalist_machine_"..machine_type.."_top.png",
			"survivalist_machine_"..machine_type.."_top.png",
			{ name="survivalist_machine_auto"..machine_type.."_on.png",
				animation={
					type="vertical_frames",
					aspect_w=32,
					aspect_h=32,
					length=1.0
				}
			}
		},
		drawtype = "normal",
		on_construct = function(pos)
			return automachine_on_construct(pos)
		end,
		can_dig = function(pos,player)
			return automachine_can_dig(pos,player)
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			return automachine_allow_metadata_inventory_put(pos, listname, index, stack, player)
		end,
		allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			return automachine_allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
		end,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		drop = "survivalist:machine_auto"..machine_type
	})

	local take_fuel = function(inv, meta)
		local fuel = inv:get_stack("fuel", 1)
		local burntime = minetest.get_craft_result({method="fuel",width=1,items={fuel}}).time
		if fuel:get_count() > 0 and burntime > 0 then
			inv:set_stack("fuel", 1, {name = fuel:get_name(), count = fuel:get_count() - 1})
			meta:set_string("ttime", burntime)
			meta:set_string("rtime", burntime)
			return true
		else
			return false
		end
	end

	local take_src = function(inv, meta)
		local src = inv:get_stack("src", 1)
		local conversion = check_input(src:get_name())
		if conversion and src:get_count() > 0 and inv:room_for_item("dst", {name=conversion[2], count=1}) then
			inv:set_stack("src", 1, {name = src:get_name(), count = src:get_count() - 1})
			meta:set_string("output", conversion[2])
			return true
		else
			return false
		end
	end

	minetest.register_abm({
		nodenames = {"survivalist:machine_auto"..machine_type,"survivalist:machine_auto"..machine_type.."_on"},
		interval = 1.0,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()

			local ttime = meta:get_int("ttime") or 0
			local rtime = meta:get_int("rtime") or 0
			local step = meta:get_int("step") or 0
			local output = meta:get_string("output")

			local valid_input = check_input(inv:get_stack("src", 1):get_name())

			if ( output ~= "" or valid_input ) and ( rtime > 0 or take_fuel(inv, meta) ) then
				ttime = meta:get_int("ttime")
				rtime = meta:get_int("rtime")

				if string.find(minetest.get_node(pos).name, "_on") then
					if step >= 3 and output ~= "" then
						if inv:room_for_item("dst", {name=output, count=1}) then
							inv:add_item("dst", output)
							meta:set_string("output", "")
							meta:set_string("step", 0)
						end
					else
						if output == "" then take_src(inv, meta) end
						step = step + 1
						meta:set_string("step", step)
					end

					if rtime > 0 then rtime = rtime - 1 end
					meta:set_string("rtime", rtime)
					meta:set_string("formspec", survivalist.get_machine_active_formspec(pos, math.floor(((ttime-rtime)/ttime)*100)))
				else
					minetest.swap_node(pos,{name="survivalist:machine_auto"..machine_type.."_on"})

					if output == "" then
						take_src(inv, meta)
						meta:set_string("step", 0)
					end
					meta:set_string("formspec", survivalist.get_machine_active_formspec(pos, math.floor(((ttime-rtime)/ttime)*100)))
				end
			elseif string.find(minetest.get_node(pos).name, "_on") then
				if rtime > 0 then
					rtime = rtime - 1
					meta:set_string("rtime", rtime)
					meta:set_string("formspec", survivalist.get_machine_active_formspec(pos, math.floor(((ttime-rtime)/ttime)*100)))
				else
					meta:set_string("ttime", 0)
					meta:set_string("rtime", 0)
					minetest.swap_node(pos,{name="survivalist:machine_auto"..machine_type})
				end
			end
		end,
	})
end

survivalist.register_machine("grinder", {
	{"default:cobble", "default:gravel"},
	{"default:gravel", "default:sand"},
	{"default:sand", "wasteland:dust"},
	{"default:desert_stone", "default:desert_sand"},
	{"default:desert_sand", "wasteland:dust"},
	{"default:desert_sand", "wasteland:dust"},
	{"survivalist:oak_sapling", "survivalist:mulch"},
	{"survivalist:apple_sapling", "survivalist:mulch"},
	{"default:sapling", "survivalist:mulch"},
	{"default:apple", "survivalist:mulch"},
	{"default:cactus", "survivalist:mulch"},
	{"default:leaves", "survivalist:mulch"},
	{"survivalist:apple_leaves", "survivalist:mulch"},
	{"flint:flintstone_block", "default:gravel"},
})
survivalist.register_machine("compressor", {
	{"default:coalblock", "default:diamond"},
	{"default:gravel", "default:cobble"},
	{"default:sand", "default:gravel"},
	{"wasteland:dust", "default:sand"},
	{"default:desert_sand", "default:desert_stone"},
	{"survivalist:mulch", "default:coal_lump"},
	{"bed:bed_bottom", "bed:minibed"},
})
