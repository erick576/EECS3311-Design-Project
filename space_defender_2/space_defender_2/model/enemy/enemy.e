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

	is_turn_over : BOOLEAN

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
			can_see_starfighter := game_info.grid.can_be_seen (game_info.starfighter, vision, row_pos, col_pos)
		end

	update_seen_by_starfighter
		do
			seen_by_starfighter := game_info.grid.can_see (game_info.starfighter, row_pos, col_pos)
		end

	regenerate
		do
			curr_health := curr_health + health_regen
			if curr_health > health then
				curr_health := health
			end
		end

	preemptive_action (type : CHARACTER)
		deferred end

	action_when_starfighter_is_not_seen
		deferred end

	action_when_starfighter_is_seen
		deferred end

	discharge_after_death
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

	set_is_turn_over (b : BOOLEAN)
		do
			is_turn_over := b
		end

feature -- Output Helpers

	can_see_starfighter_output : STRING
		do
			create Result.make_empty
			if can_see_starfighter = true then
				Result.append ("T")
			else
				Result.append ("F")
			end
		end

	seen_by_starfighter_output : STRING
		do
			create Result.make_empty
			if seen_by_starfighter = true then
				Result.append ("T")
			else
				Result.append ("F")
			end
		end
end
