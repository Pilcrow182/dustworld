function debug.message(message, to_player)
	print("DEBUG:: "..message)
	if to_player then
		if to_player == "all" then
			minetest.chat_send_all("DEBUG:: "..message)
		else
			minetest.chat_send_player(to_player, "DEBUG:: "..message, false)
		end
	end
end
