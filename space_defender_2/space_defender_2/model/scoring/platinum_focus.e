note
	description: "Summary description for {PLATINUM_FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLATINUM_FOCUS

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
			if children.count = 3 then
				Result := base * 2
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
			Result := 3
		ensure then
			correct_capacity : Result = 3
		end

end
