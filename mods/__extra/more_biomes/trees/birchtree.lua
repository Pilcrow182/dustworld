local function add_tree_branch(pos, dir)
	minetest.env:set_node(pos, {name="trees:tree_birch_horizontal", param2=dir})
	for i = math.random(2), -math.random(2), -1 do
		for k = math.random(2), -math.random(2), -1 do
			local p = {x=pos.x+i, y=pos.y, z=pos.z+k}
			local n = minetest.env:get_node(p)
			if (n.name=="air") then
				minetest.env:add_node(p, {name="trees:leaves_birch"})
			end
			local chance = math.abs(i+k)
			if (chance < 1) then
				p = {x=pos.x+i, y=pos.y+1, z=pos.z+k}
				n = minetest.env:get_node(p)
				if (n.name=="air") then
					minetest.env:add_node(p, {name="trees:leaves_birch"})
				end
			end
		end
	end
end

abstract_trees.grow_birchtree = function(pos)
	minetest.env:add_node(pos, {name="trees:tree_birch_mossy"})
	local height = 4 + math.random(2)
	for i = height, 1, -1 do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
		minetest.env:add_node(p, {name="trees:tree_birch"})
		if (math.sin(i/height*i) < 0.2 and i > 3 and math.random(0,2) < 1.5) then
			branch_pos = {x=pos.x+math.random(0,1), y=pos.y+i, z=pos.z-math.random(0,1)}
			add_tree_branch(branch_pos, math.random(1,2))
		end
	end
	add_tree_branch({x=pos.x, y=pos.y+height+math.random(0, 1),z=pos.z}, math.random(1,2))
	add_tree_branch({x=pos.x+1, y=pos.y+height-math.random(2), z=pos.z,}, 1)
	add_tree_branch({x=pos.x-1, y=pos.y+height-math.random(2), z=pos.z}, 1)
	add_tree_branch({x=pos.x, y=pos.y+height-math.random(2), z=pos.z+1}, 2)
	add_tree_branch({x=pos.x, y=pos.y+height-math.random(2), z=pos.z-1}, 2)
end

local function tree_crafts(input)
	local hori = input.."_horizontal"
	local moss = input.."_mossy"

	minetest.register_craft({
		output = 'trees:wood_birch 4',
		recipe = {{hori},}
	})

	minetest.register_craft({
		output = 'trees:wood_birch 4',
		recipe = {{moss},}
	})

	minetest.register_craft({
		output = hori.." 2",
		recipe = {{input, input},}
	})

	minetest.register_craft({
		output = input.." 2",
		recipe = {{hori},
				  {hori}}
	})
end

tree_crafts("trees:tree_birch")

minetest.register_node("trees:tree_birch_mossy", {
	description = "Mossy Birch Tree",
	tiles = {"trees_tree_top_birch.png", "trees_tree_top_birch.png", "trees_tree_birch_mossy.png"},
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("trees:tree_birch_horizontal", {
	description = "Horizontal Birch Trunk",
	tiles = {"trees_tree_birch.png", "trees_tree_birch.png", "trees_tree_birch.png^[transformR90", --transform is useful
		"trees_tree_birch.png^[transformR90", "trees_tree_top_birch.png", "trees_tree_top_birch.png"},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_abm({
	nodenames = {"trees:sapling_birch"},
	interval = 10,
	chance = 16,
	action = function(pos)
		if minetest.env:get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name == "air" then
			abstract_trees.grow_birchtree({x = pos.x, y = pos.y, z = pos.z})
		end
	end
,})

--spawn
plantslib:register_generate_plant({
    surface = "default:dirt_with_grass",
    max_count = 10,
    avoid_nodes = {"group:tree"},
    avoid_radius = 3,
    rarity = 50,
    seed_diff = 112,
    min_elevation = -1,
    max_elevation = 40,
    plantlife_limit = -0.6,
    humidity_max = -0.9,
    humidity_min = 0.4,
    temp_max = -0.9,
    temp_min = -0.3,
  },
  "abstract_trees.grow_birchtree"
)

default.register_leafdecay({
	trunks = {"trees:tree_birch", "trees:tree_birch_mossy", "trees:tree_birch_horizontal"},
	leaves = {"trees:leaves_birch"},
	radius = 4,
})
