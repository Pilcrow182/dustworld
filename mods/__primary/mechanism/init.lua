mechanism = {}

local trylabels = function(labels,inv)
	for i=1,#labels do
		local invlabel = labels[i]
		local invlist = inv:get_list(invlabel)
		if invlist then return invlabel,invlist end
	end
end

mechanism.check_storage = function(pos, labels_list)
	if not pos then return nil, nil, nil, nil, nil, nil, nil, nil end
	if not labels_list then
		print("ERROR (mechanism:itemduct) -- The check_storage function was not given a labels_list!")
		return nil, nil, nil, nil, nil, nil, nil, nil
	end

	local nname = minetest.get_node(pos).name
	local inv = minetest.get_meta(pos):get_inventory()
	local is_hopper = minetest.get_item_group(nname, "hopper")
	local metastorage = minetest.get_item_group(nname, "metastorage")
	local meta = minetest.get_meta(pos)
	local stored = meta:get_string("stored")
	local amount = tonumber(meta:get_string("amount")) or 0
	local wear = tonumber(meta:get_string("wear")) or 0
	local label, list = trylabels(labels_list, inv)
	return inv, label, list, is_hopper, metastorage, meta, stored, amount, wear
end

mechanism.pushpull = function(src, dst, reverse_order, fuel_output)
	local src_labels_list = {"dst", "main"}
	local dst_labels_list = {"main", "src"}
	if fuel_output then dst_labels_list = {"fuel"} end

	local srcinv, srclabel, srclist, srchopper, srcms, srcmeta, srcitem, srcamount, srcwear = mechanism.check_storage(src, src_labels_list)
	local dstinv, dstlabel, dstlist, dsthopper, dstms, dstmeta, dstitem, dstamount, dstwear = mechanism.check_storage(dst, dst_labels_list)

	if ( srclabel and srcinv:is_empty(srclabel) ) or ( srcms ~= 0 and srcamount == 0 ) then return end

	local srcsize = 0
	if srclabel then
		srcsize = srcinv:get_size(srclabel)
	elseif srcms ~= 0 then
		srcsize = 1
	end

	for i=1,srcsize do
		local j = 1 + srcsize - i		-- obtain the LAST non-empty item
		if not reverse_order then j = i end	-- obtain the FIRST non-empty item

		if dstlabel or dstms ~= 0 then
			local name, count, wear = nil, 0, 0
			if srclabel then
				name, count, wear = srclist[j]:get_name(), srclist[j]:get_count(), srclist[j]:get_wear()
			elseif srcms ~= 0 then
				name, count, wear = srcitem, srcamount, srcwear
			end

			if name ~= nil and name ~= "" then
				local fullstack = minetest.registered_items[name].stack_max
				local c = count + 1
				if count > fullstack then c = fullstack + 1 end
				if dstlabel then
					repeat c = c - 1 until dstinv:room_for_item(dstlabel, {name=name, count=c, wear=wear})
					dstinv:add_item(dstlabel, {name=name, count=c, wear=wear})
				elseif dstms ~= 0 then
					if (dstitem ~= "" and dstitem ~= name) or (dstamount + count > 9999) then return false end
					if dstwear ~= wear and dstitem ~= "" then return false end
					if dstitem == "" then dstitem, dstamount, dstwear = name, 0, wear end
					repeat c = c - 1 until ( dstamount + c <= 9999 )
					if c <= 0 then return false end
					dstmeta:set_string("stored", dstitem)
					dstmeta:set_string("amount", tostring(dstamount+c))
					dstmeta:set_string("wear", dstwear)
					dstmeta:set_string("infotext", dstitem.." "..dstamount+c)
				end

				if srclabel then
					srcinv:set_stack(srclabel, j, {name=name, count=count-c, wear=wear})
				elseif srcms ~= 0 then
					if c < srcamount then
						srcmeta:set_string("amount", tostring(count-c))
						srcmeta:set_string("infotext", name.." "..tostring(count-c))
					else
						srcmeta:set_string("stored", "")
						srcmeta:set_string("amount", "0")
						srcmeta:set_string("wear", "0")
						srcmeta:set_string("infotext", "")
					end
				end
				break
			end
		elseif minetest.registered_nodes[minetest.get_node(dst).name].walkable == false then
			local name, count, wear = nil, 0, 0
			if srclabel then
				name, count, wear = srclist[j]:get_name(), srclist[j]:get_count(), srclist[j]:get_wear()
			elseif srcms ~= 0 then
				name, count, wear = srcitem, srcamount, srcwear
			end

			if name ~= nil and name ~= "" then
				local fullstack = minetest.registered_items[name].stack_max
				local c = count
				if count > fullstack then c = fullstack end
				minetest.add_item(dst, {name=name, count=c, wear=wear})

				if srclabel then
					srcinv:set_stack(srclabel, j, {name=name, count=count-c, wear=wear})
				elseif srcms ~= 0 then
					if c < count then
						srcmeta:set_string("amount", tostring(count-c))
						srcmeta:set_string("infotext", name.." "..tostring(count-c))
					else
						srcmeta:set_string("stored", "")
						srcmeta:set_string("amount", "0")
						srcmeta:set_string("wear", "0")
						srcmeta:set_string("infotext", "")
					end
				end
				break
			end
		end
	end
end

dofile(minetest.get_modpath("mechanism").."/hopper.lua")
dofile(minetest.get_modpath("mechanism").."/ejector.lua")
dofile(minetest.get_modpath("mechanism").."/itemduct.lua")
dofile(minetest.get_modpath("mechanism").."/legacy.lua")
dofile(minetest.get_modpath("mechanism").."/panel.lua")
