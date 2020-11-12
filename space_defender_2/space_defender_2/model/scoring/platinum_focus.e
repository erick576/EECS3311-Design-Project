note
	description: "Summary description for {PLATINUM_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLATINUM_FOCUS

inherit
	FOCUS

create
	make

feature -- Initialization
	make
		do
			holder := create {ARRAYED_LIST[ORB]}.make (3)
			holder.force( create {BRONZE_ORB}.make )
			curr_size := 1
			capacity := 3
		end

feature -- Command

	return_total_score : INTEGER
		local
			i , sum : INTEGER
		do
			sum := 0

			from
				i := 1
			until
				i > curr_size
			loop
				sum := sum + holder.at (i).value
				i := i + 1
			end

			if curr_size = capacity then
				Result := sum * 2
			else
				Result := sum
			end
		end

end
