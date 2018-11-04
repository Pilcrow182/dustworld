pcmobs = {}
pcmobs.register_mob = function(mobname, mobdef)
	local description = mobdef.description
	minetest.log("action", "Registering player-centric mob '"..description.."' (internal name '"..mobname.."')...")
end
