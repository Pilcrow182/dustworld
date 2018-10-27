local function nodemodel(scale, boxes)
	local fixed = {}
	for i=1,#boxes do
		table.insert(fixed, {boxes[i][1]/scale, boxes[i][2]/scale, boxes[i][3]/scale, boxes[i][4]/scale, boxes[i][5]/scale, boxes[i][6]/scale})
	end
	return fixed
end

minetest.register_node("survivalist:crate",{
	description = "Storage Crate",
	tiles = {"survivalist_crate.png"},
	drawtype="nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = nodemodel(16, {
			{-6,-6,-6, 6, 6, 6},
			{-5, 5, 5, 8, 8, 8},
			{ 5, 5,-8, 8, 8, 5},
			{-8, 5,-8, 5, 8,-5},
			{-8, 5,-5,-5, 8, 8},
			{-8,-8, 5, 5,-5, 8},
			{ 5,-8,-5, 8,-5, 8},
			{-5,-8,-8, 8,-5,-5},
			{-8,-8,-8,-5,-5, 5},
			{-8,-5, 5,-5, 5, 8},
			{ 5,-5, 5, 8, 5, 8},
			{ 5,-5,-8, 8, 5,-5},
			{-8,-5,-8,-5, 5,-5}
		})
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker then return end
		local meta = minetest.get_meta(pos)
		local wielded = itemstack:get_name()
		local wieldcount = itemstack:get_count()
		local wieldwear = itemstack:get_wear()
		local stored = meta:get_string("stored")
		local amount = tonumber(meta:get_string("amount")) or 0
		local wear = tonumber(meta:get_string("wear")) or 0
		local take_item = wieldcount
		local new_amount = amount+wieldcount
		if wielded == "" then return end
		if amount >= 9999 then return end
		if wear ~= wieldwear and stored ~= "" then return end
		if stored == "" or stored == wielded then
			if new_amount > 9999 then
				take_item = 9999-amount
				new_amount = 9999
			end
			meta:set_string("stored", wielded)
			meta:set_string("amount", new_amount)
			meta:set_string("wear", wieldwear)
			meta:set_string("infotext", wielded.." "..new_amount)
			itemstack:take_item(take_item)
			return itemstack
		end
	end,
	on_punch = function(pos, node, puncher)
		if not puncher then return end
		local itemstack = puncher:get_wielded_item()
		local meta = minetest.get_meta(pos)
		local wielded = itemstack:get_name()
		local stored = meta:get_string("stored")
		local amount = tonumber(meta:get_string("amount")) or 0
		local wear = tonumber(meta:get_string("wear")) or 0
		local give = 0
		if stored ~= "" then --and wielded == "" then
			local fullstack = minetest.registered_items[stored].stack_max
			if amount > 0 and amount <= fullstack then give = amount end
			if amount > fullstack then give = fullstack end
-- 			puncher:set_wielded_item(stored.." "..give)
			survivalist.hacky_give_item(puncher, stored, give, nil, wear)
			local new_amount = amount-give
			meta:set_string("amount", new_amount)
			if new_amount == 0 then
				meta:set_string("stored", "")
				meta:set_string("wear", "0")
				meta:set_string("infotext", "")
			else
				meta:set_string("infotext", stored.." "..new_amount)
			end
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local stored = meta:get_string("stored")
		local diggable = false
		if stored == "" then 
			diggable = true
		end
		return diggable
	end,
	groups = {choppy=2,oddly_breakable_by_hand=2,metastorage=1},
})

if minetest.get_modpath("pipeworks") ~= nil then
	survivalist.clone_item("survivalist:crate", "survivalist:crate", {
		groups = {choppy=2,oddly_breakable_by_hand=2,metastorage=1,tubedevice=1,tubedevice_receiver=1},
		tube={
			insert_object = function(pos,node,stack,direction)
				local meta = minetest.get_meta(pos)
				local tubed = stack:get_name()
				local amount = tonumber(meta:get_string("amount")) or 0
				local new_amount = amount+stack:get_count()
				local wear = tonumber(meta:get_string("wear")) or 0
				local tubed_wear = stack:get_wear()
				meta:set_string("stored", tubed)
				meta:set_string("amount", new_amount)
				meta:set_string("wear", tubed_wear)
				meta:set_string("infotext", tubed.." "..new_amount)
				return ItemStack(nil)
			end,
			can_insert=function(pos,node,stack,direction)
				local meta = minetest.get_meta(pos)
				local stored, amount, wear = meta:get_string("stored"), tonumber(meta:get_string("amount")) or 0, tonumber(meta:get_string("wear")) or 0
				if amount+stack:get_count() > 9999 or ( stored ~= stack:get_name() and stored ~= "" ) then return end
				if wear ~= stack:get_wear() and stored ~= "" then return end
				return true
			end,
			connect_sides={left=1, right=1, back=1, front=1, bottom=1, top=1}
		},
		after_place_node = function(pos)
			tube_scanforobjects(pos)
		end,
		after_dig_node = function(pos)
			tube_scanforobjects(pos)
		end
	})
end
