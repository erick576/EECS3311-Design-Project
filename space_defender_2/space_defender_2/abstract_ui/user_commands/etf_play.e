note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		require else
			play_precond(row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
    	do
			-- perform some update on the model state

			if model.app.current_state.in_setup then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.play_error_1)
			elseif model.app.current_state.in_game then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.play_error_2)
			elseif not ((g_threshold <= f_threshold) and (f_threshold <= c_threshold) and (c_threshold <= i_threshold) and (i_threshold <= p_threshold)) then
				model.game_info.set_is_error (true)
				model.game_info.set_error_message (model.game_info.play_error_3)
			else
				-- Play Go to Weapon Setup State
				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)
				model.app.current_state.set_choice (1)
				model.app.execute_transition

				-- Set Inputs into grid information to hold
				model.grid.make (row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
