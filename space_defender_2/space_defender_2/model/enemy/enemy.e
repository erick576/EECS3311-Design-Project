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

  game_info: GAME_INFO
	local
		ma: ETF_MODEL_ACCESS
	do
		Result := ma.m.game_info
	end

feature -- Commands

--	For seen by Starfighter, set to true if the sum of the horizontal and vertical displacement between the
--	enemys location and the Starfighters location is less than or equal to the Starfighters vision. Set to false
--	otherwise

--	For can see Starfighter, set to true if the sum of the horizontal and vertical displacement between the
--	enemys location and the Starfighters location is less than or equal to the enemys vision. Set to false
--	otherwise

	can_see_starfighter : BOOLEAN
		do

		end

	seen_by_starfighter : BOOLEAN
		do

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
