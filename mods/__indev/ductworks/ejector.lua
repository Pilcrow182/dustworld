local make_inventory = function(pos, pagenum, player)
	local meta = minetest.get_meta(pos)
	meta:get_inventory():set_size("tmp", 4*3)
	pagenum = pagenum or 0
	meta:set_string("pagenum", pagenum)

	local page = "size[14,11]".."label[0.4,0.1;Inventory]".."button[2,0;2,1;page1;Configuration]"..
		"list[current_name;tmp;5,2;4,3;]".."list[current_player;main;2,6.25;10,4;]"

	if pagenum == 1 then
		page = "size[14,11]".."button[0,0;2,1;page0;Inventory]".."label[2.15,0.1;Configuration]"

		for x, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
			local dir_type = meta:get_string(dir..":type")

			page = page..
			"image["..(0.0+(x-1)*2.3)..",1;2.78,11.62;ductworks_border_"..dir..".png]"..
			"image["..(0.2+(x-1)*2.3)..",1.2;2.25,1;ductworks_config_"..dir..".png]"..
			"button["..(0.2+(x-1)*2.3)..",1.55;2.02,2.25;"..dir..":type;"..((dir_type == "" and "Items") or dir_type).."]"

			for y = 1, 8 do
				local item = meta:get_string(dir..":item"..y)
				page = page.."item_image_button["..(0.2+(x-1)*2.3)..","..(y+2)..";1,1;"..item..";"..dir..":item"..y..";]"

				if item ~= "" then
					page = page.."textarea["..(1.35+(x-1)*2.3)..","..(y+2.1)..";0.8,0.8;"..dir..":count"..y..";;"..meta:get_string(dir..":count"..y).."]"
					page = page.."image_button["..(1.7+(x-1)*2.3)..","..(y+2.115)..";0.5,0.706;ductworks_write.png;"..dir..":edit"..y..";]"
				end
			end
		end
	elseif pagenum == 2 then
		page = "size[14,11]".."button[0,0;2,1;page0;Inventory]".."button[2,0;2,1;page1;Configuration]"

		local itemslot, item = 0, ""
		for x = 0, 3 do for y = 0, 2 do
			item = meta:get_inventory():get_stack("tmp", (x + 4*y + 1)):get_name()
			page = page.."item_image_button["..(5 + x)..","..(2 + y)..";1,1;"..item..";"..item..";]"
		end end

		page = page.."item_image_button[3,3;1,1;ductworks:wildcard;ductworks:wildcard;]"
		page = page.."item_image_button[10,3;1,1;ductworks:overflow;ductworks:overflow;]"

		if player then
			local itemslot, item = 0, ""
			for x = 0, 9 do for y = 0, 3 do
				item = player:get_inventory():get_stack("main", (x + 10*y + 1)):get_name()
				page = page.."item_image_button["..(2 + x)..","..(6.25 + y)..";1,1;"..item..";"..item..";]"
			end end
		end
	end
	meta:set_string("formspec", page)
end

local process_inputs = function(pos, formname, fields, sender)
	local dirs = {"north", "south", "east", "west", "up", "down"}
	local meta = minetest.get_meta(pos)

	if tonumber(meta:get_string("pagenum")) == 2 then
		if fields.quit then return make_inventory(pos, 1) end

		local selection = meta:get_string("selection")
		meta:set_string("selection", "")
		if not (fields.quit or fields.page0 or fields.page1) then
			for item,_ in pairs(fields) do
				meta:set_string(selection, item)
				meta:set_string(selection:gsub("item", "count"), (item == "" and "") or 1)
			end
			return make_inventory(pos, 1)
		end
	end

	for _,dir in ipairs(dirs) do
		for slot = 1, 8 do
			if fields[dir..":count"..slot] then
				local count = math.floor(0.5 + math.min(999, math.max(0, tonumber(fields[dir..":count"..slot]) or 0)))
				if count == 0 then
					meta:set_string(dir..":item"..slot, "")
					meta:set_string(dir..":count"..slot, "")
				else
					meta:set_string(dir..":count"..slot, count)
				end
			end
		end
	end

	for _,dir in ipairs(dirs) do
		for slot = 1, 8 do
			if fields[dir..":edit"..slot] then return make_inventory(pos, 1) end
			if fields[dir..":item"..slot] then
				meta:set_string("selection", dir..":item"..slot)
			end
		end
	end

	for _,dir in ipairs(dirs) do
		if fields[dir..":type"] then
			local dir_type = meta:get_string(dir..":type")
			meta:set_string(dir..":type", (dir_type == "Fuel" and "") or "Fuel")
			return make_inventory(pos, 1)
		end
	end

	if fields.quit then return end
	if fields.page0 then return make_inventory(pos, 0) end
	if fields.page1 then return make_inventory(pos, 1) end

	return make_inventory(pos, 2, sender)
end

local facedir_to_dirname = {["0"] = "north", ["1"] = "east", ["2"] = "south", ["3"] = "west", ["4"] = "down", ["6"] = "up"}

