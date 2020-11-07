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
			projectile_cost := 10
			is_projectile_cost_health := false

			type_name := "Spread"
			projectile_cost_type_name := "energy"
		end

feature -- Deferred Commands

	projectile_movement
		do

		end

end
