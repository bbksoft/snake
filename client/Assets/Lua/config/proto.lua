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
			name="test_enum",
			is_enum=true,
			enum_values = {"te_one","te_two",},
			menbers = {
			},
		},
		{
			name="test_data",
			menbers = {
			},
		},
		{
			name="player_data",
			menbers = {
				{
					name = "id",
					type = "Int",
				},
				{
					name = "name",
					type = "String",
					is_array = true,
				},
				{
					name = "datas",
					type = "test_data",
					is_array = true,
				},
			},
		},
		{
			name="data_tt",
			menbers = {
				{
					name = "id",
					type = "Int",
				},
			},
		},
		{
			name="data_id",
			menbers = {
				{
					name = "key",
					type = "String",
				},
				{
					name = "index",
					type = "Int",
				},
				{
					name = "array",
					type = "Int",
					is_array = true,
				},
				{
					name = "datas",
					type = "String",
					is_array = true,
				},
				{
					name = "datatts",
					type = "data_tt",
					is_array = true,
				},
			},
		},
	},
	funs = {
		{
			id=1,
			name="player_update",
			class_name="client_handle",
			param_list = {
				{
					type = "player_data",
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
			class_name="test",
			param_list = {
				{
					type = "data_id",
				},
				{
					type = "String",
				},
				{
					type = "Int",
					is_array = true,
				},
				{
					type = "Single",
				},
				{
					type = "Boolean",
				},
			},
			ret =
				{
					type = "Int",
				},
		},
	}
}
return ret
