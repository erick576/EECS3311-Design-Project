note
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"


deferred class STATE

feature -- features

  game_info: GAME_INFO
	local
		ma: ETF_MODEL_ACCESS
	do
		Result := ma.m.game_info
	end

  starfighter: STARFIGHTER
	local
		ma: ETF_MODEL_ACCESS
	do
		Result := ma.m.starfighter
	end

  choice : INTEGER
    -- Choice for next step

  in_game : BOOLEAN
  	-- Is this state in_game or not?
  	deferred end

  in_setup : BOOLEAN
  	-- Is this state in setup or not?
  	deferred end

  in_setup_select : BOOLEAN
  	-- Is this state eligible for state setup?
  	deferred end

  set_choice (i : INTEGER)
  	-- Set choice value
  	deferred end

  display : STRING
    -- Display current state
    deferred end

  in_bounds (i : INTEGER) : BOOLEAN
  	-- Is the selected in the equipment selected bounds?
  	deferred end

  setup_select (i : INTEGER)
   -- Select the equipment only for setup states
   deferred end

feature -- Concrete Features
	make
		do
		end
end
