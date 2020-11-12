note
	description: "Summary description for {FOCUS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FOCUS

feature -- Attributes

	holder : LIST[ORB]
	curr_size : INTEGER
	capacity : INTEGER

feature -- Command

	return_total_score : INTEGER
		deferred end

feature -- Setters

	increment_curr_size 
		do
			curr_size := curr_size + 1
		end
end
