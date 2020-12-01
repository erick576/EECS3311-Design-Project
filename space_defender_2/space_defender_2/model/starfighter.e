note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER

create
	make

feature -- Initialization
	make
		do
			id := 0

			col_pos := 0
			row_pos := 0

			curr_health := 0
			curr_energy := 0
			health := 0
			energy := 0

			health_regen := 0
			energy_regen := 0
			vision := 0
			armour := 0
			move := 0
			move_cost := 0
			projectile_damage := 0
			projectile_cost := 0

			score := 0
			player_focus := create {PLAYER_FOCUS}.make
			focuses := create {ARRAYED_LIST[COMPOSITE_SCORING_ITEM]}.make (0)

			weapon_selected := create {WEAPON_STANDARD}.make
			armour_selected := create {ARMOUR_NONE}.make
			engine_selected := create {ENGINE_STANDARD}.make
			power_selected := create {RECALL}.make
		end


feature -- Attributes

	id : INTEGER

	col_pos : INTEGER
	row_pos : INTEGER

	curr_health : INTEGER
	curr_energy : INTEGER
	health : INTEGER
	energy : INTEGER
	health_regen : INTEGER
	energy_regen : INTEGER
	vision : INTEGER
	armour : INTEGER
	move : INTEGER
	move_cost : INTEGER
	projectile_damage : INTEGER
	projectile_cost : INTEGER

	score : INTEGER
	player_focus : COMPOSITE_SCORING_ITEM
	focuses : LIST[COMPOSITE_SCORING_ITEM]

	weapon_selected : WEAPON
	armour_selected : ARMOUR
	engine_selected : ENGINE
	power_selected : POWER

	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

