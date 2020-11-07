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

			projectile_counter := 0
			ememy_counter := 0

			create friendly_projectiles.make (0)
			create enemy_projectiles.make (0)

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

	projectile_counter : INTEGER
	ememy_counter : INTEGER

	friendly_projectiles : ARRAYED_LIST[FRIENDLY_PROJECTILE]
	enemy_projectiles : ARRAYED_LIST[ENEMY_PROJECTILE]

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

feature -- Setters

feature -- Commands

	move
		do

		end

	fire
		do

		end

	pass
		do

		end

	turn_frist_part
		do

		end

	enemy_spawn
		do

		end

end
