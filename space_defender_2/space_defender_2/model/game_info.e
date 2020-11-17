note
	description: "Summary description for {GAME_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_INFO

create
	make

feature
	make
		do
			create error_message.make_empty
			create state_message.make_from_string (state_not_started)
			create mode_message.make_from_string (normal_mode)
			create status_message.make_from_string (ok_status)
			create state_specific_message.make_from_string (not_playing_message)
			create operation_message.make_empty
			create game_over_message.make_empty

			create enemy_info.make_empty
			create projectile_info.make_empty
			create friendly_projectile_action_info.make_empty
			create enemy_projectile_action_info.make_empty
			create starfighter_action_info.make_empty
			create enemy_action_info.make_empty
			create natural_enemy_spawn_info.make_empty

			in_normal_mode := true
			is_alive := true
			is_error := false
			in_game := false
			is_valid_operation := false

			valid_operation_count := 0
			error_count := 0

			create weapons.make_empty

			weapons.force (create {WEAPON_STANDARD}.make, weapons.count + 1)
			weapons.force (create {WEAPON_SPREAD}.make, weapons.count + 1)
			weapons.force (create {WEAPON_SNIPE}.make, weapons.count + 1)
			weapons.force (create {WEAPON_ROCKET}.make, weapons.count + 1)
			weapons.force (create {WEAPON_SPLITTER}.make, weapons.count + 1)

			create armours.make_empty

			armours.force (create {ARMOUR_NONE}.make, armours.count + 1)
			armours.force (create {ARMOUR_LIGHT}.make, armours.count + 1)
			armours.force (create {ARMOUR_MEDIUM}.make, armours.count + 1)
			armours.force (create {ARMOUR_HEAVY}.make, armours.count + 1)

			create engines.make_empty

			engines.force (create {ENGINE_STANDARD}.make, engines.count + 1)
			engines.force (create {ENGINE_LIGHT}.make, engines.count + 1)
			engines.force (create {ENGINE_ARMOURED}.make, engines.count + 1)

			create powers.make_empty

			powers.force (create {RECALL}.make, powers.count + 1)
			powers.force (create {REPAIR}.make, powers.count + 1)
			powers.force (create {OVERCHARGE}.make, powers.count + 1)
			powers.force (create {DEPLOY_DRONES}.make, powers.count + 1)
			powers.force (create {ORBITAL_STRIKE}.make, powers.count + 1)

		end

feature -- Atrributes

	in_normal_mode : BOOLEAN
	is_alive : BOOLEAN
	is_error : BOOLEAN
	in_game : BOOLEAN
	is_valid_operation : BOOLEAN

	valid_operation_count : INTEGER
	error_count : INTEGER

	weapons : ARRAY[WEAPON]
	armours : ARRAY[ARMOUR]
	engines : ARRAY[ENGINE]
	powers : ARRAY[POWER]

	grid: GRID
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.grid
		end

	starfighter: STARFIGHTER
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.starfighter
		end


feature {NONE} -- Attribute Messages

	error_message : STRING
	state_message : STRING
	mode_message : STRING
	status_message : STRING
	state_specific_message: STRING
	operation_message : STRING
	game_over_message : STRING

	enemy_info : STRING
	projectile_info : STRING
	friendly_projectile_action_info : STRING
    enemy_projectile_action_info : STRING
	starfighter_action_info : STRING
    enemy_action_info : STRING
	natural_enemy_spawn_info : STRING

