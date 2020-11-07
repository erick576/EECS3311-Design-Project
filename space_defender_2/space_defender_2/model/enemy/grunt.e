note
	description: "Summary description for {GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRUNT

inherit
	ENEMY

create
	make

feature -- Initialization
	make (i : INTEGER)
		do
			id := i

			health := 100
			health_regen := 1
			armour := 1
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
