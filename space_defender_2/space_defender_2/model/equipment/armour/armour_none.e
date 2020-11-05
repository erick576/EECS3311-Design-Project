note
	description: "Summary description for {ARMOUR_NONE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_NONE

inherit
	ARMOUR

create
	make

feature -- Initialization
	make
		do
			health := 50
			energy := 0
			health_regen := 1
			energy_regen := 0
			armour := 0
			vision := 0
			move := 1
			move_cost := 0

			-- Irrelevant to Armour
			projectile_damage := 0
			projectile_health_cost := 0
			projectile_energy_cost := 0

			type_name := "None"
		end

end
