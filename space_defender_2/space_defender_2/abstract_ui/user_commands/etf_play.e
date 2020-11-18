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
		local
			start_pos : DOUBLE
    	do
			-- perform some update on the model state

			if model.app.current_state.in_setup then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.play_error_1)
			elseif model.app.current_state.in_game then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.play_error_2)
			elseif not ((g_threshold <= f_threshold) and (f_threshold <= c_threshold) and (c_threshold <= i_threshold) and (i_threshold <= p_threshold)) then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.play_error_3)
			else
				-- Clear all Debug Messages
				model.game_info.set_enemy_info ("")
				model.game_info.set_projectile_info ("")
				model.game_info.set_friendly_projectile_action_info ("")
				model.game_info.set_enemy_projectile_action_info ("")
				model.game_info.set_starfighter_action_info ("")
				model.game_info.set_enemy_action_info ("")
				model.game_info.set_natural_enemy_spawn_info ("")

				-- Play Go to Weapon Setup State
				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (false)
				model.app.current_state.set_choice (1)
				model.app.execute_transition

				-- Set Inputs into grid information to hold
				model.grid.make (row, column, g_threshold, f_threshold, c_threshold, i_threshold, p_threshold)

				-- Set Default Starfighter Position on the board
				start_pos := model.grid.row_size / 2
				model.starfighter.set_row_pos (start_pos.ceiling)
				model.starfighter.set_col_pos (1)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
