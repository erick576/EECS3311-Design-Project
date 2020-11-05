note
	description: "Summary description for {WEAPON_ROCKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_ROCKET

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 10
			energy := 0
			health_regen := 10
			energy_regen := 0
			armour := 2
			vision := 2
			move := 0
			move_cost := 3
			projectile_damage := 100
			projectile_health_cost := 10
			projectile_energy_cost := 0

			type_name := "Rocket"
		end

feature -- Deferred Commands

	projectile_movement
		do

		end

end
