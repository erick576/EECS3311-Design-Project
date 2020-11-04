note
	description: "Summary description for {WEAPON_SETUP_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEAPON_SETUP_STATE

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
      	game_info.set_state_message (game_info.state_weapon_setup)
      	game_info.set_state_specific_message (game_info.weapon_setup_message)

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
