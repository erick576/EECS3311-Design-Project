note
	description: "Summary description for {ENEMY_PROJECTILE_CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_CARRIER

inherit
	ENEMY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			id := i

			type := t
			is_friendly := false

			damage := d

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		do
			-- Do Nothing
		end

end
