torch = {}

function torch.place_torch(itemstack, placer, pointed_thing, material)
	if not pointed_thing then return end
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if pointed_thing.type ~= "node" then
		return itemstack
	end

	if placer and not placer:get_player_control().sneak then
		local n = minetest.get_node(p0)
		local nn = n.name
		if minetest.registered_nodes[nn] and minetest.registered_nodes[nn].on_rightclick then
			return minetest.registered_nodes[nn].on_rightclick(p0, n, placer, itemstack) or itemstack, false
		end
	end

	if not minetest.registered_nodes[minetest.get_node(p1).name].buildable_to then
		return itemstack
	end
	
	if not minetest.registered_nodes[minetest.get_node(p0).name].walkable then
		return itemstack
	end

	local dir = {
		x = p1.x - p0.x,
		y = p1.y - p0.y,
		z = p1.z - p0.z
	}
	param2 = minetest.dir_to_facedir(dir,false)
	local correct_rotation={
		[0]=3,
		[1]=0,
		[2]=1,
		[3]=2
	}
	if p0.y>p1.y then
	--place torch on ceiling
	minetest.add_node(p1, {name="torch:torch_"..material.."_ceiling"})
	elseif p0.y<p1.y then
	--place torch on floor
	minetest.add_node(p1, {name="torch:torch_"..material.."_floor"})
	else
	--place torch on wall
	minetest.add_node(p1, {name="torch:torch_"..material.."_wall",param2=correct_rotation[param2]})
	end
	itemstack:take_item()
	return itemstack
end

