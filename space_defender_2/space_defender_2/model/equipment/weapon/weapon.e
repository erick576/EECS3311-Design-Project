note
	description: "Summary description for {WEAPON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEAPON

inherit
	EQUIPMENT

-- Possibly Need Grid Access
feature -- Command

	-- Weapon Specific Projectile Movement
	projectile_movement
		deferred end

feature -- Attributes

	type_name : STRING
	is_projectile_cost_health : BOOLEAN
	projectile_cost_type_name : STRING

end
