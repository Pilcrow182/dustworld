local crucible = {
	wall_north = {-6/16,-8/16, 6/16, 6/16, 7/16, 7/16},
	wall_east  = { 6/16,-8/16,-6/16, 7/16, 7/16, 6/16},
	wall_south = {-6/16,-8/16,-7/16, 6/16, 7/16,-6/16},
	wall_west  = {-7/16,-8/16,-6/16,-6/16, 7/16, 6/16},
	bottom = {
		{-6/16,-8/16,-6/16, 6/16,-6/16, 6/16},
		{-6/16,-8/16,-6/16, 6/16,-2/16, 6/16},
		{-6/16,-8/16,-6/16, 6/16, 2/16, 6/16},
		{-6/16,-8/16,-6/16, 6/16, 6/16, 6/16}
	}
}

survivalist.meltable = {}

function survivalist.check_meltable(itemname)
	local output = false
	for _,name in ipairs(survivalist.meltable) do
		if itemname == name[1] then output = name[2] end
	end
	return output
end

minetest.register_node("survivalist:crucible",{
	description = "Crucible",
	tiles = {"default_steel_block.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {crucible.wall_north, crucible.wall_east, crucible.wall_south, crucible.wall_west, crucible.bottom[1]}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack or itemstack:get_count() < 8 then return end
		local meltable = survivalist.check_meltable(itemstack:get_name())
		if meltable ~= false then
			minetest.set_node(pos, {name="survivalist:crucible_"..meltable.."_1"})
			itemstack:take_item(8)
			return itemstack
		end
	end,
	groups = {cracky=1,oddly_breakable_by_hand=1},
})

function survivalist.register_meltable(longname, output, required, imagename)
	local nicename, changes = string.gsub(longname, ":", "_")

	table.insert(survivalist.meltable, {longname, nicename})

	for i=1,3 do
		minetest.register_node("survivalist:crucible_"..nicename.."_"..i,{
			tiles = {"survivalist_crucible_"..imagename.."_"..i..".png", "default_steel_block.png"},
			paramtype = "light",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = {crucible.wall_north, crucible.wall_east, crucible.wall_south, crucible.wall_west, crucible.bottom[i]}
			},
			groups = {cracky=1,oddly_breakable_by_hand=1},
			drop = "survivalist:crucible"
		})
	end

	minetest.register_node("survivalist:crucible_"..nicename.."_4",{
		tiles = {"survivalist_crucible_"..imagename.."_4.png", "default_steel_block.png"},
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {crucible.wall_north, crucible.wall_east, crucible.wall_south, crucible.wall_west, crucible.bottom[4]}
		},
		on_punch = function(pos, node, puncher)
			if required and puncher:get_wielded_item():get_name() == required then
				minetest.set_node(pos, {name="survivalist:crucible"})
				return ItemStack(output)
			end
		end,
		groups = {cracky=1,oddly_breakable_by_hand=1},
		drop = "survivalist:crucible"
	})

	minetest.register_abm({
		nodenames = { "survivalist:crucible_"..nicename.."_1", "survivalist:crucible_"..nicename.."_2", "survivalist:crucible_"..nicename.."_3" },
		interval = 20,
		chance = 1,
		action = function(pos)
			local randomness = 4-minetest.get_item_group(minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name, "hot")
			if randomness > 3 then return end
			if math.random(1,randomness) == randomness then
				local current = minetest.get_node(pos).name
				for i=1,3 do
					if current == "survivalist:crucible_"..nicename.."_"..i then becomes = "survivalist:crucible_"..nicename.."_"..i+1 end
				end
				minetest.set_node(pos, {name=becomes})
			end
		end
	})
end

local lava_input = {
	"default:stone", "default:cobble", "default:desert_stone"
}
for _,name in ipairs(lava_input) do
	survivalist.register_meltable(name, "bucket:bucket_lava", "bucket:bucket_empty", "lava")
end

local water_input = {
	"default:apple", "default:sapling", "default:junglegrass", "poisonivy:sproutling",
	"default:leaves", "survivalist:apple", "survivalist:acorn", "survivalist:oak_sapling",
	"survivalist:apple_leaves", "survivalist:apple_core" , "survivalist:apple_sapling"
}
for _,name in ipairs(water_input) do
	survivalist.register_meltable(name, "bucket:bucket_water", "bucket:bucket_empty", "water")
end

local fuel_input = {
	"default:mese_crystal"
}
for _,name in ipairs(fuel_input) do
	survivalist.register_meltable(name, "crash_site:fuel_bucket", "bucket:bucket_empty", "fuel")
end
