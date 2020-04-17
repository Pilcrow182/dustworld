--[[

  Movable storage ('backpack') mod for Minetest

  Copyright (C) 2020 Pilcrow182

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY
  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
  OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

]]--

local colors = {}
for _,R in ipairs({"77", "BB", "FF"}) do
	for _,G in ipairs({"77", "BB", "FF"}) do
		for _,B in ipairs({"77", "BB", "FF"}) do
			if R ~= G or G ~= B or B ~= R then
				table.insert(colors, "#"..R..G..B)
			end
		end
	end
end

local empty_inv = 'return {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""}'

local get_formspec = function(label)
	local formspec = "size[10,10]"..
		"field[0.29,0.34;9,1;label;;"..label.."]"..
		"button[9,0;1,1;write;Write]"..
		"list[current_name;main;0,1;10,4;]"..
		"list[current_player;main;0,6;10,4;]"..
		"listring[current_name;main]"..
		"listring[current_player;main]"
	return formspec
end

minetest.register_node("backpack:backpack", {
	description = "Backpack",
	drawtype = "nodebox",
	tiles = {
		"backpack_cloth.png^backpack_top.png",		--Up	(top)
		"backpack_cloth.png^backpack_bottom.png",	--Down	(bottom)
		"backpack_cloth.png^backpack_right.png",	--East	(right)
		"backpack_cloth.png^backpack_left.png",		--West	(left)
		"backpack_cloth.png^backpack_back.png",		--North	(back)
		"backpack_cloth.png^backpack_front.png"		--South	(front)
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-5/16, -8/16, -2/16,  5/16,  5/16,  5/16},	-- main pocket
			{-5/16, -8/16, -5/16,  5/16,  0/16, -2/16},	-- front pocket
			{-7/16, -8/16,  0/16,  7/16, -1/16,  5/16}, -- side pockets
			{-2/16,  5/16,  2/16, -1/16,  6/16,  4/16},	-- handle left
			{-2/16,  6/16,  2/16,  2/16,  7/16,  4/16},	-- handle middle
			{ 1/16,  5/16,  2/16,  2/16,  6/16,  4/16},	-- handle right
			{-4/16, -7/16,  5/16, -2/16,  4/16,  6/16},	-- strap left
			{ 2/16, -7/16,  5/16,  4/16,  4/16,  6/16}	-- strap right
		},
	},
	groups = {oddly_breakable_by_hand=3},
	drop = "backpack:placeholder",
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local label = "Unlabeled backpack"
		meta:get_inventory():set_size("main", 10*4)
		meta:set_string("formspec", get_formspec(label))
		meta:set_string("infotext", label)
		meta:set_string("label", label)
	end,
	on_place = function(itemstack, placer, pointed_thing)
		local stackmeta = itemstack:get_meta()
		local storage = stackmeta:get_string("storage")
		local label = stackmeta:get_string("description")
		label = (label == "" and "Unlabeled backpack") or label

		minetest.item_place(itemstack, placer, pointed_thing)

		if storage ~= "" and storage ~= empty_inv then
			local nodemeta = minetest.get_meta(pointed_thing.above)
			nodemeta:from_table({
				inventory = {main = minetest.deserialize(storage)},
				fields = {
					formspec = get_formspec(label),
					infotext = label,
					label = label
				}
			})
		end

		return itemstack
	end,
	on_dig = function(pos, node, player)
		local inv = player:get_inventory()

		local nodemeta = minetest.get_meta(pos)
		local label = nodemeta:get_string("label")
		local nodeinv = {}
		for i,itemstack in ipairs(nodemeta:get_inventory():get_list("main") or {}) do
			nodeinv[i] = itemstack:to_string()
		end
		local storage = minetest.serialize(nodeinv)

		minetest.node_dig(pos, node, player)

		for index, itemstack in ipairs(inv:get_list("main")) do
			if itemstack:get_name() == "backpack:placeholder" then
				local newstack = ItemStack({name="backpack:backpack"})

				if storage ~= "" and storage ~= empty_inv then
					local stackmeta = newstack:get_meta()
					stackmeta:set_string("storage", storage)
					stackmeta:set_string("description", label)
					stackmeta:set_string("color", colors[math.random(#colors)])
					storage = ""
				end

				inv:set_stack("main", index, newstack)
			end
		end
	end,
	can_dig = function(pos, player)
		return player:get_inventory():room_for_item("main", {name = "backpack:placeholder"})
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.label then
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", get_formspec(fields.label))
			meta:set_string("infotext", fields.label)
			meta:set_string("label", fields.label)
		end
	end,
})

minetest.register_craftitem("backpack:placeholder",{
	description = "Backpack (being picked up)",
	inventory_image = "backpack_placeholder.png",
	stack_max = 1,
	groups = {not_in_creative_inventory=1}
})

minetest.register_craft({
	output = 'backpack:backpack',
	recipe = {
		{            '',                  'default:stick',                   ''            },
		{'backpack:leather_treated',    'default:gold_ingot',    'backpack:leather_treated'},
		{'backpack:leather_treated', 'backpack:leather_treated', 'backpack:leather_treated'},
	}
})

minetest.register_craftitem("backpack:leather_raw",{
	description = "Raw leather",
	inventory_image = "backpack_leather_raw.png",
})

minetest.register_craftitem("backpack:leather_treated",{
	description = "Treated leather",
	inventory_image = "backpack_leather_treated.png",
})

minetest.register_craft({
	type = "cooking",
	output = "backpack:leather_treated",
	recipe = "backpack:leather_raw",
	cooktime = 5,
})

