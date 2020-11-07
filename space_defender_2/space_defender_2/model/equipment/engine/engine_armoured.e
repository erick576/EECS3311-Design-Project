note
	description: "Summary description for {ENGINE_ARMOURED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_ARMOURED

inherit
	ENGINE

create
	make

feature -- Initialization
	make
		do
			health := 50
			energy := 100
			health_regen := 0
			energy_regen := 3
			armour := 3
			vision := 6
			move := 4
			move_cost := 5

			-- Irrelevant to Engine
			projectile_damage := 0
			projectile_cost := 0

			type_name := "Armoured"
		end

end
