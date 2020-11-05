note
	description: "Summary description for {ARMOUR_LIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_LIGHT

inherit
	ARMOUR

create
	make

feature -- Initialization
	make
		do
			health := 75
			energy := 0
			health_regen := 2
			energy_regen := 0
			armour := 3
			vision := 0
			move := 0
			move_cost := 1

			-- Irrelevant to Armour
			projectile_damage := 0
			projectile_health_cost := 0
			projectile_energy_cost := 0

			type_name := "Light"
		end

end
