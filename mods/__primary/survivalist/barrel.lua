local barrel = {
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

survivalist.compostable = {}

function survivalist.check_compostable(itemname)
	local output = false
	for _,name in ipairs(survivalist.compostable) do
		if itemname == name[1] then output = name[2] end
	end
	return output
end

minetest.register_node("survivalist:barrel",{
	description = "Compost Barrel",
	tiles = {"survivalist_barrel.png"},
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {barrel.wall_north, barrel.wall_east, barrel.wall_south, barrel.wall_west, barrel.bottom[1]}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack or itemstack:get_count() < 8 then return end
		local compostable = survivalist.check_compostable(itemstack:get_name())
		if compostable ~= false then
			minetest.set_node(pos, {name="survivalist:barrel_"..compostable.."_1"})
			itemstack:take_item(8)
			return itemstack
		end
	end,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

function survivalist.register_compostable(longname, output, imagename)
	local nicename, changes = string.gsub(longname, ":", "_")

	table.insert(survivalist.compostable, {longname, nicename})

	for i=1,3 do
		minetest.register_node("survivalist:barrel_"..nicename.."_"..i,{
			tiles = {"survivalist_barrel_"..imagename.."_"..i..".png", "survivalist_barrel.png"},
			paramtype = "light",
			drawtype = "nodebox",
			node_box = {
				type = "fixed",
				fixed = { barrel.wall_north, barrel.wall_east, barrel.wall_south, barrel.wall_west, barrel.bottom[i] }
			},
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
			drop = "survivalist:barrel"
		})
	end

	minetest.register_node("survivalist:barrel_"..nicename.."_4",{
			tiles = {"survivalist_barrel_"..imagename.."_4.png", "survivalist_barrel.png"},
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = { barrel.wall_north, barrel.wall_east, barrel.wall_south, barrel.wall_west, barrel.bottom[4] }
		},
		on_dig = function(pos, node, digger)
			minetest.node_dig(pos, node, digger)
			minetest.set_node(pos, {name="survivalist:barrel"})
		end,
		groups = {dig_immediate=3,flammable=2},
		drop = "default:dirt"
	})
	
	minetest.register_abm({
		nodenames = { "survivalist:barrel_"..nicename.."_1", "survivalist:barrel_"..nicename.."_2", "survivalist:barrel_"..nicename.."_3" },
		interval = 20,
		chance = 1,
		action = function(pos)
			local current = minetest.get_node(pos).name
			for i=1,3 do
				if current == "survivalist:barrel_"..nicename.."_"..i then becomes = "survivalist:barrel_"..nicename.."_"..i+1 end
			end
			minetest.set_node(pos, {name=becomes})
		end
	})
end

local dirt_input = {
	"default:apple", "default:sapling", "default:junglegrass", "poisonivy:sproutling",
	"default:leaves","survivalist:apple",  "survivalist:acorn", "survivalist:oak_sapling",
	"survivalist:apple_leaves", "survivalist:apple_core" , "survivalist:apple_sapling",

	"default:acacia_bush_leaves", "default:acacia_leaves", "default:aspen_leaves",
	"default:bush_leaves", "default:jungleleaves", "default:pine_bush_needles",
	"default:pine_needles", "farming_plus:banana_leaves", "farming_plus:cocoa_leaves",
	"flolife:leaves", "trees:leaves_birch", "trees:leaves_conifer",
	"trees:leaves_green", "trees:leaves_green_viney", "trees:leaves_mangrove",
	"trees:leaves_palm", "trees:leaves_red", "trees:leaves_red_viney",
	"trees:leaves_yellow", "trees:leaves_yellow_viney"
}
for _,name in ipairs(dirt_input) do
	survivalist.register_compostable(name, "default:dirt", "dirt")
end
