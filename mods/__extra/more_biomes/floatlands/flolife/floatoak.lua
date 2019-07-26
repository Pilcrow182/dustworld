minetest.register_node("flolife:sapling", {
	description = "Floatoak Sapling",
	drawtype = "plantlike",
	tiles = {"flolife_sapling.png"},
	inventory_image = "flolife_sapling.png",
	wield_image = "flolife_sapling.png",
	paramtype = "light",
	light_source = 11,
	walkable = false,
	groups = {dig_immediate=3,flammable=2,sapling=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("flolife:tree", {
	description = "Floatoak",
	tiles = {"flolife_tree_top.png", "flolife_tree_top.png", "flolife_tree.png"},
	light_source = 8,
	groups = {choppy=2,oddly_breakable_by_hand=1,flammable=2,tree=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("flolife:leaves", {
	description = "Floatoak Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"flolife_leaves.png"},
	paramtype = "light",
	light_source = 6,
	groups = {snappy=3, leafdecay=3, flammable=2, leaves=1},
	drop = {
		max_items = 1,
		items = {
			{
				-- player will get sapling with 1/20 chance
				items = {'flolife:sapling'},
				rarity = 20,
			},
			{
				-- player will get leaves only if he get no saplings,
				-- this is because max_items is 1
				items = {'flolife:leaves'},
			}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

if minetest.get_modpath("survivalist") then
	minetest.override_item("flolife:leaves", {
		drop = {
			max_items = 1,
			items = {
				{
					-- player will get sapling with 1/sapling_rarity chance
					items = {'flolife:sapling'},
					rarity = 20,
				}
			}
		},
		on_punch = function(pos, node, puncher)
			if not puncher then return end
			local itemstack = puncher:get_wielded_item()
			local wielded = itemstack:get_name()
			if wielded == "survivalist:shears" then
				minetest.remove_node(pos)
				local drop = 'flolife:leaves'
				if math.random(1,20) == 10 then drop = 'flolife:sapling' end
				minetest.add_item(pos, drop)
				itemstack:add_wear(65535/297)
				puncher:set_wielded_item(itemstack)
			elseif wielded == "survivalist:crook" then
				minetest.remove_node(pos)
				local drop = 'flolife:leaves'
				if math.random(1,3) >= 2 then drop = "survivalist:silkworm" end
				if math.random(1,5) == 3 then minetest.add_item(pos, drop) end
				itemstack:add_wear(65535/99)
				puncher:set_wielded_item(itemstack)
			elseif wielded == "survivalist:silkworm" then
				minetest.set_node(pos, {name="survivalist:silk_leaves"})
				itemstack:take_item(1)
				puncher:set_wielded_item(itemstack)
			end
		end,
	})
end

minetest.register_node("flolife:wood", {
	description = "Floatoak Planks",
	tiles = {"flolife_wood.png"},
	light_source = 13,
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("flolife:fruit", {
	description = "Flyte Fruit",
	tiles = {"flolife_fruit.png"},
	inventory_image = "flolife_fruit.png",
	wield_image = "flolife_fruit.png",
	drawtype = "plantlike",
	paramtype = "light",
	light_source = 11,
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1,food=2},
	sounds = default.node_sound_defaults(),
	on_use = minetest.item_eat(-2),
})

minetest.register_node("flolife:stick", {
	description = "Glowstick",
	drawtype = "torchlike",
	tiles = {"flolife_stick_on_floor.png", "flolife_stick_on_ceiling.png", "flolife_stick.png"},
	inventory_image = "flolife_stick_inv.png",
	wield_image = "flolife_stick_inv.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	light_source = 13,
	selection_box = {
		type = "wallmounted",
		wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
		wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
		wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
	},
	groups = {choppy=2,dig_immediate=3,flammable=1,attached_node=1},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_craftitem("flolife:gel", {
	description = "Flyte Gel",
	inventory_image = "flolife_gel.png",
	groups = {food=2},
	on_use = minetest.item_eat(6)
})

minetest.register_craft({
	type = "shapeless",
	output = "flolife:gel 4",
	recipe = {"flolife:fruit"},
})

minetest.register_craft({
	type = "shapeless",
	output = "flolife:wood 4",
	recipe = {"flolife:tree"},
})

minetest.register_craft({
	type = "shapeless",
	output = "flolife:stick 4",
	recipe = {"flolife:wood"},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:stick",
	recipe = {"flolife:stick"},
})

minetest.register_abm({
	nodenames = {"flolife:fruit"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		for _,object in ipairs(minetest.get_objects_inside_radius(pos, 15.1/16)) do
			if object:get_hp() > 0 then
				object:set_hp(object:get_hp()-1)
			end
		end
	end
})

minetest.register_abm({
	nodenames = {"flolife:sapling"},
	interval = 60,
	chance = 20,
	action = function(pos, node)
		farming:generate_tree(pos, "flolife:tree", "flolife:leaves", {"flolands:floatsand"}, {["flolife:fruit"]=20})
	end
})

minetest.register_on_generated(function(minp, maxp, blockseed)
	if math.random(1, 100) > 5 then
		return
	end
	local tmp = {x=(maxp.x-minp.x)/2+minp.x, y=(maxp.y-minp.y)/2+minp.y, z=(maxp.z-minp.z)/2+minp.z}
	local pos = minetest.find_node_near(tmp, maxp.x-minp.x, {"flolands:floatsand"})
	if pos ~= nil then
		farming:generate_tree({x=pos.x, y=pos.y+1, z=pos.z}, "flolife:tree", "flolife:leaves", {"flolands:floatsand"}, {["flolife:fruit"]=20})
	end
end)

-- ========== LEAFDECAY ==========

default.register_leafdecay({
	trunks = {"flolife:tree"},
	leaves = {"flolife:fruit", "flolife:leaves"},
	radius = 3,
})
