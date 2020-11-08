note
	description: "Summary description for {FRIENDLY_PROJECTILE_SNIPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_SNIPE

inherit
	FRIENDLY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			id := i

			type := t
			is_friendly := true

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		do
			if grid.is_in_bounds (row_pos, col_pos) then

				if type = 1 then

					col_pos := col_pos + 8

					-- Collision Check TODO
				end
				
			end
		end

end
