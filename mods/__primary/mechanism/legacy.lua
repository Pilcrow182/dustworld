local get_replacement = {
	[0] = {"bent", 16},
	[1] = {"hacky", 5},
	[2] = {"bent", 14},
	[3] = {"bent", 11}
}

local clone_item = function(name, newname, newdef)
	local fulldef = {}
	local olddef = minetest.registered_items[name]
	if not olddef then return false end
	for k,v in pairs(olddef) do fulldef[k]=v end
	for k,v in pairs(newdef) do fulldef[k]=v end
	minetest.register_item(":"..newname, fulldef)
end

clone_item("mechanism:hopper", "mechanism:reverse_hopper", {description = "Hopper (legacy reverse_hopper)", groups = {not_in_creative_inventory=1}})
clone_item("mechanism:hopper_side", "mechanism:reverse_hopper_side", {description = "Hopper (legacy reverse_hopper)", groups = {not_in_creative_inventory=1}})

minetest.register_craft({output = 'mechanism:hopper', recipe = {{'mechanism:reverse_hopper'}}})
minetest.register_craft({output = 'mechanism:hopper', recipe = {{'mechanism:reverse_hopper_side'}}})

minetest.register_abm({
	nodenames = {"mechanism:reverse_hopper", "mechanism:reverse_hopper_side"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local node = minetest.get_node(pos)
		if node.name == "mechanism:reverse_hopper" then
			minetest.set_node(pos, {name = "mechanism:itemduct_straight", param2 = 4})
		else
			local pn, pp = get_replacement[node.param2][1], get_replacement[node.param2][2]
			minetest.set_node(pos, {name = "mechanism:itemduct_"..pn, param2 = pp})
		end
	end
})

minetest.register_alias("mechanism:itemduct_hacky", "mechanism:itemduct_bent")
minetest.register_alias("mechanism:fuelduct_hacky", "mechanism:fuelduct_bent")
