note
	description: "Summary description for {COMPOSITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPOSITE[T]

feature
	children : LINKED_LIST[T]

	add (c : T)
		do
			children.extend (c)
		end
end
