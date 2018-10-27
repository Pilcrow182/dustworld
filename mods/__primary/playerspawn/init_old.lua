---
--Player Spawn 0.1
--Copyright (C) 2012 Brandon Bohannon
--
--This library is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public
--License along with this library; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
--- 

playerspawn = {}
playerspawn.version = 0.1

playerspawn.set = function (name, pos)
  minetest.log("Setting spawn point "..minetest.pos_to_string(pos).." for "..name)
  local o = io.open(minetest.get_worldpath() .. "/"..name..".spawn","w")
    o:write(minetest.pos_to_string(pos))
  io.close(o)
  
  minetest.chat_send_player(name,"New spawn point set!")
  
end

playerspawn.get = function (name)
  minetest.log("action","Getting saved spawn point for "..name)
  local i = io.open(minetest.get_worldpath() .. "/"..name..".spawn","r")
    if not i then
      minetest.log("error","Saved spawn point not set for "..name)
      return nil
    end
    
    spawnpos = i:read("*all")
    minetest.log("action","Saved spawn point "..spawnpos.." found for "..name)
  io.close(i)
  
    return minetest.string_to_pos(spawnpos)
end

minetest.register_node("playerspawn:spawnpoint", {
    description = "Spawn Point",
    tile_images = {"spawn.png"},
    inventory_image = {"spawn.png"},
   
    on_punch = function ( pos, node, player )
      playerspawn.set(player:get_player_name(), player:getpos())
    end
})

minetest.register_on_respawnplayer( function ( player )
  minetest.log("action","[Playerspawn] Respawning player "..player:get_player_name())
    local spawn_pos = playerspawn.get(player:get_player_name())
    if ( spawn_pos ~= nil ) then
      player:moveto( spawn_pos )
      return true
    end
  return false
end
)

minetest.register_craft({
    output = "playerspawn:spawnpoint",
	recipe = {
		    {'default:stone','default:stone','default:stone'},
		    {'default:stone','default:steel_ingot','default:stone'},
		    {'default:stone','default:stone','default:stone'}
		  }
})