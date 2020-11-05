note
	description: "Summary description for {INTERCEPTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCEPTOR

inherit
	ENEMY

create
	make

feature -- Initialization
	make
		do
--			id: INTEGER

			health := 50
			health_regen := 0
			armour := 0
			vision := 5

-- 			Apply Random Gnerator TODO
--			row_pos := 0
--			col_pos := 0
		end

feature -- Commands

	can_see_starfighter
		do

		end

	seen_by_starfighter
		do

		end

	preemptive_action
		do

		end

	action_when_starfighter_is_not_seen
		do

		end

	action_when_starfighter_is_seen
		do

		end

	do_turn
		do

		end

	regenerate
		do

		end

	move (row : INTEGER ; col : INTEGER)
		do

		end

end

