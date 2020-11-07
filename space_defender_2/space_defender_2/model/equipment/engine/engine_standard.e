note
	description: "Summary description for {ENGINE_STANDARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_STANDARD

inherit
	ENGINE

create
	make

feature -- Initialization
	make
		do
			health := 10
			energy := 60
			health_regen := 0
			energy_regen := 2
			armour := 1
			vision := 12
			move := 8
			move_cost := 2

			-- Irrelevant to Engine
			projectile_damage := 0
			projectile_cost := 0

			type_name := "Standard"
		end
end
