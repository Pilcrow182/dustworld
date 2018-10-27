---
--Player Spawn 0.2
--
--This mod is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--- 

playerspawn = {}
playerspawn.version = 0.2

playerspawn.set = function(name, pos, silent)
	minetest.log("Setting spawn point "..minetest.pos_to_string(pos).." for "..name)
	local o = io.open(minetest.get_worldpath() .. "/"..name..".spawn","w")
	o:write(minetest.pos_to_string(pos))
	io.close(o)

	if not silent then minetest.chat_send_player(name,"New spawn point set!") end
end

playerspawn.get = function(name)
	minetest.log("action","Getting saved spawn point for "..name)
	local i = io.open(minetest.get_worldpath() .. "/"..name..".spawn","r")
	if not i then
		minetest.log("error","Saved spawn point not set for "..name)
		return nil
	end

	local spawnpos = i:read("*all")
	minetest.log("action","Saved spawn point "..spawnpos.." found for "..name)
	io.close(i)

	return minetest.string_to_pos(spawnpos)
end

minetest.register_on_respawnplayer(function(player)
	minetest.log("action","[Playerspawn] Respawning player "..player:get_player_name())
	local spawn_pos = playerspawn.get(player:get_player_name())
	if spawn_pos ~= nil then
		player:moveto(spawn_pos)
		return true
	end
	return false
end)

minetest.register_chatcommand("setspawn", {
	params = "",
	description = "Set player's spawn point to current location",
	func = function(name, param)
		local pos = minetest.get_player_by_name(name):getpos()
		pos.x, pos.y, pos.z = math.floor(pos.x + 0.5), math.ceil(pos.y), math.floor(pos.z + 0.5)
		playerspawn.set(name, pos)
		minetest.chat_send_player(name, "Spawn point set to " .. minetest.pos_to_string(pos), false)
	end
})

minetest.register_chatcommand("spawn", {
	params = "",
	description = "Teleport player back to spawn point",
	func = function(name, param)
		local spawn_pos = playerspawn.get(name)
		if spawn_pos ~= nil then minetest.get_player_by_name(name):moveto(spawn_pos) end
	end
})
