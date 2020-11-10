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

  game_info: GAME_INFO
	local
		ma: ETF_MODEL_ACCESS
	do
		Result := ma.m.game_info
	end

feature -- Commands

	special_move
		deferred end

end
