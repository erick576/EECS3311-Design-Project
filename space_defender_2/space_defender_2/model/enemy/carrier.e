note
	description: "Summary description for {CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARRIER

inherit
	ENEMY

create
	make

feature -- Initialization
	make (i : INTEGER)
		do
			id := i

			curr_health := 200
			health := 200
			health_regen := 10
			armour := 15
			vision := 15

			can_see_starfighter := false
			seen_by_starfighter := false

			symbol := 'C'

-- 			Apply Random Gnerator TODO
--			row_pos := 0
--			col_pos := 0
		end

feature -- Commands

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
