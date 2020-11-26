note
	description: "Summary description for {COMPOSITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPOSITE[T -> attached ANY]

feature {NONE}
	children : LINKED_LIST[T]

feature -- Abstraction function of a stack
	model : SEQ[T]
		do
			create Result.make_empty
			across
				children as cursor
			loop
				Result.append (cursor.item)
			end
		ensure
			consistent_counts:
				children.count = Result.count
			consistent_countens:
				across
					1 |..| Result.count as i
				all
					Result[i.item] ~ children[children.count - i.item + 1]
				end
		end

	add (c : T)
		do
			children.extend (c)
		ensure
			element_added : model ~ (old model.deep_twin).appended (c)
		end
end
