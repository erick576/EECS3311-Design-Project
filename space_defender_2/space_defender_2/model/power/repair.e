note
	description: "Summary description for {REPAIR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REPAIR

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 50
			is_health_cost := false
			type_name := "Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap."
		end

feature -- Commands

	special_move
		do

		end

end
