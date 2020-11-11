note
	description: "Summary description for {ORBITAL_STRIKE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORBITAL_STRIKE

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 100
			is_health_cost := false
			type_name := "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour."
		end

feature -- Commands

	special_move
		local
			i , damage_with_armour : INTEGER
		do
			game_info.starfighter.set_curr_energy (game_info.starfighter.curr_energy - cost)

			from
				i := 1
			until
				i > game_info.grid.enemies.count
			loop
				if game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
					damage_with_armour := 100 - game_info.grid.enemies.at (i).armour
					if damage_with_armour < 0 then
						damage_with_armour := 0
					end

					game_info.grid.enemies.at (i).set_curr_health (game_info.grid.enemies.at (i).curr_health - damage_with_armour)

					if game_info.grid.enemies.at (i).curr_health < 0 then
						game_info.grid.enemies.at (i).set_curr_health (0)
					end
				end

				if game_info.grid.enemies.at (i).curr_health = 0 then
					game_info.grid.enemies.at (i).set_row_pos (99)
					game_info.grid.enemies.at (i).set_col_pos (99)
				end

				i := i + 1
			end
		end

end
