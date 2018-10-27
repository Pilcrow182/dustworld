local clone_item = function(name, newname, newdef)
	local fulldef = {}
	local olddef = minetest.registered_items[name]
	if not olddef then return false end
	for k,v in pairs(olddef) do fulldef[k]=v end
	for k,v in pairs(newdef) do fulldef[k]=v end
	minetest.register_item(":"..newname, fulldef)
end

clone_item("default:obsidian_glass", "default:obsidian_glass", {
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
})
