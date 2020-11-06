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

	make (row : INTEGER ; col : INTEGER)
		do
			--	id : INTEGER

		    --  row_pos : INTEGER
			--  col_pos : INTEGER
		end

feature -- Commands

	do_turn (grid : GRID ; starfighter : STARFIGHTER ; game_info : GAME_INFO)
		-- Turn Action for a Projectile
		do

		end

end
