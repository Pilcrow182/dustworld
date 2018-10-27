bonemeal.fruit_or_leaves = function(leavesgen, fruitgen)
	if fruitgen and math.random(0, 10) == 3 then
		return {name = fruitgen}
	else
		return {name = leavesgen}
	end
end

bonemeal.air_or_leaves = function(leavesgen)
	if math.random(0, 50) == 3 then
		return {name = "air"}
	else
		return {name = leavesgen}
	end
end

bonemeal.generate_tree = function(pos, trunkgen, leavesgen, fruitgen)
	pos.y = pos.y-1
	local nodename = minetest.get_node(pos).name
		
	pos.y = pos.y+1
	if not minetest.get_node_light(pos) then
		return
	end

	node = {name = ""}
	for dy=1,4 do
		pos.y = pos.y+dy
		if minetest.get_node(pos).name ~= "air" then
			return
		end
		pos.y = pos.y-dy
	end
	node = {name = trunkgen}
	for dy=0,4 do
		pos.y = pos.y+dy
		minetest.set_node(pos, node)
		pos.y = pos.y-dy
	end

	node = {name = leavesgen}
	pos.y = pos.y+3
	local rarity = 0
	--[[
	if math.random(0, 10) == 3 then
		rarity = 1
	end
	--]]
	rarity = 1
	for dx=-2,2 do
		for dz=-2,2 do
			for dy=0,3 do
				pos.x = pos.x+dx
				pos.y = pos.y+dy
				pos.z = pos.z+dz

				if dx == 0 and dz == 0 and dy==3 then
					if minetest.get_node(pos).name == "air" and math.random(1, 5) <= 4 then
						minetest.set_node(pos, node)
						if rarity == 1 then
							minetest.set_node(pos, bonemeal.fruit_or_leaves(leavesgen, fruitgen))
						else
							minetest.set_node(pos, bonemeal.air_or_leaves(leavesgen))
						end
					end
				elseif dx == 0 and dz == 0 and dy==4 then
					if minetest.get_node(pos).name == "air" and math.random(1, 5) <= 4 then
						minetest.set_node(pos, node)
						if rarity == 1 then
							minetest.set_node(pos, bonemeal.fruit_or_leaves(leavesgen, fruitgen))
						else
							minetest.set_node(pos, bonemeal.air_or_leaves(leavesgen))
						end
					end
				elseif math.abs(dx) ~= 2 and math.abs(dz) ~= 2 then
					if minetest.get_node(pos).name == "air" then
						minetest.set_node(pos, node)
						if rarity == 1 then
							minetest.set_node(pos, bonemeal.fruit_or_leaves(leavesgen, fruitgen))
						else
							minetest.set_node(pos, bonemeal.air_or_leaves(leavesgen))
						end
					end
				else
					if math.abs(dx) ~= 2 or math.abs(dz) ~= 2 then
						if minetest.get_node(pos).name == "air" and math.random(1, 5) <= 4 then
							minetest.set_node(pos, node)
						if rarity == 1 then
							minetest.set_node(pos, bonemeal.fruit_or_leaves(leavesgen, fruitgen))
						else
							minetest.set_node(pos, bonemeal.air_or_leaves(leavesgen))
						end
						end
					end
				end
				pos.x = pos.x-dx
				pos.y = pos.y-dy
				pos.z = pos.z-dz
			end
		end
	end
end
 
