note
	description: "Summary description for {FRIENDLY_PROJECTILE_SPLITTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRIENDLY_PROJECTILE_SPLITTER

inherit
	FRIENDLY_PROJECTILE

create
	make

feature -- Initialization

	make (row : INTEGER ; col : INTEGER ; i : INTEGER ; t : INTEGER)
		do
			id := i

			type := t
			is_friendly := true
			move := 0

			damage := 150

		    row_pos := row
			col_pos := col
		end

feature -- Commands

	do_turn
		-- Turn Action for a Projectile
		do
			-- Does Nothing

			-- Only for Debug Output
			if not game_info.in_normal_mode then
				game_info.append_friendly_projectile_action_info ("      A friendly projectile(id:" + id.out + ") stays at: [" + game_info.grid.grid_char_rows.at (row_pos).out + "," + col_pos.out + "]" + "%N")
			end
		end

end
