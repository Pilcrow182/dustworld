--- ##################
--- Selection Handling
--- ##################

mesebay.buy_item = function (selected, price, sender, credit, max_count)
	if credit >= price then
		if sender:get_inventory():room_for_item("main", selected) then
			local trans = function ()
				item_count = item_count + 1
				cred_count = cred_count + price
				sender:get_inventory():add_item("main", selected)
				mesebay.credit[sender:get_player_name()] = credit - price
				mesebay.save_credit(sender)
				credit = tonumber(mesebay.credit[sender:get_player_name()])
			end
			item_count, cred_count = 0, 0
			if max_count == 0 then
				while ( credit >= price ) and sender:get_inventory():room_for_item("main", selected) do
					trans()
				end
			else
				for i = 1, max_count do
					if ( credit >= price ) and sender:get_inventory():room_for_item("main", selected) then
						trans()
					end
				end
			end
			message = 'Bought '..item_count..' "'..selected..'" for '..cred_count..' credits'
			print('player "'..sender:get_player_name()..'" buys '..item_count..' of item "'..selected..'" for '..cred_count..' total credits')
		else
			message = "You don't have the room for that!"
		end
	else
		message = 'Not enough credits!'
	end
end

mesebay.sell_item = function (selected, price, sender, credit, max_count)
	if sender:get_inventory():contains_item("main", selected) then
		local trans = function ()
			item_count = item_count + 1
			cred_count = cred_count + math.floor(price / 2)
			sender:get_inventory():remove_item("main", selected)
			mesebay.credit[sender:get_player_name()] = credit + math.floor(price / 2)
			mesebay.save_credit(sender)
			credit = tonumber(mesebay.credit[sender:get_player_name()])
		end
		item_count, cred_count = 0, 0
		if max_count == 0 then
			while sender:get_inventory():contains_item("main", selected) do
				trans()
			end
		else
			for i = 1, max_count do
				if sender:get_inventory():contains_item("main", selected) then
					trans()
				end
			end
		end
		message = 'Sold '..item_count..' "'..selected..'" for '..cred_count..' credits'
		print('player "'..sender:get_player_name()..'" sells '..item_count..' of item "'..selected..'" for '..cred_count..' total credits')
	else
		message = "You don't have that item!"
	end
end


--- #################
--- Credit Management
--- #################

mesebay.give_credit = function (player, number)
	mesebay.load_credit(player)
	credit = tonumber(mesebay.credit[player:get_player_name()])
	mesebay.credit[player:get_player_name()] = credit + number
	mesebay.save_credit(player)
	credit = false
end

mesebay.save_credit = function (player)
	local file = io.open(minetest.get_worldpath().."/mesebay_"..player:get_player_name().."_credit", "w+")
	if file then
		file:write(mesebay.credit[player:get_player_name()])
		file:close()
	end
end

mesebay.load_credit = function (player)
	local file = io.open(minetest.get_worldpath().."/mesebay_"..player:get_player_name().."_credit", "r")
	if file then
		mesebay.credit[player:get_player_name()] = file:read("*all")
		file:close()
	else
		mesebay.credit[player:get_player_name()] = mesebay.default_credits
		mesebay.save_credit(player)
	end
end
