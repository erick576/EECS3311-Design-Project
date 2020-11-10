note
	description: "Summary description for {ARMOUR_SETUP_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ARMOUR_SETUP_STATE

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
	  		Result := i >= 1 and i <= game_info.armours.count
	  end

	setup_select (i : INTEGER)
	  -- Select the equipment only for setup states
	  do
	  		game_info.starfighter.set_armour (game_info.armours.at (i))
	  end

    display : STRING
      -- Display current state
      do
		create Result.make_empty
      	game_info.set_state_message (game_info.state_armour_setup)
      	game_info.set_state_specific_message (game_info.armour_setup_message)

      	if game_info.is_error then
      		game_info.set_status_message (game_info.error_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_error)

      	elseif game_info.is_valid_operation then
      		game_info.set_status_message (game_info.ok_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_operation)

      	else
      		game_info.set_status_message (game_info.ok_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_state_specific)
	      	Result.append (game_info.starfighter.armour_selected.type_name)
      	end

      end

end
