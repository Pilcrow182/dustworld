wasteland.playerphysics = {speed = 1, jump = 6/5, gravity = 1/2}

minetest.register_on_joinplayer(function(player)
	minetest.after(2, function() player:set_physics_override(wasteland.playerphysics.speed, wasteland.playerphysics.jump, wasteland.playerphysics.gravity) end)
	minetest.after(10, function() player:set_physics_override(wasteland.playerphysics.speed, wasteland.playerphysics.jump, wasteland.playerphysics.gravity) end)
end)

minetest.register_on_respawnplayer(function(player)
	minetest.after(0, function() player:set_physics_override(wasteland.playerphysics.speed, wasteland.playerphysics.jump, wasteland.playerphysics.gravity) end)
end)
