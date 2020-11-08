note
	description: "Summary description for {PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROJECTILE

feature -- Attributes

	id : INTEGER

	row_pos : INTEGER
	col_pos : INTEGER

	damage : INTEGER

	type : INTEGER
	is_friendly : BOOLEAN

	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

	grid: GRID
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.grid
		end

	starfighter: STARFIGHTER
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.starfighter
		end

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		deferred end

feature -- Setters

	set_row (row : INTEGER)
		do
			row_pos := row
		end

	set_col (col : INTEGER)
		do
			col_pos := col
		end

	set_damage (dam : INTEGER)
		do
			damage := dam
		end
end
