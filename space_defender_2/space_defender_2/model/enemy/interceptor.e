note
	description: "Summary description for {INTERCEPTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCEPTOR

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 50
			health := 50
			health_regen := 0
			armour := 0
			vision := 5

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'I'
			name := "Interceptor"

			row_pos := row
			col_pos := col
		end

feature -- Commands

	discharge_after_death
		do
			game_info.starfighter.add_bronze_orb
		end

	preemptive_action (type : CHARACTER)
		local
			i, j, distance , damage_with_armour : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then
				if type ~ 'F' then

					regenerate

					-- Preemptive Action on Fire
					enemy_seen := false
					distance := row_pos - game_info.starfighter.row_pos
					if col_pos /= game_info.starfighter.col_pos then

						from
							i := 1
						until
							i > distance.abs
						loop
							from
								j := 1
							until
								j > game_info.grid.enemies.count
							loop
								if row_pos > game_info.starfighter.row_pos then
									if game_info.grid.enemies.at (j).row_pos = row_pos - 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos - 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								else
									if game_info.grid.enemies.at (j).row_pos = row_pos + 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos + 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								end
								j := j + 1
							end

							if game_info.grid.is_in_bounds (row_pos, col_pos) then
								if row_pos > game_info.starfighter.row_pos then
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos - 1
									end
								else
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos + 1
									end
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

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									j := game_info.grid.friendly_projectiles.count + 1

									if game_info.grid.is_in_bounds (row_pos, col_pos) then
										discharge_after_death
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

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									j := game_info.grid.enemy_projectiles.count + 1

									if game_info.grid.is_in_bounds (row_pos, col_pos) then
										discharge_after_death
									end
									set_row_pos (99)
									set_col_pos (99)
								end

								j := j + 1
							end

							-- Check with Collisions with starfighter
							if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
									game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

									if game_info.starfighter.curr_health < 0 then
										game_info.starfighter.set_curr_health (0)
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

					else -- col_pos = game_info.starfighter.col_pos

						from
							i := 1
						until
							i > distance.abs
						loop
							from
								j := 1
							until
								j > game_info.grid.enemies.count
							loop
								if row_pos > game_info.starfighter.row_pos then
									if game_info.grid.enemies.at (j).row_pos = row_pos - 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos - 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								else
									if game_info.grid.enemies.at (j).row_pos = row_pos + 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos + 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								end
								j := j + 1
							end

							if game_info.grid.is_in_bounds (row_pos, col_pos) then
								if row_pos > game_info.starfighter.row_pos then
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos - 1
									end
								else
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos + 1
									end
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

									game_info.grid.friendly_projectiles.at (j).set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									j := game_info.grid.friendly_projectiles.count + 1

									if game_info.grid.is_in_bounds (row_pos, col_pos) then
										discharge_after_death
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

									game_info.grid.enemy_projectiles.at (j).set_col (99)
									game_info.grid.enemy_projectiles.at (j).set_row (99)
								end

								if curr_health = 0 then
									j := game_info.grid.enemy_projectiles.count + 1

									if game_info.grid.is_in_bounds (row_pos, col_pos) then
										discharge_after_death
									end
									set_row_pos (99)
									set_col_pos (99)
								end

								j := j + 1
							end

							-- Check with Collisions with starfighter
							if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
									game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

									if game_info.starfighter.curr_health < 0 then
										game_info.starfighter.set_curr_health (0)
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

					end

					is_turn_over := true
				else
					-- Do Nothing
				end
			end
		end

	action_when_starfighter_is_not_seen
		local
			i , j , damage_with_armour : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				from
					i := 1
				until
					i > 3
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
								i := 4
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

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
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

								game_info.grid.enemy_projectiles.at (j).set_col (99)
								game_info.grid.enemy_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.enemy_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end
								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
								game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
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
			end

			-- Reset is_turn_over
			is_turn_over := false
		end

	action_when_starfighter_is_seen
		local
			i , j , damage_with_armour : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				from
					i := 1
				until
					i > 3
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
								i := 4
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

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
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

								game_info.grid.enemy_projectiles.at (j).set_col (99)
								game_info.grid.enemy_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.enemy_projectiles.count + 1

								if game_info.grid.is_in_bounds (row_pos, col_pos) then
									discharge_after_death
								end
								set_row_pos (99)
								set_col_pos (99)
							end

							j := j + 1
						end

						-- Check with Collisions with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then
								game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - curr_health)

								if game_info.starfighter.curr_health < 0 then
									game_info.starfighter.set_curr_health (0)
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
			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end

