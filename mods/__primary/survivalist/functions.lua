local DEBUG, VERBOSE = 0, 0
function survivalist.debug_message(message)
	if DEBUG == 1 then
		print("DEBUG:: SURVIVALIST: "..message)
		if VERBOSE == 1 then
			minetest.chat_send_all("DEBUG:: SURVIVALIST: "..message)
		end
	end
end

function survivalist.hacky_give_item(player, item, add_count, itemstack, wear)
	local index, count, empty = nil, nil, nil
	for i=1,player:get_inventory():get_size("main") do
		local item_table = player:get_inventory():get_stack("main", i):to_table() or {name = "", count = 0}
		local item_name, item_count = item_table.name, item_table.count
		if not empty and item_name == "" then index, count, empty = i, 0, true end
		if item_name == item and item_count + add_count <= tonumber(minetest.registered_items[item_name].stack_max) then
			index, count, empty = i, item_count, empty
			break
		end
	end
	if player:get_inventory():room_for_item("main", item.." "..tostring(add_count)) then
		if index == player:get_wield_index() then
			if itemstack ~= nil then
				survivalist.debug_message("Giving "..tostring(add_count).." of item '"..item.."' to player '"..player:get_player_name().."' (secondary method)") -- survivalist.debug_message("Replacing wielded item")
				itemstack:replace(item.." "..tostring(count+add_count))
			else
				survivalist.debug_message("Giving "..tostring(add_count).." of item '"..item.."' to player '"..player:get_player_name().."' (alternate secondary method)") -- survivalist.debug_message("Replacing wielded item")
				player:set_wielded_item(item.." "..tostring(count+add_count).." "..tostring(wear or 0))
-- 				player:get_inventory():set_stack("main", index, ItemStack(item.." "..count+add_count))
			end
		else
			survivalist.debug_message("Giving "..tostring(add_count).." of item '"..item.."' to player '"..player:get_player_name().."' (primary method)") -- survivalist.debug_message("Using proper add_item() command")
			player:get_inventory():add_item("main", item.." "..tostring(add_count).." "..tostring(wear or 0))
		end
	else
		survivalist.debug_message("Giving "..tostring(add_count).." of item '"..item.."' to player '"..player:get_player_name().."' (fallback method)") -- survivalist.debug_message("Dropping item at player's feet")
		minetest.add_item(player:getpos(), item.." "..tostring(add_count).." "..tostring(wear or 0))
	end
end

--	function survivalist.clone_item(name)
--		local item=minetest.registered_items[name]
--		local item2={}
--		for k,v in pairs(item) do
--			item2[k]=v
--		end
--		return item2
--	end

function survivalist.clone_item(name, newname, newdef)
	local fulldef = {}
	local olddef = minetest.registered_items[name]
	if not olddef then return false end
	for k,v in pairs(olddef) do fulldef[k]=v end
	for k,v in pairs(newdef) do fulldef[k]=v end
	minetest.register_item(":"..newname, fulldef)
end

function survivalist.tool_override(tool, input, output, droplist)
	-- get the input node's original definition
	local old_def = minetest.registered_nodes[input]

	-- exit safely if the input or output doesn't exist
	if not (old_def and minetest.registered_items[output]) then return false end

	-- get the input node's drops as a table
	local old_drop = (type(old_def.drop) == "table" and old_def.drop) or {items = {{items = {old_def.drop or input}}}}

	-- define the input node's new tool drops
	local new_def = {drop = {max_items = 1, items = {{items = {output}, tools = {tool}}}}}

	-- add the old drops to the new list
	for _,entry in pairs(droplist or old_drop.items) do new_def.drop.items[#new_def.drop.items+1] = entry end

	-- override the node with the new list
	minetest.override_item(input, new_def)
end

function survivalist.register_hammer(material, caps)
	local hammer_io = {
		["default:stone"] = "default:gravel",
		["default:cobble"] = "default:gravel",
		["default:gravel"] = "default:sand",
		["default:sand"] = "wasteland:dust",
		["default:desert_stone"] = "survivalist:desert_gravel",
		["default:desert_cobble"] = "survivalist:desert_gravel",
		["survivalist:desert_gravel"] = "default:desert_sand",
		["default:desert_sand"] = "wasteland:dust",
		["default:papyrus"] = "survivalist:mulch"
	}

	local shortname = string.gsub(string.gsub(material, "_.*", ""), ".*:", "")
	local nicename = string.gsub(shortname, "^%l", string.upper)

	minetest.register_tool("survivalist:hammer_"..shortname, {
		description = nicename.." Hammer",
		inventory_image = "survivalist_hammer_"..shortname..".png",
		tool_capabilities = {groupcaps={crumbly = caps, cracky = caps, snappy = caps}}
	})

	for input,output in pairs(hammer_io) do
		survivalist.tool_override("survivalist:hammer_"..shortname, input, output)
		survivalist.tool_override("hammer:hammer_"..shortname, input, output)		-- TODO: remove this; it's temporary, legacy code
	end

	minetest.register_craft({
		output = "survivalist:hammer_"..shortname,
		recipe = {
			{      ""     ,    material  ,       ""     },
			{      ""     , "group:stick",    material  },
			{"group:stick",       ""     ,       ""     },
		}
	})
end

