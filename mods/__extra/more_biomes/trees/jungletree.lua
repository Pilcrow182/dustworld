function abstract_trees.add_vine(pos)
  while minetest.env:get_node(pos).name == "air" do
    minetest.env:add_node(pos, {name="trees:vine"})
    pos.y = pos.y-1
  end
end

function abstract_trees.remove_vine(pos)
  local above = minetest.env:get_node({x=pos.x, y=pos.y+1, z=pos.z})
  if string.find(above.name, "vine") ~= nil or above.name == "ignore" then
    return false
  else
    while minetest.env:get_node(pos).name == "trees:vine" do
      minetest.env:add_node(pos, {name="air"})
      pos.y = pos.y-1
    end
  return true
  end
end

local function add_tree_branch(pos)
  local leaves = {"green","yellow","red"}
  local leave = "trees:leaves_"..leaves[math.random(1,3)]
  minetest.env:add_node(pos, {name="default:jungletree"})
  --height

  local height = 2 + math.random(3)

  for y = height , 0, -1 do
    if y <= 0 then return end
    for x = y, -y, -1 do
      for z = y, -y, -1  do
        if math.abs(x)+math.abs(z) <= 4 then
          local p = {x=pos.x+x, y=pos.y+height-1-y, z=pos.z+z}
          local n = minetest.env:get_node(p)
          if (n.name=="air") then
            if math.random(0,10) == 5 then
              minetest.env:add_node(p, {name=leave.."_viney"})
              abstract_trees.add_vine({x=p.x, y=p.y-1, z=p.z})
            else
              minetest.env:add_node(p, {name=leave})
            end
          end
        end
      end
    end
  end
end

abstract_trees.grow_jungletree = function(pos)
  local size =  5+math.random(15)
  if size < 10 then
    for i = size, -2, -1 do
      local p = {x=pos.x, y=pos.y+i, z=pos.z}
      minetest.env:add_node(p, {name="default:jungletree"})
      if i == size then
        add_tree_branch({x=pos.x, y=pos.y+size+math.random(0, 1), z=pos.z})
        add_tree_branch({x=pos.x+1, y=pos.y+i-math.random(2), z=pos.z})
        add_tree_branch({x=pos.x-1, y=pos.y+i-math.random(2), z=pos.z})
        add_tree_branch({x=pos.x, y=pos.y+i-math.random(2), z=pos.z+1})
        add_tree_branch({x=pos.x, y=pos.y+i-math.random(2), z=pos.z-1})
      end
      if i < 0 then
        minetest.env:add_node({x=pos.x+1, y=pos.y+i-math.random(2), z=pos.z}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x, y=pos.y+i-math.random(2), z=pos.z+1}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x-1, y=pos.y+i-math.random(2), z=pos.z}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x, y=pos.y+i-math.random(2), z=pos.z-1}, {name="default:jungletree"})
      end
      if (math.sin(i/size*i) < 0.2 and i > 3 and math.random(0,2) < 1.5) then
        branch_pos = {x=pos.x+math.random(0,1), y=pos.y+i, z=pos.z-math.random(0,1)}
        add_tree_branch(branch_pos)
      end
    end
  else
    for i = size, -5, -1 do
      if i < 0 then
        minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="default:jungletree"})

        minetest.env:add_node({x=pos.x+2, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z-2}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x-1, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
        minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z+1}, {name="default:jungletree"})
      else
        if (math.sin(i/size*i) < 0.2 and i > 3 and math.random(0,2) < 1.5) then
          branch_pos = {x=pos.x-1+math.random(0,2), y=pos.y+i, z=pos.z-1-math.random(0,2)}
          add_tree_branch(branch_pos)
        end
        if i < math.random(2) then
          add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z+1})
          add_tree_branch({x=pos.x+2, y=pos.y+i, z=pos.z-1})
          add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-2})
          add_tree_branch({x=pos.x-1, y=pos.y+i, z=pos.z})
        end
        if i == size then
          add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z+1})
          add_tree_branch({x=pos.x+2, y=pos.y+i, z=pos.z-1})
          add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-2})
          add_tree_branch({x=pos.x-1, y=pos.y+i, z=pos.z})
          add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z+2})
          add_tree_branch({x=pos.x+3, y=pos.y+i, z=pos.z-1})
          add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-3})
          add_tree_branch({x=pos.x-2, y=pos.y+i, z=pos.z})
          add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z})
          add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z-1})
          add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-1})
          add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z})
        else
          minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
          minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
          minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
          minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
        end
      end
    end
  end
