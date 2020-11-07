note
	description: "Summary description for {WEAPON_SPLITTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SPLITTER

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
			energy_regen := 10
			armour := 0
			vision := 0
			move := 0
			move_cost := 5
			projectile_damage := 150
			projectile_cost := 70
			is_projectile_cost_health := false

			type_name := "Splitter"
			projectile_cost_type_name := "energy"
		end

feature -- Deferred Commands

	projectile_movement
		do

		end

end
