note
	description: "Summary description for {WEAPON_SPREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SPREAD

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 0
			energy := 60
			health_regen := 0
			energy_regen := 2
			armour := 1
			vision := 0
			move := 0
			move_cost := 2
			projectile_damage := 50
			projectile_cost := 10
			is_projectile_cost_health := false

			type_name := "Spread"
			projectile_cost_type_name := "energy"
		end

feature -- Deferred Commands

	-- Create Weapon Specific Projectile
	create_projectile (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			grid.add_friendly_projectile_spread (row, col, i, t)
		end

	fire
		do
			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos - 1, starfighter.col_pos + 1, grid.projectile_id_counter, 1)

			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos, starfighter.col_pos + 1, grid.projectile_id_counter, 2)

			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos + 1, starfighter.col_pos + 1, grid.projectile_id_counter, 3)

			-- Still have to cover spawning collisions cases TODO
		end

end
