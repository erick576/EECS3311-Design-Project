note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SETUP_NEXT
inherit
	ETF_SETUP_NEXT_INTERFACE
create
	make
feature -- command
	setup_next(state: INTEGER_32)
		require else
			setup_next_precond(state)
		local
			count : INTEGER_32
    	do
			-- perform some update on the model state

			if not model.app.current_state.in_setup then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.setup_next_error_1)
			else

				from
					count := 0
				until
					count >= state
				loop
					if model.app.curr_index < 7 then
						model.app.current_state.set_choice (3)
						model.app.execute_transition
					end

					count := count + 1
				end

				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (false)

				if model.app.curr_index = 7 then
					-- Initialize Up starfighter stats
					model.starfighter.reset

					-- Reset Counts
					model.game_info.set_valid_operation_count (0)
					model.game_info.set_error_count (0)


					-- Now in game
					model.game_info.set_in_game (true)
					model.game_info.set_is_alive (true)
				end
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
