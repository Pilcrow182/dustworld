--this is an alternate version of machine.lua that uses no metadata, but a global table instead. not used due to it having no noticeable benefit.

machine = {
	{-0.5,-0.5,-0.5,0.5,0.5,0.5}, --Machine_Core
	{-0.0625,0.5,-0.0625,0.0625,0.9375,0.0625}, --Handle_Center
	crank = {
		{-0.0625,0.8125,0.0625,0.0625,0.9375,0.25}, --Handle_North
		{0.0625,0.8125,-0.0625,0.25,0.9375,0.0625}, --Handle_East
		{-0.0625,0.8125,-0.25,0.0625,0.9375,-0.0625}, --Handle_South
		{-0.25,0.8125,-0.0625,-0.0625,0.9375,0.0625}, --Handle_West
	}
}

survivalist.processing = {}

function survivalist.swap_machine(pos, machine_type)
	local n=minetest.get_node(pos)
	local nn = n.name
	for i=1,3 do
		if nn == "survivalist:machine_"..machine_type.."_"..i then becomes = "survivalist:machine_"..machine_type.."_"..i+1 end
	end
	if nn == "survivalist:machine_"..machine_type.."_4" then becomes = "survivalist:machine_"..machine_type.."_1" end
	minetest.set_node(pos, {name=becomes})
end

function survivalist.register_machine(machine_type, itemtable)
	local function check_input(input)
		local conversion = nil
		for i=1,#itemtable do
			if input == itemtable[i][1] then conversion = itemtable[i] end
		end
		return conversion
	end

	local function check_processing(poshash)
		local output = {nil, 0}
		for i=1,#survivalist.processing do
			if poshash == survivalist.processing[i][1] then
				output = {survivalist.processing[i][2], survivalist.processing[i][3]}
			end
		end
		return output
	end

	local function set_processing(poshash, key, value)
		local added = false
		for i=1,#survivalist.processing do
			if poshash == survivalist.processing[i][1] then
				survivalist.processing[i][key] = value
				added = true
			end
		end
		if not added then
			table.insert(survivalist.processing, {poshash, nil, 0})
			set_processing(poshash, key, value)
		end
	end

	local function remove_processing(poshash)
		for i=1,#survivalist.processing do
			if poshash == survivalist.processing[i][1] then
				table.remove(survivalist.processing, i)
			end
		end
	end

	for i = 1,4 do
		minetest.register_node("survivalist:machine_"..machine_type.."_"..i,{
			description = machine_type,
			tiles = {"survivalist_machine_"..machine_type.."_top.png", "survivalist_machine_"..machine_type.."_top.png", "survivalist_machine_"..machine_type.."_"..i..".png"},
			drawtype = "nodebox",
			paramtype = "light",
			node_box = {
				type = "fixed",
				fixed = {machine[1], machine[2], machine.crank[i]}
			},
			on_rightclick = function(pos, node, clicker, itemstack)
				if not clicker then return end
				local wielded = itemstack:get_name()
				local poshash = minetest.hash_node_position(pos)
				local machine_data = check_processing(poshash)
				local processing = machine_data[1]
				local worktime = machine_data[2]
				local conv1 = check_input(wielded)
				local conv2 = check_input(processing)
				if conv2 then
					worktime = worktime + 1
					set_processing(poshash, 3, worktime)
					if worktime >= 3 then
						remove_processing(poshash)
						survivalist.hacky_give_item(clicker, conv2[2], 1, itemstack) -- clicker:get_inventory():add_item("main", conv2[2])
					end
				elseif conv1 then
					set_processing(poshash, 2, conv1[1])
					set_processing(poshash, 3, 0)
					itemstack:take_item(1)
				end
				survivalist.swap_machine(pos, machine_type)
				return itemstack
			end,
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
			drop = "survivalist:machine_"..machine_type.."_1"
		})
	end
end

survivalist.register_machine("grinder", {
	{"default:cobble", "default:gravel"},
	{"default:gravel", "default:sand"},
	{"default:sand", "wasteland:dust"},
	{"default:desert_stone", "default:desert_sand"},
	{"default:desert_sand", "wasteland:dust"},
})
survivalist.register_machine("compressor", {
	{"default:coalblock", "default:diamond"},
	{"default:gravel", "default:cobble"},
	{"default:sand", "default:gravel"},
	{"wasteland:dust", "default:sand"},
	{"default:desert_sand", "default:desert_stone"},
})
