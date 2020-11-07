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
			cost := 100
			is_health_cost := false
			type_name := "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour."
		end

feature -- Commands

	special_move
		do

		end

end
