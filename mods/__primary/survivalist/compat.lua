-- all nodes that can become silk leaves (note: problems will NOT be caused if the node doesn't actually exist)
survivalist.supported_leaves = {
	"default:apple", "default:leaves", "default:jungleleaves", "survivalist:apple_leaves", "trees:leaves_palm", "trees:leaves_mangrove", "trees:leaves_conifer",
	"trees:leaves_birch", "trees:leaves_green", "trees:leaves_yellow", "trees:leaves_red", "trees:leaves_green_viney", "trees:leaves_yellow_viney", "trees:leaves_red_viney",
	"farming_plus:banana_leaves", "farming_plus:cocoa_leaves", "default:acacia_leaves", "default:aspen_leaves", "default:pine_needles", "flolife:leaves",
	"default:bush_leaves", "default:acacia_bush_leaves", "default:pine_bush_needles"
}

-- custom leafdecay so silk leaves will decay from *ALL* tree types (note: experimental; it may eat your hamster)
minetest.register_on_dignode(function(pos, oldnode, digger)
	if minetest.get_item_group(oldnode.name, "tree") or oldnode.name == "survivalist:silk_leaves" then
		local minp = {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}
		local maxp = {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}
		for _,leafpos in pairs(minetest.find_nodes_in_area(minp, maxp, "survivalist:silk_leaves")) do
			if not minetest.find_node_near(leafpos, 4, {"group:tree"}) then
				minetest.after(math.random(1,15), function(pos) minetest.dig_node(pos) end, leafpos)
			end
		end
	end
end)

survivalist.use_bucket = function(itemstack, user, pointed_thing)
	-- Must be pointing to node
	if pointed_thing.type ~= "node" then
		return
	end
	-- Check if pointing to a liquid source
	node = minetest.get_node(pointed_thing.under)
	liquiddef = bucket.liquids[node.name]
	if liquiddef ~= nil and liquiddef.itemname ~= nil and (node.name == liquiddef.source or
		(node.name == liquiddef.flowing and minetest.setting_getbool("liquid_finite"))) then

		minetest.add_node(pointed_thing.under, {name="air"})

		if node.name == liquiddef.source then node.param2 = LIQUID_MAX end
		return ItemStack({name = liquiddef.itemname, metadata = tostring(node.param2)})
	end
end

survivalist.clone_item("bucket:bucket_empty", "bucket:bucket_empty", {
	on_use = function(itemstack, user, pointed_thing)
		if not pointed_thing or not pointed_thing.under then return end
		if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name] then
			local after_punch = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_punch(pointed_thing.under, minetest.get_node(pointed_thing.under), user, itemstack) or itemstack
			local after_use = survivalist.use_bucket(after_punch, user, pointed_thing) or after_punch
			itemstack:replace(after_use)
		end
		user:set_wielded_item(itemstack)
		return itemstack
	end
})

survivalist.clone_item("default:lava_source", "default:lava_source", {
	groups = {hot = 3, lava = 3, liquid = 2, igniter = 1},
})

survivalist.clone_item("default:lava_flowing", "default:lava_flowing", {
	groups = {hot = 3, lava = 3, liquid = 2, igniter = 1, not_in_creative_inventory = 1},
})

survivalist.clone_item("doors:gate_wood", "doors:gate_wood", {
	description = "Wood Fence Gate",
})

survivalist.clone_item("default:tree", "default:tree", {
	description = "Tree",
})

survivalist.clone_item("default:wood", "default:wood", {
	description = "Wood Planks",
})

survivalist.clone_item("default:sapling", "default:sapling", {
	description = "Tree Sapling",
})

survivalist.clone_item("default:leaves", "default:leaves", {
	description = "Tree Leaves",
})

survivalist.clone_item("default:fence_wood", "default:fence_wood", {
	description = "Wood Fence",
})

survivalist.clone_item("default:fence_rail_wood", "default:fence_rail_wood", {
	description = "Wood Fence Rail",
})

for i=1,4 do
	minetest.register_alias("survivalist:grinder_"..i, "survivalist:machine_grinder_"..i)
	minetest.register_alias("survivalist:compressor_"..i, "survivalist:machine_compressor_"..i)
end


if minetest.get_modpath("mesecons") == nil then
	minetest.register_craftitem(":mesecons:wire_00000000_off",{
		description = "Mesecons Wire",
		inventory_image = "survivalist_subst_wire.png"
	})

	minetest.register_craftitem(":mesecons_pistons:piston_normal_off",{
		description = "Mesecons Piston",
		inventory_image = "survivalist_subst_piston.png"
	})

	minetest.register_craft({
		output = "mesecons_pistons:piston_normal_off 2",
		recipe = {
			{"default:wood", "default:wood", "default:wood"},
			{"default:cobble", "default:steel_ingot", "default:cobble"},
			{"default:cobble", "mesecons:wire_00000000_off", "default:cobble"},
		}
	})

	minetest.register_craft({
		type = "cooking",
		output = "mesecons:wire_00000000_off 2",
		recipe = "default:mese_crystal_fragment",
		cooktime = 3,
	})

	minetest.register_craft({
		type = "cooking",
		output = "mesecons:wire_00000000_off 16",
		recipe = "default:mese_crystal",
	})

	minetest.register_craft({
		type = "cooking",
		output = "mesecons:wire_00000000_off 162",
		recipe = "default:mese",
		cooktime = 30,
	})
end

if minetest.get_modpath("mobf") == nil then
	if minetest.get_modpath("bonemeal") == nil then
		minetest.register_alias("animalmaterials:bone", "default:clay")
	else
		minetest.register_craftitem(":animalmaterials:bone",{
			description = "Bone",
			inventory_image = "survivalist_subst_bone.png"
		})
	end
end

if minetest.get_modpath("bonemeal") == nil then minetest.register_alias("bonemeal:bonemeal", "survivalist:mulch") end
if minetest.get_modpath("flint") == nil then minetest.register_alias("flint:flintstone", "survivalist:rock") end
if minetest.get_modpath("wasteland") == nil then minetest.register_alias("wasteland:dust", "default:sand") end
