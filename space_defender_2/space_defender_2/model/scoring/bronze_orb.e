note
	description: "Summary description for {BRONZE_ORB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BRONZE_ORB

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
			Result := 1
		end
end
