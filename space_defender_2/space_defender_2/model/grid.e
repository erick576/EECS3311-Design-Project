note
	description: "Summary description for {GRID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID

create
	make

feature -- Initialization
	make (row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		do
			row_size := row
			col_size := column
			grunt_threshold := g_threshold
			fighter_threshold := f_threshold
			carrier_threshold := c_threshold
			interceptor_threshold := i_threshold
			pylon_threshold := p_threshold

			projectile_id_counter := 0
			enemy_id_counter := 0

			create friendly_projectiles.make (0)
			create enemy_projectiles.make (0)
			create all_projectiles.make (0)

			create enemies.make (0)

			grid_char_rows := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'>>
			create grid_elements.make_filled ('_', 0, row_size * col_size)
		end

feature -- Attributes

	row_size : INTEGER_32
	col_size : INTEGER_32
	grunt_threshold : INTEGER_32
	fighter_threshold : INTEGER_32
	carrier_threshold : INTEGER_32
	interceptor_threshold : INTEGER_32
	pylon_threshold : INTEGER_32

	projectile_id_counter : INTEGER
	enemy_id_counter : INTEGER

	friendly_projectiles : ARRAYED_LIST[FRIENDLY_PROJECTILE]
	enemy_projectiles : ARRAYED_LIST[ENEMY_PROJECTILE]
	all_projectiles : ARRAYED_LIST[PROJECTILE]

	enemies : ARRAYED_LIST[ENEMY]

	grid_char_rows : ARRAY[CHARACTER]
	grid_elements : ARRAY[CHARACTER]


	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

feature -- Helper Methods

	can_see (starfighter : STARFIGHTER ; row : INTEGER ; column : INTEGER) : BOOLEAN
		-- Is this spot in the starfighters vision ?
		local
			column_diff, row_diff : INTEGER
		do
			if (starfighter.col_pos - column) >= 0 then
				column_diff := starfighter.col_pos - column
			else
				column_diff := column - starfighter.col_pos
			end

			if (starfighter.row_pos - row) >= 0 then
				row_diff := starfighter.row_pos - row
			else
				row_diff := row - starfighter.row_pos
			end

			if (starfighter.vision - (row_diff + column_diff)) < 0 then
				Result := false
			else
				Result := true
			end
		end

	can_be_seen (starfighter : STARFIGHTER ; enemy_vision : INTEGER ; enemy_row : INTEGER ; enemy_column : INTEGER) : BOOLEAN
		-- Can a Ememy see the starfighter?
		local
			column_diff, row_diff : INTEGER
		do
			if (enemy_column - starfighter.col_pos) >= 0 then
				column_diff := enemy_column - starfighter.col_pos
			else
				column_diff := starfighter.col_pos - enemy_column
			end

			if (enemy_row - starfighter.row_pos) >= 0 then
				row_diff := enemy_row - starfighter.row_pos
			else
				row_diff := starfighter.row_pos - enemy_row
			end

			if (enemy_vision - (row_diff + column_diff)) < 0 then
				Result := false
			else
				Result := true
			end
		end

	can_see_enemy (other_enemy : ENEMY ; enemy_vision : INTEGER ; enemy_row : INTEGER ; enemy_column : INTEGER) : BOOLEAN
		-- Can a Ememy see the enemy?
		local
			column_diff, row_diff : INTEGER
		do
			if (enemy_column - other_enemy.col_pos) >= 0 then
				column_diff := enemy_column - other_enemy.col_pos
			else
				column_diff := other_enemy.col_pos - enemy_column
			end

			if (enemy_row - other_enemy.row_pos) >= 0 then
				row_diff := enemy_row - other_enemy.row_pos
			else
				row_diff := other_enemy.row_pos - enemy_row
			end

			if (enemy_vision - (row_diff + column_diff)) < 0 then
				Result := false
			else
				Result := true
			end
		end

	is_in_bounds (row : INTEGER ; column : INTEGER) : BOOLEAN
		do
			Result := not (row > row_size or row < 1 or column > col_size or column < 1)
		end

feature -- Setters

	add_friendly_projectile_standard (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_STANDARD}.make (row, col, i, t))
		end

	add_friendly_projectile_spread (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_SPREAD}.make (row, col, i, t))
		end

	add_friendly_projectile_snipe (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_SNIPE}.make (row, col, i, t))
		end

	add_friendly_projectile_rocket (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_ROCKET}.make (row, col, i, t))
		end

	add_friendly_projectile_splitter (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			friendly_projectiles.force (create {FRIENDLY_PROJECTILE_SPLITTER}.make (row, col, i, t))
		end

	add_enemy_projectile_grunt (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_GRUNT}.make (row, col, i, t, d))
		end

	add_enemy_projectile_fighter (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_FIGHTER}.make (row, col, i, t, d))
		end

	add_enemy_projectile_carrier (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_CARRIER}.make (row, col, i, t, d))
		end

	add_enemy_projectile_interceptor (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_INTERCEPTOR}.make (row, col, i, t, d))
		end

	add_enemy_projectile_pylon (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			enemy_projectiles.force (create {ENEMY_PROJECTILE_PYLON}.make (row, col, i, t, d))
		end

	increment_projectile_id_counter
		do
			projectile_id_counter := projectile_id_counter - 1
		end

	increment_enemy_id_counter
		do
			enemy_id_counter := enemy_id_counter + 1
		end

feature -- Commands

	fire
		do
			game_info.starfighter.weapon_selected.fire
		end

	friendly_projectile_movements
		local
			index_curr : INTEGER
		do
			from
				index_curr := 1
			until
				index_curr > friendly_projectiles.count
			loop
				if game_info.starfighter.curr_health /= 0 then
					friendly_projectiles.at (index_curr).do_turn
				else
					index_curr := friendly_projectiles.count + 1
				end

				index_curr := index_curr + 1
			end
		end

	enemy_projectile_movements
		local
			index_curr : INTEGER
		do
			from
				index_curr := 1
			until
				index_curr > enemy_projectiles.count
			loop
				if game_info.starfighter.curr_health /= 0 then
					enemy_projectiles.at (index_curr).do_turn
				else
					index_curr := enemy_projectiles.count + 1
				end

				index_curr := index_curr + 1
			end
		end

	update_enemy_vision
		local
			index_curr : INTEGER
		do
			from
				index_curr := 1
			until
				index_curr > enemies.count
			loop
				if game_info.starfighter.curr_health /= 0 then
					if is_in_bounds (enemies.at (index_curr).row_pos , enemies.at (index_curr).col_pos) then
						enemies.at (index_curr).update_seen_by_starfighter
						enemies.at (index_curr).update_can_see_starfighter
					end
				else
					index_curr := enemies.count + 1
				end

				index_curr := index_curr + 1
			end
		end

	enemy_spawn
		local
			random : RANDOM_GENERATOR_ACCESS
			j , damage_with_armour: INTEGER
			first_num, second_num : INTEGER
			did_spawn , do_spawn : BOOLEAN
		do
			first_num := random.rchoose (1, row_size)
			second_num := random.rchoose (1, 100)

			-- Check if occupied
			do_spawn := true
			from
				j := 1
			until
				j > enemies.count
			loop
				if enemies.at (j).row_pos = first_num and enemies.at (j).col_pos = col_size then
					do_spawn := false
				end
				j := j + 1
			end

			if do_spawn = true then

				did_spawn := false

				if second_num >= 1 and second_num < grunt_threshold then
					-- Grunt Spawns
					increment_enemy_id_counter
					enemies.force (create {GRUNT}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= grunt_threshold and second_num < fighter_threshold then
					-- Fighter Spawns
					increment_enemy_id_counter
					enemies.force (create {FIGHTER}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= fighter_threshold and second_num < carrier_threshold then
					-- Carriern Spawns
					increment_enemy_id_counter
					enemies.force (create {CARRIER}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= carrier_threshold and second_num < interceptor_threshold then
					-- Interceptor Spawns
					increment_enemy_id_counter
					enemies.force (create {INTERCEPTOR}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				elseif second_num >= interceptor_threshold and second_num < pylon_threshold then
					-- Pylon Spawns
					increment_enemy_id_counter
					enemies.force (create {PYLON}.make (first_num, col_size, enemy_id_counter))
					did_spawn := true
				else
					-- Nothing Spawns
					did_spawn := false
				end

				-- Collision Checks
				if did_spawn = true then
					-- Collisions with Friendly Projectiles
					from
						j := 1
					until
						j > friendly_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = friendly_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = friendly_projectiles.at (j).col_pos then
							damage_with_armour := friendly_projectiles.at (j).damage - enemies.at (enemies.count).armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health - damage_with_armour)

							if enemies.at (enemies.count).curr_health < 0 then
								enemies.at (enemies.count).set_curr_health (0)
							end

							friendly_projectiles.at (j).set_col (99)
							friendly_projectiles.at (j).set_row (99)
						end

						if enemies.at (enemies.count).curr_health = 0 then
							j := friendly_projectiles.count + 1

							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
						end

						j := j + 1
					end


					-- Collisions with Enemy Projectiles
					from
						j := 1
					until
						j > enemy_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = enemy_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = enemy_projectiles.at (j).col_pos then
							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health + enemy_projectiles.at (j).damage)

							if enemies.at (enemies.count).curr_health > enemies.at (enemies.count).health then
								enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).health)
							end

							enemy_projectiles.at (j).set_col (99)
							enemy_projectiles.at (j).set_row (99)
						end

						if enemies.at (enemies.count).curr_health = 0 then
							j := enemy_projectiles.count + 1

							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
						end

						j := j + 1
					end


					-- Collision with the Starfighter
					if enemies.at (enemies.count).row_pos = game_info.starfighter.row_pos and enemies.at (enemies.count).col_pos = game_info.starfighter.col_pos then
							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - enemies.at (enemies.count).curr_health)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
					end

				end
			end
		end

	spawn_interceptor (row : INTEGER ; column : INTEGER)
		local
			i , j, damage_with_armour: INTEGER
			do_spawn : BOOLEAN
		do
			do_spawn := true
			from
				i := 1
			until
				i > enemies.count
			loop
				if enemies.at (i).row_pos = row and enemies.at (i).col_pos = column then
					do_spawn := false
				end
				i := i + 1
			end

			if do_spawn = true then
				increment_enemy_id_counter
				enemies.force (create {INTERCEPTOR}.make (row, column, enemy_id_counter))
				enemies.at (enemies.count).set_is_turn_over (true)

				if is_in_bounds (row, column) then

					-- Collisions with Friendly Projectiles
					from
						j := 1
					until
						j > friendly_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = friendly_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = friendly_projectiles.at (j).col_pos then
							damage_with_armour := friendly_projectiles.at (j).damage - enemies.at (enemies.count).armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health - damage_with_armour)

							if enemies.at (enemies.count).curr_health < 0 then
								enemies.at (enemies.count).set_curr_health (0)
							end

							friendly_projectiles.at (j).set_col (99)
							friendly_projectiles.at (j).set_row (99)
						end

						if enemies.at (enemies.count).curr_health = 0 then
							j := friendly_projectiles.count + 1

							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
						end

						j := j + 1
					end


					-- Collisions with Enemy Projectiles
					from
						j := 1
					until
						j > enemy_projectiles.count
					loop
						if enemies.at (enemies.count).row_pos = enemy_projectiles.at (j).row_pos and enemies.at (enemies.count).col_pos = enemy_projectiles.at (j).col_pos then
							enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).curr_health + enemy_projectiles.at (j).damage)

							if enemies.at (enemies.count).curr_health > enemies.at (enemies.count).health then
								enemies.at (enemies.count).set_curr_health (enemies.at (enemies.count).health)
							end

							enemy_projectiles.at (j).set_col (99)
							enemy_projectiles.at (j).set_row (99)
						end

						if enemies.at (enemies.count).curr_health = 0 then
							j := enemy_projectiles.count + 1

							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
						end

						j := j + 1
					end


					-- Collision with the Starfighter
					if enemies.at (enemies.count).row_pos = game_info.starfighter.row_pos and enemies.at (enemies.count).col_pos = game_info.starfighter.col_pos then
							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - enemies.at (enemies.count).curr_health)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							enemies.at (enemies.count).set_row_pos (99)
							enemies.at (enemies.count).set_col_pos (99)
					end
				end

			end
		end

	enemy_preemptive_action (type : CHARACTER)
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > enemies.count
			loop
				enemies.at (i).preemptive_action (type)

				if game_info.starfighter.curr_health = 0 then
					i := enemies.count + 1
				end

				i := i + 1
			end
		end

	enemy_action
		local
			i : INTEGER
		do
			from
				i := 1
			until
				i > enemies.count
			loop
				if enemies.at (i).can_see_starfighter then
					enemies.at (i).action_when_starfighter_is_seen
				else
					enemies.at (i).action_when_starfighter_is_not_seen
				end

				if game_info.starfighter.curr_health = 0 then
					i := enemies.count + 1
				end

				i := i + 1
			end
		end

end
