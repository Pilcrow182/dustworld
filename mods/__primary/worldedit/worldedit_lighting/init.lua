local clone_item = function(name, newname, newdef)
	local fulldef = {}
	local olddef = minetest.registered_items[name]
	if not olddef then return false end
	for k,v in pairs(olddef) do fulldef[k]=v end
	for k,v in pairs(newdef) do fulldef[k]=v end
	minetest.register_item(":"..newname, fulldef)
end

clone_item("air", "recalc", {})

minetest.register_abm({
	nodenames = {"recalc"},
	interval = 1,
	chance = 1,
	action = function(pos)
		minetest.remove_node(pos)
	end
})
