note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_SELECT
inherit
	ETF_SETUP_SELECT_INTERFACE
create
	make
feature -- command
	setup_select(value: INTEGER_32)
		require else
			setup_select_precond(value)
    	do
			-- perform some update on the model state

			if not model.app.current_state.in_setup_select then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.setup_select_error_1)
			elseif not model.app.current_state.in_bounds (value) then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.setup_select_error_2)
			else
				model.app.current_state.setup_select (value)
				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (false)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
