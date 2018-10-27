local function overwrite(name, def)
	local item = {}
	local olditem = minetest.registered_items[name]
	if not olditem then return false end
	for k,v in pairs(olditem) do item[k]=v end
	for k,v in pairs(def) do item[k]=v end
	minetest.register_item(":"..name, item)
end

overwrite("default:lava_source", {liquid_renewable = true})
overwrite("default:lava_flowing", {liquid_renewable = true})
