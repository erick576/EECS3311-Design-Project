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
			game_info.grid.add_friendly_projectile_standard (row, col, i, t)
		end

	fire
		local
			i : INTEGER
		do
			game_info.grid.increment_projectile_id_counter
			create_projectile (game_info.starfighter.row_pos, game_info.starfighter.col_pos + 1, game_info.grid.projectile_id_counter, 1)

			-- Spawn Collision Case with an Enemy Projectile

			-- Spawn Collision Case with an Friendly Projectile
			from
				i := 1
			until
				i > game_info.grid.friendly_projectiles.count - 1
			loop
				if game_info.grid.friendly_projectiles.at (i).row_pos = game_info.starfighter.row_pos and game_info.grid.friendly_projectiles.at (i).col_pos = (game_info.starfighter.col_pos + 1) then
					game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).set_damage (game_info.grid.friendly_projectiles.at (game_info.grid.friendly_projectiles.count).damage + game_info.grid.friendly_projectiles.at (i).damage)
					game_info.grid.friendly_projectiles.at (i).set_row (99)
					game_info.grid.friendly_projectiles.at (i).set_col (99)

					i := game_info.grid.friendly_projectiles.count
				end

				i := i + 1
			end

			-- Spawn Collision Case with an Enemy


		end

end
