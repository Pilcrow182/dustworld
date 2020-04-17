--[[

  Advanced node storage ('encapsulator') mod for Minetest

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

meta_to_string = function(meta)
	local meta = meta:to_table()
	local output = {}
	for k0,v0 in pairs(meta) do
		if type(v0) == "table" then
			output[k0] = {}
			for k1,v1 in pairs(v0) do
				if type(v1) == "table" then
					output[k0][k1] = {}
					for k2,v2 in pairs(v1) do
						if type(v2) == "userdata" then
							output[k0][k1][k2] = v2:to_string()
						elseif type(v2) ~= "function" and type(v2) ~= "thread" then
							output[k0][k1][k2] = v2
						end
					end
				elseif type(v1) == "userdata" then
					output[k0][k1] = v1:to_string()
				elseif type(v1) ~= "function" and type(v1) ~= "thread" then
					output[k0][k1] = v1
				end
			end
		elseif type(v0) == "userdata" then
			output[k0] = v0:to_string()
		elseif type(v0) ~= "function" and type(v0) ~= "thread" then
			output[k0] = v0
		end
	end
	return minetest.serialize(output)
end

minetest.register_craftitem("encapsulator:gun_empty",{
	description = "Encapsulator (unloaded)",
	inventory_image = "encapsulator_gun_empty.png",
	stack_max = 1
})

minetest.register_tool("encapsulator:gun", {
	description = "Encapsulator",
	inventory_image = "encapsulator_gun.png",
	on_use = function(itemstack, user, pointed_thing)
		if not ( pointed_thing and pointed_thing.under ) then return end
		local node = minetest.get_node(pointed_thing.under)
		local meta = minetest.get_meta(pointed_thing.under)

		local capsule = ItemStack({name="encapsulator:capsule"})
		local capmeta = capsule:get_meta()
		capmeta:set_string("description", "Capsule containing "..node.name)
		capmeta:set_string("storednode", minetest.serialize(node))
		capmeta:set_string("storedmeta", meta_to_string(meta))
		capmeta:set_string("color", "#AADDFF")

		if user:get_inventory():room_for_item("main", capsule) then
			user:get_inventory():add_item("main", capsule)
		else
			minetest.add_item(pointed_thing.under, capsule)
		end
		minetest.remove_node(pointed_thing.under)

		local wear = itemstack:get_wear()
		if wear + ( 65536 / 8 ) < 65536 then
			itemstack:add_wear(65536/8)
		else
			itemstack:replace("encapsulator:gun_empty")
		end
		return itemstack
	end,
	stack_max = 1
})

minetest.register_craftitem("encapsulator:capsule_empty",{
	description = "Capsule (empty)",
	inventory_image = "encapsulator_capsule.png",
	stack_max = 1
})

minetest.register_craftitem("encapsulator:capsule",{
	description = "Capsule",
	inventory_image = "encapsulator_capsule.png",
	on_place = function(itemstack, placer, pointed_thing)
		if not minetest.registered_nodes[minetest.get_node(pointed_thing.above).name].buildable_to then return end

		local stackmeta = itemstack:get_meta()
		if stackmeta:get_string("storednode") ~= "" then
			minetest.set_node(pointed_thing.above, minetest.deserialize(stackmeta:get_string("storednode")))
			local nodemeta = minetest.get_meta(pointed_thing.above)
			nodemeta:from_table(minetest.deserialize(stackmeta:get_string("storedmeta")))

			itemstack:replace("encapsulator:capsule_empty")
		end

		return itemstack
	end,
	stack_max = 1,
	groups = {not_in_creative_inventory=1}
})

local gun_tip = ( minetest.get_modpath("flolands") and "flolands:floatcrystal" ) or "default:diamond"

minetest.register_craft({
	output = 'encapsulator:gun_empty',
	recipe = {
		{gun_tip, 'default:tin_ingot', 'default:tin_ingot'},
		{  ''   ,         ''         , 'default:coal_lump'},
	}
})

minetest.register_craft({
	output = 'encapsulator:capsule_empty',
	recipe = {
		{'default:tin_ingot',  'default:tin_ingot',           ''         },
		{'default:tin_ingot', 'default:mese_crystal', 'default:tin_ingot'},
		{        ''         ,  'default:tin_ingot',   'default:tin_ingot'}
	}
})

minetest.register_craft({
	output = 'encapsulator:gun',
	recipe = {
		{'encapsulator:capsule_empty', 'encapsulator:capsule_empty', 'encapsulator:capsule_empty'},
		{'encapsulator:capsule_empty',   'encapsulator:gun_empty',   'encapsulator:capsule_empty'},
		{'encapsulator:capsule_empty', 'encapsulator:capsule_empty', 'encapsulator:capsule_empty'}
	}
})

