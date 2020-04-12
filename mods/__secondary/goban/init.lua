local image = {}
for _,color in pairs({"empty", "black", "white", "red"}) do image[color] = {} end

for y = 1, 19 do for x = 1, 19 do
	local xc, img = string.char(x+64), "goban_board_empty.png"

	local rot = (x == 1 and y < 19 and 0) or (x < 19 and y == 19 and 90) or (x == 19 and y > 1 and 180) or (x > 1 and y == 1 and 270)
	if (x == 1 or x == 19) and (y == 1 or y == 19) then img = img.."^goban_corner_r"..rot..".png"
	elseif x == 1 or x == 19 or y == 1 or y == 19 then img = img.."^goban_side_r"..rot..".png"
	else img = img.."^goban_middle.png" end

	for _,hy in pairs({4, 10, 16}) do for _,hx in pairs({"D", "J", "P"}) do
		if xc..y == hx..hy then img = img.."^goban_handicap.png" break end
	end end
	image.empty[xc..y] = img

	for _,color in pairs({"black", "white", "red"}) do image[color][xc..y] = img.."^goban_stone_"..color..".png" end
end end

for y = 1, 19 do for x = 1, 19 do
	local xc = string.char(x+64)
	for _,color in pairs({"empty", "black", "white", "red"}) do
		minetest.register_craftitem("goban:"..color.."_"..xc..y,{
			description = xc..y,
			inventory_image = image[color][xc..y],
			groups = {not_in_creative_inventory=1}
		})
	end
end end

local get_count = function(color, state)
	local count = 0
	for point,contents in pairs(state) do
		if contents == color then count = count + 1 end
	end
	return count
end

local render_board = function(pos)
	local meta = minetest.get_meta(pos)
	local state = minetest.deserialize(meta:get_string("state"))

	local interface = "size[11,9.5] background[0,0;9.5,9.5;goban_board_blank.png]"
	interface = interface.."button[9.6,-0.2;1.5,1;reset;Reset]"
	interface = interface.."image_button[9.6,2.75;1,1;goban_stone_black.png;black;]"
	interface = interface.."label[10.5,2.95;"..get_count("black", state).."]"
	interface = interface.."image_button[9.6,4.25;1,1;goban_stone_white.png;white;]"
	interface = interface.."label[10.5,4.45;"..get_count("white", state).."]"
	interface = interface.."image_button[9.6,5.75;1,1;goban_stone_red.png;red;]"
	interface = interface.."label[10.5,5.95;"..get_count("red", state).."]"
	interface = interface.."label[-0.1,9.45;"..meta:get_string("infotext").."]"

	for y = 1, 19 do for x = 1, 19 do
		local xc = string.char(x+64)
		interface = interface.."item_image_button["..((y/2)-0.60)..","..((x/2)-0.55)..";0.72,0.65;goban:"..state[xc..y].."_"..xc..y..";"..xc..y..";]"
	end end

	meta:set_string("formspec", interface)
end

local reset_board = function(pos)
	local state = {}
	for y = 1, 19 do for x = 1, 19 do
		local xc = string.char(x+64)
		state[xc..y] = "empty"
	end end

	local meta = minetest.get_meta(pos)
	meta:set_string("state", minetest.serialize(state))
	meta:set_string("infotext", "Please place a black piece to get started.")

	render_board(pos)
end

local get_button = function(fields) for k,v in pairs(fields) do return k end end

local process_input = function(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	local state = minetest.deserialize(meta:get_string("state"))
	local selected = minetest.deserialize(meta:get_string("selected")) or {}
	local name = sender:get_player_name()

	for _,color in pairs({"black", "white", "red"}) do
		if fields[color] then
			if selected[name] == color then
				meta:set_string("infotext", "Player "..name.." deselected color "..color..".")
				selected[name] = nil
			else
				meta:set_string("infotext", "Player "..name.." selected color "..color..".")
				selected[name] = color
			end
			meta:set_string("selected", minetest.serialize(selected))
			return render_board(pos)
		end
	end

	if fields.reset then
		return reset_board(pos)
	elseif selected[name] and not fields.quit then
		local clicked = get_button(fields)
		local action = (state[clicked] == "empty" and "placed") or "removed"
		local color = (action == "placed" and selected[name]) or state[clicked]
		state[clicked] = (action == "placed" and selected[name]) or "empty"
		meta:set_string("state", minetest.serialize(state))
		meta:set_string("infotext", "Player "..name.." "..action.." a "..color.." stone at "..clicked..".")

		return render_board(pos)
	end
end

minetest.register_node("goban:board", {
	description = "Go Board",
	tiles = {"goban_face.png"},
	drawtype = "nodebox",
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-7/16, -8/16, -7/16, 7/16, -7/16, 7/16}
		}
	},
	groups = {choppy=2, dig_immediate=2},
	on_construct = reset_board,
	on_receive_fields = process_input,
	sounds = (default and default.node_sound_wood_defaults())
})

local slabs = {
	"flolife:slab_floatoak",
	"stairs:slab_acacia_wood",
	"stairs:slab_aspen_wood",
	"stairs:slab_birch",
	"stairs:slab_conifer",
	"stairs:slab_hardwood",
	"stairs:slab_junglewood",
	"stairs:slab_mangrove",
	"stairs:slab_palm",
	"stairs:slab_pine_wood",
	"stairs:slab_wood"
}

for _,slab in pairs(slabs) do
	minetest.register_craft( {
		type = "shapeless",
		output = "goban:board",
		recipe = {"goban:gravel_black", slab, "goban:gravel_white"},
	})
end

minetest.register_node("goban:gravel_black", {
	description = "Black Gravel",
	tiles = {"goban_gravel_black.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default and default.node_sound_gravel_defaults()
})

minetest.register_craft( {
	type = "shapeless",
	output = "goban:gravel_black",
	recipe = {"default:gravel", "dye:black"},
})

minetest.register_node("goban:gravel_white", {
	description = "White Gravel",
	tiles = {"goban_gravel_white.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default and default.node_sound_gravel_defaults()
})

minetest.register_craft( {
	type = "shapeless",
	output = "goban:gravel_white",
	recipe = {"default:gravel", "dye:white"},
})

