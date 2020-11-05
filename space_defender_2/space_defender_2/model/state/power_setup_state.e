note
	description: "Summary description for {POWER_SETUP_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POWER_SETUP_STATE

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

	in_setup_select : BOOLEAN
  	    -- Is this state eligible for state setup?
  		do
			Result := true
		end

	in_bounds (i : INTEGER) : BOOLEAN
	  -- Is the selected in the equipment selected bounds?
	  do
	  		Result := true
--	  		Result := i >= 1 and i <= game_info.powers.count
	  end

	setup_select (i : INTEGER)
	  -- Select the equipment only for setup states
	  do
--	  		starfighter.set_power (game_info.powers.at (i))
	  end

    display : STRING
      -- Display current state
      do
		create Result.make_empty
      	game_info.set_state_message (game_info.state_power_setup)
      	game_info.set_state_specific_message (game_info.power_setup_message)

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
--	      	Result.append (starfighter.power_selected.type_name)
      	end

      end

end
