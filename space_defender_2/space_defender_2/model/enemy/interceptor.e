note
	description: "Summary description for {INTERCEPTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCEPTOR

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 50
			health := 50
			health_regen := 0
			armour := 0
			vision := 5

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'I'

			row_pos := row
			col_pos := col
		end

feature -- Commands

	preemptive_action (type : CHARACTER)
		local
			i, j, distance : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then
				if type ~ 'F' then

					-- Preemptive Action on Fire
					enemy_seen := false
					distance := row_pos - game_info.starfighter.row_pos
					if col_pos /= game_info.starfighter.col_pos then

						from
							i := 1
						until
							i > distance.abs
						loop
							from
								j := 1
							until
								j > game_info.grid.enemies.count
							loop
								if row_pos > game_info.starfighter.row_pos then
									if game_info.grid.enemies.at (j).row_pos = row_pos - 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos - 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								else
									if game_info.grid.enemies.at (j).row_pos = row_pos + 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos + 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								end
								j := j + 1
							end

							if game_info.grid.is_in_bounds (row_pos, col_pos) then
								if row_pos > game_info.starfighter.row_pos then
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos - 1
									end
								else
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos + 1
									end
								end

								-- Collision Check TODO
							end
							i := i + 1
						end

					else -- col_pos = game_info.starfighter.col_pos

						from
							i := 1
						until
							i > distance.abs
						loop
							from
								j := 1
							until
								j > game_info.grid.enemies.count
							loop
								if row_pos > game_info.starfighter.row_pos then
									if game_info.grid.enemies.at (j).row_pos = row_pos - 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos - 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								else
									if game_info.grid.enemies.at (j).row_pos = row_pos + 1 and game_info.grid.enemies.at (j).col_pos = col_pos and game_info.grid.is_in_bounds (row_pos + 1, col_pos) then
										enemy_seen := true
										j := game_info.grid.enemies.count + 1
									end
								end
								j := j + 1
							end

							if game_info.grid.is_in_bounds (row_pos, col_pos) then
								if row_pos > game_info.starfighter.row_pos then
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos - 1
									end
								else
									if enemy_seen = true then -- If enemy is next then just stop
										i := distance.abs + 1
									else
										row_pos := row_pos + 1
									end
								end

								-- Collision Check TODO
							end
							i := i + 1
						end

					end

				else
					-- Do Nothing
				end
			end
		end

	action_when_starfighter_is_not_seen
		local
			i , j : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				from
					i := 1
				until
					i > 3
				loop
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if game_info.grid.enemies.at (j).row_pos = row_pos and game_info.grid.enemies.at (j).col_pos = col_pos - 1 and game_info.grid.is_in_bounds (row_pos, col_pos - 1) then
								enemy_seen := true
								j := game_info.grid.enemies.count + 1
								i := 4
							end
							j := j + 1
						end

						if enemy_seen = false then
							col_pos := col_pos - 1
						end

						-- Collision Check TODO
					end
					i := i + 1
				end
			end

			-- Reset is_turn_over
			is_turn_over := false
		end

	action_when_starfighter_is_seen
		local
			i , j : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				from
					i := 1
				until
					i > 3
				loop
					if game_info.grid.is_in_bounds (row_pos, col_pos) then
						from
							j := 1
						until
							j > game_info.grid.enemies.count
						loop
							if game_info.grid.enemies.at (j).row_pos = row_pos and game_info.grid.enemies.at (j).col_pos = col_pos - 1 and game_info.grid.is_in_bounds (row_pos, col_pos - 1) then
								enemy_seen := true
								j := game_info.grid.enemies.count + 1
								i := 4
							end
							j := j + 1
						end

						if enemy_seen = false then
							col_pos := col_pos - 1
						end

						-- Collision Check TODO
					end
					i := i + 1
				end
			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end

