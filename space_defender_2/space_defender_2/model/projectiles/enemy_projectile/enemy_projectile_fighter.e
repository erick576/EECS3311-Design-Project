note
	description: "Summary description for {ENEMY_PROJECTILE_FIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_FIGHTER

inherit
	ENEMY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER ; m : INTEGER)
		do
			id := i

			type := t
			is_friendly := false
			move := m

			damage := d

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		local
			i , j, damage_with_armour : INTEGER
			projectile_action , projectile_action_info : STRING
			destination_assigned : BOOLEAN
		do
			if game_info.grid.is_in_bounds (row_pos, col_pos) then

				destination_assigned := false
				projectile_action := "    A enemy projectile(id:" + id.out +") moves: [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] -> "
				projectile_action_info := ""

				if type = 1 then

					from
						i := 1
					until
						i > 10
					loop
						col_pos := col_pos - 1

						-- Check with Collisions with friendly projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if id /= game_info.grid.friendly_projectiles.at (j).id then
								if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then

									-- Add Debug Info
									if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
										projectile_action_info.append ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], negating damage." + "%N")
									end

									if game_info.grid.friendly_projectiles.at (j).damage > damage then

										-- Set destroyed destination
										if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
											projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
											destination_assigned := true
										end

										set_row (99)
										set_col (99)
										game_info.grid.friendly_projectiles.at (j).set_damage (game_info.grid.friendly_projectiles.at (j).damage - damage)

									elseif game_info.grid.friendly_projectiles.at (j).damage < damage then

										game_info.grid.friendly_projectiles.at (j).set_row (99)
										game_info.grid.friendly_projectiles.at (j).set_col (99)
										set_damage (damage - game_info.grid.friendly_projectiles.at (j).damage)

									else
										-- Set destroyed destination
										if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
											projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
											destination_assigned := true
										end

										set_row (99)
										set_col (99)
										game_info.grid.friendly_projectiles.at (j).set_row (99)
										game_info.grid.friendly_projectiles.at (j).set_col (99)
									end

									j := game_info.grid.friendly_projectiles.count + 1
								end
							end
							j := j + 1
						end


						-- Check with Collisions with enemy projectiles
						from
							j := 1
						until
							j > game_info.grid.enemy_projectiles.count
						loop
							if id /= game_info.grid.enemy_projectiles.at (j).id then
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage := damage + game_info.grid.enemy_projectiles.at (j).damage

									-- Add Debug Info
									if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
										projectile_action_info.append ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], combining damage."+ "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_row (99)
									game_info.grid.enemy_projectiles.at (j).set_col (99)

									j := game_info.grid.enemy_projectiles.count + 1
								end
							end

							j := j + 1
						end


						-- Check with Collisions with enemies
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if row_pos = game_info.grid.enemies.at (j).row_pos and col_pos = game_info.grid.enemies.at (j).col_pos then

								game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health + damage)

								if game_info.grid.enemies.at (j).curr_health > game_info.grid.enemies.at (j).health then
									game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).health)
								end

								-- Set destroyed destination and debug output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
									projectile_action_info.append ("      The projectile collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], healing " + damage.out + " damage."+ "%N")
									projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									destination_assigned := true
								end

								set_row (99)
								set_col (99)

								j := game_info.grid.enemies.count + 1
							end

							j := j + 1
						end

						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then

							damage_with_armour := damage - game_info.starfighter.armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							-- Set destroyed destination and debug output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
								projectile_action_info.append ("      The projectile collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], dealing " + damage_with_armour.out + " damage."+ "%N")
								projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
								destination_assigned := true
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
								projectile_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed."+ "%N")
							end

							set_row (99)
							set_col (99)
						end


						i := i + 1
					end

				elseif type = 2 then

					from
						i := 1
					until
						i > 3
					loop
						col_pos := col_pos - 1

						-- Check with Collisions with friendly projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if id /= game_info.grid.friendly_projectiles.at (j).id then
								if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then

									-- Add Debug Info
									if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
										projectile_action_info.append ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], negating damage." + "%N")
									end

									if game_info.grid.friendly_projectiles.at (j).damage > damage then

										-- Set destroyed destination
										if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
											projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
											destination_assigned := true
										end

										set_row (99)
										set_col (99)
										game_info.grid.friendly_projectiles.at (j).set_damage (game_info.grid.friendly_projectiles.at (j).damage - damage)

									elseif game_info.grid.friendly_projectiles.at (j).damage < damage then

										game_info.grid.friendly_projectiles.at (j).set_row (99)
										game_info.grid.friendly_projectiles.at (j).set_col (99)
										set_damage (damage - game_info.grid.friendly_projectiles.at (j).damage)

									else
										-- Set destroyed destination
										if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
											projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
											destination_assigned := true
										end

										set_row (99)
										set_col (99)
										game_info.grid.friendly_projectiles.at (j).set_row (99)
										game_info.grid.friendly_projectiles.at (j).set_col (99)
									end

									j := game_info.grid.friendly_projectiles.count + 1
								end
							end
							j := j + 1
						end


						-- Check with Collisions with enemy projectiles
						from
							j := 1
						until
							j > game_info.grid.enemy_projectiles.count
						loop
							if id /= game_info.grid.enemy_projectiles.at (j).id then
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage := damage + game_info.grid.enemy_projectiles.at (j).damage

									-- Add Debug Info
									if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
										projectile_action_info.append ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], combining damage."+ "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_row (99)
									game_info.grid.enemy_projectiles.at (j).set_col (99)

									j := game_info.grid.enemy_projectiles.count + 1
								end
							end

							j := j + 1
						end


						-- Check with Collisions with enemies
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if row_pos = game_info.grid.enemies.at (j).row_pos and col_pos = game_info.grid.enemies.at (j).col_pos then

								game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health + damage)

								if game_info.grid.enemies.at (j).curr_health > game_info.grid.enemies.at (j).health then
									game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).health)
								end

								-- Set destroyed destination and debug output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
									projectile_action_info.append ("      The projectile collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], healing " + damage.out + " damage."+ "%N")
									projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									destination_assigned := true
								end

								set_row (99)
								set_col (99)

								j := game_info.grid.enemies.count + 1
							end

							j := j + 1
						end


						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then

							damage_with_armour := damage - game_info.starfighter.armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							-- Set destroyed destination and debug output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
								projectile_action_info.append ("      The projectile collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], dealing " + damage_with_armour.out + " damage."+ "%N")
								projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
								destination_assigned := true
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
								projectile_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed."+ "%N")
							end

							set_row (99)
							set_col (99)
						end


						i := i + 1
					end

				elseif type = 3 then

					from
						i := 1
					until
						i > 6
					loop
						col_pos := col_pos - 1

						-- Check with Collisions with friendly projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if id /= game_info.grid.friendly_projectiles.at (j).id then
								if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then

									-- Add Debug Info
									if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (j).row_pos, game_info.grid.friendly_projectiles.at (j).col_pos) then
										projectile_action_info.append ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], negating damage." + "%N")
									end

									if game_info.grid.friendly_projectiles.at (j).damage > damage then

										-- Set destroyed destination
										if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
											projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
											destination_assigned := true
										end

										set_row (99)
										set_col (99)
										game_info.grid.friendly_projectiles.at (j).set_damage (game_info.grid.friendly_projectiles.at (j).damage - damage)

									elseif game_info.grid.friendly_projectiles.at (j).damage < damage then

										game_info.grid.friendly_projectiles.at (j).set_row (99)
										game_info.grid.friendly_projectiles.at (j).set_col (99)
										set_damage (damage - game_info.grid.friendly_projectiles.at (j).damage)

									else
										-- Set destroyed destination
										if not game_info.in_normal_mode and game_info.grid.is_in_bounds (row_pos, col_pos) then
											projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
											destination_assigned := true
										end

										set_row (99)
										set_col (99)
										game_info.grid.friendly_projectiles.at (j).set_row (99)
										game_info.grid.friendly_projectiles.at (j).set_col (99)
									end

									j := game_info.grid.friendly_projectiles.count + 1
								end
							end
							j := j + 1
						end


						-- Check with Collisions with enemy projectiles
						from
							j := 1
						until
							j > game_info.grid.enemy_projectiles.count
						loop
							if id /= game_info.grid.enemy_projectiles.at (j).id then
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage := damage + game_info.grid.enemy_projectiles.at (j).damage

									-- Add Debug Info
									if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (j).row_pos, game_info.grid.enemy_projectiles.at (j).col_pos) then
										projectile_action_info.append ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], combining damage."+ "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_row (99)
									game_info.grid.enemy_projectiles.at (j).set_col (99)

									j := game_info.grid.enemy_projectiles.count + 1
								end
							end

							j := j + 1
						end


						-- Check with Collisions with enemies
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if row_pos = game_info.grid.enemies.at (j).row_pos and col_pos = game_info.grid.enemies.at (j).col_pos then

								game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health + damage)

								if game_info.grid.enemies.at (j).curr_health > game_info.grid.enemies.at (j).health then
									game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).health)
								end

								-- Set destroyed destination and debug output
								if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
									projectile_action_info.append ("      The projectile collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], healing " + damage.out + " damage."+ "%N")
									projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
									destination_assigned := true
								end

								set_row (99)
								set_col (99)

								j := game_info.grid.enemies.count + 1
							end

							j := j + 1
						end


						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then

							damage_with_armour := damage - game_info.starfighter.armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							-- Set destroyed destination and debug output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) then
								projectile_action_info.append ("      The projectile collides with Starfighter(id:0) at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "], dealing " + damage_with_armour.out + " damage."+ "%N")
								projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
								destination_assigned := true
							end

							-- Add to debug Output
							if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.starfighter.row_pos, game_info.starfighter.col_pos) and game_info.starfighter.curr_health = 0 then
								projectile_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (game_info.starfighter.row_pos).out + "," + game_info.starfighter.col_pos.out + "] has been destroyed."+ "%N")
							end

							set_row (99)
							set_col (99)
						end

						i := i + 1
					end
				end

				-- If destination not assigned , assign it
				if not game_info.in_normal_mode and destination_assigned = false then
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						projectile_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
					else
						projectile_action.append ("out of board" + "%N")
					end
				end

				game_info.append_enemy_projectile_action_info (projectile_action + projectile_action_info)

			end
		end

end
