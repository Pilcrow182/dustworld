local MC_PICKUP = true       -- pick up items without clicking them like minecraft
local MC_DROP = false        -- make mining/chopping/etc drop items like it does in minecraft
local MC_DEATH = false       -- drop all your items when you die, like minecraft (disable if you have "bones" mod)
local LAVA_BURN = true       -- destroy an item if it touches either flowing lava or a lava source
local LIQUID_FLOW = true     -- push an item in the flowing direction if it is within a liquid such as water
local LIQUID_FLOAT = true    -- make an item float upward when it is within a source and LIQUID_FLOW is enabled
local PICKUP_DISTANCE = 1    -- this determines how far from a player an item can be and still get picked up
local SOUND_VOL = 1          -- volume can be any decimal between 0 and 1

if MC_PICKUP then
	minetest.register_globalstep(function(dtime)
		for _,player in ipairs(minetest.get_connected_players()) do
			if player:get_hp() > 0 or not minetest.setting_getbool("enable_damage") then
				if player:get_look_pitch() > 0 and not player:get_player_control()["sneak"] then return end
				if player:get_look_pitch() <= 0 and player:get_player_control()["sneak"] then return end
				local pos = player:getpos()
				pos.y = pos.y+0.7
				local inv = player:get_inventory()
				
				for _,object in ipairs(minetest.get_objects_inside_radius(pos, PICKUP_DISTANCE)) do
					if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
							if object:get_luaentity().itemstring ~= "" then
								minetest.sound_play("item_drop_pickup", {
									to_player = player:get_player_name(),
									gain = SOUND_VOL,
								})
							end
							object:get_luaentity().itemstring = ""
							object:remove()
						end
					end
				end
				
				for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1.5)) do
					if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
						if object:get_luaentity().collect then
							if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
								local pos1 = pos
								pos1.y = pos1.y+0.2
								local pos2 = object:getpos()
								local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
								vec.x = vec.x*2
								vec.y = vec.y*2
								vec.z = vec.z*2
								object:setvelocity(vec)
								object:get_luaentity().physical_state = false
								object:get_luaentity().flying = false
								object:get_luaentity().object:set_properties({
									physical = false,
									collisionbox = {0,0,0, 0,0,0},
								})
								
								minetest.after(1, function(args)
									local lua = object:get_luaentity()
									if object == nil or lua == nil or lua.itemstring == nil then
										return
									end
									if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
										inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
										if object:get_luaentity().itemstring ~= "" then
											minetest.sound_play("item_drop_pickup", {
												to_player = player:get_player_name(),
												gain = SOUND_VOL,
											})
										end
										object:get_luaentity().itemstring = ""
										object:remove()
									else
										object:setvelocity({x=0,y=0,z=0})
										object:get_luaentity().physical_state = true
										object:get_luaentity().object:set_properties({
											physical = true,
											collisionbox = {-0.17,-0.17,-0.17, 0.17,0.17,0.17},
										})
									end
								end, {player, object})
								
							end
						end
					end
				end
			end
		end
	end)
	
	minetest.register_entity(":__builtin:item", {
		initial_properties = {
			hp_max = 1,
			physical = true,
			collisionbox = {-0.17,-0.17,-0.17, 0.17,0.17,0.17},
			visual = "sprite",
			visual_size = {x=0.5, y=0.5},
			textures = {""},
			spritediv = {x=1, y=1},
			initial_sprite_basepos = {x=0, y=0},
			collide_with_objects = false,
			is_visible = false,
		},
		
		itemstring = '',
		physical_state = true,
		flying = false,
		flowing = false,
		flowdir = nil,
		time = 0,
	
		set_item = function(self, itemstring)
			self.itemstring = itemstring
			local stack = ItemStack(itemstring)
			local itemtable = stack:to_table()
			local itemname = nil
			if itemtable then
				itemname = stack:to_table().name
			end
			local item_texture = nil
			local item_type = ""
			if minetest.registered_items[itemname] then
				item_texture = minetest.registered_items[itemname].inventory_image
				item_type = minetest.registered_items[itemname].type
			end
			prop = {
				is_visible = true,
				visual = "wielditem",
				textures = {itemname},
				visual_size = {x=0.20, y=0.20},
				automatic_rotate = math.pi * 0.25,
			}
			self.object:set_properties(prop)
		end,
	
		get_staticdata = function(self)
			--return self.itemstring
			return minetest.serialize({
				itemstring = self.itemstring,
				always_collect = self.always_collect,
				time = self.time,
				collect = self.collect,
			})
		end,
	
		on_activate = function(self, staticdata, dtime_s)
			if string.sub(staticdata, 1, string.len("return")) == "return" then
				local data = minetest.deserialize(staticdata)
				if data and type(data) == "table" then
					self.itemstring = data.itemstring
					self.always_collect = data.always_collect
					self.collect = data.collect
					if data.time then
						self.time = data.time + dtime_s
					end
				end
			else
				self.itemstring = staticdata
			end
			self.object:set_armor_groups({immortal=1})
			self.object:setvelocity({x=0, y=2, z=0})
			self.object:setacceleration({x=0, y=-10, z=0})
			self:set_item(self.itemstring)
		end,
	
		on_step = function(self, dtime)
			if self.flying then
				return
			end
			self.time = self.time + dtime
			if self.time > 300 then
				self.object:remove()
				return
			end
			local p = self.object:getpos()
			if minetest.get_item_group(minetest.get_node(p).name, "lava") ~= 0 then
				self.object:remove()
			end
			p.y = p.y - 0.3
			local nn = minetest.get_node(p).name
			-- If node is not registered or node is walkably solid and resting on nodebox
			local v = self.object:getvelocity()
			if not minetest.registered_nodes[nn] or minetest.registered_nodes[nn].walkable and v.y == 0 then
				if self.physical_state then
					self.object:setvelocity({x=0,y=0,z=0})
					self.object:setacceleration({x=0, y=0, z=0})
					self.physical_state = false
					self.object:set_properties({
						physical = false,
						collisionbox = {0,0,0, 0,0,0},
					})
				end
			else
				if not self.physical_state then
					self.object:setvelocity({x=0,y=0,z=0})
					self.object:setacceleration({x=0, y=-10, z=0})
					self.physical_state = true
					self.object:set_properties({
						physical = true,
						collisionbox = {-0.17,-0.17,-0.17, 0.17,0.17,0.17},
					})
				end
			end
			if LAVA_BURN then
				if nn == "default:lava_flowing" or nn == "default:lava_source" then
					minetest.sound_play("builtin_item_lava", {pos=self.object:getpos()})
					self.object:remove()
					return
				end
			end
			if LIQUID_FLOW then -- TODO: the LIQUID_FLOW code really needs a full rewrite. it works, but it's very hacky...
				local roundh = function(pos)
					pos.x = tonumber(string.format("%.0f", pos.x))
					pos.z = tonumber(string.format("%.0f", pos.z))
					return pos
				end

				local pos = self.object:getpos()
				local param2 = minetest.get_node(pos).param2
				local pn = minetest.get_node(pos).name
				local liquidtype = minetest.registered_nodes[pn].liquidtype

				if liquidtype then
					if LIQUID_FLOAT and liquidtype == "source" then
						local v = self.object:getvelocity()
						self.object:setvelocity({x = v.x / 1.04, y = math.min(v.y + 1, 2), z = v.z / 1.04})
					elseif liquidtype == "flowing" then
						get_flowing_dir = function(self)
							if self.flowdir ~= nil then
								local dp = {x=pos.x+self.flowdir[1], y=pos.y, z=pos.z+self.flowdir[2]}
								local dn = minetest.get_node(dp).name
								if not minetest.registered_nodes[dn].walkable then return dp end
							end
							for i,d in ipairs({-1, 1, -1, 1}) do
								if i<3 then pos.x = pos.x+d else pos.z = pos.z+d end
	
								local dn = minetest.get_node(pos).name
								local par2 = minetest.get_node(pos).param2
								if param2 < 9 and dn == "default:water_flowing" and par2 < param2 then
									return pos
								end

								if i<3 then pos.x = pos.x-d else pos.z = pos.z-d end
							end
							for i,d in ipairs({-1, 1, -1, 1}) do
								if i<3 then pos.x = pos.x+d else pos.z = pos.z+d end

								local dn = minetest.get_node(pos).name
								local par2 = minetest.get_node(pos).param2
								if param2 < 9 and dn == "default:water_flowing" and par2 >= 9 then
									return pos
								end

								if i<3 then pos.x = pos.x-d else pos.z = pos.z-d end
							end
							for i,d in ipairs({-1, 1, -1, 1}) do
								if i<3 then pos.x = pos.x+d else pos.z = pos.z+d end

								local dn = minetest.get_node(pos).name
								local par2 = minetest.get_node(pos).param2
								if dn == "air" then
									return pos
								end

								if i<3 then pos.x = pos.x-d else pos.z = pos.z-d end
							end
						end

						local vec = get_flowing_dir(self)
						if vec then
							self.flowing = true
							self.flowdir = {vec.x-p.x, vec.z-p.z}
							local newpos = {x=p.x+((vec.x-p.x)/20), y=vec.y, z=p.z+((vec.z-p.z)/20)}
							if param2 == 15 then newpos = roundh(pos) end
							self.object:moveto(newpos)
							return
						end
					elseif self.flowing == true then
						self.object:moveto(roundh(pos))
						self.flowing = false
						self.flowdir = nil
					end
				end
			end
		end,
	})
