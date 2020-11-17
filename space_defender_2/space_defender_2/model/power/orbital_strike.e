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

			-- Debug Mode Output
			if not game_info.in_normal_mode then
				game_info.append_starfighter_action_info ("    The Starfighter(id:0) uses special, unleashing a wave of energy." + "%N")
			end

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

					-- Debug Mode Output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      A " + game_info.grid.enemies.at (i).name + "(id:" + game_info.grid.enemies.at (i).id.out + ") at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "] takes " + damage_with_armour.out + " damage." + "%N")
					end
				end

				if game_info.grid.enemies.at (i).curr_health = 0 then
					if game_info.grid.is_in_bounds (game_info.grid.enemies.at (i).row_pos, game_info.grid.enemies.at (i).col_pos) then
						game_info.grid.enemies.at (i).discharge_after_death
					end

					-- Debug Mode Output
					if not game_info.in_normal_mode then
						game_info.append_starfighter_action_info ("      The " + game_info.grid.enemies.at (i).name + " at location [" + game_info.grid.grid_char_rows.at (game_info.grid.enemies.at (i).row_pos).out + "," + game_info.grid.enemies.at (i).col_pos.out + "] has been destroyed." + "%N")
					end

					game_info.grid.enemies.at (i).set_row_pos (99)
					game_info.grid.enemies.at (i).set_col_pos (99)
				end

				i := i + 1
			end
		end

end
