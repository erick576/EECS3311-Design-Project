note
	description: "Summary description for {CARRIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CARRIER

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 200
			health := 200
			health_regen := 10
			armour := 15
			vision := 15

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'C'

			row_pos := row
			col_pos := col
		end

feature -- Commands

	preemptive_action (type : CHARACTER)
		local
			i , j : INTEGER
			enemy_seen : BOOLEAN
		do
			if type ~ 'S' then

				-- Preemptive Action on Special
				health_regen := health_regen + 10

			elseif type ~ 'P' then

				-- Preemptive Action on Pass
				enemy_seen := false

				from
					i := 1
				until
					i > 2
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
								i := 3
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

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Spawn Two Interceptors
					game_info.grid.spawn_interceptor (row_pos - 1, col_pos)
					game_info.grid.spawn_interceptor (row_pos + 1, col_pos)
				end

				-- Turn is now over
				is_turn_over := true

			else
				-- Do Nothing
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
					i > 2
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
								i := 3
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
			j : INTEGER
			enemy_seen : BOOLEAN
		do
			if is_turn_over = false then

				regenerate

				-- Do Action
				enemy_seen := false
				if game_info.grid.is_in_bounds (row_pos, col_pos) then
					from
						j := 1
					until
						j > game_info.grid.enemies.count
					loop
						if game_info.grid.enemies.at (j).row_pos = row_pos and game_info.grid.enemies.at (j).col_pos = col_pos - 1 and game_info.grid.is_in_bounds (row_pos, col_pos - 1) then
							enemy_seen := true
							j := game_info.grid.enemies.count + 1
						end
						j := j + 1
					end

					if enemy_seen = false then
						col_pos := col_pos - 1
					end

					-- Collision Check TODO
				end

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Spawn Interceptor
					game_info.grid.spawn_interceptor (row_pos, col_pos - 1)
				end
			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end
