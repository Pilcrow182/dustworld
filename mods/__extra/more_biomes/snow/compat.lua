minetest.register_alias("snow:sapling_pine", "snow:sapling_evergreen")

if minetest.get_modpath("survivalist") then
	for _,leaves in pairs({"snow:needles", "snow:needles_decorated"}) do
		minetest.override_item(leaves, {
			drop = {
				max_items = 1,
				items = {
					{
						-- player will get xmas tree with 1/20 chance
						items = {"snow:xmas_tree"},
						rarity = 30,
					},
					{
						-- player will get sapling with 1/20 chance
						items = {"snow:sapling_evergreen"},
						rarity = 10,
					},
				}
			},
			on_punch = function(pos, node, puncher)
				if not puncher then return end
				local itemstack = puncher:get_wielded_item()
				local wielded = itemstack:get_name()
				if wielded == "survivalist:shears" then
					minetest.remove_node(pos)
					local drop = leaves
					if math.random(1,10) == 5 then
						if math.random(1,40) <= 10 then 
							drop = "snow:xmas_tree"
						else
							drop = "snow:sapling_evergreen"
						end
					end
					minetest.add_item(pos, drop)
					itemstack:add_wear(65535/297)
					puncher:set_wielded_item(itemstack)
				elseif wielded == "survivalist:crook" then
					minetest.remove_node(pos)
					local drop = leaves
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

