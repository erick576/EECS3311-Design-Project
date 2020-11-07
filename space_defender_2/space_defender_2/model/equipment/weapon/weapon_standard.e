note
	description: "Summary description for {WEAPON_STANDARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_STANDARD

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 10
			energy := 10
			health_regen := 0
			energy_regen := 1
			armour := 0
			vision := 1
			move := 1
			move_cost := 1
			projectile_damage := 70
			projectile_cost := 5
			is_projectile_cost_health := false

			type_name := "Standard"
			projectile_cost_type_name := "energy"
		end

feature -- Deferred Commands

	projectile_movement
		do

		end

end