end

if MC_DROP then
	function minetest.handle_node_drops(pos, drops, digger)
		local inv
		if minetest.setting_getbool("creative_mode") and digger and digger:is_player() then
			inv = digger:get_inventory()
		end
		for _,item in ipairs(drops) do
			local count, name
			if type(item) == "string" then
				name, count = item:match("^([a-zA-Z0-9_:]*) ([0-9]*)$")
				if not name then
					name = item
				end
				if not count then
					count = 1
				end
			else
				count = item:get_count()
				name = item:get_name()
			end
			if not inv or not inv:contains_item("main", ItemStack(name)) then
				for i=1,count do
					local obj = minetest.add_item(pos, name)
					if obj ~= nil then
						obj:get_luaentity().collect = true
						local x = math.random(1, 5)
						if math.random(1,2) == 1 then
							x = -x
						end
						local z = math.random(1, 5)
						if math.random(1,2) == 1 then
							z = -z
						end
						obj:setvelocity({x=1/x, y=obj:getvelocity().y, z=1/z})
					end
				end
			end
		end
	end
end

if MC_DEATH then
	minetest.register_on_dieplayer(function(player)
		if minetest.setting_getbool("creative_mode") then
			return
		end
		local inv = player:get_inventory()
		local pos = player:getpos()
		for _,list in ipairs({"main", "craft"}) do
			for i,stack in ipairs(inv:get_list(list)) do
				local x = math.random(0, 9)/3 - 1.5
				local z = math.random(0, 9)/3 - 1.5
				pos.x = pos.x + x
				pos.z = pos.z + z
				local obj = minetest.add_item(pos, stack)
				if obj then
					obj:get_luaentity().collect = true
				end
				stack:clear()
				inv:set_stack(list, i, stack)
				pos.x = pos.x - x
				pos.z = pos.z - z
			end
		end
	end)
end
