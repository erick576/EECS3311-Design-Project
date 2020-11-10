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
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 100
			health := 100
			health_regen := 1
			armour := 1
			vision := 5

			can_see_starfighter := false
			seen_by_starfighter := false

			symbol := 'G'

			row_pos := row
			col_pos := col
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
