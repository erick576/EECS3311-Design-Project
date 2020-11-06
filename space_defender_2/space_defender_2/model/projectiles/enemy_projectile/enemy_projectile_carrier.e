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
