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

	turn_frist_phase
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

	turn_second_phase
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

	turn_fourth_phase
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

	turn_sixth_phase
		do
			-- Do same thing as phase four
			turn_fourth_phase
		end

	enemy_spawn
		do
			
		end

end
