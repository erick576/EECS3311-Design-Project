note
	description: "Summary description for {POWER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	POWER

feature -- Attributes

	cost : INTEGER
	is_health_cost : BOOLEAN
	type_name : STRING

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

feature -- Commands

	special_move
		deferred end

end
