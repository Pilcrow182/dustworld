--[[

  Programmable robot ('hoverbot') mod for Minetest

  Copyright (C) 2018 Pilcrow182

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted, provided that the
  above copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL ISC BE LIABLE FOR ANY
  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
  OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

]]--

hoverbot.mimic_player = function(pos)
	local player = {
		get_armor_groups = function() return end,
		get_breath = function() return end,
		get_eye_offset = function() return {x=0,y=0,z=0} end,
		get_hp = function() return 20 end,
		get_inventory_formspec = function() return end,
		get_inventory = function() return minetest.get_meta(pos):get_inventory() end,
		get_look_dir = function() return {x=0,y=0,z=0} end,
		get_look_pitch = function() return 0 end,
		get_look_vertical = function() return 0 end,
		get_look_yaw = function() return end,
		get_player_control_bits = function() return end,
		get_player_control = function() return {jump=false,right=false,left=false,LMB=false,RMB=false,sneak=false,aux1=false,down=false,up=false} end,
		get_player_name = function() return "hoverbot" end,
		get_pos = function() return pos end,
		getpos = function() return pos end,
		get_properties = function() return {eye_height = pos.y} end,
		get_wielded_item = function() return minetest.get_meta(pos):get_inventory():get_stack("main", tonumber(minetest.get_meta(pos):get_string("inv_slot"))) end,
		get_wield_index = function() return tonumber(minetest.get_meta(pos):get_string("inv_slot")) end,
		get_wield_list = function() return end,
		hud_add = function() return end,
		hud_change = function() return end,
		hud_get_flags = function() return end,
		hud_get = function() return end,
		hud_remove = function() return end,
		hud_replace_builtin = function() return end,
		hud_set_flags = function() return end,
		hud_set_hotbar_image = function() return end,
		hud_set_hotbar_itemcount = function() return end,
		hud_set_hotbar_selected_image = function() return end,
		is_player = function() return true end,
		move_to = function() return end,
		moveto = function() return end,
		override_day_night_ratio = function() return end,
		punch = function() return end,
		remove = function() return end,
		right_click = function() return end,
		set_animation = function() return end,
		set_armor_groups = function() return end,
		set_attach = function() return end,
		set_bone_position = function() return end,
		set_breath = function() return end,
		set_detach = function() return end,
		set_eye_offset = function() return end,
		set_hp = function() return end,
		set_inventory_formspec = function() return end,
		set_local_animation = function() return end,
		set_look_yaw = function() return end,
		set_physics_override = function() return end,
		set_pos = function() return end,
		setpos = function() return end,
		set_properties = function() return end,
		set_sky = function() return end,
		set_wielded_item = function (self, newstack) return minetest.get_meta(pos):get_inventory():set_stack("main", tonumber(minetest.get_meta(pos):get_string("inv_slot")), newstack) end,
	}
	return player
end
