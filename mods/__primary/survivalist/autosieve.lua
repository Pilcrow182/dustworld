minetest.register_node("survivalist:machine_autosieve",{
	description = "autosieve",
	tiles = {"survivalist_barrel.png", "survivalist_barrel.png", "survivalist_machine_autosieve.png"},
	drawtype = "normal",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", survivalist.get_machine_active_formspec(nil, 100, 9))
		meta:set_string("infotext", "Autosieve")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 9)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not ( inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src") ) then return false end
		return true
	end,
	is_ground_content = false,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2},
	drop = "survivalist:machine_autosieve"
})

minetest.register_node("survivalist:machine_autosieve_on",{
	description = "autosieve (on)",
	tiles = {
		"survivalist_barrel.png",
		"survivalist_barrel.png",
		{ name="survivalist_machine_autosieve_on.png",
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
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", survivalist.get_machine_active_formspec(nil, 100, 9))
		meta:set_string("infotext", "Autosieve")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 9)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not ( inv:is_empty("fuel") and inv:is_empty("dst") and inv:is_empty("src") ) then return false end
		return true
	end,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2},
	drop = "survivalist:machine_autosieve"
})

local get_output = function(input)
	if not survivalist.sieve_lookup[input] then return false end
	local droprates = survivalist.sieve_lookup[input]
	local j, output = nil, ""
	for i=1,#droprates do
		if math.random(1,2) == 2 then j=1+#droprates-i else j=i end
		if math.random(1,droprates[j].rarity) == math.ceil(droprates[j].rarity/2) then output = droprates[j].items[1] break end
	end
	return output
end

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
	output = get_output(src:get_name())
	if output and src:get_count() > 0 and inv:room_for_item("dst", {name=output, count=1}) then
		inv:set_stack("src", 1, {name = src:get_name(), count = src:get_count() - 1})
		meta:set_string("output", output)
		return true
	else
		return false
	end
end

local check_input = function(name)
	if survivalist.sieve_lookup[name] then
		return true
	else
		return false
	end
end

minetest.register_abm({
	nodenames = {"survivalist:machine_autosieve","survivalist:machine_autosieve_on"},
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
				if step >= 3 then
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
				meta:set_string("formspec", survivalist.get_machine_active_formspec(pos, math.floor(((ttime-rtime)/ttime)*100), 9))
			else
				minetest.swap_node(pos,{name="survivalist:machine_autosieve_on"})

				if output == "" then
					take_src(inv, meta)
					meta:set_string("step", 0)
				end
				meta:set_string("formspec", survivalist.get_machine_active_formspec(pos, math.floor(((ttime-rtime)/ttime)*100), 9))
			end
		elseif string.find(minetest.get_node(pos).name, "_on") then
			if rtime > 0 then
				rtime = rtime - 1
				meta:set_string("rtime", rtime)
				meta:set_string("formspec", survivalist.get_machine_active_formspec(pos, math.floor(((ttime-rtime)/ttime)*100), 9))
			else
				meta:set_string("ttime", 0)
				meta:set_string("rtime", 0)
				minetest.swap_node(pos,{name="survivalist:machine_autosieve"})
			end
		end
	end
})
