note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
create
	make
feature -- command
	fire
    	do
			-- perform some update on the model state

			if not model.app.current_state.in_game then
				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_1)
			elseif model.starfighter.weapon_selected.is_projectile_cost_health and model.starfighter.projectile_cost > (model.starfighter.curr_health + model.starfighter.health_regen) and (model.starfighter.curr_health + model.starfighter.health_regen) <= model.starfighter.health then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_2)
			elseif model.starfighter.weapon_selected.is_projectile_cost_health and model.starfighter.projectile_cost > model.starfighter.health and (model.starfighter.curr_health + model.starfighter.health_regen) > model.starfighter.health then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_2)
			elseif not model.starfighter.weapon_selected.is_projectile_cost_health and model.starfighter.projectile_cost > (model.starfighter.curr_energy + model.starfighter.energy_regen) and (model.starfighter.curr_energy + model.starfighter.energy_regen) <= model.starfighter.energy then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_2)
			elseif not model.starfighter.weapon_selected.is_projectile_cost_health and model.starfighter.projectile_cost > model.starfighter.energy and (model.starfighter.curr_energy + model.starfighter.energy_regen) > model.starfighter.energy then
				-- Increment Error Count
				model.game_info.set_error_count (model.game_info.error_count + 1)

				model.game_info.set_is_error (true)
				model.game_info.set_is_valid_operation (false)
				model.game_info.set_error_message (model.game_info.fire_error_2)
			else
				-- Reset Error Count and Increment Valid Operation Count
				model.game_info.set_error_count (0)
				model.game_info.set_valid_operation_count (model.game_info.valid_operation_count + 1)

				model.game_info.set_is_error (false)
				model.game_info.set_is_valid_operation (true)
--				model.game_info.set_operation_message ("")

				-- Perform Fire
				model.starfighter.regenerate
				model.grid.turn_frist_part
				model.starfighter.use_fire
				model.grid.fire
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
