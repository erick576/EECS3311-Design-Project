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
		ensure then
			correct_output : Result = false
		end

    in_setup : BOOLEAN
        -- Is this state in setup or not?
  		do
			Result := false
		ensure then
			correct_output : Result = false
		end

	in_setup_select : BOOLEAN
  	    -- Is this state eligible for state setup?
  		do
			Result := false
		ensure then
			correct_output : Result = false
		end

	in_bounds (i : INTEGER) : BOOLEAN
	  -- Is the selected in the equipment selected bounds?
	  do
	  		Result := false
	  end

	setup_select (i : INTEGER)
	  -- Select the equipment only for setup states
	  do
	  end

    display : STRING
      -- Display current state
      do
		create Result.make_empty
      	game_info.set_state_message (game_info.state_not_started)
      	game_info.set_state_specific_message (game_info.not_playing_message)

      	if game_info.is_error then
      		game_info.set_status_message (game_info.error_status)
      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_error)

	   elseif not game_info.is_alive then
      		game_info.set_status_message (game_info.ok_status)
      		game_info.set_game_over_message (game_info.starfighter_is_dead)

      		game_info.set_in_game (false)

      		Result.append (game_info.display_state)
	      	Result.append ("%N")
	      	Result.append (game_info.display_objects)
	      	Result.append ("%N")

	      	if game_info.in_normal_mode = false then
	     		Result.append (game_info.display_debug_mode)
			end

	      	Result.append (game_info.display_grid)
	      	Result.append ("%N")
	      	Result.append (game_info.display_game_over)

      		game_info.set_is_alive (true)
			game_info.starfighter.reset

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
      	end

      end

end
