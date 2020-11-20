note
	description: "Summary description for {COMPOSITE_SCORING_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMPOSITE_SCORING_ITEM

inherit
	SCORING_ITEM
	COMPOSITE [SCORING_ITEM]

create
	make

feature -- Initialization
	make
		do
			create children.make
		end

feature
	value : INTEGER
		do
			across
				children as cursor
			loop
				Result := Result + cursor.item.value
			end
		end

	has_capacity : BOOLEAN
		do
			Result := false
		end

	capacity : INTEGER
		do
			Result := 0
		end
end
