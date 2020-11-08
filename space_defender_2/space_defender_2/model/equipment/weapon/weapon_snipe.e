note
	description: "Summary description for {WEAPON_SNIPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SNIPE

inherit
	WEAPON

create
	make

feature -- Initialization

	make
		do
			health := 0
			energy := 100
			health_regen := 0
			energy_regen := 5
			armour := 0
			vision := 10
			move := 3
			move_cost := 0
			projectile_damage := 1000
			projectile_cost := 20
			is_projectile_cost_health := false

			type_name := "Snipe"
			projectile_cost_type_name := "energy"
		end

feature -- Deferred Commands

	-- Create Weapon Specific Projectile
	create_projectile (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			grid.add_friendly_projectile_snipe (row, col, i, t)
		end

	fire
		do
			grid.increment_projectile_id_counter
			create_projectile (starfighter.row_pos, starfighter.col_pos + 1, grid.projectile_id_counter, 1)

			-- Still have to cover spawning collisions cases TODO
		end

end
