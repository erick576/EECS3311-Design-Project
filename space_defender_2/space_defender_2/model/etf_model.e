note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create grid.make
			create game_info.make
			create starfighter.make

			create app.make (7, 4)

			app.put_state (create {NOT_STARTED_STATE}.make, 1)
			app.put_state (create {WEAPON_SETUP_STATE}.make, 2)
			app.put_state (create {ARMOUR_SETUP_STATE}.make, 3)
			app.put_state (create {ENGINE_SETUP_STATE}.make, 4)
 			app.put_state (create {POWER_SETUP_STATE}.make, 5)
			app.put_state (create {SETUP_SUMMARY_STATE}.make, 6)
			app.put_state (create {IN_GAME_STATE}.make, 7)

			app.choose_initial (1)

--			Choices
--			1. Decide To Play
--			2. Back
--			3. Next
--			4. Game Over

			app.put_transition (2, 1, 1)

			app.put_transition (1, 2, 2)
			app.put_transition (2, 3, 2)
			app.put_transition (3, 4, 2)
			app.put_transition (4, 5, 2)
			app.put_transition (5, 6, 2)

			app.put_transition (3, 2, 3)
			app.put_transition (4, 3, 3)
			app.put_transition (5, 4, 3)
			app.put_transition (6, 5, 3)
			app.put_transition (7, 6, 3)

			app.put_transition (1, 7, 4)
		end

feature -- model attributes
	app : APPLICATION
	game_info : GAME_INFO
	grid : GRID
	starfighter : STARFIGHTER

feature -- model operations

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		do
			create Result.make_empty
			Result.append (app.current_state.display)
		end

end
