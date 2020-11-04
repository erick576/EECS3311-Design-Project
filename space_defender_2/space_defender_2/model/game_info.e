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

			in_normal_mode := true
			is_alive := true
			is_error := false
			in_game := false
			is_valid_operation := true

			valid_operation_count := 0
			error_count := 0
		end

feature -- Atrributes

	in_normal_mode : BOOLEAN
	is_alive : BOOLEAN
	is_error : BOOLEAN
	in_game : BOOLEAN
	is_valid_operation : BOOLEAN

	valid_operation_count : INTEGER
	error_count : INTEGER

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
--	game_over_message : STRING
--	objects_display : STRING
--	grid_display : STRING



feature -- Set Messages

	play_error_1 : STRING = "Already in setup mode."
	play_error_2 : STRING = "Already in a game. Please abort to start a new one."
	play_error_3 : STRING = "Threshold values are not non-decreasing."

	setup_next_error_1 : STRING = "Command can only be used in setup mode."

	setup_back_error_1 : STRING = "Command can only be used in setup mode."

	setup_select_error_1 : STRING = "Command can only be used in setup mode (excluding summary in setup)."
	setup_select_error_2 : STRING = "Menu option selected out of range."

	abort_error_1 : STRING = "Command can only be used in setup mode or in game."

	move_error_1 : STRING = "Command can only be used in game."
	move_error_2 : STRING = "Cannot move outside of board."
	move_error_3 : STRING = "Already there."
	move_error_4 : STRING = "Out of movement range."
	move_error_5 : STRING = "Not enough resources to move."

	pass_error_1 : STRING = "Command can only be used in game."

	fire_error_1 : STRING = "Command can only be used in game."
	fire_error_2 : STRING = "Not enough resources to fire."

	special_error_1 : STRING = "Command can only be used in game."
	special_error_2 : STRING = "Not enough resources to use special."

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

	weapon_setup_message : STRING =
	"[
  1:Standard (A single projectile is fired in front)
    Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1,
    Projectile Damage:70, Projectile Cost:5 (energy)
  2:Spread (Three projectiles are fired in front, two going diagonal)
    Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2,
    Projectile Damage:50, Projectile Cost:10 (energy)
  3:Snipe (Fast and high damage projectile, but only travels via teleporting)
    Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0,
    Projectile Damage:1000, Projectile Cost:20 (energy)
  4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)
    Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3,
    Projectile Damage:100, Projectile Cost:10 (health)
  5:Splitter (A single mine projectile is placed in front of the Starfighter)
    Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5,
    Projectile Damage:150, Projectile Cost:70 (energy)
  Weapon Selected:TODO
	]"

	armour_setup_message : STRING =
	"[
  1:None
    Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0
  2:Light
    Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1
  3:Medium
    Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3
  4:Heavy
    Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5
  Armour Selected:TODO
	]"

	engine_setup_message : STRING =
	"[
  1:Standard
    Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2
  2:Light
    Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1
  3:Armoured
    Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5
  Engine Selected:TODO
	]"

	power_setup_message : STRING =
	"[
  1:Recall (50 energy): Teleport back to spawn.
  2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.
  3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.
  4:Deploy Drones (100 energy): Clear all projectiles.
  5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.
  Power Selected:TODO
	]"

	setup_summary_message : STRING =
	"[
  Weapon Selected:TODO
  Armour Selected:TODO
  Engine Selected:TODO
  Power Selected:TODO
	]"

	not_playing_message : STRING = "Welcome to Space Defender Version 2."

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

--	set_game_over_message (s : STRING)
--		do
--			game_over_message := s
--		end
--
--	set_grid_display
--		do
--			--TODO
--		end
--		
--	set_objects_display
--		do
--			--TODO
--		end

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
				Result := state_message + ", " + mode_message + ", " + status_message
			else
				Result := state_message + ", " + mode_message + ", " + status_message
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

--	display_grid : STRING
--		do
--			
--		end
--	
--	display_objects: STRING
--		do
--			
--		end

end
