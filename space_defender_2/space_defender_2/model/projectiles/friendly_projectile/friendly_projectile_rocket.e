note
	description: "Summary description for {FRIENDLY_PROJECTILE_ROCKET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_ROCKET

inherit
	FRIENDLY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			id := i

			type := t
			is_friendly := true
			turn := 1

			damage := 100

		    row_pos := row
			col_pos := col
		end

feature -- Attribute

	turn : INTEGER

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		local
			i , j , damage_with_armour: INTEGER
		do
			if game_info.grid.is_in_bounds (row_pos, col_pos) then

				if type = 1 then

					from
						i := 1
					until
						i > turn
					loop
						col_pos := col_pos + 1

						-- Check For Collisions with friendly Projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if id /= game_info.grid.friendly_projectiles.at (j).id then
								if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
									damage := damage + game_info.grid.friendly_projectiles.at (j).damage
									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)

									j := game_info.grid.friendly_projectiles.count + 1
								end
							end

							j := j + 1
						end


						-- Check For Collisions with enemy Projectiles

						-- Check with Collisions with enemies

						-- Check with Collision with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then

							damage_with_armour := damage - game_info.starfighter.armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							row_pos := 99
							col_pos := 99

							i := turn + 1
						end

						i := i + 1
					end

				elseif type = 2 then

					from
						i := 1
					until
						i > turn
					loop
						col_pos := col_pos + 1

						-- Check For Collisions with friendly Projectiles
						from
							j := 1
						until
							j > game_info.grid.friendly_projectiles.count
						loop
							if id /= game_info.grid.friendly_projectiles.at (j).id then
								if row_pos = game_info.grid.friendly_projectiles.at (j).row_pos and col_pos = game_info.grid.friendly_projectiles.at (j).col_pos then
									damage := damage + game_info.grid.friendly_projectiles.at (j).damage
									game_info.grid.friendly_projectiles.at (j).set_row (99)
									game_info.grid.friendly_projectiles.at (j).set_col (99)

									j := game_info.grid.friendly_projectiles.count + 1
								end
							end

							j := j + 1
						end


						-- Check For Collisions with enemy Projectiles

						-- Check with Collisions with enemies

						-- Check with Collision with starfighter
						if row_pos = game_info.starfighter.row_pos and col_pos = game_info.starfighter.col_pos then

							damage_with_armour := damage - game_info.starfighter.armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							game_info.starfighter.set_curr_health (game_info.starfighter.curr_health - damage_with_armour)

							if game_info.starfighter.curr_health < 0 then
								game_info.starfighter.set_curr_health (0)
							end

							row_pos := 99
							col_pos := 99

							i := turn + 1
						end

						i := i + 1
					end

				end

				turn := turn * 2

			end
		end

end
