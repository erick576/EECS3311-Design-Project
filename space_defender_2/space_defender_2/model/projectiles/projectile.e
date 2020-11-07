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

feature -- Commands

	do_turn (grid : GRID ; starfighter : STARFIGHTER ; game_info : GAME_INFO)
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

end
