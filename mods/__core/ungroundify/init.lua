ungroundify = {}

dofile(minetest.get_modpath("ungroundify").."/is_not_ground.lua")

local function overwrite(name, def)
	local item = {}
	local olditem = minetest.registered_items[name]
	if not olditem then return false end
	for k,v in pairs(olditem) do item[k]=v end
	for k,v in pairs(def) do item[k]=v end
	minetest.register_item(":"..name, item)
end

for _,name in pairs(ungroundify.is_not_ground) do overwrite(name, {is_ground_content = false}) end
