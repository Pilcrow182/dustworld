sfinv.override_page("sfinv:crafting", {
	title = "Crafting",
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				list[current_player;craft;3.5,0;3,3;]
				image[6.5,1;1,1;gui_furnace_arrow_bg.png^[transformR270]
				list[current_player;craftpreview;7.5,1;1,1;]
				list[current_player;main;0,3.5;10,4;]
				listring[current_player;main]
				listring[current_player;craft]
			]], false, "size[10,7.5]")
	end
})

minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_size("main", 10*4)
	player:hud_set_hotbar_itemcount(10)
end)

function sfinv.get_homepage_name(player)
	return "sfinv:crafting"
end
