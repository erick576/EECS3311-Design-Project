note
	description: "Summary description for {EQUIPMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EQUIPMENT

feature -- Attributes

	health : INTEGER
	energy : INTEGER
	health_regen : INTEGER
	energy_regen : INTEGER
	armour : INTEGER
	vision : INTEGER
	move : INTEGER
	move_cost : INTEGER
	projectile_damage : INTEGER
	projectile_cost : INTEGER

	game_info: GAME_INFO
		local
			ma: ETF_MODEL_ACCESS
		do
			Result := ma.m.game_info
		end

end
