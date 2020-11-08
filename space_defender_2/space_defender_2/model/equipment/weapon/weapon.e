note
	description: "Summary description for {WEAPON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEAPON

inherit
	EQUIPMENT

feature -- Command

	-- Create Weapon Specific Projectile
	create_projectile (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		deferred end

	-- Fire onto the board
	fire
		deferred end

feature -- Attributes

	type_name : STRING
	is_projectile_cost_health : BOOLEAN
	projectile_cost_type_name : STRING

	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

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

end
