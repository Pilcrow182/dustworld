-------------------------------------------------------------------------------
-- Based on pushable block Mod by Sapier
-- 
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice. 
-- And of course you are NOT allow to pretend you have written it.
--
--! @file data_storage.lua
--! @brief generic functions used in many different places
--! @copyright Sapier
--! @author Sapier
--! @date 2013-02-04
--!
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- name: carts_get_current_time()
--
--! @brief alias to get current time
--
--! @return current time in seconds
-------------------------------------------------------------------------------
function carts_get_current_time()
	return os.time(os.date('*t'))
	--return minetest.get_time()
end
-------------------------------------------------------------------------------
-- name: carts_global_data_store(value)
--
--! @brief save data and return unique identifier
--
--! @param value to save
--
--! @return unique identifier
-------------------------------------------------------------------------------
carts_global_data_identifier = 0
carts_global_data = {}
carts_global_data.cleanup_index = 0
carts_global_data.last_cleanup = carts_get_current_time()
function carts_global_data_store(value)

	local current_id = carts_global_data_identifier
	
	carts_global_data_identifier = carts_global_data_identifier + 1
	
	carts_global_data[current_id] = {
									value = value,
									added = carts_get_current_time(),
									}
	return current_id
end


-------------------------------------------------------------------------------
-- name: carts_global_data_store(value)
--
--! @brief pop data from global store
--
--! @param id to pop
--
--! @return stored value
-------------------------------------------------------------------------------
function carts_global_data_get(id)

	local dataid = tonumber(id)

	if dataid == nil or 
		carts_global_data[dataid] == nil then
		return nil
	end

	local retval = carts_global_data[dataid].value
	carts_global_data[dataid] = nil
	return retval
end

-------------------------------------------------------------------------------
-- name: carts_global_data_store(value)
--
--! @brief pop data from global store
--
--! @param id to pop
--
--! @return stored value
-------------------------------------------------------------------------------
function carts_global_data_cleanup(id)

	if carts_global_data.last_cleanup + 500 < 
											carts_get_current_time() then

		for i=1,50,1 do
			if carts_global_data[carts_global_data.cleanup_index] ~= nil then
				if carts_global_data[carts_global_data.cleanup_index].added < 
						carts_get_current_time() - 300 then
						
					carts_global_data[carts_global_data.cleanup_index] = nil
				end
				carts_global_data.cleanup_index = carts_global_data.cleanup_index +1
				
				if carts_global_data.cleanup_index > #carts_global_data then
					carts_global_data.cleanup_index = 0
					break
				end
			end
		end
		
		carts_global_data.last_cleanup = carts_get_current_time()
	end
end