feature -- Set Messages

	play_error_1 : STRING = "  Already in setup mode."
	play_error_2 : STRING = "  Already in a game. Please abort to start a new one."
	play_error_3 : STRING = "  Threshold values are not non-decreasing."

	setup_next_error_1 : STRING = "  Command can only be used in setup mode."

	setup_back_error_1 : STRING = "  Command can only be used in setup mode."

	setup_select_error_1 : STRING = "  Command can only be used in setup mode (excluding summary in setup)."
	setup_select_error_2 : STRING = "  Menu option selected out of range."

	abort_error_1 : STRING = "  Command can only be used in setup mode or in game."

	move_error_1 : STRING = "  Command can only be used in game."
	move_error_2 : STRING = "  Cannot move outside of board."
	move_error_3 : STRING = "  Already there."
	move_error_4 : STRING = "  Out of movement range."
	move_error_5 : STRING = "  Not enough resources to move."

	pass_error_1 : STRING = "  Command can only be used in game."

	fire_error_1 : STRING = "  Command can only be used in game."
	fire_error_2 : STRING = "  Not enough resources to fire."

	special_error_1 : STRING = "  Command can only be used in game."
	special_error_2 : STRING = "  Not enough resources to use special."

	state_not_started : STRING = "state:not started"
	state_weapon_setup : STRING = "state:weapon setup"
	state_armour_setup : STRING = "state:armour setup"
	state_engine_setup : STRING = "state:engine setup"
	state_power_setup : STRING = "state:power setup"
	state_setup_summary : STRING = "state:setup summary"
	state_in_game : STRING = "state:in game"

	normal_mode : STRING = "normal"
	debug_mode : STRING = "debug"

	ok_status : STRING = "ok"
	error_status : STRING = "error"

	weapon_setup_message : STRING
		do
			Create Result.make_empty
			Result.append ("  " + "1:Standard (A single projectile is fired in front)" + "%N")
			Result.append ("    " + "Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1," + "%N")
			Result.append ("    " + "Projectile Damage:70, Projectile Cost:5 (energy)" + "%N")
			Result.append ("  " + "2:Spread (Three projectiles are fired in front, two going diagonal)" + "%N")
			Result.append ("    " + "Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2," + "%N")
			Result.append ("    " + "Projectile Damage:50, Projectile Cost:10 (energy)" + "%N")
			Result.append ("  " + "3:Snipe (Fast and high damage projectile, but only travels via teleporting)" + "%N")
			Result.append ("    " + "Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0," + "%N")
			Result.append ("    " + "Projectile Damage:1000, Projectile Cost:20 (energy)" + "%N")
			Result.append ("  " + "4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)" + "%N")
			Result.append ("    " + "Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3," + "%N")
			Result.append ("    " + "Projectile Damage:100, Projectile Cost:10 (health)" + "%N")
			Result.append ("  " + "5:Splitter (A single mine projectile is placed in front of the Starfighter)" + "%N")
			Result.append ("    " + "Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5," + "%N")
			Result.append ("    " + "Projectile Damage:150, Projectile Cost:70 (energy)" + "%N")
			Result.append ("  " + "Weapon Selected:")
		end

	armour_setup_message : STRING
		do
			create Result.make_empty
			Result.append ("  " + "1:None" + "%N")
			Result.append ("    " + "Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0" + "%N")
			Result.append ("  " + "2:Light" + "%N")
			Result.append ("    " + "Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1" + "%N")
			Result.append ("  " + "3:Medium" + "%N")
			Result.append ("    " + "Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3" + "%N")
			Result.append ("  " + "4:Heavy" + "%N")
			Result.append ("    " + "Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5" + "%N")
			Result.append ("  " + "Armour Selected:")
		end

	engine_setup_message : STRING
		do
			create Result.make_empty
			Result.append ("  " + "1:Standard" + "%N")
			Result.append ("    " + "Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2" + "%N")
			Result.append ("  " + "2:Light" + "%N")
			Result.append ("    " + "Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1" + "%N")
			Result.append ("  " + "3:Armoured" + "%N")
			Result.append ("    " + "Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5" + "%N")
			Result.append ("  " + "Engine Selected:")
		end

	power_setup_message : STRING
		do
			create Result.make_empty
			Result.append ("  " + "1:Recall (50 energy): Teleport back to spawn." + "%N")
			Result.append ("  " + "2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap." + "%N")
			Result.append ("  " + "3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap." + "%N")
			Result.append ("  " + "4:Deploy Drones (100 energy): Clear all projectiles." + "%N")
			Result.append ("  " + "5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour." + "%N")
			Result.append ("  " + "Power Selected:")
		end

	setup_summary_weapon_message : STRING = "  Weapon Selected:"
	setup_summary_armour_message : STRING = "  Armour Selected:"
	setup_summary_engine_message : STRING = "  Engine Selected:"
	setup_summary_power_message : STRING = "  Power Selected:"

	not_playing_message : STRING = "  Welcome to Space Defender Version 2."

	abort_setup_operation_message : STRING = "  Exited from setup mode."
	abort_game_operation_message : STRING = "  Exited from game."

	starfighter_is_dead : STRING = "  The game is over. Better luck next time!"

	in_debug_mode_message : STRING = "  In debug mode."
	not_in_debug_mode_message : STRING = "  Not in debug mode."


