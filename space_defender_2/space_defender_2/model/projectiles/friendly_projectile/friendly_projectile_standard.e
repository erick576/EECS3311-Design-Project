note
	description: "Summary description for {FRIENDLY_PROJECTILE_STANDARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_STANDARD

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
		-- Turn Action for a Projectile
		local
			i : INTEGER
		do
			if grid.is_in_bounds (row_pos, col_pos) then

				if type = 1 then

					from
						i := 1
					until
						i > 5
					loop
						col_pos := col_pos + 1

						-- Collision Check TODO

						i := i + 1
					end

				end

			end
		end

end
