note
	description: "Summary description for {ENGINE_LIGHT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_LIGHT

inherit
	ENGINE

create
	make

feature -- Initialization
	make
		do
			health := 0
			energy := 30
			health_regen := 0
			energy_regen := 1
			armour := 0
			vision := 15
			move := 10
			move_cost := 1

			-- Irrelevant to Engine
			projectile_damage := 0
			projectile_health_cost := 0
			projectile_energy_cost := 0

			type_name := "Light"
		end
end
