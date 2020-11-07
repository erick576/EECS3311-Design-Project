note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SPECIAL
inherit
	ETF_SPECIAL_INTERFACE
create
	make
feature -- command
	special
    	do
			-- perform some update on the model state

			if not model.app.current_state.in_game then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.special_error_1)
--			elseif  then  -- TODO IF ENOUGH RESOURCES

			else
				-- Reset Error Count and Increment Valid Operation Count
				model.game_info.set_error_count (0)
				model.game_info.set_valid_operation_count (model.game_info.valid_operation_count + 1)

				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)
--				model.game_info.set_operation_message ("")

				-- Perform Special
				model.starfighter.regenerate
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
