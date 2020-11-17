note
	description: "Summary description for {DEPLOY_DRONES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEPLOY_DRONES

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 100
			is_health_cost := false
			type_name := "Deploy Drones (100 energy): Clear all projectiles."
		end

feature -- Commands

	special_move
		local
			i , j, k : INTEGER
		do
			-- Debug Mode Output
			if not game_info.in_normal_mode then
				game_info.append_starfighter_action_info ("    The Starfighter(id:0) uses special, clearing projectiles with drones." + "%N")

				j := 1
				k := 1

				from
					i := -1
				until
					i < game_info.grid.projectile_id_counter
				loop
					if game_info.grid.friendly_projectiles.valid_index (j) and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) and game_info.grid.friendly_projectiles.at (j).id = i then
						game_info.append_starfighter_action_info ("      A projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "] has been neutralized." + "%N")
						j := j + 1
					end

					if game_info.grid.enemy_projectiles.valid_index (k) and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (k).row_pos, game_info.grid.enemy_projectiles.at (k).col_pos) and game_info.grid.enemy_projectiles.at (k).id = i then
						game_info.append_starfighter_action_info ("      A projectile(id:" + game_info.grid.enemy_projectiles.at (k).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (k).row_pos).out + "," + game_info.grid.enemy_projectiles.at (k).col_pos.out + "] has been neutralized." + "%N")
						k := k + 1
					end
					i := i - 1
				end

			end

			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy - cost)
			game_info.grid.friendly_projectiles.wipe_out
			game_info.grid.enemy_projectiles.wipe_out
		end

end
