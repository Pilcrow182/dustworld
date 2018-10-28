dofile(minetest.get_modpath("ruins").."/golem.lua")

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
	minetest.env:set_node(pos, {name="default:chest"})
	minetest.env:set_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="ruins:spawner_golem"})
	if not minetest.setting_getbool("only_peaceful_mobs") then ruins.spawn_golem({x=pos.x+1,y=pos.y,z=pos.z},2) end
	minetest.after(2, function()
		local n = minetest.env:get_node(pos)
		if n ~= nil then
			if n.name == "default:chest" then
				local meta = minetest.env:get_meta(pos)
				meta:set_string("formspec", "size[10,9]list[current_name;main;1,0;8,4;]list[current_player;main;0,5;10,4;]")
				meta:set_string("infotext", "Chest")
				local inv = meta:get_inventory()
				inv:set_size("main", 8*4)
				for i=0,4,1 do
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

local function can_replace(pos)
	local n = minetest.env:get_node_or_nil(pos)
	if n and n.name and minetest.registered_nodes[n.name] and not minetest.registered_nodes[n.name].walkable then
		return true
	elseif not n then
		return true
	else
		return false
	end
end


local function ground(pos)
	local p2 = pos
	local cnt = 0
	local mat = "dirt"
	p2.y = p2.y-1
	while can_replace(p2)==true do--minetest.env:get_node(p2).name == "air" do
		cnt = cnt+1
		if cnt > 200 then break end
		if cnt>math.random(2,4) then mat = "stone"end
		minetest.env:set_node(p2, {name="default:"..mat})
		p2.y = p2.y-1
	end
end

local function door(pos)
	pos.y = pos.y+1
	if math.random(0,1) > 0 then
		if math.random(0,1)>0 then pos.x=pos.x+6 end
		pos.z = pos.z + 3
	else
		if math.random(0,1)>0 then pos.z=pos.z+6 end
		pos.x = pos.x + 3
	end
	minetest.env:remove_node(pos)
	pos.y = pos.y+1
	minetest.env:remove_node(pos)
end

local function make(pos)
local material = "mossycobble"
if math.random(1,10) > 8 then material = "wood" end
 for yi = 0,4 do
	for xi = 0,6 do
		for zi = 0,6 do
			if yi == 0 then
				local p = {x=pos.x+xi, y=pos.y, z=pos.z+zi}
				minetest.env:set_node(p, {name="default:cobble"})
				minetest.after(1,ground,p)--(p)
			else
				if xi < 1 or xi > 5 or zi<1 or zi>5 then
					if math.random(1,yi) == 1 then
						local new = material
						if yi == 2 and math.random(1,10) == 3 then new = "glass" end
						local n = minetest.env:get_node_or_nil({x=pos.x+xi, y=pos.y+yi-1, z=pos.z+zi})
						if n and n.name ~= "air" then
							minetest.env:set_node({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi}, {name="default:"..new})
						end
					end
				else
					minetest.env:remove_node({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi})
					if yi == 1 then
						if math.random(0,7) == 6 then fill_chest({x=pos.x+xi, y=pos.y+yi, z=pos.z+zi}) end
					end
				end
			end
		end
	end
 end
 door(pos)
end



local perl1 = {
	SEED1 = 9130, -- Values should match minetest mapgen V6 desert noise.
	OCTA1 = 3,
	PERS1 = 0.5,
	SCAL1 = 250,
}

local is_set = false
local function set_seed(seed)
	if not is_set then
		math.randomseed(seed)
		is_set = true
	end
end

minetest.register_on_generated(function(minp, maxp, seed)

	if maxp.y < 0 then return end
	if math.random(0,10)<8 then return end
	set_seed(seed)

	local perlin1 = minetest.env:get_perlin(perl1.SEED1, perl1.OCTA1, perl1.PERS1, perl1.SCAL1)
	local noise1 = perlin1:get2d({x=minp.x,y=minp.y})--,z=minp.z})
	if noise1 < 0.36 or noise1 > -0.36 then
		local mpos = {x=math.random(minp.x,maxp.x), y=math.random(minp.y,maxp.y), z=math.random(minp.z,maxp.z)}
		minetest.after(0.5, function()
		 p2 = minetest.env:find_node_near(mpos, 25, {"default:dirt_with_grass"})	
		 if not p2 or p2 == nil or p2.y < 0 then return end
		
		  make(p2)
		end)
	end
end)