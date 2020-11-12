note
	description: "Summary description for {DIAMOND_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIAMOND_FOCUS

inherit
	FOCUS

create
	make

feature -- Initialization
	make
		do
			holder := create {ARRAYED_LIST[ORB]}.make (4)
			holder.force( create {GOLD_ORB}.make )
			curr_size := 1
			capacity := 4
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
				Result := sum * 3
			else
				Result := sum
			end
		end

end
