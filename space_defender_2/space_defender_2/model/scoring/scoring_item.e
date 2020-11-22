note
	description: "Summary description for {SCORING_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCORING_ITEM

feature
	value : INTEGER
		deferred
		ensure
			non_negative_value : Result >= 0
		end

end
