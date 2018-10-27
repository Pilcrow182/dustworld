doors.register("more_doors:door_glass", {
	tiles = {"more_doors_door_glass.png"},
	description = "Glass Door",
	inventory_image = "more_doors_item_glass.png",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	recipe = {
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
		{"default:glass", "default:glass"},
	},
})

doors.register("more_doors:door_obsidian_glass", {
	tiles = {"more_doors_door_obsidian_glass.png"},
	description = "Obsidian Glass Door",
	inventory_image = "more_doors_item_obsidian_glass.png",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	recipe = {
		{"default:obsidian_glass", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:obsidian_glass"},
		{"default:obsidian_glass", "default:obsidian_glass"},
	},
})

doors.register("more_doors:door_stone", {
	tiles = {"more_doors_door_stone.png"},
	description = "Stone Door",
	inventory_image = "more_doors_item_stone.png",
	groups = {cracky=3,oddly_breakable_by_hand=2},
	recipe = {
		{"default:stone", "default:stone"},
		{"default:stone", "default:stone"},
		{"default:stone", "default:stone"},
	},
})

doors.register("more_doors:door_desert_stone", {
	tiles = {"more_doors_door_desert_stone.png"},
	description = "Desert Stone Door",
	inventory_image = "more_doors_item_desert_stone.png",
	groups = {cracky=3,oddly_breakable_by_hand=2},
	recipe = {
		{"default:desert_stone", "default:desert_stone"},
		{"default:desert_stone", "default:desert_stone"},
		{"default:desert_stone", "default:desert_stone"},
	},
})

doors.register("more_doors:door_obsidian", {
	tiles = {"more_doors_door_obsidian.png"},
	description = "Obsidian Door",
	inventory_image = "more_doors_item_obsidian.png",
	groups = {cracky=3,oddly_breakable_by_hand=2},
	recipe = {
		{"default:obsidian", "default:obsidian"},
		{"default:obsidian", "default:obsidian"},
		{"default:obsidian", "default:obsidian"},
	},
})
