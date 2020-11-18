note
	description: "Summary description for {CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARRIER

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 200
			health := 200
			health_regen := 10
			armour := 15
			vision := 15

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'C'
			name := "Carrier"

			row_pos := row
			col_pos := col
		end

feature -- Commands

	discharge_after_death
		do
			game_info.starfighter.add_diamond_focus
		end

	preemptive_action (type : CHARACTER)
		local
			i , j , damage_with_armour : INTEGER
			enemy_seen , destination_assigned : BOOLEAN
			enemy_action , enemy_action_info : STRING
			old_row , old_col : INTEGER
		do
			if type ~ 'S' then

				-- Preemptive Action on Special
				health_regen := health_regen + 10

				-- Debug Mode Output
				if not game_info.in_normal_mode then
					game_info.append_enemy_action_info ("    A " + name + "(id:" + id.out + ") gains 10 regen." + "%N")
				end

			elseif type ~ 'P' then

				regenerate

				-- Preemptive Action on Pass
				enemy_seen := false
				destination_assigned := false
				old_row := row_pos
				old_col := col_pos
				enemy_action := "    A " + name + "(id:" + id.out + ") moves: [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] -> "
				enemy_action_info := ""

				from
					i := 1
				until
					i > 2
				loop
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if game_info.grid.enemies.at (j).row_pos = row_pos and game_info.grid.enemies.at (j).col_pos = col_pos - 1 and game_info.grid.is_in_bounds (row_pos, col_pos - 1) then
								enemy_seen := true
								j := game_info.grid.enemies.count + 1
								i := 3
							end
							j := j + 1
						end

						if enemy_seen = false then
							col_pos := col_pos - 1
						end

						-- Collision Checks
						-- Check with Collisions with friendly projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
								damage_with_armour := game_info.grid.friendly_projectiles.at (j).damage - armour
								if damage_with_armour < 0 then
									damage_with_armour := 0
								end

								set_curr_health (curr_health - damage_with_armour)

								if curr_health < 0 then
									set_curr_health (0)
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with friendly projectile(id:" +  game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
								end

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with enemy projectiles
						from
							j := 1
						until
							j > game_info.grid.enemy_projectiles.count
						loop
							if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
								set_curr_health (curr_health + game_info.grid.enemy_projectiles.at (j).damage)

								if curr_health > health then
									set_curr_health (health)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (j).damage.out + "damage." + "%N")
								end

								game_info.grid.enemy_projectiles.at (j).set_col (99)
								game_info.grid.enemy_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.enemy_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
								game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

								-- Add to debug Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + curr_health.out + " damage." + "%N")
								end

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.starfighter.curr_health = 0 then
									enemy_action_info.append ("      The Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
								end

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end
								set_row_pos (99)
								set_col_pos (99)
						end

					end
					i := i + 1
				end

				-- Debug Mode Output
				if not game_info.in_normal_mode and destination_assigned = false then
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
					else
						enemy_action.append ("out of board" + "%N")
					end

					if row_pos = old_row and col_pos = old_col then
						enemy_action := "    A " + name + "(id:" + id.out + ") stays at: [" + game_info.grid.grid_char_rows.at (old_row).out + "," + old_col.out + "]" + "%N"
					end
				end

				-- Append to enemy action info for turn
				game_info.append_enemy_action_info (enemy_action + enemy_action_info)

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Spawn Two Interceptors
					game_info.grid.spawn_interceptor (row_pos - 1, col_pos)
					game_info.grid.spawn_interceptor (row_pos + 1, col_pos)
				end

				-- Turn is now over
				is_turn_over := true

			else
				-- Do Nothing
			end

		end

	action_when_starfighter_is_not_seen
		local
			i , j , damage_with_armour : INTEGER
			enemy_seen , destination_assigned : BOOLEAN
			enemy_action , enemy_action_info : STRING
			old_row , old_col : INTEGER
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				destination_assigned := false
				old_row := row_pos
				old_col := col_pos
				enemy_action := "    A " + name + "(id:" + id.out + ") moves: [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] -> "
				enemy_action_info := ""

				from
					i := 1
				until
					i > 2
				loop
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if game_info.grid.enemies.at (j).row_pos = row_pos and game_info.grid.enemies.at (j).col_pos = col_pos - 1 and game_info.grid.is_in_bounds (row_pos, col_pos - 1) then
								enemy_seen := true
								j := game_info.grid.enemies.count + 1
								i := 3
							end
							j := j + 1
						end

						if enemy_seen = false then
							col_pos := col_pos - 1
						end

						-- Collision Checks
						-- Check with Collisions with friendly projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
								damage_with_armour := game_info.grid.friendly_projectiles.at (j).damage - armour
								if damage_with_armour < 0 then
									damage_with_armour := 0
								end

								set_curr_health (curr_health - damage_with_armour)

								if curr_health < 0 then
									set_curr_health (0)
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with friendly projectile(id:" +  game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
								end

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with enemy projectiles
						from
							j := 1
						until
							j > game_info.grid.enemy_projectiles.count
						loop
							if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
								set_curr_health (curr_health + game_info.grid.enemy_projectiles.at (j).damage)

								if curr_health > health then
									set_curr_health (health)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (j).damage.out + "damage." + "%N")
								end

								game_info.grid.enemy_projectiles.at (j).set_col (99)
								game_info.grid.enemy_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.enemy_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
								game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

								-- Add to debug Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + curr_health.out + " damage." + "%N")
								end

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.starfighter.curr_health = 0 then
									enemy_action_info.append ("      The Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
								end

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end
								set_row_pos (99)
								set_col_pos (99)
						end

					end
					i := i + 1
				end

				-- Debug Mode Output
				if not game_info.in_normal_mode and destination_assigned = false then
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
					else
						enemy_action.append ("out of board" + "%N")
					end

					if row_pos = old_row and col_pos = old_col then
						enemy_action := "    A " + name + "(id:" + id.out + ") stays at: [" + game_info.grid.grid_char_rows.at (old_row).out + "," + old_col.out + "]" + "%N"
					end
				end

				-- Append to enemy action info for turn
				game_info.append_enemy_action_info (enemy_action + enemy_action_info)

			end

			-- Reset is_turn_over
			is_turn_over := false
		end

	action_when_starfighter_is_seen
		local
			j , damage_with_armour : INTEGER
			enemy_seen , destination_assigned : BOOLEAN
			enemy_action , enemy_action_info : STRING
			old_row , old_col : INTEGER
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				destination_assigned := false
				old_row := row_pos
				old_col := col_pos
				enemy_action := "    A " + name + "(id:" + id.out + ") moves: [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] -> "
				enemy_action_info := ""

				if game_info.grid.is_in_bounds (row_pos, col_pos) then
					from
						j := 1
					until
						j > game_info.grid.enemies.count
					loop
						if game_info.grid.enemies.at (j).row_pos = row_pos and game_info.grid.enemies.at (j).col_pos = col_pos - 1 and game_info.grid.is_in_bounds (row_pos, col_pos - 1) then
							enemy_seen := true
							j := game_info.grid.enemies.count + 1
						end
						j := j + 1
					end

					if enemy_seen = false then
						col_pos := col_pos - 1
					end

						-- Collision Checks
						-- Check with Collisions with friendly projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
								damage_with_armour := game_info.grid.friendly_projectiles.at (j).damage - armour
								if damage_with_armour < 0 then
									damage_with_armour := 0
								end

								set_curr_health (curr_health - damage_with_armour)

								if curr_health < 0 then
									set_curr_health (0)
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with friendly projectile(id:" +  game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
								end

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with enemy projectiles
						from
							j := 1
						until
							j > game_info.grid.enemy_projectiles.count
						loop
							if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
								set_curr_health (curr_health + game_info.grid.enemy_projectiles.at (j).damage)

								if curr_health > health then
									set_curr_health (health)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (j).damage.out + "damage." + "%N")
								end

								game_info.grid.enemy_projectiles.at (j).set_col (99)
								game_info.grid.enemy_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.enemy_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end

								-- Debug Mode Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
								game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

								-- Add to debug Output
								if not game_info.in_normal_mode then
									enemy_action_info.append ("      The " + name + " collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + curr_health.out + " damage." + "%N")
								end

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.starfighter.curr_health = 0 then
									enemy_action_info.append ("      The Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
								end

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end
								set_row_pos (99)
								set_col_pos (99)
						end

				end

				-- Debug Mode Output
				if not game_info.in_normal_mode and destination_assigned = false then
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
					else
						enemy_action.append ("out of board" + "%N")
					end

					if row_pos = old_row and col_pos = old_col then
						enemy_action := "    A " + name + "(id:" + id.out + ") stays at: [" + game_info.grid.grid_char_rows.at (old_row).out + "," + old_col.out + "]" + "%N"
					end
				end

				-- Append to enemy action info for turn
				game_info.append_enemy_action_info (enemy_action + enemy_action_info)

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Spawn Interceptor
					game_info.grid.spawn_interceptor (row_pos, col_pos - 1)
				end
			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end
