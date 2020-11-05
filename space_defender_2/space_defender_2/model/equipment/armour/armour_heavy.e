note
	description: "Summary description for {ARMOUR_HEAVY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_HEAVY

inherit
	ARMOUR

create
	make

feature -- Initialization
	make
		do
			health := 200
			energy := 0
			health_regen := 4
			energy_regen := 0
			armour := 10
			vision := 0
			move := -1
			move_cost := 5

			-- Irrelevant to Armour
			projectile_damage := 0
			projectile_health_cost := 0
			projectile_energy_cost := 0

			type_name := "Heavy"
		end

end
