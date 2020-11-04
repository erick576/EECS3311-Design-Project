note
	description: "Summary description for {ENGINE_SETUP_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENGINE_SETUP_STATE

inherit
	STATE

create
	make

feature
    set_choice (i : INTEGER)
  	  -- Set choice value
  	  do
  	  	choice := i
  	  end

  	in_game : BOOLEAN
  	  	-- Is this state in_game or not?
  		do
			Result := false
		end

    display (game_info : GAME_INFO) : STRING
      -- Display current state
      do
      	Result := "Engine Setup"
      end

end
