ductworks = {}

dofile(minetest.get_modpath("ductworks").."/api.lua")		-- TODO: Process a list of valid storage types inside ductworks.register_duct instead of hard-coding
dofile(minetest.get_modpath("ductworks").."/pipewrench.lua")
dofile(minetest.get_modpath("ductworks").."/hopper.lua")
dofile(minetest.get_modpath("ductworks").."/ejector.lua")
dofile(minetest.get_modpath("ductworks").."/compat.lua")	-- TODO: add ABM to transform mechanism itemducts/fuelducts into ductworks itemducts/fuelducts

ductworks.register_duct("itemduct")
ductworks.register_duct("fuelduct")
ductworks.register_duct("powerduct")
ductworks.register_duct("liquiduct")
ductworks.register_duct("dataduct")

dofile(minetest.get_modpath("ductworks").."/crafts.lua")

