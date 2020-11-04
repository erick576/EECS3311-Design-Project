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

  choice : INTEGER
    -- Choice for next step

  in_game : BOOLEAN
  	-- Is this state in_game or not?
  	deferred end

  in_setup : BOOLEAN
  	-- Is this state in setup or not?
  	deferred end

  set_choice (i : INTEGER)
  	-- Set choice value
  	deferred end

  display : STRING
    -- Display current state
    deferred end

feature -- Concrete Features
	make
		do
		end
end