function torch.register_torch(material, drop, groups)
	if not minetest.registered_nodes[drop] then return end

	--overwrite the default torch to make sure that the torch are placed
	local newtorch = {}
	for k,v in pairs(minetest.registered_nodes[drop]) do newtorch[k]=v end
	newtorch.on_place = function(itemstack, placer, pointed_thing)
		return torch.place_torch(itemstack, placer, pointed_thing, material)
	end
	minetest.register_node(":"..drop, newtorch)

	minetest.register_node("torch:torch_"..material.."_ceiling",{
		tiles = {
		"torch_torch_"..material.."_top.png",
		"torch_torch_"..material.."_top.png",
		{ name="torch_torch_"..material.."_ceiling.png",
					animation={
						type="vertical_frames",
						aspect_w=40,
						aspect_h=40,
						length=1.0
						}
					}
				},

		inventory_image = "default_torch_on_floor.png",
		wield_image = "default_torch_on_floor.png",
		light_source = LIGHT_MAX-1,
		is_ground_content = true,
		walkable = false,
		sunlight_propagates = true,
		drawtype="nodebox",
		paramtype = "light",
		on_place = function(itemstack, placer, pointed_thing)
			return torch.place_torch(itemstack, placer, pointed_thing, material)
		end,
		groups = groups, 
		drop = drop,
		node_box = {
			type = "fixed",
			fixed = {
				{0.1875,0.25,0.0625,-0.1875,-0.25,0.0625}, --fire_north
				{0.0625,0.25,0.1875,0.0625,-0.25,-0.1875}, --fire_east
				{0.1875,0.25,-0.0625,-0.1875,-0.25,-0.0625}, --fire_south
				{-0.0625,0.25,0.1875,-0.0625,-0.25,-0.1875}, --fire_west
				{0.0625,0.5,0.0625,-0.0625,-0.4375,-0.0625}, --torchwood
				{-0.375,0.3125,-0.375,0.375,0.375,0.375}, --frame_top_1
				{-0.25,0.375,-0.25,0.25,0.4375,0.25}, --frame_top_2
				{0.25,-0.4375,0.25,0.3125,0.3125,0.3125}, --frame_northeast
				{0.25,-0.4375,-0.3125,0.3125,0.3125,-0.25}, --frame_southeast
				{-0.3125,-0.4375,0.25,-0.25,0.3125,0.3125}, --frame_northwest
				{-0.3125,-0.4375,-0.3125,-0.25,0.3125,-0.25}, --frame_southwest
				{-0.375,-0.5,-0.375,0.375,-0.4375,0.375}, --frame_bottom
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{0.0625,-0.125,0.0625,-0.0625,-0.4375,-0.0625}, --torchwood
				{-0.375,0.3125,-0.375,0.375,0.375,0.375}, --frame_top_1
				{-0.25,0.375,-0.25,0.25,0.4375,0.25}, --frame_top_2
				{0.0625,0.5,0.0625,-0.0625,0.4375,-0.0625}, --frame_top_3
				{0.25,-0.4375,0.25,0.3125,0.3125,0.3125}, --frame_northeast
				{0.25,-0.4375,-0.3125,0.3125,0.3125,-0.25}, --frame_southeast
				{-0.3125,-0.4375,0.25,-0.25,0.3125,0.3125}, --frame_northwest
				{-0.3125,-0.4375,-0.3125,-0.25,0.3125,-0.25}, --frame_southwest
				{-0.375,-0.5,-0.375,0.375,-0.4375,0.375}, --frame_bottom
			},
		},
		sounds = default.node_sound_defaults(),
	})

	minetest.register_node("torch:torch_"..material.."_wall",{
		tiles = {
		"torch_torch_"..material.."_top.png",
		"torch_torch_"..material.."_top.png",
		{name="torch_torch_"..material.."_floor.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
		{name="torch_torch_"..material.."_floor.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
		{name="torch_torch_"..material.."_wall.png^[transformFX", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
		{name="torch_torch_"..material.."_wall.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
		},
		inventory_image = "default_torch_on_floor.png",
		wield_image = "default_torch_on_floor.png",
		light_source = LIGHT_MAX-1,
		is_ground_content = false,
		walkable = false,
		sunlight_propagates = true,
		drawtype="nodebox",
		paramtype = "light",
		on_place = function(itemstack, placer, pointed_thing)
			return torch.place_torch(itemstack, placer, pointed_thing, material)
		end,
		paramtype2 = "facedir",
		groups = groups, 
		drop = drop,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.409091,-0.0625,-0.375,-0.362669,0.0625},
				{-0.484526,-0.362669,-0.0638297,-0.359768,-0.319149,0.0638297},
				{-0.348163,-0.281431,-0.0638297,-0.470019,-0.32205,0.0638297},
				{-0.455513,-0.240812,-0.0638297,-0.336557,-0.281431,0.0638297},
				{-0.32205,-0.240812,-0.0638297,-0.441006,-0.197292,0.0638297},
				{-0.426499,-0.197292,-0.0638297,-0.307544,-0.156673,0.0638297},
				{-0.414894,-0.156673,-0.0638297,-0.295938,-0.113153,0.0638297},
				{-0.5,-0.446808,-0.0638297,-0.38588,-0.409091,0.0638297},
				{-0.5,-0.484526,-0.0638297,-0.397485,-0.446808,0.0638297},
				{-0.403288,-0.113153,-0.0638297,-0.284333,-0.0696325,0.0638297},
				{-0.388782,-0.0696325,-0.0638297,-0.269826,-0.0290134,0.0638297},
				{-0.5,-0.0290134,-0.0638297,-0.0667311,0.5,-0.0638297},
				{-0.5,-0.0290134,0.0609284,-0.0667311,0.5,0.0609284},
				{-0.388782,-0.0290134,-0.199956,-0.388782,0.5,0.20914},
				{-0.269826,-0.0290134,-0.197292,-0.269826,0.5,0.205996}
			}
		},
			selection_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.4912921,-0.110013,-0.261122,0.182785,0.11}
			}
		},
		sounds = default.node_sound_defaults(),
	})

	minetest.register_node("torch:torch_"..material.."_floor",{
		tiles = {
		"torch_torch_"..material.."_top.png",
		"torch_torch_"..material.."_top.png",
		{ name="torch_torch_"..material.."_floor.png",
			animation={
				type="vertical_frames",
				aspect_w=40,
				aspect_h=40,
				length=1.0
				}
			}
		},

		inventory_image = "default_torch_on_floor.png",
		wield_image = "default_torch_on_floor.png",
		light_source = LIGHT_MAX-1,
		is_ground_content = false,
		walkable = false,
		sunlight_propagates = true,
		drawtype="nodebox",
		paramtype = "light",
		on_place = function(itemstack, placer, pointed_thing)
			return torch.place_torch(itemstack, placer, pointed_thing, material)
		end,
		groups = groups, 
		drop = drop,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.0696325,-0.5,-0.0638297,0.0638297,0.124758,0.0696325},
				{-0.336557,-0.0667312,0.0698737,0.301741,0.5,0.0698737},
				{-0.336557,-0.0725339,-0.0693932,0.307544,0.5,-0.0693932},
				{0.0522243,-0.0841393,-0.31311,0.0522243,0.5,0.307788},
				{-0.0696325,-0.0783366,-0.318913,-0.0696325,0.5,0.296182}
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
			{-0.0696325,-0.5,-0.0638297,0.0638297,0.1,0.0696325}
			}
		},
		sounds = default.node_sound_defaults(),
	})

	--abm that drops a floating torch (attached to air)
	minetest.register_abm({
		nodenames = {"torch:torch_"..material.."_floor", "torch:torch_"..material.."_ceiling", "torch:torch_"..material.."_wall"},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local name = node.name
			local param2 = node.param2
			local p2_to_pos = {
				[0]={x=pos.x-1,y=pos.y,z=pos.z}, --west
				[1]={x=pos.x,y=pos.y,z=pos.z+1}, --north
				[2]={x=pos.x+1,y=pos.y,z=pos.z}, --east
				[3]={x=pos.x,y=pos.y,z=pos.z-1}, --south
				[4]={x=pos.x,y=pos.y+1,z=pos.z}, --up
				[5]={x=pos.x,y=pos.y-1,z=pos.z}  --down
			}

			local function get_node(pos)
	-- 			print("DEBUG:: TORCHES: Checking node at pos "..minetest.pos_to_string(pos))
				return minetest.get_node(pos)
			end
	
			local function check_attached(pos, param2)
				for p2 = 0,5 do
					if param2 == p2 and get_node(p2_to_pos[p2]).name == "air" then
						minetest.remove_node(pos)
						minetest.add_item(pos, "default:torch")
					end
				end
			end

			if name == "torch:torch_"..material.."_wall" then check_attached(pos, param2) end
			if name == "torch:torch_"..material.."_ceiling" then check_attached(pos, 4) end
			if name == "torch:torch_"..material.."_floor" then check_attached(pos, 5) end
		end,
	})
end
