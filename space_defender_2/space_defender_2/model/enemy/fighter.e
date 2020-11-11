note
	description: "Summary description for {FIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIGHTER

inherit
	ENEMY

create
	make

feature -- Initialization
	make (row : INTEGER ; col : INTEGER ; i : INTEGER)
		do
			id := i

			curr_health := 150
			health := 150
			health_regen := 5
			armour := 10
			vision := 10

			can_see_starfighter := false
			seen_by_starfighter := false

			is_turn_over := false

			symbol := 'F'

			row_pos := row
			col_pos := col
		end

feature -- Commands

	preemptive_action (type : CHARACTER)
		local
			i , j : INTEGER
			enemy_seen : BOOLEAN
		do
			enemy_seen := false

			if type ~ 'F' then

				-- Preemptive Action on Fire
				armour := armour + 1

			elseif type ~ 'P' then

				-- Preemptive Action on Pass
				from
					i := 1
				until
					i > 6
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
								i := 7
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
					game_info.grid.add_enemy_projectile_fighter (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 1, 100)

					-- Spawn Collision Case with Starfighter
					-- Spawn Collision Case with an Enemy Projectile
					-- Spawn Collision Case with an Friendly Projectile
					-- Spawn Collision Case with an Enemy
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

				if curr_health > 0 and game_info.grid.is_in_bounds (row_pos, col_pos) then
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_fighter (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 2, 20)

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
					-- Fire Projectile

					game_info.grid.increment_projectile_id_counter
					game_info.grid.add_enemy_projectile_fighter (row_pos, col_pos - 1, game_info.grid.projectile_id_counter, 3, 50)

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
