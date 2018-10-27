minetest.register_node("survivalist:tank",{
	description = "Liquid Storage Tank",
	tiles = {"survivalist_tank.png"},
	on_rightclick = function(pos, node, clicker, itemstack)
		if not clicker then return end
		local meta = minetest.get_meta(pos)
		local wielded = itemstack:get_name()
		local wear = itemstack:get_wear()
		local wieldcount = itemstack:get_count()
		local stored = meta:get_string("stored")
		local amount = tonumber(meta:get_string("amount")) or 0
		local take_item = wieldcount
		local new_amount = amount+wieldcount
		if wielded == "" then return end
		if wear ~= 0 then return end
		if amount >= 10000 then return end
		if stored == "" or stored == wielded then
			if new_amount > 10000 then
				take_item = 10000-amount
				new_amount = 10000
			end
			meta:set_string("stored", wielded);
			meta:set_string("amount", new_amount);
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
		local give = 0
		if stored ~= "" then
			local fullstack = minetest.registered_items[stored].stack_max
			if amount > 0 and amount <= fullstack then give = amount end
			if amount > fullstack then give = fullstack end
			survivalist.hacky_give_item(puncher, stored, give)
			local new_amount = amount-give
			meta:set_string("amount", new_amount);
			if new_amount == 0 then
				meta:set_string("stored", "");
				meta:set_string("infotext", "")
			else
				meta:set_string("infotext", stored.." "..new_amount)
			end
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local stored = meta:get_string("stored")
		local diggable = true
		if stored == "" then 
			diggable = true
		end
		return diggable
	end,
	groups = {cracky=1,oddly_breakable_by_hand=1}
})
