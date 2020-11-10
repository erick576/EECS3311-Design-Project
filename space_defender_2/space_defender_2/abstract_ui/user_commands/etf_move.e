note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
		local
			column_diff, row_diff : INTEGER
    	do
			-- perform some update on the model state

			if (model.starfighter.col_pos - column) >= 0 then
				column_diff := model.starfighter.col_pos - column
			else
				column_diff := column - model.starfighter.col_pos
			end

			if (model.starfighter.row_pos - row) >= 0 then
				row_diff := model.starfighter.row_pos - row
			else
				row_diff := row - model.starfighter.row_pos
			end

			if not model.app.current_state.in_game then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.move_error_1)
			elseif row > model.grid.row_size or row < 1 or column > model.grid.col_size or column < 1 then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.move_error_2)
			elseif row = model.starfighter.row_pos and column = model.starfighter.col_pos then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.move_error_3)
			elseif model.starfighter.move - (row_diff + column_diff) < 0 then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.move_error_4)
			elseif (row_diff + column_diff) * model.starfighter.move_cost > (model.starfighter.curr_energy + model.starfighter.energy_regen) and (model.starfighter.curr_energy + model.starfighter.energy_regen) <= model.starfighter.energy then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.move_error_5)
			elseif (row_diff + column_diff) * model.starfighter.move_cost > model.starfighter.energy and (model.starfighter.curr_energy + model.starfighter.energy_regen) > model.starfighter.energy then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.move_error_5)
			else
				-- Reset Error Count and Increment Valid Operation Count
				model.game_info.set_error_count (0)
				model.game_info.set_valid_operation_count (model.game_info.valid_operation_count + 1)

				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)
--				model.game_info.set_operation_message ("")

				-- Perform Move

			-- Phase 1
				if model.game_info.is_alive = true then
					model.grid.turn_frist_phase
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 2
				if model.game_info.is_alive = true then
					model.grid.turn_second_phase
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 3
				if model.game_info.is_alive = true then
					model.starfighter.regenerate
					model.starfighter.move_starfighter (row, column)
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 4
				if model.game_info.is_alive = true then
					model.grid.turn_fourth_phase
				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 5
				if model.game_info.is_alive = true then

				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 6
				if model.game_info.is_alive = true then

				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end

			-- Phase 7
				if model.game_info.is_alive = true then

				end

				-- Check if Died
				if model.starfighter.curr_health = 0 then
					model.game_info.set_is_alive (false)
				end


				-- Check if Died , If so then exit game
				if model.game_info.is_alive = false then
					-- Transition into Not Started State
					model.app.current_state.set_choice (4)
					model.app.execute_transition
				end

			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
