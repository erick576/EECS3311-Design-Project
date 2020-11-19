note
	description: "Summary description for {WEAPON_SPREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SPREAD

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 0
			energy := 60
			health_regen := 0
			energy_regen := 2
			armour := 1
			vision := 0
			move := 0
			move_cost := 2
			projectile_damage := 50
			projectile_cost := 10
			is_projectile_cost_health := false

			type_name := "Spread"
			projectile_cost_type_name := "energy"
		end

feature -- Deferred Commands

	-- Create Weapon Specific Projectile
	create_projectile (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			game_info.grid.add_friendly_projectile_spread (row, col, i, t)
		end

	fire
		local
			i , damage_with_armour : INTEGER
		do
			game_info.grid.increment_projectile_id_counter
			create_projectile (game_info.starfighter.row_pos - 1, game_info.starfighter.col_pos + 1, game_info.grid.projectile_id_counter, 1)

			-- Add to debug output
			if not game_info.in_normal_mode then
				if game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).row_pos, game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).col_pos) then
					game_info.append_starfighter_action_info ("      A friendly projectile(id:" + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).id.out + ") spawns at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).row_pos).out + "," + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).col_pos.out + "]." + "%N")
				else
					game_info.append_starfighter_action_info ("      A friendly projectile(id:" + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).id.out + ") spawns at location out of board." + "%N")
				end
			end

			-- Spawn Collision Case with an Enemy Projectile
			from
				i := 1
			until
				i > game_info.grid.enemy_projectiles.count
			loop
				if game_info.grid.enemy_projectiles.at (i).row_pos = (game_info.starfighter.row_pos - 1) and game_info.grid.enemy_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (i).row_pos, game_info.grid.enemy_projectiles.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (i).row_pos).out + "," + game_info.grid.enemy_projectiles.at (i).col_pos.out + "], negating damage." + "%N")
					end

					if game_info.grid.enemy_projectiles.at (i).damage > game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage then

						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)
						game_info.grid.enemy_projectiles.at (i).set_damage (game_info.grid.enemy_projectiles.at (i).damage - game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage)

					elseif game_info.grid.enemy_projectiles.at (i).damage < game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage then

						game_info.grid.enemy_projectiles.at (i).set_row (99)
						game_info.grid.enemy_projectiles.at (i).set_col (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage - game_info.grid.enemy_projectiles.at (i).damage)

					else
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)
						game_info.grid.enemy_projectiles.at (i).set_row (99)
						game_info.grid.enemy_projectiles.at (i).set_col (99)
					end

					i := game_info.grid.enemy_projectiles.count
				end

				i := i + 1
			end


			-- Spawn Collision Case with an Friendly Projectile
			from
				i := 1
			until
				i > game_info.grid.friendly_projectiles.count - 1
			loop
				if game_info.grid.friendly_projectiles.at (i).row_pos = (game_info.starfighter.row_pos - 1) and game_info.grid.friendly_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage + game_info.grid.friendly_projectiles.at (i).damage)

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (i).row_pos, game_info.grid.friendly_projectiles.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (i).row_pos).out + "," + game_info.grid.friendly_projectiles.at (i).col_pos.out + "], combining damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (i).set_row (99)
					game_info.grid.friendly_projectiles.at (i).set_col (99)

					i := game_info.grid.friendly_projectiles.count
				end

				i := i + 1
			end

			-- Spawn Collision Case with an Enemy
			from
				i := 1
			until
				i > game_info.grid.enemies.count
			loop
				if game_info.grid.enemies.at (i).row_pos = (game_info.starfighter.row_pos - 1) and game_info.grid.enemies.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					damage_with_armour := game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage - game_info.grid.enemies.at (i).armour
					if damage_with_armour < 0 then
						damage_with_armour := 0
					end

					game_info.grid.enemies.at (i).set_curr_health (game_info.grid.enemies.at (i).curr_health - damage_with_armour)

					if game_info.grid.enemies.at (i).curr_health < 0 then
						game_info.grid.enemies.at (i).set_curr_health (0)
					end

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with " + game_info.grid.enemies.at (i).name + "(id:" + game_info.grid.enemies.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "], dealing " + damage_with_armour.out + " damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)

					if game_info.grid.enemies.at (i).curr_health = 0 then
						if game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
							game_info.grid.enemies.at (i).discharge_after_death
						end

						-- Add to debug output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
							game_info.append_starfighter_action_info ("      The " + game_info.grid.enemies.at (i).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "] has been destroyed." + "%N")
						end

						game_info.grid.enemies.at (i).set_row_pos (99)
						game_info.grid.enemies.at (i).set_col_pos (99)
					end

					i := game_info.grid.enemies.count + 1
				end

				i := i + 1
			end



			game_info.grid.increment_projectile_id_counter
			create_projectile (game_info.starfighter.row_pos, game_info.starfighter.col_pos + 1, game_info.grid.projectile_id_counter, 2)

			-- Add to debug output
			if not game_info.in_normal_mode then
				if game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).row_pos, game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).col_pos) then
					game_info.append_starfighter_action_info ("      A friendly projectile(id:" + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).id.out + ") spawns at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).row_pos).out + "," + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).col_pos.out + "]." + "%N")
				else
					game_info.append_starfighter_action_info ("      A friendly projectile(id:" + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).id.out + ") spawns at location out of board." + "%N")
				end
			end

			-- Spawn Collision Case with an Enemy Projectile
			from
				i := 1
			until
				i > game_info.grid.enemy_projectiles.count
			loop
				if game_info.grid.enemy_projectiles.at (i).row_pos = (game_info.starfighter.row_pos) and game_info.grid.enemy_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (i).row_pos, game_info.grid.enemy_projectiles.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (i).row_pos).out + "," + game_info.grid.enemy_projectiles.at (i).col_pos.out + "], negating damage." + "%N")
					end

					if game_info.grid.enemy_projectiles.at (i).damage > game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage then

						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)
						game_info.grid.enemy_projectiles.at (i).set_damage (game_info.grid.enemy_projectiles.at (i).damage - game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage)

					elseif game_info.grid.enemy_projectiles.at (i).damage < game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage then

						game_info.grid.enemy_projectiles.at (i).set_row (99)
						game_info.grid.enemy_projectiles.at (i).set_col (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage - game_info.grid.enemy_projectiles.at (i).damage)

					else
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)
						game_info.grid.enemy_projectiles.at (i).set_row (99)
						game_info.grid.enemy_projectiles.at (i).set_col (99)
					end

					i := game_info.grid.enemy_projectiles.count
				end

				i := i + 1
			end


			-- Spawn Collision Case with an Friendly Projectile
			from
				i := 1
			until
				i > game_info.grid.friendly_projectiles.count - 1
			loop
				if game_info.grid.friendly_projectiles.at (i).row_pos = game_info.starfighter.row_pos and game_info.grid.friendly_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage + game_info.grid.friendly_projectiles.at (i).damage)

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (i).row_pos, game_info.grid.friendly_projectiles.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (i).row_pos).out + "," + game_info.grid.friendly_projectiles.at (i).col_pos.out + "], combining damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (i).set_row (99)
					game_info.grid.friendly_projectiles.at (i).set_col (99)

					i := game_info.grid.friendly_projectiles.count
				end

				i := i + 1
			end

			-- Spawn Collision Case with an Enemy
			from
				i := 1
			until
				i > game_info.grid.enemies.count
			loop
				if game_info.grid.enemies.at (i).row_pos = (game_info.starfighter.row_pos) and game_info.grid.enemies.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					damage_with_armour := game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage - game_info.grid.enemies.at (i).armour
					if damage_with_armour < 0 then
						damage_with_armour := 0
					end

					game_info.grid.enemies.at (i).set_curr_health (game_info.grid.enemies.at (i).curr_health - damage_with_armour)

					if game_info.grid.enemies.at (i).curr_health < 0 then
						game_info.grid.enemies.at (i).set_curr_health (0)
					end

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with " + game_info.grid.enemies.at (i).name + "(id:" + game_info.grid.enemies.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "], dealing " + damage_with_armour.out + " damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)

					if game_info.grid.enemies.at (i).curr_health = 0 then
						if game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
							game_info.grid.enemies.at (i).discharge_after_death
						end

						-- Add to debug output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
							game_info.append_starfighter_action_info ("      The " + game_info.grid.enemies.at (i).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "] has been destroyed." + "%N")
						end

						game_info.grid.enemies.at (i).set_row_pos (99)
						game_info.grid.enemies.at (i).set_col_pos (99)
					end

					i := game_info.grid.enemies.count + 1
				end

				i := i + 1
			end



			game_info.grid.increment_projectile_id_counter
			create_projectile (game_info.starfighter.row_pos + 1, game_info.starfighter.col_pos + 1, game_info.grid.projectile_id_counter, 3)

			-- Add to debug output
			if not game_info.in_normal_mode then
				if game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).row_pos, game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).col_pos) then
					game_info.append_starfighter_action_info ("      A friendly projectile(id:" + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).id.out + ") spawns at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).row_pos).out + "," + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).col_pos.out + "]." + "%N")
				else
					game_info.append_starfighter_action_info ("      A friendly projectile(id:" + game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).id.out + ") spawns at location out of board." + "%N")
				end
			end

			-- Spawn Collision Case with an Enemy Projectile
			from
				i := 1
			until
				i > game_info.grid.enemy_projectiles.count
			loop
				if game_info.grid.enemy_projectiles.at (i).row_pos = (game_info.starfighter.row_pos + 1) and game_info.grid.enemy_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemy_projectiles.at (i).row_pos, game_info.grid.enemy_projectiles.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with enemy projectile(id:" + game_info.grid.enemy_projectiles.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemy_projectiles.at (i).row_pos).out + "," + game_info.grid.enemy_projectiles.at (i).col_pos.out + "], negating damage." + "%N")
					end

					if game_info.grid.enemy_projectiles.at (i).damage > game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage then

						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)
						game_info.grid.enemy_projectiles.at (i).set_damage (game_info.grid.enemy_projectiles.at (i).damage - game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage)

					elseif game_info.grid.enemy_projectiles.at (i).damage < game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage then

						game_info.grid.enemy_projectiles.at (i).set_row (99)
						game_info.grid.enemy_projectiles.at (i).set_col (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage - game_info.grid.enemy_projectiles.at (i).damage)

					else
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
						game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)
						game_info.grid.enemy_projectiles.at (i).set_row (99)
						game_info.grid.enemy_projectiles.at (i).set_col (99)
					end

					i := game_info.grid.enemy_projectiles.count
				end

				i := i + 1
			end

			-- Spawn Collision Case with an Friendly Projectile
			from
				i := 1
			until
				i > game_info.grid.friendly_projectiles.count - 1
			loop
				if game_info.grid.friendly_projectiles.at (i).row_pos = (game_info.starfighter.row_pos + 1) and game_info.grid.friendly_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage + game_info.grid.friendly_projectiles.at (i).damage)

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.friendly_projectiles.at (i).row_pos, game_info.grid.friendly_projectiles.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with friendly projectile(id:" + game_info.grid.friendly_projectiles.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.friendly_projectiles.at (i).row_pos).out + "," + game_info.grid.friendly_projectiles.at (i).col_pos.out + "], combining damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (i).set_row (99)
					game_info.grid.friendly_projectiles.at (i).set_col (99)

					i := game_info.grid.friendly_projectiles.count
				end

				i := i + 1
			end

			-- Spawn Collision Case with an Enemy
			from
				i := 1
			until
				i > game_info.grid.enemies.count
			loop
				if game_info.grid.enemies.at (i).row_pos = (game_info.starfighter.row_pos + 1) and game_info.grid.enemies.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					damage_with_armour := game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage - game_info.grid.enemies.at (i).armour
					if damage_with_armour < 0 then
						damage_with_armour := 0
					end

					game_info.grid.enemies.at (i).set_curr_health (game_info.grid.enemies.at (i).curr_health - damage_with_armour)

					if game_info.grid.enemies.at (i).curr_health < 0 then
						game_info.grid.enemies.at (i).set_curr_health (0)
					end

					-- Add to debug output
					if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
						game_info.append_starfighter_action_info ("      The projectile collides with " + game_info.grid.enemies.at (i).name + "(id:" + game_info.grid.enemies.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "], dealing " + damage_with_armour.out + " damage." + "%N")
					end

					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_row (99)
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_col (99)

					if game_info.grid.enemies.at (i).curr_health = 0 then
						if game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
							game_info.grid.enemies.at (i).discharge_after_death
						end

						-- Add to debug output
						if not game_info.in_normal_mode and game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
							game_info.append_starfighter_action_info ("      The " + game_info.grid.enemies.at (i).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "] has been destroyed." + "%N")
						end

						game_info.grid.enemies.at (i).set_row_pos (99)
						game_info.grid.enemies.at (i).set_col_pos (99)
					end

					i := game_info.grid.enemies.count + 1
				end

				i := i + 1
			end


		end

end
