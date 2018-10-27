local DEBUG = true
local VERBOSE = false

dofile(minetest.get_modpath("waste_basket").."/compat.lua")

minetest.register_alias("trash:can", "waste_basket:basket")
minetest.register_alias("trash:block", "waste_basket:basket")
minetest.register_alias("trash_can:trash_can_wooden", "waste_basket:basket")

minetest.register_node("waste_basket:basket",{
	description = "Waste Basket",
	tiles = {"waste_basket_basket_top.png", "waste_basket_basket_top.png", "waste_basket_basket.png"},
	drawtype="nodebox",
	sunlight_propagates = true,
	paramtype = "light",
	node_box = {
		type = "fixed",
        	fixed = {
                	{-0.300000,-0.500000,-0.300000,0.300000,-0.200000,0.300000},
                	{0.300000,-0.200000,-0.350000,0.350000,0.100000,0.350000},
                	{-0.350000,-0.200000,-0.350000,-0.300000,0.100000,0.350000},
                	{-0.300000,-0.200000,0.300000,0.300000,0.100000,0.350000},
                	{-0.300000,-0.200000,-0.350000,0.300000,0.100000,-0.300000},
                	{0.350000,0.100000,-0.400000,0.400000,0.400000,0.400000},
                	{-0.350000,0.100000,-0.400000,-0.400000,0.400000,0.400000},
                	{-0.350000,0.100000,0.400000,0.350000,0.400000,0.350000},
                	{-0.350000,0.100000,-0.400000,0.350000,0.400000,-0.350000},
	        }
	},
	on_rightclick = function(pos,node,clicker,itemstack)
		if not itemstack then
			minetest.chat_send_player(clicker:get_player_name(), "ERROR: This item cannot be thrown away!", false)
			return
		end
		if itemstack:get_name() ~= "" and ( not clicker:get_player_control().sneak ) then
			if DEBUG then
				local player = clicker:get_player_name()
				local trash = itemstack:to_string()
				local basketpos = minetest.pos_to_string(pos)
				print("DEBUG:: WASTE_BASKET: Player '"..player.."' discarded item '"..trash.."' at pos "..basketpos)
				if VERBOSE then
					minetest.chat_send__all("DEBUG:: WASTE_BASKET: Player '"..player.."' discarded item '"..trash.."' at pos "..basketpos)
				end
			end
			itemstack:clear()
			minetest.sound_play("trash", {to_player=clicker, gain = 1.0})
		end
		return itemstack
	end,
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
})

minetest.register_craft({
	output = 'waste_basket:basket',
	recipe = {
		{'default:papyrus', '', 'default:papyrus'},
		{'', 'default:papyrus', ''},
	}
})
