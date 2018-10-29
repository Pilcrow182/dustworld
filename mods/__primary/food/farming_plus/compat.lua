if minetest.get_modpath("survivalist") then
	for _,name in pairs({"banana", "cocoa"}) do
		minetest.override_item("farming_plus:"..name.."_leaves", {
			drop = {
				max_items = 1,
				items = {
					{
						-- player will get sapling with 1/20 chance
						items = {"farming_plus:"..name.."_sapling"},
						rarity = 20,
					}
				}
			},
			on_punch = function(pos, node, puncher)
				if not puncher then return end
				local itemstack = puncher:get_wielded_item()
				local wielded = itemstack:get_name()
				if wielded == "survivalist:shears" then
					minetest.remove_node(pos)
					local drop = "farming_plus:"..name.."_leaves"
					if math.random(1,20) == 10 then drop = "farming_plus:"..name.."_sapling" end
					minetest.add_item(pos, drop)
					itemstack:add_wear(65535/297)
					puncher:set_wielded_item(itemstack)
				elseif wielded == "survivalist:crook" then
					minetest.remove_node(pos)
					local drop = "farming_plus:"..name.."_leaves"
					if math.random(1,3) >= 2 then drop = "survivalist:silkworm" end
					if math.random(1,5) == 3 then minetest.add_item(pos, drop) end
					itemstack:add_wear(65535/99)
					puncher:set_wielded_item(itemstack)
				elseif wielded == "survivalist:silkworm" then
					minetest.set_node(pos, {name="survivalist:silk_leaves"})
					itemstack:take_item(1)
					puncher:set_wielded_item(itemstack)
				end
			end
		})
	end
end
