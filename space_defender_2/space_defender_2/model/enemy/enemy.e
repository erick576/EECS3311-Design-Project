note
	description: "Summary description for {ENEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENEMY

feature -- Attributes

	id: INTEGER

	health : INTEGER
	health_regen : INTEGER
	armour : INTEGER
	vision : INTEGER

	row_pos : INTEGER
	col_pos : INTEGER

	starfighter : STARFIGHTER
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.starfighter
		end

	grid: GRID
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.grid
		end

feature -- Commands

	can_see_starfighter
		deferred end

	seen_by_starfighter
		deferred end

	preemptive_action
		deferred end

	action_when_starfighter_is_not_seen
		deferred end

	action_when_starfighter_is_seen
		deferred end

	do_turn
		deferred end

	regenerate
		deferred end

	move (row : INTEGER ; col : INTEGER)
		deferred end

feature -- Sertters

	set_row (row : INTEGER)
		do
			row_pos := row
		end

	set_col (col : INTEGER)
		do
			col_pos := col
		end

end
