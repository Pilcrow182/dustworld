worldedit = worldedit or {}

--modifies positions `pos1` and `pos2` so that each component of `pos1` is less than or equal to its corresponding conent of `pos2`, returning two new positions
worldedit.sort_pos = function(pos1, pos2)
	pos1 = {x=pos1.x, y=pos1.y, z=pos1.z}
	pos2 = {x=pos2.x, y=pos2.y, z=pos2.z}
	if pos1.x > pos2.x then
		pos2.x, pos1.x = pos1.x, pos2.x
	end
	if pos1.y > pos2.y then
		pos2.y, pos1.y = pos1.y, pos2.y
	end
	if pos1.z > pos2.z then
		pos2.z, pos1.z = pos1.z, pos2.z
	end
	return pos1, pos2
end

--determines the volume of the region defined by positions `pos1` and `pos2`, returning the volume
worldedit.volume = function(pos1, pos2)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	return (pos2.x - pos1.x + 1) * (pos2.y - pos1.y + 1) * (pos2.z - pos1.z + 1)
end

--sets a region defined by positions `pos1` and `pos2` to `nodename`, returning the number of nodes filled
worldedit.set = function(pos1, pos2, nodename, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if env == nil then env = minetest.env end

	local node = {name=nodename}
	local pos = {x=pos1.x, y=0, z=0}
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				env:add_node(pos, node)
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return worldedit.volume(pos1, pos2)
end

--replaces all instances of `searchnode` with `replacenode` in a region defined by positions `pos1` and `pos2`, returning the number of nodes replaced
worldedit.replace = function(pos1, pos2, searchnode, replacenode, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if env == nil then env = minetest.env end

	if minetest.registered_nodes[searchnode] == nil then
		searchnode = "default:" .. searchnode
	end

	local pos = {x=pos1.x, y=0, z=0}
	local node = {name=replacenode}
	local count = 0
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				if env:get_node(pos).name == searchnode then
					env:add_node(pos, node)
					count = count + 1
				end
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return count
end

--replaces all nodes other than `searchnode` with `replacenode` in a region defined by positions `pos1` and `pos2`, returning the number of nodes replaced
worldedit.replaceinverse = function(pos1, pos2, searchnode, replacenode, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if env == nil then env = minetest.env end

	if minetest.registered_nodes[searchnode] == nil then
		searchnode = "default:" .. searchnode
	end

	local pos = {x=pos1.x, y=0, z=0}
	local node = {name=replacenode}
	local count = 0
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				local name = env:get_node(pos).name
				if name ~= "ignore" and name ~= searchnode then
					env:add_node(pos, node)
					count = count + 1
				end
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return count
end

--copies the region defined by positions `pos1` and `pos2` along the `axis` axis ("x" or "y" or "z") by `amount` nodes, returning the number of nodes copied
worldedit.copy = function(pos1, pos2, axis, amount, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if env == nil then env = minetest.env end

	if amount < 0 then
		local pos = {x=pos1.x, y=0, z=0}
		while pos.x <= pos2.x do
			pos.y = pos1.y
			while pos.y <= pos2.y do
				pos.z = pos1.z
				while pos.z <= pos2.z do
					local node = env:get_node(pos) --obtain current node
					local meta = env:get_meta(pos):to_table() --get meta of current node
					local value = pos[axis] --store current position
					pos[axis] = value + amount --move along axis
					env:add_node(pos, node) --copy node to new position
					env:get_meta(pos):from_table(meta) --set metadata of new node
					pos[axis] = value --restore old position
					pos.z = pos.z + 1
				end
				pos.y = pos.y + 1
			end
			pos.x = pos.x + 1
		end
	else
		local pos = {x=pos2.x, y=0, z=0}
		while pos.x >= pos1.x do
			pos.y = pos2.y
			while pos.y >= pos1.y do
				pos.z = pos2.z
				while pos.z >= pos1.z do
					local node = minetest.get_node(pos) --obtain current node
					local meta = env:get_meta(pos):to_table() --get meta of current node
					local value = pos[axis] --store current position
					pos[axis] = value + amount --move along axis
					minetest.add_node(pos, node) --copy node to new position
					env:get_meta(pos):from_table(meta) --set metadata of new node
					pos[axis] = value --restore old position
					pos.z = pos.z - 1
				end
				pos.y = pos.y - 1
			end
			pos.x = pos.x - 1
		end
	end
	return worldedit.volume(pos1, pos2)
end

--moves the region defined by positions `pos1` and `pos2` along the `axis` axis ("x" or "y" or "z") by `amount` nodes, returning the number of nodes moved
worldedit.move = function(pos1, pos2, axis, amount, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if env == nil then env = minetest.env end

	if amount < 0 then
		local pos = {x=pos1.x, y=0, z=0}
		while pos.x <= pos2.x do
			pos.y = pos1.y
			while pos.y <= pos2.y do
				pos.z = pos1.z
				while pos.z <= pos2.z do
					local node = env:get_node(pos) --obtain current node
					local meta = env:get_meta(pos):to_table() --get metadata of current node
					env:remove_node(pos)
					local value = pos[axis] --store current position
					pos[axis] = value + amount --move along axis
					env:add_node(pos, node) --move node to new position
					env:get_meta(pos):from_table(meta) --set metadata of new node
					pos[axis] = value --restore old position
					pos.z = pos.z + 1
				end
				pos.y = pos.y + 1
			end
			pos.x = pos.x + 1
		end
	else
		local pos = {x=pos2.x, y=0, z=0}
		while pos.x >= pos1.x do
			pos.y = pos2.y
			while pos.y >= pos1.y do
				pos.z = pos2.z
				while pos.z >= pos1.z do
					local node = env:get_node(pos) --obtain current node
					local meta = env:get_meta(pos):to_table() --get metadata of current node
					env:remove_node(pos)
					local value = pos[axis] --store current position
					pos[axis] = value + amount --move along axis
					env:add_node(pos, node) --move node to new position
					env:get_meta(pos):from_table(meta) --set metadata of new node
					pos[axis] = value --restore old position
					pos.z = pos.z - 1
				end
				pos.y = pos.y - 1
			end
			pos.x = pos.x - 1
		end
	end
	return worldedit.volume(pos1, pos2)
end

--duplicates the region defined by positions `pos1` and `pos2` along the `axis` axis ("x" or "y" or "z") `count` times, returning the number of nodes stacked
worldedit.stack = function(pos1, pos2, axis, count, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	local length = pos2[axis] - pos1[axis] + 1
	if count < 0 then
		count = -count
		length = -length
	end
	local amount = 0
	local copy = worldedit.copy
	for i = 1, count do
		amount = amount + length
		copy(pos1, pos2, axis, amount, env)
	end
	return worldedit.volume(pos1, pos2)
end

--transposes a region defined by the positions `pos1` and `pos2` between the `axis1` and `axis2` axes, returning the number of nodes transposed, the new position 1, and the new position 2
worldedit.transpose = function(pos1, pos2, axis1, axis2, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)

	local compare
	local extent1, extent2 = pos2[axis1] - pos1[axis1], pos2[axis2] - pos1[axis2]

	if extent1 > extent2 then
		compare = function(extent1, extent2)
			return extent1 > extent2
		end
	else
		compare = function(extent1, extent2)
			return extent1 < extent2
		end
	end

	--calculate the new position 2 after transposition
	local newpos2 = {x=pos2.x, y=pos2.y, z=pos2.z}
	newpos2[axis1] = pos1[axis1] + extent2
	newpos2[axis2] = pos1[axis2] + extent1

	local pos = {x=pos1.x, y=0, z=0}
	if env == nil then env = minetest.env end
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				local extent1, extent2 = pos[axis1] - pos1[axis1], pos[axis2] - pos1[axis2]
				if compare(extent1, extent2) then --transpose only if below the diagonal
					local node1 = env:get_node(pos)
					local meta1 = env:get_meta(pos):to_table()
					local value1, value2 = pos[axis1], pos[axis2] --save position values
					pos[axis1], pos[axis2] = pos1[axis1] + extent2, pos1[axis2] + extent1 --swap axis extents
					local node2 = env:get_node(pos)
					local meta2 = env:get_meta(pos):to_table()
					env:add_node(pos, node1)
					env:get_meta(pos):from_table(meta1)
					pos[axis1], pos[axis2] = value1, value2 --restore position values
					env:add_node(pos, node2)
					env:get_meta(pos):from_table(meta2)
				end
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return worldedit.volume(pos1, pos2), pos1, newpos2
end

--flips a region defined by the positions `pos1` and `pos2` along the `axis` axis ("x" or "y" or "z"), returning the number of nodes flipped
worldedit.flip = function(pos1, pos2, axis, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)

	local pos = {x=pos1.x, y=0, z=0}
	local start = pos1[axis] + pos2[axis]
	pos2[axis] = pos1[axis] + math.floor((pos2[axis] - pos1[axis]) / 2)
	if env == nil then env = minetest.env end
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				local node1 = env:get_node(pos)
				local meta1 = env:get_meta(pos):to_table()
				local value = pos[axis]
				pos[axis] = start - value
				local node2 = env:get_node(pos)
				local meta2 = env:get_meta(pos):to_table()
				env:add_node(pos, node1)
				env:get_meta(pos):from_table(meta1)
				pos[axis] = value
				env:add_node(pos, node2)
				env:get_meta(pos):from_table(meta2)
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return worldedit.volume(pos1, pos2)
end

--rotates a region defined by the positions `pos1` and `pos2` by `angle` degrees clockwise around axis `axis` (90 degree increment), returning the number of nodes rotated
worldedit.rotate = function(pos1, pos2, axis, angle, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)

	local axis1, axis2
	if axis == "x" then
		axis1, axis2 = "z", "y"
	elseif axis == "y" then
		axis1, axis2 = "x", "z"
	else --axis == "z"
		axis1, axis2 = "y", "x"
	end
	angle = angle % 360

	local count
	if angle == 90 then
		worldedit.flip(pos1, pos2, axis1, env)
		count, pos1, pos2 = worldedit.transpose(pos1, pos2, axis1, axis2, env)
	elseif angle == 180 then
		worldedit.flip(pos1, pos2, axis1, env)
		count = worldedit.flip(pos1, pos2, axis2, env)
	elseif angle == 270 then
		worldedit.flip(pos1, pos2, axis2, env)
		count, pos1, pos2 = worldedit.transpose(pos1, pos2, axis1, axis2, env)
	end
	return count, pos1, pos2
end

--rotates all oriented nodes in a region defined by the positions `pos1` and `pos2` by `angle` degrees clockwise (90 degree increment) around the Y axis, returning the number of nodes oriented
worldedit.orient = function(pos1, pos2, angle, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	local nodes = minetest.registered_nodes
	if env == nil then env = minetest.env end
	local wallmounted = {
		[90]={[0]=0, [1]=1, [2]=5, [3]=4, [4]=2, [5]=3},
		[180]={[0]=0, [1]=1, [2]=3, [3]=2, [4]=5, [5]=4},
		[270]={[0]=0, [1]=1, [2]=4, [3]=5, [4]=3, [5]=2}
	}
	local facedir = {
		[90]={[0]=1, [1]=2, [2]=3, [3]=0},
		[180]={[0]=2, [1]=3, [2]=0, [3]=1},
		[270]={[0]=3, [1]=0, [2]=1, [3]=2}
	}

	angle = angle % 360
	if angle == 0 then
		return 0
	end
	local wallmounted_substitution = wallmounted[angle]
	local facedir_substitution = facedir[angle]

	local count = 0
	local pos = {x=pos1.x, y=0, z=0}
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				local node = env:get_node(pos)
				local def = nodes[node.name]
				if def then
					if def.paramtype2 == "wallmounted" then
						node.param2 = wallmounted_substitution[node.param2]
						local meta = env:get_meta(pos):to_table()
						env:add_node(pos, node)
						env:get_meta(pos):from_table(meta)
						count = count + 1
					elseif def.paramtype2 == "facedir" then
						node.param2 = facedir_substitution[node.param2]
						local meta = env:get_meta(pos):to_table()
						env:add_node(pos, node)
						env:get_meta(pos):from_table(meta)
						count = count + 1
					end
				end
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return count
end

--fixes the lighting in a region defined by positions `pos1` and `pos2`, returning the number of nodes updated
worldedit.fixlight = function(pos1, pos2, env)
	local pos1, pos2 = worldedit.sort_pos(pos1, pos2)
	if env == nil then env = minetest.env end
	local count = 0

	local pos = {x=pos1.x, y=0, z=0}
	while pos.x <= pos2.x do
		pos.y = pos1.y
		while pos.y <= pos2.y do
			pos.z = pos1.z
			while pos.z <= pos2.z do
				if env:get_node(pos).name == "air" then
					env:dig_node(pos)
					count = count + 1
				end
				pos.z = pos.z + 1
			end
			pos.y = pos.y + 1
		end
		pos.x = pos.x + 1
	end
	return count
end