local get_needed = function(meta)
	local needed = {}
	for facedir, dirname in pairs(facedir_to_dirname) do
		for index = 1, 8 do
			local item = meta:get_string(dirname..":item"..index)
			local count = meta:get_string(dirname..":count"..index)
			if item ~= "" and count ~= "" then
				needed[item] = needed[item] or {}
				needed[item].total = (needed[item].total or 0) + tonumber(count)
				needed[item][dirname] = (needed[item][dirname] or 0) + tonumber(count)
			end
		end
	end
	return needed
end

local get_stock = function(meta)
	local stock = {}
	for _,stack in pairs(meta:get_inventory():get_list("tmp")) do
		local item = stack:get_name()
		local count = stack:get_count()
		if item ~= "" and count ~= 0 then
			stock[item] = (stock[item] or 0) + count
		end
	end
	return stock
end

local run_ejector = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local needs = get_needed(meta)
	local stock = get_stock(meta)

	for item, count in pairs(stock) do
		local needed = ((needs[item] and needs[item].total) or 0) --TODO: incorporate needs["ductworks:wildcard"] somehow

		while needed > 0 and count >= needed do
			local send = true
			for facedir, dirname in pairs(facedir_to_dirname) do
				if needs[item][dirname] then
					local basename = meta:get_string(dirname..":type")
					basename = (basename == "Fuel" and "fuelduct") or "itemduct"
					local dstpos = ductworks.find_dst(vector.add(pos, minetest.facedir_to_dir(facedir)), basename)
					if dstpos and ductworks.valid_dst(dstpos, basename) then
						send = send and ductworks.room_for_item(ItemStack({name = item, count = needs[item][dirname]}), dstpos, ductworks.valid_dst(dstpos, basename))
					else
						send = false
					end
				end
			end

			if send then
				for facedir, dirname in pairs(facedir_to_dirname) do
					if needs[item][dirname] then
						local basename = meta:get_string(dirname..":type")
						basename = (basename == "Fuel" and "fuelduct") or "itemduct"
						local dstpos = ductworks.find_dst(vector.add(pos, minetest.facedir_to_dir(facedir)), basename)
						ductworks.transfer(pos, dstpos, basename, ItemStack({name = item, count = needs[item][dirname]}))
						count = count - needs[item][dirname]
					end
				end
			end
		end
	end
end

minetest.register_node("ductworks:ejector", {
	description = "Ejector",
	drawtype = "nodebox",
	tiles = {
		"ductworks_base.png^ductworks_ejector_up.png",
		"ductworks_base.png^ductworks_ejector_down.png",
		"ductworks_base.png^ductworks_ejector_east.png",
		"ductworks_base.png^ductworks_ejector_west.png",
		"ductworks_base.png^ductworks_ejector_north.png",
		"ductworks_base.png^ductworks_ejector_south.png"
	},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-4/16, -4/16, -4/16,  4/16,  4/16,  4/16}, --center
			{-3/16,  4/16, -3/16,  3/16,  6/16,  3/16}, --up1
			{-2/16,  6/16, -2/16,  2/16,  8/16,  2/16}, --up2
			{-3/16, -6/16, -3/16,  3/16, -4/16,  3/16}, --down1
			{-2/16, -8/16, -2/16,  2/16, -6/16,  2/16}, --down2
			{-3/16, -3/16,  4/16,  3/16,  3/16,  6/16}, --north1
			{-2/16, -2/16,  6/16,  2/16,  2/16,  8/16}, --north2
			{-3/16, -3/16, -6/16,  3/16,  3/16, -4/16}, --south1
			{-2/16, -2/16, -8/16,  2/16,  2/16, -6/16}, --south2
			{ 4/16, -3/16, -3/16,  6/16,  3/16,  3/16}, --east1
			{ 6/16, -2/16, -2/16,  8/16,  2/16,  2/16}, --east2
			{-6/16, -3/16, -3/16, -4/16,  3/16,  3/16}, --west1
			{-8/16, -2/16, -2/16, -6/16,  2/16,  2/16}, --west2
		},
	},
	groups = {cracky=2,oddly_breakable_by_hand=1},
	on_timer = function(pos, elapsed) return run_ejector(pos) end,
	on_metadata_inventory_put = function(pos) return minetest.get_node_timer(pos):start(0) end,
	on_construct = function(pos) return make_inventory(pos, 1) end,
	on_receive_fields = function(pos, formname, fields, sender) return process_inputs(pos, formname, fields, sender) end,
	can_dig = function(pos, player) return minetest.get_meta(pos):get_inventory():is_empty("tmp") end
})

minetest.register_craftitem("ductworks:wildcard", {
	description = "Wildcard",
	inventory_image = minetest.inventorycube("ductworks_wildcard.png"),
	groups = {not_in_creative_inventory = 1}
})

minetest.register_craftitem("ductworks:overflow", {
	description = "Overflow",
	inventory_image = minetest.inventorycube("ductworks_overflow.png"),
	groups = {not_in_creative_inventory = 1}
})

