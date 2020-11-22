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

	move : INTEGER

	damage : INTEGER

	type : INTEGER
	is_friendly : BOOLEAN

	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		deferred end

feature -- Setters

	set_row (row : INTEGER)
		do
			row_pos := row
		ensure
			value_set_correctly : row_pos = row
		end

	set_col (col : INTEGER)
		do
			col_pos := col
		ensure
			value_set_correctly : col_pos = col
		end

	set_damage (dam : INTEGER)
		do
			damage := dam
		ensure
			value_set_correctly : damage = dam
		end
end