feature -- Setters for messages

	set_error_message (s : STRING)
		do
			error_message := s
		end

	set_state_message (s : STRING)
		do
			state_message := s
		end

	set_mode_mesage (s : STRING)
		do
			mode_message := s
		end

	set_status_message (s : STRING)
		do
			status_message := s
		end

	set_state_specific_message (s : STRING)
		do
			state_specific_message := s
		end

	set_operation_message (s : STRING)
		do
			operation_message := s
		end

	set_game_over_message (s : STRING)
		do
			game_over_message := s
		end

	set_enemy_info (s : STRING)
		do
			enemy_info := s
		end

	set_projectile_info (s : STRING)
		do
			projectile_info := s
		end

	set_friendly_projectile_action_info (s : STRING)
		do
			friendly_projectile_action_info := s
		end

    set_enemy_projectile_action_info (s : STRING)
    	do
			enemy_projectile_action_info := s
    	end

	set_starfighter_action_info (s : STRING)
		do
			starfighter_action_info := s
		end

    set_enemy_action_info (s : STRING)
    	do
			enemy_action_info := s
    	end

	set_natural_enemy_spawn_info (s : STRING)
		do
			natural_enemy_spawn_info := s
		end

	append_enemy_info (s : STRING)
		do
			enemy_info.append (s)
			enemy_info.append ("%N")
		end

	append_projectile_info (s : STRING)
		do
			projectile_info.append (s)
			projectile_info.append ("%N")
		end

	append_friendly_projectile_action_info (s : STRING)
		do
			friendly_projectile_action_info.append (s)
		end

    append_enemy_projectile_action_info (s : STRING)
    	do
			enemy_projectile_action_info.append (s)
    	end

	append_starfighter_action_info (s : STRING)
		do
			starfighter_action_info.append (s)
			starfighter_action_info.append ("%N")

		end

    append_enemy_action_info (s : STRING)
    	do
			enemy_action_info.append (s)
			enemy_action_info.append ("%N")
    	end

	append_natural_enemy_spawn_info (s : STRING)
		do
			natural_enemy_spawn_info.append (s)
			natural_enemy_spawn_info.append ("%N")
		end

feature -- Setters for boolean queries

	set_in_normal_mode (b : BOOLEAN)
		do
			in_normal_mode := b
		end

	set_is_alive (b : BOOLEAN)
		do
			is_alive := b
		end

	set_is_error (b : BOOLEAN)
		do
			is_error := b
		end

	set_in_game (b : BOOLEAN)
		do
			in_game := b
		end

	set_is_valid_operation (b : BOOLEAN)
		do
			is_valid_operation := b
		end

	set_valid_operation_count (i : INTEGER)
		do
			valid_operation_count := i
		end
	set_error_count (i : INTEGER)
		do
			error_count := i
		end

