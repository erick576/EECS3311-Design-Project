note
	description: "Summary description for {DEPLOY_DRONES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEPLOY_DRONES

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 100
			is_health_cost := false
			type_name := "Deploy Drones (100 energy): Clear all projectiles."
		end

feature -- Commands

	special_move
		do
			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy - cost)
			game_info.grid.friendly_projectiles.wipe_out
			game_info.grid.enemy_projectiles.wipe_out
		end

end
