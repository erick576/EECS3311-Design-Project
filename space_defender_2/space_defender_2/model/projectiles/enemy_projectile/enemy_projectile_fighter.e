note
	description: "Summary description for {ENEMY_PROJECTILE_FIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_FIGHTER

inherit
	ENEMY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
				id := i

			--	type : INTEGER
			is_friendly := false

		    --  row_pos : INTEGER
			--  col_pos : INTEGER
		end

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		do

		end

end
