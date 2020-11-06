note
	description: "Summary description for {STARFIGHTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARFIGHTER

create
	make

feature -- Initialization
	make
		do
			id := 0

--			col_pos : INTEGER
--			row_pos : INTEGER

--			health : INTEGER
--			energy : INTEGER
--			health_regen : INTEGER
--			energy_regen : INTEGER
--			vision : INTEGER
--			move_cost : INTEGER
--			projectile_damage : INTEGER
--			projectile_cost : INTEGER

--			score : INTEGER

			weapon_selected := create {WEAPON_STANDARD}.make
			armour_selected := create {ARMOUR_NONE}.make
			engine_selected := create {ENGINE_STANDARD}.make
			power_selected := create {RECALL}.make

		end


feature -- Attributes

	id : INTEGER

	col_pos : INTEGER
	row_pos : INTEGER

	health : INTEGER
	energy : INTEGER
	health_regen : INTEGER
	energy_regen : INTEGER
	vision : INTEGER
	move_cost : INTEGER
	projectile_damage : INTEGER
	projectile_cost : INTEGER

	score : INTEGER

	weapon_selected : WEAPON
	armour_selected : ARMOUR
	engine_selected : ENGINE
	power_selected : POWER

feature -- Commands

	regenerate
		do

		end

feature -- Setters for Setting State

	set_weapon (weapon : WEAPON)
		do
			weapon_selected := weapon
		end

	set_armour (armour : ARMOUR)
		do
			armour_selected := armour
		end

	set_engine (engine : ENGINE)
		do
			engine_selected := engine
		end

	set_power (power : POWER)
		do
			power_selected := power
		end

feature -- Exit Game

	reset
		do

		end

end
