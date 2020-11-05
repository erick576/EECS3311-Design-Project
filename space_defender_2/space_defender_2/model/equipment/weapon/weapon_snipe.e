note
	description: "Summary description for {WEAPON_SNIPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SNIPE

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 0
			energy := 100
			health_regen := 0
			energy_regen := 5
			armour := 0
			vision := 10
			move := 3
			move_cost := 0
			projectile_damage := 1000
			projectile_health_cost := 0
			projectile_energy_cost := 20

			type_name := "Snipe"
		end

feature -- Deferred Commands

	projectile_movement
		do

		end

end
