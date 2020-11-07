note
	description: "Summary description for {DEPLOY_DRONES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DEPLOY_DRONES

inherit
	POWER

create
	make

feature -- Initialization

	make
		do
			cost := 100
			is_health_cost := false
			type_name := "Deploy Drones (100 energy): Clear all projectiles."
		end

feature -- Commands

	special_move
		do

		end

end
