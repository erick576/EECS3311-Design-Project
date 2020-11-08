note
	description: "Summary description for {FRIENDLY_PROJECTILE_SPREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_SPREAD

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

			damage := 50

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		do
			if grid.is_in_bounds (row_pos, col_pos) then

				if type = 1 then

					row_pos := row_pos - 1
					col_pos := col_pos + 1

					-- Collision Check TODO

				elseif type = 2 then

					col_pos := col_pos + 1

					-- Collision Check TODO

				elseif type = 3 then

					row_pos := row_pos + 1
					col_pos := col_pos + 1

					-- Collision Check TODO

				end

			end
		end

end
