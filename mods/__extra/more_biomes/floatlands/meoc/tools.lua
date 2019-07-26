local function create_soil(pos, inv, p)
	if pos == nil then
		return false
	end
	local node = minetest.get_node(pos)
	local name = node.name
	local above = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
	if name == "default:dirt" or name == "default:dirt_with_grass" then
		if above.name == "air" then
			node.name = "farming:soil"
			minetest.set_node(pos, node)
			if inv and p and name == "default:dirt_with_grass" then
				for name,rarity in pairs(farming.seeds) do
					if math.random(1, rarity-p) == 1 then
						inv:add_item("main", ItemStack(name))
					end
				end
			end
			return true
		end
	end
	return false
end

minetest.register_tool("meoc:pick", {
	description = "Meoc Pickaxe",
	inventory_image = "meoc_tool_meocpick.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=0.50, [2]=0.50, [3]=0.50}, uses=100, maxlevel=3}, -- primary
			crumbly = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			choppy = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			snappy = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=10},
	},
})

minetest.register_tool("meoc:shovel", {
	description = "Meoc Shovel",
	inventory_image = "meoc_tool_meocshovel.png",
	wield_image = "meoc_tool_meocshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			crumbly = {times={[1]=0.50, [2]=0.50, [3]=0.50}, uses=100, maxlevel=3}, -- primary
			choppy = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			snappy = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=8},
	},
})

minetest.register_tool("meoc:axe", {
	description = "Meoc Axe",
	inventory_image = "meoc_tool_meocaxe.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			crumbly = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			choppy = {times={[1]=0.50, [2]=0.50, [3]=0.50}, uses=100, maxlevel=3}, -- primary
			snappy = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
		},
		damage_groups = {fleshy=12},
	},
})

minetest.register_tool("meoc:sword", {
	description = "Meoc Sword",
	inventory_image = "meoc_tool_meocsword.png",
	tool_capabilities = {
		full_punch_interval = 0.7,
		max_drop_level=1,
		groupcaps={
			cracky = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			crumbly = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			choppy = {times={[1]=1.50, [2]=1.50, [3]=1.50}, uses=100, maxlevel=3},
			snappy = {times={[1]=0.50, [2]=0.50, [3]=0.50}, uses=100, maxlevel=3}, -- primary
		},
		damage_groups = {fleshy=14},
	}
})

minetest.register_tool("meoc:hoe", {
	description = "Meoc Hoe",
	inventory_image = "meoc_tool_meochoe.png",
	on_use = function(itemstack, user, pointed_thing)
		if create_soil(pointed_thing.under, user:get_inventory(), 5) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/600)
			end
			return itemstack
		end
	end
})

minetest.register_craft({
	output = 'meoc:pick',
	recipe = {
		{'meoc:crystal', 'meoc:crystal', 'meoc:crystal'},
		{'', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})

minetest.register_craft({
	output = 'meoc:shovel',
	recipe = {
		{'meoc:crystal'},
		{'default:stick'},
		{'default:stick'},
	}
})

minetest.register_craft({
	output = 'meoc:axe',
	recipe = {
		{'meoc:crystal', 'meoc:crystal'},
		{'meoc:crystal', 'default:stick'},
		{'', 'default:stick'},
	}
})

minetest.register_craft({
	output = 'meoc:sword',
	recipe = {
		{'meoc:crystal'},
		{'meoc:crystal'},
		{'default:stick'},
	}
})

minetest.register_craft({
	output = "meoc:hoe",
	recipe = {
		{"meoc:crystal", "meoc:crystal"},
		{"", "default:stick"},
		{"", "default:stick"}
	}
})