end

--nodes
minetest.register_node("trees:vine", {
  description = "Vine",
  walkable = false,
  climbable = true,
  pointable = false,
  diggable = false,
  buildable_to = true,
  air_equivalent = true,
  sunlight_propagates = true,
  paramtype = "light",
  tiles = { "trees_vine.png" },
  drawtype = "plantlike",
  groups = {snappy = 3, flammable=2, not_in_creative_inventory=1},
  sounds =  default.node_sound_leaves_defaults(),
  drop = "",
})

local leaves = {"green","yellow","red"}
for color = 1, 3 do
  local leave_name = "trees:leaves_"..leaves[color]

  minetest.register_node(leave_name, {
    description = "Jungle Tree Leaves",
    drawtype = "allfaces_optional",
    tiles = {"trees_leaves_"..leaves[color]..".png"},
    paramtype = "light",
    use_texture_alpha = false,
    groups = {snappy=3, leafdecay=4, flammable=2, leaves=1},
    drop = {
      max_items = 1,
      items = {
        {
          -- player will get sapling with 1/50 chance
          items = {'trees:jungletree_sapling'},
          rarity = 50,
        },
        {
          -- player will get leaves only if he get no saplings,
          -- this is because max_items is 1
          items = {leave_name},
        }
      }
    },
    sounds = default.node_sound_leaves_defaults(),
  })

  minetest.register_node(leave_name.."_viney", {
    description = "Viney Leaves",
    drawtype = "allfaces_optional",
    tiles = {"trees_leaves_"..leaves[color].."_viney.png"},
    paramtype = "light",
    sunlight_propagates = true,
    use_texture_alpha = false,
    groups = {snappy=3, leafdecay=4, flammable=2, leaves=1},
    after_place_node = function(pos)
      abstract_trees.add_vine({x=pos.x, y=pos.y-1, z=pos.z})
    end,
    drop = {
      max_items = 1,
      items = {
        {
          -- player will get sapling with 1/50 chance
          items = {'trees:jungletree_sapling'},
          rarity = 50,
        },
        {
          -- player will get leaves only if he get no saplings,
          -- this is because max_items is 1
          items = {leave_name.."_viney"},
          rarity = 5,
        }
      }
    },
    sounds = default.node_sound_leaves_defaults(),
  })
  if minetest.get_modpath("survivalist") then
    minetest.override_item(leave_name, {
      drop = {
        max_items = 1,
        items = {
          {
            -- player will get sapling with 1/50 chance
            items = {'trees:jungletree_sapling'},
            rarity = 50,
          },
        }
      },
      on_punch = function(pos, node, puncher)
        if not puncher then return end
        local itemstack = puncher:get_wielded_item()
        local wielded = itemstack:get_name()
        if wielded == "survivalist:shears" then
          minetest.remove_node(pos)
          local drop = "trees:leaves_green_viney"
          if math.random(1,20) == 10 then drop = "trees:sapling_"..name end
          minetest.add_item(pos, drop)
          itemstack:add_wear(65535/297)
          puncher:set_wielded_item(itemstack)
        elseif wielded == "survivalist:crook" then
          minetest.remove_node(pos)
          local drop = "trees:leaves_green_viney"
          if math.random(1,3) >= 2 then drop = "survivalist:silkworm" end
          if math.random(1,5) == 3 then minetest.add_item(pos, drop) end
          itemstack:add_wear(65535/99)
          puncher:set_wielded_item(itemstack)
        elseif wielded == "survivalist:silkworm" then
          minetest.set_node(pos, {name="survivalist:silk_leaves"})
          itemstack:take_item(1)
          puncher:set_wielded_item(itemstack)
        end
      end,
    })
    minetest.override_item(leave_name.."_viney", {
      drop = {
        max_items = 1,
        items = {
          {
            -- player will get sapling with 1/50 chance
            items = {'trees:jungletree_sapling'},
            rarity = 50,
          },
        }
      },
      on_punch = function(pos, node, puncher)
        if not puncher then return end
        local itemstack = puncher:get_wielded_item()
        local wielded = itemstack:get_name()
        if wielded == "survivalist:shears" then
          minetest.remove_node(pos)
          local drop = "trees:leaves_green_viney"
          if math.random(1,20) == 10 then drop = "trees:sapling_"..name end
          minetest.add_item(pos, drop)
          itemstack:add_wear(65535/297)
          puncher:set_wielded_item(itemstack)
        elseif wielded == "survivalist:crook" then
          minetest.remove_node(pos)
          local drop = "trees:leaves_green_viney"
          if math.random(1,3) >= 2 then drop = "survivalist:silkworm" end
          if math.random(1,5) == 3 then minetest.add_item(pos, drop) end
          itemstack:add_wear(65535/99)
          puncher:set_wielded_item(itemstack)
        elseif wielded == "survivalist:silkworm" then
          minetest.set_node(pos, {name="survivalist:silk_leaves"})
          itemstack:take_item(1)
          puncher:set_wielded_item(itemstack)
        end
      end,
    })
  end

