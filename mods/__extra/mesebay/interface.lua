mesebay.make_formspec = function (pos)
	if selected then
		sel_label = selected
		pri_label = price
	else
		sel_label = "--"
		pri_label = "--"
		message = "Select an item to get started..."
	end
	if credit then
		cre_label = credit
	else
		cre_label = "--"
	end

	local meta = minetest.env:get_meta(pos)
	local formspec = "size[14,10]"
		formspec = formspec .. "background[-0.19,-0.2;14.38,10.55;mesebay_bg.png]"

		formspec = formspec .. "label[3.0,0.4;Selected:]"
		formspec = formspec .. "label[4.7,0.4;"..sel_label.."]"

		formspec = formspec .. "label[3.0,0.725;Price:]"
		formspec = formspec .. "label[4.7,0.725;"..pri_label.."]"

		formspec = formspec .. "label[3.0,1.05;Your Credits:]"
		formspec = formspec .. "label[4.7,1.05;"..cre_label.."]"

		formspec = formspec .. "label[9.5,0.4;Buy...]"
		formspec = formspec .. "button[10.3,0.3;1,1;buy_one;One]"
		formspec = formspec .. "button[11.3,0.3;1,1;buy_ten;Ten]"
		formspec = formspec .. "button[12.3,0.3;1,1;buy_max;Max]"

		formspec = formspec .. "label[9.5,1.05;Sell...]"
		formspec = formspec .. "button[10.3,0.95;1,1;sell_one;One]"
		formspec = formspec .. "button[11.3,0.95;1,1;sell_ten;Ten]"
		formspec = formspec .. "button[12.3,0.95;1,1;sell_max;Max]"

		local count = 0
		for _,name in ipairs(mesebay.market) do
			local start_x = count + 0.3
			local start_y = 1.8
			while start_x >= 13 do
				start_x = start_x - 13
				start_y = start_y + 1
			end
			formspec = formspec .. "item_image_button["..(start_x)..","..(start_y)..";1,1;"..name[1]..";item"..count..";]"
			count = count + 1
		end
		formspec = formspec .. "label[0,9.77;"..message.."]"
	meta:set_string("formspec", formspec)
end

mesebay.on_receive_fields = function (pos, formname, fields, sender)
	mesebay.load_credit(sender)
	credit = tonumber(mesebay.credit[sender:get_player_name()])
	for i = 0, #mesebay.market do
		if fields["item"..i] then
			selected = mesebay.market[i+1][1]
			price = mesebay.market[i+1][2]
		end
	end

	if fields.quit then
		selected = false
		credit = false
		fields.quit = false
	elseif selected then
		if fields.buy_one then
			mesebay.buy_item(selected, price, sender, credit, 1)
			fields.buy_one = false
		elseif fields.buy_ten then
			mesebay.buy_item(selected, price, sender, credit, 10)
			fields.buy_ten = false
		elseif fields.buy_max then
			mesebay.buy_item(selected, price, sender, credit, 0)
			fields.buy_max = false
		elseif fields.sell_one then
			mesebay.sell_item(selected, price, sender, credit, 1)
			fields.sell_one = false
		elseif fields.sell_ten then
			mesebay.sell_item(selected, price, sender, credit, 10)
			fields.sell_ten = false
		elseif fields.sell_max then
			mesebay.sell_item(selected, price, sender, credit, 0)
			fields.sell_max = false
		else
			message = 'Selected "'..selected..'"'
		end
		mesebay.load_credit(sender)
		credit = tonumber(mesebay.credit[sender:get_player_name()])
	end

	mesebay.make_formspec(pos)
end
