bonemeal.is_growable = function(pos, name)
	if minetest.get_node(pos).name == name or minetest.get_node(pos).name == "air" then
		return true
	else
		return false
	end
end

bonemeal.multinode_grow = function(pos, name)
	if bonemeal.is_growable({x = pos.x, y = pos.y-1, z = pos.z}, name) then
		if bonemeal.is_growable({x = pos.x, y = pos.y-2, z = pos.z}, name) then
			if bonemeal.is_growable({x = pos.x, y = pos.y-3, z = pos.z}, name) then
				if bonemeal.is_growable({x = pos.x, y = pos.y-4, z = pos.z}, name) then
					print("BONEMEAL:: ERROR: No y_start found! Aborting...")
					return false
				else
					y_start = pos.y-3
				end
			else
				y_start = pos.y-2
			end
		else
			y_start = pos.y-1
		end
	else
		y_start = pos.y
	end
	if bonemeal.is_growable({x = pos.x, y = y_start+1, z = pos.z}, name) then
		if bonemeal.is_growable({x = pos.x, y = y_start+2, z = pos.z}, name) then
			if bonemeal.is_growable({x = pos.x, y = y_start+3, z = pos.z}, name) then
				print("BONEMEAL:: ALERT: No y_end found! Setting to maximum height...")
				y_end = y_start+3
			else
				y_end = y_start+2
			end
		else
			y_end = y_start+1
		end
	else
		y_end = y_start
	end
	print("BONEMEAL:: Generating "..name.." from height of "..y_start.." to "..y_end)
	for y_pos = y_start, y_end do
		minetest.set_node({x = pos.x, y = y_pos, z = pos.z}, {name=name})
	end
end
 