end

minetest.register_node("trees:jungletree_sapling", {
  description = "Jungle Tree Sapling",
  drawtype = "plantlike",
  visual_scale = 1.0,
  tiles = {"trees_jungletree_sapling.png"},
  inventory_image = "trees_jungletree_sapling.png",
  wield_image = "trees_jungletree_sapling.png",
  paramtype = "light",
  walkable = false,
  groups = {snappy=2,dig_immediate=3,flammable=2},
})

--leafdecay
default.register_leafdecay({
  trunks = {"default:jungletree"},
  leaves = {"trees:leaves_green", "trees:leaves_yellow", "trees:leaves_red", "trees:leaves_green_viney", "trees:leaves_yellow_viney", "trees:leaves_red_viney"},
  radius = 3,
})

--abm
minetest.register_abm({
  nodenames = {"trees:vine"},
  interval = 2,
  chance = 1,
  action = function(pos)
    if not abstract_trees.remove_vine(pos) then
      abstract_trees.add_vine({x=pos.x, y=pos.y-1, z=pos.z})
    end
  end
})

minetest.register_abm({
  nodenames = {"trees:leaves_green_viney", "trees:leaves_yellow_viney", "trees:leaves_red_viney"},
  interval = 5,
  chance = 1,
  action = function(pos)
    abstract_trees.add_vine({x=pos.x, y=pos.y-1, z=pos.z})
  end
})

minetest.register_abm({
  nodenames = {"trees:jungletree_sapling"},
  interval = 60,
  chance = 20,
  action = function(pos, node)
    abstract_trees.grow_jungletree(pos)
  end,
})

--spawn
plantslib:register_generate_plant({
    surface = "default:dirt_with_grass",
    max_count = 30,
    avoid_nodes = {"group:tree"},
    avoid_radius = 3,
    rarity = 40,
    seed_diff = 112,
    min_elevation = -1,
    max_elevation = 40,
    plantlife_limit = -0.6,
    humidity_max = -0.9,
    humidity_min = 0.4,
    temp_max = -0.9,
    temp_min = -0.3,
  },
  "abstract_trees.grow_jungletree"
)
