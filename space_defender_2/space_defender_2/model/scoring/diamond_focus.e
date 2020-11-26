note
	description: "Summary description for {DIAMOND_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DIAMOND_FOCUS

inherit
	COMPOSITE_SCORING_ITEM
		redefine
			value ,
			has_capacity ,
			capacity
		end

create
	make

feature
	value : INTEGER
		local
			base : INTEGER
		do
			base := Precursor
			if children.count = capacity then
				Result := base * 3
			else
				Result := base
			end
		end

	has_capacity : BOOLEAN
		do
			Result := true
		ensure then
			has_capacity : Result = true
		end

	capacity : INTEGER
		do
			Result := 4
		ensure then
			correct_capacity : Result = 4
		end

end
