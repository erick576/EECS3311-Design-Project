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

			row_pos := row
			col_pos := col
		end

feature -- Commands

	preemptive_action (type : CHARACTER)
		do
			if type ~ 'P' then

				-- Preemptive Action on Pass
				health := health + 10
				curr_health := curr_health + 10

			elseif type ~ 'S' then

				-- Preemptive Action on Special
				health := health + 20
				curr_health := curr_health + 20

			else
				-- Do Nothing
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

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

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

								set_row_pos (99)
								set_col_pos (99)
						end

					end
					i := i + 1
				end

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_grunt (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 15)

					-- Spawn Collision Case with Friendly Projectile
					from
						j := 1
					until
						j > game_info.grid.friendly_projectiles.count
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id /= game_info.grid.friendly_projectiles.at (j).id then
							if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
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
							if game_info.grid.enemy_projectiles.at (j).row_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos and game_info.grid.enemy_projectiles.at (j).col_pos = (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos - 1) then
								game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_damage (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage + game_info.grid.enemy_projectiles.at (j).damage)
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
						if game_info.grid.enemies.at (j).row_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos and game_info.grid.enemies.at (j).col_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos then
							damage_with_armour := game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage - game_info.grid.enemies.at (j).armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health - damage_with_armour)

							if game_info.grid.enemies.at (j).curr_health < 0 then
								game_info.grid.enemies.at (j).set_curr_health (0)
							end

							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)

							if game_info.grid.enemies.at (j).curr_health = 0 then
								game_info.grid.enemies.at (j).set_row_pos (99)
								game_info.grid.enemies.at (j).set_col_pos (99)
							end

							j := game_info.grid.enemies.count + 1
						end

						j := j + 1
					end


					-- Spawn Collision Case with an Starfighter

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

								game_info.grid.friendly_projectiles.at (j).set_col (99)
								game_info.grid.friendly_projectiles.at (j).set_row (99)
							end

							if curr_health = 0 then
								j := game_info.grid.friendly_projectiles.count + 1

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

								set_row_pos (99)
								set_col_pos (99)
						end

					end
					i := i + 1
				end

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_grunt (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 15)

					-- Spawn Collision Case with Friendly Projectile
					from
						j := 1
					until
						j > game_info.grid.friendly_projectiles.count
					loop
						if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).id /= game_info.grid.friendly_projectiles.at (j).id then
							if game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
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
						if game_info.grid.enemy_projectiles.at (j).row_pos = row_pos and game_info.grid.enemy_projectiles.at (j).col_pos = (col_pos - 1) then
							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_damage (game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage + game_info.grid.enemy_projectiles.at (j).damage)
							game_info.grid.enemy_projectiles.at (j).set_row (99)
							game_info.grid.enemy_projectiles.at (j).set_col (99)

							j := game_info.grid.enemy_projectiles.count
						end

						j := i + 1
					end


					-- Spawn Collision Case with an Enemy
					from
						j := 1
					until
						j > game_info.grid.enemies.count
					loop
						if game_info.grid.enemies.at (j).row_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).row_pos and game_info.grid.enemies.at (j).col_pos = game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).col_pos then
							damage_with_armour := game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).damage - game_info.grid.enemies.at (j).armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health - damage_with_armour)

							if game_info.grid.enemies.at (j).curr_health < 0 then
								game_info.grid.enemies.at (j).set_curr_health (0)
							end

							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
							game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)

							if game_info.grid.enemies.at (j).curr_health = 0 then
								game_info.grid.enemies.at (j).set_row_pos (99)
								game_info.grid.enemies.at (j).set_col_pos (99)
							end

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

						game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_row (99)
						game_info.grid.enemy_projectiles.at (game_info.grid.enemy_projectiles.count).set_col (99)
					end

				end

			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end
