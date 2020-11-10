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
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 50
			health := 50
			health_regen := 0
			armour := 0
			vision := 5

			can_see_starfighter := false
			seen_by_starfighter := false

			symbol := 'I'

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

