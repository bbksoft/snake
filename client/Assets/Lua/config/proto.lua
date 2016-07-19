-- export by tool[proto]
local ret = {
	types = {
		{
			name="String",
			menbers = {
			},
		},
		{
			name="Int",
			menbers = {
			},
		},
		{
			name="Boolean",
			menbers = {
			},
		},
		{
			name="Single",
			menbers = {
			},
		},
		{
			name="snake_point",
			menbers = {
				{
					name = "x",
					type = "Single",
				},
				{
					name = "y",
					type = "Single",
				},
			},
		},
		{
			name="snake_data",
			menbers = {
				{
					name = "id",
					type = "Int",
				},
				{
					name = "path",
					type = "snake_point",
					is_array = true,
				},
			},
		},
		{
			name="top_info",
			menbers = {
				{
					name = "name",
					type = "String",
				},
				{
					name = "len",
					type = "Single",
				},
			},
		},
	},
	funs = {
		{
			id=1,
			name="enter_ack",
			class_name="client_handle",
			param_list = {
				{
					type = "Single",
				},
				{
					type = "Int",
				},
			},
			ret = 
				{
					type = "Void",
				},
		},
		{
			id=2,
			name="update_snakes",
			class_name="client_handle",
			param_list = {
				{
					type = "Single",
				},
				{
					type = "snake_data",
					is_array = true,
				},
			},
			ret = 
				{
					type = "Void",
				},
		},
		{
			id=3,
			name="update_top",
			class_name="client_handle",
			param_list = {
				{
					type = "top_info",
					is_array = true,
				},
			},
			ret = 
				{
					type = "Void",
				},
		},
		{
			id=4,
			name="snake_death",
			class_name="client_handle",
			param_list = {
				{
					type = "Int",
				},
			},
			ret = 
				{
					type = "Void",
				},
		},
		{
			id=5,
			name="snake_enter",
			class_name="Game",
			param_list = {
			},
			ret = 
				{
					type = "Void",
				},
		},
		{
			id=6,
			name="snake_turn",
			class_name="Game",
			param_list = {
				{
					type = "Single",
				},
				{
					type = "Single",
				},
				{
					type = "Single",
				},
			},
			ret = 
				{
					type = "Void",
				},
		},
	}
}
return ret