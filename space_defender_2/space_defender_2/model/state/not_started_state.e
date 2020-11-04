note
	description: "Summary description for {NOT_STARTED_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOT_STARTED_STATE

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
      	create Result.make_empty
      	Result.append (game_info.display_state)
      	Result.append ("%N")
      	Result.append (game_info.display_state_specific)
      end

end
