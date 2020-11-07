note
	description: "Summary description for {ARMOUR_MEDIUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_MEDIUM

inherit
	ARMOUR

create
	make

feature -- Initialization
	make
		do
			health := 100
			energy := 0
			health_regen := 3
			energy_regen := 0
			armour := 5
			vision := 0
			move := 0
			move_cost := 3

			-- Irrelevant to Armour
			projectile_damage := 0
			projectile_cost := 0

			type_name := "Medium"
		end

end
