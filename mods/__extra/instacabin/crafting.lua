local upgrades = {
	{"shack", "house", "default:clay_brick"},
	{"house", "large_house", "default:clay_brick"},
	{"large_house", "mansion", "default:diamond"},

	{"shack", "tower", "default:cobble"},
	{"tower", "large_tower", "default:cobble"},
	{"large_tower", "apartment", "concrete:concrete"},

	{"shack", "warehouse", "group:wood"},
	{"warehouse", "large_warehouse", "group:wood"},
	{"large_warehouse", "vault", "default:steelblock"},

	{"garden", "large_garden", "default:dirt"},
	{"large_garden", "greenhouse", "group:wood"},
}

for i in ipairs(upgrades) do
	local input = upgrades[i][1]
	local output = upgrades[i][2]
	local material = upgrades[i][3]

	minetest.register_craft({
		output = "instacabin:"..output,
		recipe = {
			{material, material,             material},
			{material, "instacabin:"..input, material},
			{material, material,             material},
		}
	})
end

