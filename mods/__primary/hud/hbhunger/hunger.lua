local known_foods = {
	["default:apple"] = 5,
	["default:scorched_stuff"] = 2,
	["farming:bread"] = 15,
	["farming:pumpkin_bread"] = 20,
	["farming:pumpkin"] = 10,
	["farming:big_pumpkin"] = 15,
	["farming_plus:banana"] = 5,
	["farming_plus:blueberry_item"] = 5,
	["farming_plus:carrot_item"] = 5,
	["farming_plus:orange_item"] = 5,
	["farming_plus:potatoe_item"] = 5,
	["farming_plus:rhubarb_item"] = 5,
	["farming_plus:strawberry_item"] = 5,
	["farming_plus:tomato_item"] = 5,
	["mobs:meat"] = 10,
	["animalmaterials:meat_undead"] = 5,
	["animalmaterials:meat_toxic"] = -20,
	["animalmaterials:milk"] = 5,
	["cooking:meat_cooked"] = 10,
	["cooking:fish_cooked"] = 10,
	["cooking:eggs_cooked"] = 5,
	["cooking:chocolate"] = 10,
	["cooking:pie_cooked"] = 15,
	["cooking:pie_basket"] = 20,
	["cooking:banana_bread"] = 20,
	["cooking:cactus_cooked"] = 10,
	["flolife:gel"] = 10,
	["apple_tree:iron_apple"] = 10,
	["ferns:ferntuber_roasted"] = 10,
	["ferns:fiddlehead_roasted"] = 5,
	["seaplants:seasaladmix"] = 15,
	["cooking:worm_cooked"] = 2
}

function hbhunger.item_eat(hunger_change, old_on_use)
	return function(itemstack, user, pointed_thing)
		if itemstack:peek_item() ~= nil then
			local h = tonumber(hbhunger.hunger[user:get_player_name()])
			h=h+hunger_change
			if h>21 then h=21 end
			hbhunger.hunger[user:get_player_name()]=h
			minetest.sound_play("hbhunger_eat", {to_player=user:get_player_name(), gain = 1.0})
			hbhunger.set_hunger(user)
			hbhunger.update_hud(user)

			local modified_itemstack = old_on_use(itemstack, user, pointed_thing)
			if modified_itemstack then
				user:set_wielded_item(modified_itemstack)
				return modified_itemstack
			else
				itemstack:take_item(1)
				user:set_wielded_item(itemstack)
				return itemstack
			end
		end
	end
end

local function overwrite(name, hunger_change)
	local tab = minetest.registered_items[name]
	if tab == nil then return end
	local old_on_use = tab.on_use;
	tab.on_use = hbhunger.item_eat(hunger_change, old_on_use)
	minetest.registered_items[name] = tab
end

for name, value in pairs(known_foods) do overwrite(name, value) end

-- player-action based hunger changes
function hbhunger.handle_node_actions(pos, oldnode, player, ext)
	if not player or not player:is_player() then
		return
	end
	local name = player:get_player_name()
	local exhaus = tonumber(hbhunger.exhaustion[name]) or 0
	local new = HUNGER_EXHAUST_PLACE
	-- placenode event
	if not ext then
		new = HUNGER_EXHAUST_DIG
	end
	-- assume its send by main timer when movement detected
	if not pos and not oldnode then
		new = HUNGER_EXHAUST_MOVE
	end
	exhaus = exhaus + new
	if exhaus > HUNGER_EXHAUST_LVL then
		exhaus = 0
		local h = tonumber(hbhunger.hunger[name]) or hbhunger.get_hunger(player)
		h = h - 1
		if h < 0 then h = 0 end
		hbhunger.hunger[name] = h
		hbhunger.set_hunger(player)
	end
	hbhunger.exhaustion[name] = exhaus
end

minetest.register_on_placenode(hbhunger.handle_node_actions)
minetest.register_on_dignode(hbhunger.handle_node_actions)
