note
	description: "Summary description for {FRIENDLY_PROJECTILE_SPLITTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_SPLITTER

inherit
	FRIENDLY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
				id := i

		    --  row_pos : INTEGER
			--  col_pos : INTEGER
		end

feature -- Commands

	do_turn (grid : GRID ; starfighter : STARFIGHTER ; game_info : GAME_INFO)
		-- Turn Action for a Projectile
		do

		end

end
