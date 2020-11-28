note
	description: "Summary description for {APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Attributes

  transition: ARRAY2[INTEGER]
  states: ARRAY[STATE]

feature
  curr_index: INTEGER
  num_of_states: INTEGER
  num_of_choices: INTEGER

  make(n, m: INTEGER)
    do
    	num_of_states := n
    	num_of_choices := m
    	create transition.make_filled (0, num_of_states, num_of_choices)
        create states.make_empty
    end

feature
  is_final (index: INTEGER): BOOLEAN
  	do
  		Result := index = -1
  	end

feature -- Commands
  put_state(s: STATE; index: INTEGER)
    require
    	1 <= index and index <= num_of_states
    do
    	states.force(s, index)
    end

  choose_initial(index: INTEGER)
    require
    	1 <= index and index <= num_of_states
    do
    	curr_index := index
    end

  put_transition(tar, src, choice: INTEGER)
    require
      1 <= src and src <= num_of_states
      1 <= tar and tar <=num_of_states
      1 <= choice and choice <= num_of_choices
    do
      transition.put(tar, src, choice)
    end

  execute_transition
     do
     	curr_index := transition.item (curr_index, states[curr_index].choice)
     end

  current_state : STATE
    do
    	Result := states[curr_index]
    end

invariant
	transition.height = num_of_states
	transition.width = num_of_choices
end
