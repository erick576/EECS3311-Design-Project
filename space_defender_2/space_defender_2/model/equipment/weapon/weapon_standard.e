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

	-- Create Weapon Specific Projectile
	create_projectile (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			grid.add_friendly_projectile_standard (row, col, i, t)
		end

	fire
		do
			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos, starfighter.col_pos + 1, grid.projectile_id_counter, 1)

			-- Still have to cover spawning collisions cases TODO
		end

end
