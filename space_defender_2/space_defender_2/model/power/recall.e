note
	description: "Summary description for {RECALL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RECALL

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 50
			is_health_cost := false
			type_name := "Recall (50 energy): Teleport back to spawn."
		end

feature -- Commands

	special_move
		do

		end

end
