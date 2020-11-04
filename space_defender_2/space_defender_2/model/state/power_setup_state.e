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

    display : STRING
      -- Display current state
      do
      	Result := "Power Setup"
      end

end
