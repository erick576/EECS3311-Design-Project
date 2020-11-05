note
	description: "Summary description for {WEAPON_SPREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SPREAD

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 0
			energy := 60
			health_regen := 0
			energy_regen := 2
			armour := 1
			vision := 0
			move := 0
			move_cost := 2
			projectile_damage := 50
			projectile_health_cost := 0
			projectile_energy_cost := 10

			type_name := "Spread"
		end

feature -- Deferred Commands

	projectile_movement
		do

		end

end
