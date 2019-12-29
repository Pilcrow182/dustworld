local make_inventory = function(pos, pagenum)
	local meta = minetest.get_meta(pos)

	local page = "size[14,11]".."label[0.4,0.1;Inventory]".."button[2,0;2,1;page1;Configuration]"..
		"list[current_name;src;4.95,2;4,3;]".."list[current_player;main;2,6.5;10,4;]"

	if pagenum == 1 then
		page = "size[14,11]".."button[0,0;2,1;page0;Inventory]".."label[2.15,0.1;Configuration]"

		for x, dir in ipairs({"north", "south", "east", "west", "up", "down"}) do
			page = page..
			"image["..(0.0+(x-1)*2.3)..",1;2.78,11.62;ductworks_ejector_border_"..dir..".png]"..
			"image["..(0.2+(x-1)*2.3)..",1.2;2.25,1;ductworks_config_"..dir..".png]"..
			"button["..(0.2+(x-1)*2.3)..",1.55;2,2.25;type:"..dir..";Items]"

			for y = 1, 8 do
				page = page.."item_image_button["..(0.2+(x-1)*2.3)..","..(y+2)..";1,1;;"..dir.."_"..y..";]"
			end
		end
	end

	meta:set_string("formspec", page)
	meta:get_inventory():set_size("src", 4*3)
end

minetest.register_node("ductworks:ejector", {
	description = "Ejector",
	drawtype = "nodebox",
	tiles = {
		"ductworks_base.png^ductworks_ejector_up.png",
		"ductworks_base.png^ductworks_ejector_down.png",
		"ductworks_base.png^ductworks_ejector_east.png",
		"ductworks_base.png^ductworks_ejector_west.png",
		"ductworks_base.png^ductworks_ejector_north.png",
		"ductworks_base.png^ductworks_ejector_south.png"
	},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-4/16, -4/16, -4/16,  4/16,  4/16,  4/16}, --center
			{-3/16,  4/16, -3/16,  3/16,  6/16,  3/16}, --up1
			{-2/16,  6/16, -2/16,  2/16,  8/16,  2/16}, --up2
			{-3/16, -6/16, -3/16,  3/16, -4/16,  3/16}, --down1
			{-2/16, -8/16, -2/16,  2/16, -6/16,  2/16}, --down2
			{-3/16, -3/16,  4/16,  3/16,  3/16,  6/16}, --north1
			{-2/16, -2/16,  6/16,  2/16,  2/16,  8/16}, --north2
			{-3/16, -3/16, -6/16,  3/16,  3/16, -4/16}, --south1
			{-2/16, -2/16, -8/16,  2/16,  2/16, -6/16}, --south2
			{ 4/16, -3/16, -3/16,  6/16,  3/16,  3/16}, --east1
			{ 6/16, -2/16, -2/16,  8/16,  2/16,  2/16}, --east2
			{-6/16, -3/16, -3/16, -4/16,  3/16,  3/16}, --west1
			{-8/16, -2/16, -2/16, -6/16,  2/16,  2/16}, --west2
		},
	},
	groups = {cracky=2,oddly_breakable_by_hand=1},
	on_construct = function(pos)
		make_inventory(pos, 0)
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		print(dump(fields))
		if fields.page0 then make_inventory(pos, 0) end
		if fields.page1 then make_inventory(pos, 1) end
	end,
})

