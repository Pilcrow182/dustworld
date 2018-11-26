shops.itemlist = {
	{"default:pick_bronze 1", "default:papyrus 20", "default:desert_stone 7"},
	{"default:axe_bronze 1", "gloopores:akalin_ingot 8", "default:stone 7"},
	{"default:shovel_bronze 1", "default:clay_brick 3", "trees:jungletree_sapling 5"},
	{"default:sword_bronze 1", "default:cactus 6", "default:desert_stone 5"},
	{"archery:bow 1", "trees:wood_mangrove 8", "flolands:floatsandstone 3"},
	{"archery:arrow 10", "default:obsidian 2", "farming_plus:strawberry_item 20"},
	{"bucket:bucket_empty 1", "default:dirt 15", "default:cactus 6"},
	{"concrete:concrete 99", "default:junglewood 99", "default:mese_crystal 6"},
	{"instacabin:shack 1", "flolands:floatstone 25", "default:mossycobble 20"},
	{"instacabin:garden 1", "default:sand 60", "default:junglewood 30"},
	{"bed:bed_bottom 1", "trees:tree_birch 4", "farming_plus:blueberry_item 25"},
	{"bags:medium 1", "survivalist:oak_sapling 5", "trees:wood_palm 8"},
	{"ropeblock:source 1", "default:coal_lump 2", "efault:sand 6"},
	{"bonemeal:bonemeal 10", "default:desert_sand 10", "default:tree 1"},
	{"map:mapping_kit 1", "default:coal_lump 10", "default:cactus 8"},
	{"mesebay:laptop 1", "default:tree 99", "default:obsidian 60"},
}

shops.get_formspec = function()
	local formspec = "size[10,8.25]"..
	"list[context;shop;1,0.5;8,2;]"..
	"label[1.9,2.5;Shop Item:]" ..
	"list[context;shop_item;2,3;1,1;]"..
	"label[4.6,2.5;Value:]" ..
	"list[context;exchange_1;3.8,3;1,1;]"..
	"label[4.75,3.25;OR]" ..
	"list[context;exchange_2;5.2,3;1,1;]"..
	"label[6.85,2.5;Player Item:]" ..
	"list[context;player_item;7,3;1,1;]"..
	"list[current_player;main;0,4.25;10,4;]"
	return formspec
end

shops.reset_stacks = function(inv, shop_only)
	local shoplist = {}
	for _,entry in ipairs(shops.itemlist) do
		table.insert(shoplist, ItemStack(entry[1]))
	end
	inv:set_list("shop", shoplist)
	if not shop_only then
		inv:set_list("shop_item", {})
		inv:set_list("exchange_1", {})
		inv:set_list("exchange_2", {})
-- 		inv:set_list("player_item", {})
	end
end

shops.update_inventory = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", shops.get_formspec())
		local inv = meta:get_inventory()
		inv:set_size("shop", 8*2)
		inv:set_size("shop_item", 1*1)
		inv:set_size("exchange_1", 1*1)
		inv:set_size("exchange_2", 1*1)
		inv:set_size("player_item", 1*1)
		shops.reset_stacks(inv)
end

shops.allow_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	if from_list == "shop" and to_list == "shop_item" then
		return count
	else
		return 0
	end
end

shops.on_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	shops.reset_stacks(inv)
	if from_list == "shop" and to_list == "shop_item" then
		inv:set_stack("shop_item", 1, shops.itemlist[from_index][1])
		inv:set_stack("exchange_1", 1, shops.itemlist[from_index][2])
		inv:set_stack("exchange_2", 1, shops.itemlist[from_index][3])
	end
end

shops.allow_put = function(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "player_item" then
		return stack:get_count()
	else
		return 0
	end
end

shops.on_put = function(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	shops.reset_stacks(inv, true)
end

shops.allow_take = function(pos, listname, index, stack, player)
	if listname == "player_item" then
		return stack:get_count()
	elseif listname == "shop_item" then
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local player_item = inv:get_stack("player_item", 1)
		local player_item_name = player_item:get_name()
		local player_item_count = player_item:get_count()
		local exchange_1 = inv:get_stack("exchange_1", 1)
		local exchange_1_name = exchange_1:get_name()
		local exchange_1_count = exchange_1:get_count()
		local exchange_2 = inv:get_stack("exchange_2", 1)
		local exchange_2_name = exchange_2:get_name()
		local exchange_2_count = exchange_2:get_count()
		if ( player_item_name == exchange_1_name and player_item_count >= exchange_1_count )
		or  ( player_item_name == exchange_2_name and player_item_count >= exchange_2_count )
		then
			return stack:get_count()
		else
			return 0
		end
	end
end

shops.on_take = function(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "shop_item" then
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local player_item = inv:get_stack("player_item", 1)
		local player_item_name = player_item:get_name()
		local player_item_count = player_item:get_count()
		local exchange_1 = inv:get_stack("exchange_1", 1)
		local exchange_1_name = exchange_1:get_name()
		local exchange_1_count = exchange_1:get_count()
		local exchange_2 = inv:get_stack("exchange_2", 1)
		local exchange_2_name = exchange_2:get_name()
		local exchange_2_count = exchange_2:get_count()
		shops.reset_stacks(inv)
		if player_item_name == exchange_1_name then
			player_item_count = player_item_count - exchange_1_count
			inv:set_stack("player_item", 1, ItemStack({name=player_item_name, count=player_item_count, wear=player_item:get_wear(), metadata=player_item:get_metadata()}))
		elseif player_item_name == exchange_2_name then
			player_item_count = player_item_count - exchange_2_count
			inv:set_stack("player_item", 1, ItemStack({name=player_item_name, count=player_item_count, wear=player_item:get_wear(), metadata=player_item:get_metadata()}))
		end
	end
end