feature -- Getters

	display_state : STRING
		do
			if in_game then
				-- TODO
				Result := "  " + state_message + "(" + valid_operation_count.out + "." + error_count.out + "), " + mode_message + ", " + status_message
			else
				Result := "  " + state_message + ", " + mode_message + ", " + status_message
			end
		end

	display_state_specific : STRING
		do
			Result := state_specific_message
		end

	display_operation : STRING
		do
			Result := operation_message
		end

	display_error : STRING
		do
			Result := error_message
		end

	display_game_over : STRING
		do
			Result := game_over_message
		end

	display_grid : STRING
		local
			i, j, count : INTEGER
		do
			-- Clear grid for new turn
			grid.grid_elements.make_filled ('_', 0, grid.row_size * grid.col_size)

			-- Place Starfighter on Grid
			grid.grid_elements.put ('S', ((starfighter.row_pos - 1) * grid.col_size) + starfighter.col_pos)

			-- If not alive then put a X instead
			if not is_alive then
				grid.grid_elements.put ('X', ((starfighter.row_pos - 1) * grid.col_size) + starfighter.col_pos)
			end

			-- Set Friendly Projectiles on Grid
			from
				i := 1
			until
				i > grid.friendly_projectiles.count
			loop
				if grid.is_in_bounds (grid.friendly_projectiles.at (i).row_pos, grid.friendly_projectiles.at (i).col_pos) then
					grid.grid_elements.put ('*', ((grid.friendly_projectiles.at (i).row_pos - 1) * grid.col_size) + grid.friendly_projectiles.at (i).col_pos)
				end
				i := i + 1
			end

			-- Set Enemy Projectiles on Grid
			from
				i := 1
			until
				i > grid.enemy_projectiles.count
			loop
				if grid.is_in_bounds (grid.enemy_projectiles.at (i).row_pos, grid.enemy_projectiles.at (i).col_pos) then
					grid.grid_elements.put ('<', ((grid.enemy_projectiles.at (i).row_pos - 1) * grid.col_size) + grid.enemy_projectiles.at (i).col_pos)
				end
				i := i + 1
			end

			-- Set Enemies on Grid
			from
				i := 1
			until
				i > grid.enemies.count
			loop
				if grid.is_in_bounds (grid.enemies.at (i).row_pos, grid.enemies.at (i).col_pos) then
					grid.grid_elements.put (grid.enemies.at (i).symbol, ((grid.enemies.at (i).row_pos - 1) * grid.col_size) + grid.enemies.at (i).col_pos)
				end
				i := i + 1
			end


			-- Set Vision Limits
			count := 1

			from
				i := 1
			until
				i > grid.row_size
			loop
				from
					j := 1
				until
					j > grid.col_size
				loop
					if not grid.can_see (starfighter, i, j) and in_normal_mode then
						grid.grid_elements.put ('?', count)
					end
					j := j  + 1
					count := count + 1
				end
				i := i + 1
			end


			-- Create Board Output
			create Result.make_empty
			Result.append("      ")
			from
				i := 1
			until
				i > grid.col_size
			loop
				if i = grid.col_size then
					Result.append (i.out)
				else
					Result.append (i.out)

					if i >= 9 then
						Result.append (" ")
					else
						Result.append ("  ")
					end
				end

				i := i + 1
			end

			Result.append ("%N")

			count := 1

			from
				i := 1
			until
				i > grid.row_size
			loop
				Result.append ("    " + grid.grid_char_rows.at (i).out + " ")

				from
					j := 1
				until
					j > grid.col_size
				loop
					if j = grid.col_size then
						Result.append (grid.grid_elements.at (count).out)
					else
						Result.append (grid.grid_elements.at (count).out + "  ")
					end
					j := j  + 1
					count := count + 1
				end

				if i < grid.row_size then
					Result.append ("%N")
				end

				i := i + 1
			end
		end

	display_objects: STRING
		do
			create Result.make_empty
			Result.append ("  Starfighter:")
			Result.append ("%N")
			Result.append ("    [0,S]->health:" + starfighter.curr_health.out + "/" + starfighter.health.out)
			Result.append (", energy:" + starfighter.curr_energy.out + "/" + starfighter.energy.out)
			Result.append (", Regen:" + starfighter.health_regen.out + "/" + starfighter.energy_regen.out + ", ")
			Result.append ("Armour:" + starfighter.armour.out + ", Vision:" + starfighter.vision.out + ", Move:" + starfighter.move.out)
			Result.append (", Move Cost:" + starfighter.move_cost.out + ", location:[" + grid.grid_char_rows.at (starfighter.row_pos).out + "," + starfighter.col_pos.out + "]")
			Result.append ("%N")
			Result.append ("      Projectile Pattern:" + starfighter.weapon_selected.type_name + ", Projectile Damage:" + starfighter.projectile_damage.out + ", Projectile Cost:" + starfighter.projectile_cost.out + " (" + starfighter.weapon_selected.projectile_cost_type_name + ")")
			Result.append ("%N")
			Result.append ("      Power:" + starfighter.power_selected.type_name)
			Result.append ("%N")
			Result.append ("      score:" + starfighter.score.out)
		end

	display_debug_mode : STRING
		do
			create Result.make_empty
			Result.append ("  Enemy:")
			Result.append ("%N")
			Result.append (enemy_info)
			Result.append ("  Projectile:")
			Result.append ("%N")
			Result.append (projectile_info)
			Result.append ("  Friendly Projectile Action:")
			Result.append ("%N")
			Result.append (friendly_projectile_action_info)
			Result.append ("  Enemy Projectile Action:")
			Result.append ("%N")
			Result.append (enemy_projectile_action_info)
			Result.append ("  Starfighter Action:")
			Result.append ("%N")
			Result.append (starfighter_action_info)
			Result.append ("  Enemy Action:")
			Result.append ("%N")
			Result.append (enemy_action_info)
			Result.append ("  Natural Enemy Spawn:")
			Result.append ("%N")
			Result.append (natural_enemy_spawn_info)

		end
end
