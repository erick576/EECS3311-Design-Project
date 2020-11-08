note
	description: "Summary description for {WEAPON_ROCKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_ROCKET

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 10
			energy := 0
			health_regen := 10
			energy_regen := 0
			armour := 2
			vision := 2
			move := 0
			move_cost := 3
			projectile_damage := 100
			projectile_cost := 10
			is_projectile_cost_health := true

			type_name := "Rocket"
			projectile_cost_type_name := "health"

		end

feature -- Deferred Commands

	-- Create Weapon Specific Projectile
	create_projectile (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			grid.add_friendly_projectile_rocket (row, col, i, t)
		end

	fire
		do
			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos - 1, starfighter.col_pos - 1, grid.projectile_id_counter, 1)

			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos + 1, starfighter.col_pos - 1, grid.projectile_id_counter, 2)

			-- Still have to cover spawning collisions cases TODO
		end

end
