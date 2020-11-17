note
	description: "Summary description for {REPAIR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REPAIR

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 50
			is_health_cost := false
			type_name := "Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap."
		end

feature -- Commands

	special_move
		do
			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy - cost)
			game_info.starfighter.set_curr_health (game_info.starfighter.curr_health + 50)

			-- Debug Mode Output
			if not game_info.in_normal_mode then
				game_info.append_starfighter_action_info ("    The Starfighter(id:0) uses special, gaining 50 health." + "%N")
			end
		end

end
