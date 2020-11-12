note
	description: "Summary description for {SINGLE_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SINGLE_FOCUS

inherit
	FOCUS

create
	make

feature -- Initialization
	make
		do
			holder := create {ARRAYED_LIST[ORB]}.make (1)
			curr_size := 1
			capacity := 1
		end

feature -- Command

	return_total_score : INTEGER
		do
			Result := holder.at (1).value
		end


end
