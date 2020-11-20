note
	description: "Summary description for {GOLD_ORB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOLD_ORB

inherit
	SCORING_ITEM

create
	make

feature -- Initialization
	make
		do
		end

feature
	value : INTEGER
		do
			Result := 3
		end
end
