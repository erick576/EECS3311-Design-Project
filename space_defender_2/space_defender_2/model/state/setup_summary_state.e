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
      	Result := "Setup Summary"
      end

end
