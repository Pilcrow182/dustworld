minetest.register_alias("noairblocks:water_sourcex", "default:water_source")
minetest.register_alias("noairblocks:water_flowingx", "default:water_flowing")

minetest.register_alias("seaplants:seaplantssandkelpbrown", "seaflora:sand_with_brown_kelp")
minetest.register_alias("seaplants:seaplantssandkelpgreen", "seaflora:sand_with_green_kelp")

minetest.register_alias("seaplants:seaplantsdirtkelpbrown", "seaflora:dirt_with_brown_kelp")
minetest.register_alias("seaplants:seaplantsdirtkelpgreen", "seaflora:dirt_with_green_kelp")

minetest.register_alias("seaplants:seagrassgreen", "default:water_source")
minetest.register_alias("seaplants:seagrassred", "default:water_source")

minetest.register_alias("seaplants:seaplantssandseagrassgreen", "seaflora:sand_with_green_coral")
minetest.register_alias("seaplants:seaplantssandseagrassred", "seaflora:sand_with_red_coral")

minetest.register_alias("seaplants:seaplantsdirtseagrassgreen", "seaflora:dirt_with_green_coral")
minetest.register_alias("seaplants:seaplantsdirtseagrassred", "seaflora:dirt_with_red_coral")

minetest.register_alias("seacoral:seacoralsandaqua", "default:sand")
minetest.register_alias("seacoral:seacoralsandcyan", "default:sand")
minetest.register_alias("seacoral:seacoralsandlime", "default:sand")
minetest.register_alias("seacoral:seacoralsandmagenta", "default:sand")
minetest.register_alias("seacoral:seacoralsandskyblue", "default:sand")
minetest.register_alias("seacoral:seacoralsandredviolet", "default:sand")

minetest.register_alias("seacoral:seacoraldirtaqua", "default:dirt")
minetest.register_alias("seacoral:seacoraldirtcyan", "default:dirt")
minetest.register_alias("seacoral:seacoraldirtlime", "default:dirt")
minetest.register_alias("seacoral:seacoraldirtmagenta", "default:dirt")
minetest.register_alias("seacoral:seacoraldirtskyblue", "default:dirt")
minetest.register_alias("seacoral:seacoraldirtredviolet", "default:dirt")

local corals = {
	["seacoral:coralaqua"] = "yellow",
	["seacoral:coralcyan"] = "cyan",
	["seacoral:corallime"] = "green",
	["seacoral:coralmagenta"] = "magenta",
	["seacoral:coralskyblue"] = "blue",
	["seacoral:seacoralredviolet"] = "red",
}

for old,color in pairs(corals) do
	minetest.register_abm({
		nodenames = {old},
		interval = 1,
		chance = 1,
		action = function(pos)
			local p = {x = pos.x, y = pos.y - 1, z = pos.z}
			local n = minetest.get_node(p)

			local new = "seaflora:sand_with_"..color.."_coral"
			if n.name == "default:dirt" then
				new = "seaflora:dirt_with_"..color.."_coral"
			end

			minetest.remove_node(pos)
			minetest.swap_node(p, {name = new, param2 = 16})
		end
	})
end

local kelp = {
	["seaplants:seaplantssandkelpgreen"] = "seaflora:sand_with_green_kelp",
	["seaplants:seaplantssandkelpbrown"] = "seaflora:sand_with_brown_kelp",
	["seaflora:sand_with_green_kelp"] = "seaflora:sand_with_green_kelp",
	["seaflora:sand_with_brown_kelp"] = "seaflora:sand_with_brown_kelp",
}

minetest.register_abm({
	nodenames = {"seaplants:kelpgreen", "seaplants:kelpgreenmiddle", "seaplants:kelpbrown", "seaplants:kelpbrownmiddle"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local nodeabove = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z})
		if string.find(nodeabove.name, "water") == nil then return end
		local height = 0
		local p = pos
		local node = minetest.get_node(p)
		while true do
			height = height + 1
			p = {x = pos.x, y = pos.y + 1 - height, z = pos.z}
			node = minetest.get_node(p)
			if node.name == "ignore" then return end
			if string.find(node.name, "seaplants") == nil or string.find(node.name, "water") ~= nil or string.find(node.name, "sand") ~= nil then break end
			minetest.set_node(p, {name = "default:water_source"})
		end
		if kelp[node.name] then
			minetest.swap_node(p, {name = kelp[node.name], param2 = height * 16})
		else
			minetest.chat_send_all("ERROR: node "..node.name.." has no kelp equivalent")
		end
	end
})

