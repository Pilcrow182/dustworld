minetest.register_chatcommand("credit", {
	params = "<player> <number>",
	description = "Give <number> mesebay credits to <player>",
	privs = {give=true},
	func = function(name, param)
		local found, _, player, number = param:find("^([^%s]+)%s+([^%s]+)$")
		if found == nil then
			minetest.chat_send_player(name, "Usage: /credit <player> <number>", false)
			return
		end
		number = tonumber(number)
		if not number then
			minetest.chat_send_player(name, "Usage: /credit <player> <number>", false)
			return
		end
		local reciever = minetest.env:get_player_by_name(player)
		if reciever then
			mesebay.give_credit(reciever, number)
			if not player == name then
				minetest.chat_send_player(name, "Gave "..player.." "..number.." mesebay credits", false)
			end
			minetest.chat_send_player(player, "Recieved "..number.." mesebay credits from player "..name, false)
			minetest.log('action','[MeseBay] Gave player "'..player..'" '..number..' additional credits')
		else
			minetest.chat_send_player(name, "Error: recieving player is not online", false)
		end
	end,
})

minetest.register_chatcommand("creditme", {
	params = "<number>",
	description = "Get <number> mesebay credits",
	privs = {give=true},
	func = function(name, param)
		if param == "" then
			number = mesebay.default_credits
		else
			number = tonumber(param)
		end
		if not number then
			minetest.chat_send_player(name, "Usage: /creditme <number>", false)
			return
		end
		local reciever = minetest.env:get_player_by_name(name)
		mesebay.give_credit(reciever, number)
		minetest.chat_send_player(name, "Recieved "..number.." mesebay credits", false)
		minetest.log('action','[MeseBay] Gave player "'..name..'" '..number..' additional credits')
	end,
})
