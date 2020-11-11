note
	description: "Summary description for {GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRUNT

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 100
			health := 100
			health_regen := 1
			armour := 1
			vision := 5

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'G'

			row_pos := row
			col_pos := col
		end

feature -- Commands

	preemptive_action (type : CHARACTER)
		do
			if type ~ 'P' then

				-- Preemptive Action on Pass
				health := health + 10
				curr_health := curr_health + 10

			elseif type ~ 'S' then

				-- Preemptive Action on Special
				health := health + 20
				curr_health := curr_health + 20

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

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_grunt (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 15)

					-- Spawn Collision Case with Starfighter
					-- Spawn Collision Case with an Enemy Projectile
					-- Spawn Collision Case with an Friendly Projectile
					-- Spawn Collision Case with an Enemy
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
					i > 4
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
								i := 5
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
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_grunt (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 15)

					-- Spawn Collision Case with Starfighter
					-- Spawn Collision Case with an Enemy Projectile
					-- Spawn Collision Case with an Friendly Projectile
					-- Spawn Collision Case with an Enemy
				end

			end

			-- Reset is_turn_over
			is_turn_over := false
		end

end
