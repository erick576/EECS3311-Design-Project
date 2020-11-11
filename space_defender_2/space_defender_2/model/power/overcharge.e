note
	description: "Summary description for {OVERCHARGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OVERCHARGE

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 50
			is_health_cost := true
			type_name := "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap."
		end

feature -- Commands

	special_move
		local
			val : INTEGER
		do
			if game_info.starfighter.curr_health < 51 then
				val := game_info.starfighter.curr_health - 1
			else
				val := 50
			end

			game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - val)
			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy + (val * 2))
		end
end
