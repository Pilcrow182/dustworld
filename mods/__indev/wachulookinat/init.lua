--[[
local function get_pointed_thing(player, range)
	local plpos = player:getpos()
	plpos.y = plpos.y+1.625
	local dir = player:get_look_dir()
	local p2 = vector.add(plpos, vector.multiply(dir, range))
	local _,pos = minetest.line_of_sight(plpos, p2)
	if not pos then
		return
	end
	return {
		under = vector.round(pos),
		above = vector.round(vector.subtract(pos, dir)),
		type = "node"
	}
end
--]]

-- https://github.com/HybridDog/technic_extras/blob/master/init.lua#L175
