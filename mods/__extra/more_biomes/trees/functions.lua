abstrac_trees.add_tree_branch = function(pos, leaves)
	local leave = "jungletree:leaves_"..leaves[math.random(1,3)]
	minetest.add_node(pos, {name="default:jungletree"})
	for i = math.floor(math.random(2)), -math.floor(math.random(2)), -1 do
		for k = math.floor(math.random(2)), -math.floor(math.random(2)), -1 do
			local p = {x=pos.x+i, y=pos.y, z=pos.z+k}
			local n = minetest.get_node(p)
			if (n.name=="air") then
				minetest.add_node(p, {name=leave})
			end
			local chance = math.abs(i+k)
			if (chance < 1) then
				p = {x=pos.x+i, y=pos.y+1, z=pos.z+k}
				n = minetest.get_node(p)
				if (n.name=="air") then
					minetest.add_node(p, {name=leave})
				end
			end
		end
	end
end
