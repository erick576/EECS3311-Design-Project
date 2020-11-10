note
	description: "Summary description for {ENEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENEMY

feature -- Attributes

	id: INTEGER

	curr_health : INTEGER
	health : INTEGER
	health_regen : INTEGER
	armour : INTEGER
	vision : INTEGER

	row_pos : INTEGER
	col_pos : INTEGER

	can_see_starfighter : BOOLEAN
	seen_by_starfighter : BOOLEAN

	symbol : CHARACTER

  game_info: GAME_INFO
	local
		ma: ETF_MODEL_ACCESS
	do
		Result := ma.m.game_info
	end

feature -- Commands

	update_can_see_starfighter
		do
			can_see_starfighter := game_info.grid.can_see (game_info.starfighter, row_pos, col_pos)
		end

	update_seen_by_starfighter
		do
			seen_by_starfighter := game_info.grid.can_be_seen (game_info.starfighter, vision, row_pos, col_pos)
		end

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

feature -- Setters

	set_row_pos (row : INTEGER)
		do
			row_pos := row
		end

	set_col_pos (col : INTEGER)
		do
			col_pos := col
		end

	set_curr_health (i : INTEGER)
		do
			curr_health := i
		end

end
