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
			val , val_energy : INTEGER
		do
			if game_info.starfighter.curr_health < 51 then
				val := game_info.starfighter.curr_health - 1
			else
				val := 50
			end

			val_energy := val * 2

			-- Add Debug Output
			if not game_info.in_normal_mode then
				game_info.append_starfighter_action_info ("    The Starfighter(id:0) uses special, gaining " + val_energy.out + " energy at the expense of " + val.out + " health." + "%N")
			end

			game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - val)
			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy + val_energy)
		end
end
