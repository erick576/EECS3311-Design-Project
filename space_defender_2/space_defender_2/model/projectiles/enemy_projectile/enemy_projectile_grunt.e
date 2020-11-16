note
	description: "Summary description for {ENEMY_PROJECTILE_GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENEMY_PROJECTILE_GRUNT

inherit
	ENEMY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER ; d : INTEGER)
		do
			id := i

			type := t
			is_friendly := false
			move := 4

			damage := d

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		local
			i , j, damage_with_armour : INTEGER
		do

			if type = 1 then

				from
					i := 1
				until
					i > 4
				loop
					col_pos := col_pos - 1

					-- Check with Collisions with friendly projectiles
					from
						j := 1
					until
						j > game_info.grid.friendly_projectiles.count
					loop
						if id /= game_info.grid.friendly_projectiles.at (j).id then
							if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
								if game_info.grid.friendly_projectiles.at (j).damage > damage then

									set_row (99)
									set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_damage (game_info.grid.friendly_projectiles.at (j).damage - damage)

								elseif game_info.grid.friendly_projectiles.at (j).damage < damage then

									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)
									set_damage (damage - game_info.grid.friendly_projectiles.at (j).damage)

								else
									set_row (99)
									set_col (99)
									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)
								end

								j := game_info.grid.friendly_projectiles.count + 1
							end
						end
						j := j + 1
					end


					-- Check with Collisions with enemy projectiles
					from
						j := 1
					until
						j > game_info.grid.enemy_projectiles.count
					loop
						if id /= game_info.grid.enemy_projectiles.at (j).id then
							if row_pos = game_info.grid.enemy_projectiles.at (j).row_pos and col_pos = game_info.grid.enemy_projectiles.at (j).col_pos then
								damage := damage + game_info.grid.enemy_projectiles.at (j).damage
								game_info.grid.enemy_projectiles.at (j).set_row (99)
								game_info.grid.enemy_projectiles.at (j).set_col (99)

								j := game_info.grid.enemy_projectiles.count + 1
							end
						end

						j := j + 1
					end


					-- Check with Collisions with enemies
					from
						j := 1
					until
						j > game_info.grid.enemies.count
					loop
						if row_pos = game_info.grid.enemies.at (j).row_pos and col_pos = game_info.grid.enemies.at (j).col_pos then

							game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).curr_health + damage)

							if game_info.grid.enemies.at (j).curr_health > game_info.grid.enemies.at (j).health then
								game_info.grid.enemies.at (j).set_curr_health (game_info.grid.enemies.at (j).health)
							end

							set_row (99)
							set_col (99)

							j := game_info.grid.enemies.count + 1
						end

						j := j + 1
					end



					-- Check with Collisions with starfighter
					if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then

						damage_with_armour := damage - game_info.starfighter.armour
						if damage_with_armour < 0 then
							damage_with_armour := 0
						end

						game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

						if game_info.starfighter.curr_health < 0 then
							game_info.starfighter.set_curr_health (0)
						end

						set_row (99)
						set_col (99)
					end


					i := i + 1
				end
			end

		end

end
