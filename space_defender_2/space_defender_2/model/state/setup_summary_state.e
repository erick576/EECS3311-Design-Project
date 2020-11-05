note
	description: "Summary description for {SETUP_SUMMARY_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SETUP_SUMMARY_STATE

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

    in_setup : BOOLEAN
        -- Is this state in setup or not?
  		do
			Result := true
		end

    display : STRING
      -- Display current state
      do
		create Result.make_empty
      	game_info.set_state_message (game_info.state_setup_summary)
      	game_info.set_state_specific_message (game_info.setup_summary_message)

      	if game_info.is_error then
      		game_info.set_status_message (game_info.error_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_error)

      	else
      		game_info.set_status_message (game_info.ok_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_state_specific)
      	end

      end

end
