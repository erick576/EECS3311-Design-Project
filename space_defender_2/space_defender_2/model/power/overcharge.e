note
	description: "Summary description for {OVERCHARGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OVERCHARGE

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 50
			is_health_cost := true
			type_name := "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap."
		end

feature -- Commands

	special_move
		do

		end

end
