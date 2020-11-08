note
	description: "Summary description for {FRIENDLY_PROJECTILE_STANDARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_STANDARD

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

			damage := 70

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		local
			i , j , damage_with_armour: INTEGER
		do
			if grid.is_in_bounds (row_pos, col_pos) then

				if type = 1 then

					from
						i := 1
					until
						i > 5
					loop
						col_pos := col_pos + 1

						-- Check For Collisions with friendly Projectiles
						from
							j := 1
						until
							j > grid.friendly_projectiles.count
						loop
							if id /= grid.friendly_projectiles.at (j).id then
								if row_pos = grid.friendly_projectiles.at (j).row_pos and col_pos = grid.friendly_projectiles.at (j).col_pos then
									damage := damage + grid.friendly_projectiles.at (j).damage
									grid.friendly_projectiles.at (j).set_row (99)
									grid.friendly_projectiles.at (j).set_col (99)

									j := grid.friendly_projectiles.count + 1
								end
							end

							j := j + 1
						end


						-- Check For Collisions with enemy Projectiles

						-- Check with Collisions with enemies

						-- Check with Collision with starfighter
						if row_pos = starfighter.row_pos and col_pos = starfighter.col_pos then

							damage_with_armour := damage - starfighter.armour
							if damage_with_armour < 0 then
								damage_with_armour := 0
							end

							starfighter.set_curr_health (starfighter.curr_health - damage_with_armour)

							if starfighter.curr_health < 0 then
								starfighter.set_curr_health (0)
							end

							row_pos := 99
							col_pos := 99

							i := 6
						end

						i := i + 1
					end

				end

			end
		end

end
