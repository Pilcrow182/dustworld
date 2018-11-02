-- Bow and arrow mod
-- Topic on the forum: http://c55.me/minetest/forum/viewtopic.php?id=687

ARROW_DAMAGE=6
ARROW_GRAVITY=9
ARROW_VELOCITY=19
BOW_USES=99

dofile(minetest.get_modpath("archery").."/legacy.lua")

archery_shoot_arrow=function (itemstack, player, pointed_thing)
	-- Check if arrows in Inventory and remove one of them
	local i=1
	if player:get_inventory():contains_item("main", "archery:arrow") then
		player:get_inventory():remove_item("main", "archery:arrow")
		minetest.sound_play("archery_arrow", {to_player = player:get_player_name(), gain = 10.0})
		-- Shoot Arrow
		local playerpos=player:getpos()
		local dir=player:get_look_dir()
		local obj=minetest.add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+1.5+dir.y,z=playerpos.z+0+dir.z}, "archery:arrow_entity")
		obj:setvelocity({x=dir.x*ARROW_VELOCITY, y=dir.y*ARROW_VELOCITY, z=dir.z*ARROW_VELOCITY})
		obj:setacceleration({x=dir.x*-3, y=-ARROW_GRAVITY, z=dir.z*-3})
		obj:get_luaentity().thrown_by = player
		obj:get_luaentity().thrown_at = player:get_look_dir()
	end
	return true
end

minetest.register_tool("archery:bow", {
	description = "Bow",
	inventory_image = "archery_bow.png",
	on_use = function(itemstack, user, pointed_thing)
		if archery_shoot_arrow(itemstack, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/BOW_USES)
			end
			return itemstack
		end
	end
})

minetest.register_craftitem("archery:arrow", {
	description = "Arrow",
	inventory_image = "archery_arrow.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing and pointed_thing.type == "object" then
			pointed_thing.ref:punch(user, 1.0,  {
				full_punch_interval=1.0,
				damage_groups = {fleshy=ARROW_DAMAGE/3},
			}, user:get_look_dir())
		end
	end
})

-- The Arrow Entity

THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	textures = {"archery_arrow_back.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
	thrown_by = nil,
	thrown_at = nil,
}


-- Arrow_entity.on_step()--> called when arrow is moving
THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	if not self.thrown_by then self.thrown_by = self.object end
	if not self.thrown_at then self.thrown_at = {x=0, y=0, z=0} end
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	local node = minetest.get_node(pos)

	-- When arrow is away from player (after 0.2 seconds): Cause damage to mobs and players
	if self.timer>0.2 then
		local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y-0.5,z=pos.z}, 1.5)
		for k, obj in pairs(objs) do
			if obj:get_entity_name() ~= "archery:arrow_entity" and obj:get_entity_name() ~= "__builtin:item" then
				local s = self.thrown_by:getpos()
				local p = self.thrown_at
				local vec = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z}
				obj:punch(self.thrown_by, 1.0,  {
					full_punch_interval=1.0,
					damage_groups = {fleshy=ARROW_DAMAGE},
				}, vec)
				self.object:remove() 
			end
		end
	end

	-- Become item when hitting a node
	if self.lastpos.x~=nil then --If there is no lastpos for some reason
		if node.name ~= "air" then
			minetest.add_item(self.lastpos, 'archery:arrow')
			self.object:remove()
		end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z} -- Set lastpos-->Item will be added at last pos outside the node
end

minetest.register_entity("archery:arrow_entity", THROWING_ARROW_ENTITY)



--CRAFTS
minetest.register_craft({
	output = 'archery:bow',
	recipe = {
		{'survivalist:silk_string', 'group:wood', ''},
		{'survivalist:silk_string', '', 'group:wood'},
		{'survivalist:silk_string', 'group:wood', ''},
	}
})

minetest.register_craft({
	output = 'archery:bow',
	recipe = {
		{'', 'group:wood', 'survivalist:silk_string'},
		{'group:wood', '', 'survivalist:silk_string'},
		{'', 'group:wood', 'survivalist:silk_string'},
	}
})

minetest.register_craft({
	output = 'archery:arrow',
	recipe = {
		{'group:stick', 'group:stick', 'flint:flintstone'},
	}
})

minetest.register_craft({
	output = 'archery:arrow',
	recipe = {
		{'flint:flintstone', 'group:stick', 'group:stick'},
	}
})

print ("[Throwing_mod] Loaded!")