feature -- Commands

	regenerate
		require
			is_alive : game_info.is_alive = true
		do
			if curr_health > health then
				-- Do Nothing (Only Can Occur From using Repair)
			else
				if curr_health + health_regen > health then
					curr_health := health
				else
					curr_health := curr_health + health_regen
				end
			end

			if curr_energy > energy then
				-- Do Nothing (Only Can Occur From using Overcharge)
			else
				if curr_energy + energy_regen > energy then
					curr_energy := energy
				else
					curr_energy := curr_energy + energy_regen
				end
			end
		end

	move_starfighter (row: INTEGER_32 ; column: INTEGER_32)
		require
			is_alive : game_info.is_alive = true
		local
			i , j , damage_with_armour: INTEGER
			stop_starfighter : BOOLEAN
			starfighter_action , starfighter_action_info : STRING
			destination_assigned : BOOLEAN
		do
			stop_starfighter := false
			destination_assigned := false
			starfighter_action := "    The Starfighter(id:0) moves: [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] -> "
			starfighter_action_info := ""

			if row = row_pos and column /= col_pos then

				-- Move Right
				if column > col_pos then

					if stop_starfighter = false then
						from
							i := col_pos
						until
							i >= column
						loop
							set_col_pos (col_pos + 1)
							curr_energy := curr_energy - move_cost
							i := i + 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

				-- Move Left
				-- column < col_pos
				else
					if stop_starfighter = false then
						from
							i := col_pos
						until
							i <= column
						loop
							set_col_pos (col_pos - 1)
							curr_energy := curr_energy - move_cost
							i := i - 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end
				end

			elseif row /= row_pos and column = col_pos then

				-- Move Up
				if row > row_pos then

					if stop_starfighter = false then
						from
							i := row_pos
						until
							i >= row
						loop
							set_row_pos (row_pos + 1)
							curr_energy := curr_energy - move_cost
							i := i + 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

				-- Move Down
				-- row < row_pos
				else

					if stop_starfighter = false then
						from
							i := row_pos
						until
							i <= row
						loop
							set_row_pos (row_pos - 1)
							curr_energy := curr_energy - move_cost
							i := i - 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end
				end

			else

				if row > row_pos and column > col_pos then

					-- Move Up then Right
					if stop_starfighter = false then
						from
							i := row_pos
						until
							i >= row
						loop
							set_row_pos (row_pos + 1)
							curr_energy := curr_energy - move_cost
							i := i + 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

					if stop_starfighter = false then
						from
							i := col_pos
						until
							i >= column
						loop
							set_col_pos (col_pos + 1)
							curr_energy := curr_energy - move_cost
							i := i + 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

				elseif row < row_pos and column > col_pos then

					-- Move Down then Right

					if stop_starfighter = false then
						from
							i := row_pos
						until
							i <= row
						loop
							set_row_pos (row_pos - 1)
							curr_energy := curr_energy - move_cost
							i := i - 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

					if stop_starfighter = false then
						from
							i := col_pos
						until
							i >= column
						loop
							set_col_pos (col_pos + 1)
							curr_energy := curr_energy - move_cost
							i := i + 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column + 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

				elseif row > row_pos and column < col_pos then

					-- Move Up then Left

					if stop_starfighter = false then
						from
							i := row_pos
						until
							i >= row
						loop
							set_row_pos (row_pos + 1)
							curr_energy := curr_energy - move_cost
							i := i + 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row + 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

					if stop_starfighter = false then
						from
							i := col_pos
						until
							i <= column
						loop
							set_col_pos (col_pos - 1)
							curr_energy := curr_energy - move_cost
							i := i - 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end

				-- row < row_pos and column < col_pos
				else

					-- Move Down then Left

					if stop_starfighter = false then
						from
							i := row_pos
						until
							i <= row
						loop
							set_row_pos (row_pos - 1)
							curr_energy := curr_energy - move_cost
							i := i - 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := row - 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end


						end
					end

					if stop_starfighter = false then
						from
							i := col_pos
						until
							i <= column
						loop
							set_col_pos (col_pos - 1)
							curr_energy := curr_energy - move_cost
							i := i - 1

							-- Check For Collisions with friendly Projectiles
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

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (j).row_pos).out + "," + game_info.grid.friendly_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.friendly_projectiles.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

							-- Check For Collisions with enemy Projectiles
							from
								j := 1
							until
								j > game_info.grid.enemy_projectiles.count
							loop
								if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
									damage_with_armour := game_info.grid.enemy_projectiles.at (j).damage - armour
									if damage_with_armour < 0 then
										damage_with_armour := 0
									end

									curr_health := curr_health - damage_with_armour

									if curr_health < 0 then
										curr_health := 0
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (j).row_pos).out + "," + game_info.grid.enemy_projectiles.at (j).col_pos.out + "], taking " + damage_with_armour.out + " damage." + "%N")
									end

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.enemy_projectiles.count + 1
									stop_starfighter := true
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
									set_curr_health (curr_health - game_info.grid.enemies.at (j).curr_health)

									if curr_health < 0 then
										set_curr_health (0)
									end

									-- Add to debug output
									if not game_info.in_normal_mode then
										starfighter_action_info.append ("      The Starfighter collides with " + game_info.grid.enemies.at (j).name + "(id:" + game_info.grid.enemies.at (j).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "], trading "+ game_info.grid.enemies.at (j).curr_health.out + " damage." + "%N")
										starfighter_action_info.append ("      The " + game_info.grid.enemies.at (j).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (j).row_pos).out + "," + game_info.grid.enemies.at (j).col_pos.out + "] has been destroyed." + "%N")
									end

									if game_info.grid.is_in_bounds (game_info.grid.enemies.at (j).row_pos, game_info.grid.enemies.at (j).col_pos) then
										game_info.grid.enemies.at (j).discharge_after_death
									end
									game_info.grid.enemies.at (j).set_row_pos (99)
									game_info.grid.enemies.at (j).set_col_pos (99)
								end

								if curr_health = 0 then
									-- Add to debug output
									if not game_info.in_normal_mode and not destination_assigned then
										destination_assigned := true
										starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
										starfighter_action_info.append ("      The Starfighter at location [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "] has been destroyed." + "%N")
									end

									i := column - 1
									j := game_info.grid.enemies.count + 1
									stop_starfighter := true
								end

								j := j + 1
							end

						end
					end
				end
			end

			-- If not assigned yet add destination		
			if not game_info.in_normal_mode and destination_assigned = false then
				starfighter_action.append ("[" + game_info.grid.grid_char_rows.at (row_pos).out +"," + col_pos.out + "]" + "%N")
			end

			game_info.append_starfighter_action_info (starfighter_action + starfighter_action_info)
		end

	use_fire
		do
			if weapon_selected.is_projectile_cost_health then
				curr_health := curr_health - projectile_cost
			else
				curr_energy := curr_energy - projectile_cost
			end
		ensure
			cost_applied : (weapon_selected.is_projectile_cost_health and curr_health = old curr_health - projectile_cost)
							or
						   (not weapon_selected.is_projectile_cost_health and curr_energy = old curr_energy - projectile_cost)
		end

	special
		require
			is_alive : game_info.is_alive = true
		do
			power_selected.special_move
		end

	update_score
		do
			score := player_focus.value
		ensure
			value_assigned : score = player_focus.value
		end

	add_diamond_focus
		local
			i : INTEGER
			focus : COMPOSITE_SCORING_ITEM
			did_add : BOOLEAN
		do
			create {DIAMOND_FOCUS} focus.make
			focus.add (create {GOLD_ORB}.make)

			did_add := false

			from
				i := 1
			until
				i > focuses.count
			loop
				if focuses.at (i).has_capacity and focuses.at (i).model.count < focuses.at (i).capacity then
					focuses.at (i).add (focus)
					did_add := true
					i := focuses.count + 1
				end
				i := i + 1
			end

			focuses.force (focus)

			if did_add = false then
				player_focus.add (focus)
			end
		end

	add_platinum_focus
		local
			i : INTEGER
			focus : COMPOSITE_SCORING_ITEM
			did_add : BOOLEAN
		do
			create {PLATINUM_FOCUS} focus.make
			focus.add (create {BRONZE_ORB}.make)

			did_add := false

			from
				i := 1
			until
				i > focuses.count
			loop
				if focuses.at (i).has_capacity and focuses.at (i).model.count < focuses.at (i).capacity then
					focuses.at (i).add (focus)
					did_add := true
					i := focuses.count + 1
				end
				i := i + 1
			end

			focuses.force (focus)

			if did_add = false then
				player_focus.add (focus)
			end
		end


	add_bronze_orb
		local
			i : INTEGER
			did_add : BOOLEAN
		do
			did_add := false

			from
				i := 1
			until
				i > focuses.count
			loop
				if focuses.at (i).has_capacity and focuses.at (i).model.count < focuses.at (i).capacity then
					focuses.at (i).add (create {BRONZE_ORB}.make)
					did_add := true
					i := focuses.count + 1
				end
				i := i + 1
			end

			if did_add = false then
				player_focus.add (create {BRONZE_ORB}.make)
			end
		end

	add_silver_orb
		local
			i : INTEGER
			did_add : BOOLEAN
		do
			did_add := false

			from
				i := 1
			until
				i > focuses.count
			loop
				if focuses.at (i).has_capacity and focuses.at (i).model.count < focuses.at (i).capacity then
					focuses.at (i).add (create {SILVER_ORB}.make)
					did_add := true
				end
				i := i + 1
			end

			if did_add = false then
				player_focus.add (create {SILVER_ORB}.make)
			end
		end

	add_gold_orb
		local
			i : INTEGER
			did_add : BOOLEAN
		do
			did_add := false

			from
				i := 1
			until
				i > focuses.count
			loop
				if focuses.at (i).has_capacity and focuses.at (i).model.count < focuses.at (i).capacity then
					focuses.at (i).add (create {GOLD_ORB}.make)
					did_add := true
				end
				i := i + 1
			end

			if did_add = false then
				player_focus.add (create {GOLD_ORB}.make)
			end
		end

