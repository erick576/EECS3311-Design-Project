note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_TOGGLE_DEBUG_MODE
inherit
	ETF_TOGGLE_DEBUG_MODE_INTERFACE
create
	make
feature -- command
	toggle_debug_mode
    	do
			-- perform some update on the model state

			-- Switch To Debug Mode
			if model.game_info.in_normal_mode = false then
				-- Increment Error Count (For Some Reason Error Count Is incremented when this is invoked)
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)

				model.game_info.set_operation_message (model.game_info.not_in_debug_mode_message)

				model.game_info.set_in_normal_mode (true)
				model.game_info.set_mode_mesage (model.game_info.normal_mode)
			else
				-- Increment Error Count (For Some Reason Error Count Is incremented when this is invoked)
				model.game_info.set_error_count (model.game_info.error_count + 1)
	
				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)

				model.game_info.set_operation_message (model.game_info.in_debug_mode_message)

				model.game_info.set_in_normal_mode (false)
				model.game_info.set_mode_mesage (model.game_info.debug_mode)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
