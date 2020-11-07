note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ABORT
inherit
	ETF_ABORT_INTERFACE
create
	make
feature -- command
	abort
    	do
			-- perform some update on the model state

			if not model.app.current_state.in_game and not model.app.current_state.in_setup then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.abort_error_1)
			elseif model.app.current_state.in_setup then
				-- Exit back to not started mode from setup mode
				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)
				model.game_info.set_operation_message (model.game_info.abort_setup_operation_message)
				model.app.current_state.set_choice (4)
				model.app.execute_transition

				-- Reset the starfighter
				model.starfighter.reset
			else
				-- Exit back to not started mode from game mode
				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)
				model.game_info.set_operation_message (model.game_info.abort_game_operation_message)
				model.app.current_state.set_choice (4)
				model.app.execute_transition

				-- Reset the starfighter
				model.starfighter.reset

				-- Not in game anymore
				model.game_info.set_in_game (false)
				model.game_info.set_is_alive (true)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
