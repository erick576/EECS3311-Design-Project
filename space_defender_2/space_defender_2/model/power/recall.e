note
	description: "Summary description for {RECALL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECALL

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 50
			is_health_cost := false
			type_name := "Recall (50 energy): Teleport back to spawn."
		end

feature -- Commands

	special_move
		local
			j , damage_with_armour : INTEGER
			start_pos : DOUBLE
		do
			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy - cost)

			start_pos := game_info.grid.row_size / 2
			game_info.starfighter.set_row_pos (start_pos.ceiling)
			game_info.starfighter.set_col_pos (1)

			-- Debug Mode Output
			if not game_info.in_normal_mode then
				game_info.append_starfighter_action_info ("    The Starfighter(id:0) uses special, teleporting to: [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "]" + "%N")
			end

			-- Check For Spawning Collisions
			-- Check For Collisions with friendly Projectiles
			from
				j := 1
			until
				j > game_info.grid.friendly_projectiles.count
			loop
				if game_info.starfighter.row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and game_info.starfighter.col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
					damage_with_armour := game_info.grid.friendly_projectiles.at (j).damage - game_info.starfighter.armour
					if damage_with_armour < 0 then
						damage_with_armour := 0
					end

					game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

					if game_info.starfighter.curr_health < 0 then
						game_info.starfighter.set_curr_health (0)
					end

					-- Add to debug output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (j).set_col (99)
					game_info.grid.friendly_projectiles.at (j).set_row (99)
				end

				if game_info.starfighter.curr_health = 0 then
					-- Add to debug output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
					end

					j := game_info.grid.friendly_projectiles.count + 1
				end

				j := j + 1
			end

			-- Check For Collisions with enemy Projectiles
			from
				j := 1
			until
				j > game_info.grid.enemy_projectiles.count
			loop
				if game_info.starfighter.row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and game_info.starfighter.col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
					damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - game_info.starfighter.armour
					if damage_with_armour < 0 then
						damage_with_armour := 0
					end

					game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

					if game_info.starfighter.curr_health < 0 then
						game_info.starfighter.set_curr_health (0)
					end

					-- Add to debug output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
					end

					game_info.grid.enemy_projectiles.at (j).set_col (99)
					game_info.grid.enemy_projectiles.at (j).set_row (99)
				end

				if game_info.starfighter.curr_health = 0 then
					-- Add to debug output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
					end

					j := game_info.grid.enemy_projectiles.count + 1
				end

				j := j + 1
			end


			-- Check with Collisions with enemies
			from
				j := 1
			until
				j > game_info.grid.enemies.count
			loop
				if game_info.starfighter.row_pos = game_info.grid.enemies.at (j).row_pos and game_info.starfighter.col_pos = game_info.grid.enemies.at (j).col_pos then
					game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - game_info.grid.enemies.at (j).curr_health)

					if game_info.starfighter.curr_health < 0 then
						game_info.starfighter.set_curr_health (0)
					end

					if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
						game_info.grid.enemies.at (j).discharge_after_death
					end

					-- Add to debug output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
						game_info.append_starfighter_action_info ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
					end

					game_info.grid.enemies.at (j).set_row_pos (99)
					game_info.grid.enemies.at (j).set_col_pos (99)
				end

				if game_info.starfighter.curr_health = 0 then
					-- Add to debug output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
					end

					j := game_info.grid.enemy_projectiles.count + 1
				end

				j := j + 1
			end

		end

end