feature -- Setters for Setting State

	set_col_pos (col : INTEGER)
		do
			col_pos := col
		ensure
			value_set_correctly : col_pos = col
		end

	set_row_pos (row :INTEGER)
		do
			row_pos := row
		ensure
			value_set_correctly : row_pos = row
		end

	set_weapon (weapon : WEAPON)
		do
			weapon_selected := weapon
		ensure
			value_set_correctly : weapon_selected = weapon
		end

	set_armour (armour_val : ARMOUR)
		do
			armour_selected := armour_val
		ensure
			value_set_correctly : armour_selected = armour_val
		end

	set_engine (engine : ENGINE)
		do
			engine_selected := engine
		ensure
			value_set_correctly : engine_selected = engine
		end

	set_power (power : POWER)
		do
			power_selected := power
		ensure
			value_set_correctly : power_selected = power
		end

	set_curr_health (curr : INTEGER)
		do
			curr_health := curr
		ensure
			value_set_correctly : curr_health = curr
		end

	set_curr_energy (curr : INTEGER)
		do
			curr_energy := curr
		ensure
			value_set_correctly : curr_energy = curr
		end

feature -- Exit Game

	reset
		do
			-- Add Up all Selections
			curr_health := weapon_selected.health + armour_selected.health + engine_selected.health
			curr_energy := weapon_selected.energy + armour_selected.energy + engine_selected.energy
			health := weapon_selected.health + armour_selected.health + engine_selected.health
			energy := weapon_selected.energy + armour_selected.energy + engine_selected.energy
			health_regen := weapon_selected.health_regen + armour_selected.health_regen + engine_selected.health_regen
			energy_regen := weapon_selected.energy_regen + armour_selected.energy_regen + engine_selected.energy_regen
			vision := weapon_selected.vision + armour_selected.vision + engine_selected.vision
			armour := weapon_selected.armour + armour_selected.armour + engine_selected.armour
			move := weapon_selected.move + armour_selected.move + engine_selected.move
			move_cost := weapon_selected.move_cost + armour_selected.move_cost + engine_selected.move_cost
			projectile_damage :=  weapon_selected.projectile_damage + armour_selected.projectile_damage + engine_selected.projectile_damage
			projectile_cost :=  weapon_selected.projectile_cost + armour_selected.projectile_cost + engine_selected.projectile_cost

			score := 0
			player_focus := create {PLAYER_FOCUS}.make
			focuses := create {ARRAYED_LIST[COMPOSITE_SCORING_ITEM]}.make (0)
		end

invariant
	in_bounds : game_info.in_game implies game_info.grid.is_in_bounds (row_pos, col_pos)

end
