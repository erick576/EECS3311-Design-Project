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
			energy_cost := 100
			type_name := "Deploy Drones (100 energy): Clear all projectiles."
		end

feature -- Commands

	special_move
		do

		end

end
