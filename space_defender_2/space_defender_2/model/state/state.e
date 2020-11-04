note
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"


deferred class STATE

feature -- features
  choice : INTEGER
    -- Choice for next step

  in_game : BOOLEAN
  	-- Is this state in_game or not?
  	deferred end

  set_choice (i : INTEGER)
  	-- Set choice value
  	deferred end

  display (game_info : GAME_INFO) : STRING
    -- Display current state
    deferred end

feature -- Concrete Features
	make
		do
		end
end
