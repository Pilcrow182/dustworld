local MINE_DEEP_MIN = -64    -- how high mines can spawn. default = -64
local MINE_DEEP_MAX = -380   -- how low mines can spawn. default = -380
local DEBUG = false          -- whether or not the mod should display debug messages

minetest.register_node("mines:dummy", {
	description = "Air (you hacker you!)",
	inventory_image = "unknown_node.png",
	wield_image = "unknown_node.png",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	air_equivalent = true,
	drop = "",
	groups = {not_in_creative_inventory=1},
})

local ids = {
	air = "air",
	fence = "default:fence_wood",
	wood = "default:wood",
	dummy = "mines:dummy",
	lantern = "torches:torch_ceiling"
}

local chest_stuff = {
	{name="default:apple", max = 3},
	{name="farming:bread", max = 3},
	{name="default:steel_ingot", max = 2},
	{name="default:gold_ingot", max = 2},
	{name="default:diamond", max = 1},
	{name="default:pick_steel", max = 1},
	{name="default:pick_diamond", max = 1}
}

local function fill_chest(pos)
	minetest.after(8, function()
		local n = minetest.get_node(pos)
		if n ~= nil then
			if n.name == ids.dummy then
				if DEBUG then
					minetest.chat_send_all("DEBUG: Generating chest at "..minetest.pos_to_string(pos))
					print ("DEBUG: Generating chest at "..minetest.pos_to_string(pos))
				end
				minetest.set_node(pos, {name="default:chest"})
				local meta = minetest.get_meta(pos)
				meta:set_string("formspec", "size[10,9]list[current_name;main;1,0;8,4;]list[current_player;main;0,5;10,4;]")
				meta:set_string("infotext", "Chest")
				local inv = meta:get_inventory()
				for i=0,2,1 do
					local stuff = chest_stuff[math.random(1,#chest_stuff)]
					local stack = {name=stuff.name, count = math.random(1,stuff.max)}
					if not inv:contains_item("main", stack) then
						inv:set_stack("main", math.random(1,32), stack)
					end
				end
			end
		end
	end)
end

local function make_mine(mpos)
	for j=0,3,1 do
	local switch = false
	local pos = {x=mpos.x,y=mpos.y, z=mpos.z+j*20}
	if math.random(0,1) == 1 then 
		switch = true
	end
		if switch then
			pos = {x=mpos.x,y=mpos.y, z=mpos.z+j*30}
		else
			pos = {x=mpos.x+j*30,y=mpos.y, z=mpos.z}
		end
		for i=0,35,1 do
			local pillar = ids.air
			local pillar_top = ids.air
			local pillar_topmid = ids.air
			if i==0 or i == 5 or i == 10 or i == 15 or i == 20 or i == 25 or i == 30 or i == 35 then
				pillar = ids.fence
				pillar_top = ids.wood
				pillar_topmid = ids.wood
			end
			if i==1 or i == 4 or i == 6 or i == 9 or i == 11 or i == 14 or i == 16 or i == 19 or i == 21 or i == 24 or i == 26 or i == 29 or i == 31 or i == 34 then
				if math.random(0,3) == 2 then
					pillar_topmid = ids.air
				else
					pillar_topmid = ids.lantern
				end
			end
			local x1
			local x2
			local x3
			local x4
			local x5
			local z1
			local z2
			local z3
			local z4
			local z5
			if switch then
				x1 = pos.x+1
				x2 = pos.x
				x3 = pos.x-1
				x4 = pos.x
				x5 = pos.x+1

				z1 = pos.z+i
				z2 = pos.z+i
				z3 = pos.z+i
				z4 = pos.z+i-1
				z5 = pos.z+i
			else
				x1 = pos.x+i
				x2 = pos.x+i
				x3 = pos.x+i
				x4 = pos.x+i-1
				x5 = pos.x+i

				z1 = pos.z+1
				z2 = pos.z
				z3 = pos.z-1
				z4 = pos.z
				z5 = pos.z+1
			end
			minetest.after(2, function()
				minetest.set_node({x=x1, y=pos.y-1, z=z1}, {name=pillar})
				minetest.set_node({x=x2, y=pos.y-1, z=z2}, {name=ids.air})
				minetest.set_node({x=x3, y=pos.y-1, z=z3}, {name=pillar})

				minetest.set_node({x=x1, y=pos.y, z=z1}, {name=pillar})
				minetest.set_node({x=x2, y=pos.y, z=z2}, {name=ids.air})
				minetest.set_node({x=x3, y=pos.y, z=z3}, {name=pillar})

				minetest.set_node({x=x1, y=pos.y+1, z=z1}, {name=pillar_top})
				minetest.set_node({x=x2, y=pos.y+1, z=z2}, {name=pillar_topmid})
				minetest.set_node({x=x3, y=pos.y+1, z=z3}, {name=pillar_top})

				if math.random(0,60) == 13 then
					local p = {x=x5, y=pos.y-1, z=z5}
					if minetest.get_node(p).name ~= ids.fence then
						minetest.set_node(p, {name=ids.dummy})
						fill_chest(p)
					end
				end
			end)
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if minetest.get_modpath("wasteland") or minetest.get_modpath("skyland") then return end
	if minp.y > MINE_DEEP_MIN or minp.y < MINE_DEEP_MAX then return end
	if math.random(0,100) > 85 then return end
	make_mine({x=math.random(minp.x,maxp.x), y=minp.y+math.random(-2,2), z=math.random(minp.z,maxp.z)})
end)

