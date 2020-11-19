note
	description: "Summary description for {GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRUNT

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 100
			health := 100
			health_regen := 1
			armour := 1
			vision := 5

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'G'
			name := "Grunt"

			row_pos := row
			col_pos := col
		end

feature -- Commands

	discharge_after_death
		do
			game_info.starfighter.add_silver_orb
		end

	preemptive_action (type : CHARACTER)
		do
			if type ~ 'P' then

				-- Preemptive Action on Pass
				health := health + 10
				curr_health := curr_health + 10

				-- Debug Mode Output
				if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
					game_info.append_enemy_action_info ("    A " + name + "(id:" + id.out + ") gains 10 total health." + "%N")
				end

			elseif type ~ 'S' then

				-- Preemptive Action on Special
				health := health + 20
				curr_health := curr_health + 20

				-- Debug Mode Output
				if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
					game_info.append_enemy_action_info ("    A " + name + "(id:" + id.out + ") gains 20 total health." + "%N")
				end

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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
									enemy_action_info.append ("      The " + name + " collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (j).damage.out + " damage." + "%N")
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
									enemy_action_info.append ("      The " + name + " collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + curr_health.out + " damage." + "%N")
								end

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
									enemy_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
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

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_grunt (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 15)

					-- Debug Mode Output
					if not game_info.in_normal_mode then
						if game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos, game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos) then
							enemy_action_info.append ("      A enemy projectile(id:" + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id.out + ") spawns at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos).out + "," + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos.out + "]." + "%N")
						else
							enemy_action_info.append ("      A enemy projectile(id:" + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id.out + ") spawns at location out of board." + "%N")
						end
					end

					-- Spawn Collision Case with Friendly Projectile
					from
						j := 1
					until
						j > game_info.grid.friendly_projectiles.count
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id /= game_info.grid.friendly_projectiles.at (j).id then
							if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then

								-- Add Debug Info
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
									enemy_action_info.append ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], negating damage." + "%N")
								end

								if game_info.grid.friendly_projectiles.at (j).damage > game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage then

									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_damage (game_info.grid.friendly_projectiles.at (j).damage - game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage)

								elseif game_info.grid.friendly_projectiles.at (j).damage < game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage then

									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_damage (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage - game_info.grid.friendly_projectiles.at (j).damage)

								else
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)
								end

								j := game_info.grid.friendly_projectiles.count
							end
						end
						j := j + 1
					end

					-- Spawn Collision Case with an Enemy Projectile
					from
						j := 1
					until
						j > game_info.grid.enemy_projectiles.count - 1
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id /= game_info.grid.enemy_projectiles.at (j).id then
							if game_info.grid.enemy_projectiles.at (j).row_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos and game_info.grid.enemy_projectiles.at (j).col_pos = (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos) then
								game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_damage (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage + game_info.grid.enemy_projectiles.at (j).damage)

								-- Add Debug Info
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
									enemy_action_info.append ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], combining damage."+ "%N")
								end

								game_info.grid.enemy_projectiles.at (j).set_row (99)
								game_info.grid.enemy_projectiles.at (j).set_col (99)

								j := game_info.grid.enemy_projectiles.count
							end
						end
						j := j + 1
					end

					-- Spawn Collision Case with an Enemy
					from
						j := 1
					until
						j > game_info.grid.enemies.count
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.grid.enemies.at (j).row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.grid.enemies.at (j).col_pos then

							game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage)

							if game_info.grid.enemies.at (j).curr_health > game_info.grid.enemies.at (j).health then
								game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).health)
							end

							-- Set destroyed destination and debug output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
								enemy_action_info.append ("      The projectile collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage.out + " damage."+ "%N")
							end

							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)

							j := game_info.grid.enemies.count + 1
						end

						j := j + 1
					end

					-- Spawn Collision Case with an Starfighter
					if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.starfighter.row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.starfighter.col_pos then

						damage_with_armour := game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage - game_info.starfighter.armour
						if damage_with_armour < 0 then
							damage_with_armour := 0
						end

						game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

						if game_info.starfighter.curr_health < 0 then
							game_info.starfighter.set_curr_health (0)
						end

						-- Set destroyed destination and debug output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
							enemy_action_info.append ("      The projectile collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], dealing " + damage_with_armour.out + " damage."+ "%N")
						end

						-- Add to debug Output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
							enemy_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed."+ "%N")
						end

						game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
						game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
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
					i > 4
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
								i := 5
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
									enemy_action_info.append ("      The " + name + " collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (j).damage.out + " damage." + "%N")
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
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
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
									enemy_action_info.append ("      The " + name + " collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], trading " + curr_health.out + " damage." + "%N")
								end

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
									destination_assigned := true
									enemy_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									enemy_action_info.append ("      The " + name + " at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
								end

								-- Add to debug Output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
									enemy_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed." + "%N")
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

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_grunt (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 15)

					-- Debug Mode Output
					if not game_info.in_normal_mode then
						if game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos, game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos) then
							enemy_action_info.append ("      A enemy projectile(id:" + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id.out + ") spawns at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos).out + "," + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos.out + "]." + "%N")
						else
							enemy_action_info.append ("      A enemy projectile(id:" + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id.out + ") spawns at location out of board." + "%N")
						end
					end

					-- Spawn Collision Case with Friendly Projectile
					from
						j := 1
					until
						j > game_info.grid.friendly_projectiles.count
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id /= game_info.grid.friendly_projectiles.at (j).id then
							if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then

								-- Add Debug Info
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
									enemy_action_info.append ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], negating damage." + "%N")
								end

								if game_info.grid.friendly_projectiles.at (j).damage > game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage then

									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_damage (game_info.grid.friendly_projectiles.at (j).damage - game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage)

								elseif game_info.grid.friendly_projectiles.at (j).damage < game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage then

									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_damage (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage - game_info.grid.friendly_projectiles.at (j).damage)

								else
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
									game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)
								end

								j := game_info.grid.friendly_projectiles.count
							end
						end
						j := j + 1
					end

					-- Spawn Collision Case with an Enemy Projectile
					from
						j := 1
					until
						j > game_info.grid.enemy_projectiles.count - 1
					loop
						if game_info.grid.enemy_projectiles.at (j).row_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos and game_info.grid.enemy_projectiles.at (j).col_pos = (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos) then
							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_damage (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage + game_info.grid.enemy_projectiles.at (j).damage)

							-- Add Debug Info
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
								enemy_action_info.append ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], combining damage."+ "%N")
							end

							game_info.grid.enemy_projectiles.at (j).set_row (99)
							game_info.grid.enemy_projectiles.at (j).set_col (99)

							j := game_info.grid.enemy_projectiles.count
						end

						j := j + 1
					end


					-- Spawn Collision Case with an Enemy
					from
						j := 1
					until
						j > game_info.grid.enemies.count
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.grid.enemies.at (j).row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.grid.enemies.at (j).col_pos then

							game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage)

							if game_info.grid.enemies.at (j).curr_health > game_info.grid.enemies.at (j).health then
								game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).health)
							end

							-- Set destroyed destination and debug output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
								enemy_action_info.append ("      The projectile collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], healing " + game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage.out + " damage."+ "%N")
							end

							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)

							j := game_info.grid.enemies.count + 1
						end

						j := j + 1
					end

					-- Spawn Collision Case with an Starfighter
					if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.starfighter.row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.starfighter.col_pos then

						damage_with_armour := game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage - game_info.starfighter.armour
						if damage_with_armour < 0 then
							damage_with_armour := 0
						end

						game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

						if game_info.starfighter.curr_health < 0 then
							game_info.starfighter.set_curr_health (0)
						end

						-- Set destroyed destination and debug output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
							enemy_action_info.append ("      The projectile collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], dealing " + damage_with_armour.out + " damage."+ "%N")
						end

						-- Add to debug Output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
							enemy_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed."+ "%N")
						end

						game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
						game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
					end

				end

				-- Append to enemy action info for turn
				game_info.append_enemy_action_info (enemy_action + enemy_action_info)

			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end
