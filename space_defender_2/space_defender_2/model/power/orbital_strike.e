note
	description: "Summary description for {ORBITAL_STRIKE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ORBITAL_STRIKE

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			energy_cost := 100
			type_name := "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour."
		end

feature -- Commands

	special_move
		do

		end

end
