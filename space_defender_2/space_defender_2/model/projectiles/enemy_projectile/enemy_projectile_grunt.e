note
	description: "Summary description for {ENEMY_PROJECTILE_GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_GRUNT

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
		local
			i : INTEGER
		do

			if type = 1 then

				from
					i := 1
				until
					i > 4
				loop
					col_pos := col_pos - 1

					-- Collision Check TODO

					i := i + 1
				end
			end

		end

end
