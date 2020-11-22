note
	description: "Summary description for {SILVER_ORB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SILVER_ORB

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
			Result := 2
		ensure then
			correct_value : Result = 2
		end
end
