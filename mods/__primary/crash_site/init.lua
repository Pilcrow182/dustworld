crash_site = {}

dofile(minetest.get_modpath("crash_site").."/nodes.lua")
dofile(minetest.get_modpath("crash_site").."/abms.lua")
dofile(minetest.get_modpath("crash_site").."/legacy.lua")

crash_site.spawn = function(player, tries)
	-- calculate the number of times this function has run itself while waiting for land to generate
	local tries = tries or 0
	tries = tries + 1

	if tries == 1 then -- if this is the first time this function runs,
		-- temporarily move player out of the way (under the ground, most likely)
		player:moveto({x=0,y=-50,z=0})

		-- if the ship has already been generated, move the player to the spawnpoint and quit this function instead of trying to generate the ship again
		local i = io.open(minetest.get_worldpath() .. "/crash_site.txt","r")
		if i then
			local spawnpoint = playerspawn.get(player:get_player_name())
			if not spawnpoint then
				spawnpoint = minetest.string_to_pos(i:read("*all"))
				playerspawn.set(player:get_player_name(), spawnpoint)
			end
			io.close(i)
			minetest.after(0, function() player:moveto(spawnpoint) end)
			return
		end
	end

	-- if land is taking a long time to generate, tell the player why we are waiting
	if tries == 3 then minetest.chat_send_player(player:get_player_name(), "Waiting for land to generate") end

	-- if the land hasn't finished generating at pos(0, 0, 0), wait 1 second and try again
	if minetest.get_node({x=0,y=0,z=0}).name == "ignore" then return minetest.after(1, function() return crash_site.spawn(player, tries) end) end
	
	-- now that land generaton is done, tell the player we are spawning the ship
	minetest.chat_send_player(player:get_player_name(), "Creating crash site")

	-- set up the ability to write all ship models into the map
	local write_model = function(pos, disp, model_name)
		local checkpos = {x=pos.x+disp.x, y=pos.y+disp.y, z=pos.z+disp.z}
		local checked_name = minetest.get_node({x=pos.x+disp.x, y=pos.y+disp.y, z=pos.z+disp.z}).name
		while checked_name ~= "air" and checked_name ~= "default:water_source" do
			pos.y = pos.y+1
			checked_name = minetest.get_node({x=pos.x+disp.x, y=pos.y+disp.y, z=pos.z+disp.z}).name
		end
		local model = io.open(minetest.get_modpath("crash_site").."/models/"..model_name..".we")
		local nodelist = model:read("*a")
		model:close()
		worldedit.deserialize(pos, nodelist)
		return pos
	end

	-- spawn the models themselves
	local shipspawn = write_model({x=-6,y=-32,z=-14}, {x=7, y=9, z=9}, "ship_main")
	local waterspawn = write_model({x=-14,y=-32,z=-26}, {x=6, y=5, z=2}, "ship_water")
	local fuelspawn = write_model({x=11,y=-32,z=-15}, {x=2, y=5, z=5}, "ship_fuel")
	
	-- set the player's initial spawnpoint and move him to it
	local spawnpoint = {x=0,y=shipspawn.y+4.5,z=0}
	playerspawn.set(player:get_player_name(), spawnpoint)
	player:moveto(spawnpoint)

	-- make a note to say that the ship has already been generated
	local o = io.open(minetest.get_worldpath() .. "/crash_site.txt","w")
	o:write(minetest.pos_to_string(spawnpoint))
	io.close(o)
end

-- register all of the above so it happens when a new player joins the game
minetest.register_on_joinplayer(function(player) crash_site.spawn(player) end)
