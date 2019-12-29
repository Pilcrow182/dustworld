local capitalize = function(word)
	return string.gsub(word, "^%l", string.upper)
end

local show_config = function(pos, playername)
	local node = minetest.get_node(pos)
	local name = node.name

	local basename = nil
	for _,duct in pairs(ductworks.duct_types) do
		if minetest.get_item_group(name, duct) > 0 then
			basename = duct
			break
		end
	end
	if not basename then return end

	ductworks.target[playername] = minetest.pos_to_string(pos)

	local ductlist, selected = "", 0
	for index, dtype in ipairs(ductworks.duct_types) do
		if dtype == basename then selected = index end
		ductlist = ( ductlist == "" and dtype:gsub("^%l", string.upper) ) or ductlist..","..dtype:gsub("^%l", string.upper)
	end

	local groups, config, connect, output = minetest.registered_nodes[node.name].groups, "size[4,6.5;]", "", ""
	for i, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
		config = config..
		"image_button[0,"..(i-1)..";1,1;"..((groups["duct_connect_"..dir] == 2 and "ductworks_star.png") or "")..";output_"..dir..";]"..
		"image[1,"..(i-1)..";2.25,1;ductworks_config_"..dir..".png]"..
		"image_button[3,"..(i-1)..";1,1;"..((groups["duct_connect_"..dir] and "ductworks_naught.png") or "ductworks_cross.png")..";connect_"..dir..";]"
	end
	config = config.."dropdown[0,6;4.125,1;duct_type;"..ductlist..";"..selected.."]"

	minetest.show_formspec(playername, "ductworks:config", config)
end

minetest.register_craftitem("ductworks:pipe_wrench", {
	description = "Pipe Wrench",
	inventory_image = "ductworks_pipe_wrench.png",
	wield_image = "ductworks_pipe_wrench.png",
	wield_scale = {x=1,y=1,z=1+1/16},
	on_use = function(itemstack, user, pointed_thing)
		if not ( pointed_thing and pointed_thing.type == "node" ) then return itemstack end
		local node = minetest.get_node(pointed_thing.under)
		if minetest.registered_nodes[node.name] then minetest.registered_nodes[node.name].on_punch(pointed_thing.under, node, user, itemstack) end

		local basename = nil
		for _,duct in pairs(ductworks.duct_types) do
			if minetest.get_item_group(node.name, duct) > 0 then
				basename = duct
				break
			end
		end
		if not basename then return end

		if user:get_player_control().sneak then
			ductworks.rescan(pointed_thing.under, true)
		elseif string.find(node.name, "_disabled") then
			minetest.swap_node(pointed_thing.under, {name = string.gsub(node.name, "_disabled", "")})
		else
			minetest.swap_node(pointed_thing.under, {name = node.name.."_disabled"})
		end
	end,
	on_place = function(itemstack, placer, pointed_thing)
		if not ( pointed_thing and pointed_thing.type == "node" ) then return itemstack end
		local under = minetest.get_node(pointed_thing.under)
		if placer and not placer:get_player_control().sneak and minetest.registered_nodes[under.name] and minetest.registered_nodes[under.name].on_rightclick then
			return minetest.registered_nodes[under.name].on_rightclick(pointed_thing.under, under, placer, itemstack) or itemstack, false
		end

		show_config(pointed_thing.under, placer:get_player_name())
	end,
	stack_max = 1
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "ductworks:config" then
		if fields.quit == "true" then ductworks.target[player:get_player_name()] = nil return end

		local pos = minetest.string_to_pos(ductworks.target[player:get_player_name()])
		local node = minetest.get_node(pos)
		if minetest.get_item_group(node.name, "ductworks") == 0 then return end

		local oldgroups = minetest.registered_nodes[node.name].groups
		local basename, newgroups, oldout, newout = fields.duct_type:lower(), {}, nil, nil
		for i, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
			if oldgroups["duct_connect_"..dir] then newgroups["duct_connect_"..dir] = 1 end
			if fields["connect_"..dir] then
				if oldgroups["duct_connect_"..dir] then
					newgroups["duct_connect_"..dir] = nil
				else
					newgroups["duct_connect_"..dir] = 1
				end
			end
			if oldgroups["duct_connect_"..dir] == 2 then oldout = dir end
			if fields["output_"..dir] then newout = dir end
		end

		local output = newout or oldout or "north"
		newgroups["duct_connect_"..output] = 2

		local to_place = ductworks.node_lookup(newgroups, basename, oldgroups["disabled"] or nil)
		if not to_place then return end
		minetest.swap_node(pos, {name = to_place})

		show_config(pos, player:get_player_name())
	end
end)

minetest.register_craft({
	output = 'ductworks:pipe_wrench',
	recipe = {
		{'default:steel_ingot', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot'},
		{'', 'default:steel_ingot'},
	}
})

