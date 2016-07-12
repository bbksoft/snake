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
			name="snake_data",
			menbers = {
				{
					name = "id",
					type = "Int",
				},
				{
					name = "path_x",
					type = "Single",
					is_array = true,
				},
				{
					name = "path_y",
					type = "Single",
					is_array = true,
				},
			},
		},
		{
			name="AcountData",
			menbers = {
				{
					name = "id",
					type = "Int",
				},
				{
					name = "name",
					type = "String",
				},
			},
		},
	},
	funs = {
		{
			id=1,
			name="update_snakes",
			class_name="client_handle",
			param_list = {
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
			id=2,
			name="login",
			class_name="Account",
			param_list = {
				{
					type = "String",
				},
				{
					type = "String",
				},
			},
			ret = 
				{
					type = "AcountData",
				},
		},
		{
			id=3,
			name="snake_turn",
			class_name="Game",
			param_list = {
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