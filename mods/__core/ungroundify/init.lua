ungroundify = {}

dofile(minetest.get_modpath("ungroundify").."/is_not_ground.lua")

for _,name in pairs(ungroundify.is_not_ground) do
	if minetest.registered_items[name] then
		minetest.override_item(name, {is_ground_content = false})
	end
end

