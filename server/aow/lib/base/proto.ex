require Tools

defmodule Proto do

	def start() do
		proto = load_proto("../config/proto.txt")
		G.put(:proto,proto)

		Tools.log("proto mod init ok.")		
	end

	def stop() do
		
	end

	def load_proto(file) do
		{:ok,binary} =  File.read(file) 
		{:ok,proto} = Poison.decode(binary, keys: :atoms)

		#IO.puts Macro.to_string(proto)

		funs_hash = List.foldl(proto.funs,%{},fn(value,acc)->
			Map.put(acc,value.id,value)
		end)

		funs_str_hash = List.foldl(proto.funs,%{},fn(value,acc)->
			Map.put(acc,value.class_name <> value.name,value)
		end)

		types_hash = List.foldl(proto.types,%{},fn(value,acc)->
			Map.put(acc,value.name,value)
		end)
		
		proto
		|> Map.put(:funs_hash,funs_hash)
		|> Map.put(:types_hash,types_hash)
		|> Map.put(:funs_str_hash,funs_str_hash)
	end

	def bin_to_term(proto,bin) do		
		
		{type,bin} = read_int(bin)

		{fun_id,bin} = 
			if type == 1 do
				{class,bin} = read_string(bin)	
				{fun_name,bin} = read_string(bin)	
				{%{class: class, fun: fun_name},bin}	
			else
				read_int(bin)
			end

		fun = get_fun(proto,fun_id)

		#Tools.log(fun)
		#Tools.log(bin)

		{params,bin} = List.foldl(fun.param_list,{[],bin},fn(param_def,acc)->

			{params,bin} = acc

			{value,bin} = if param_def.is_array do
				read_array_value(proto,bin,param_def.type)
			else
				read_value(proto,bin,param_def.type)
			end
	
			{params++[value],bin}					
		end)

		%{fun: fun.name, class: fun.class_name, params: params}
	end


	def term_to_bin(proto,term) do
		fun_id = %{class: term.class, fun: term.fun}
		fun = get_fun(proto,fun_id)
		bin = if term[:used_name] do
				<<>>
				|> write_int(1)
				|> write_string(term.class)
				|> write_string(term.fun)
			else
				<<>>
				|> write_int(0)
				|> write_int(fun.id)
			end

		Tools.list_fold_2(term.params,fun.param_list,bin,fn(value,param_def,acc)->			
					
			#Tools.log(acc)
					
			if param_def.is_array do
				write_array_value(proto,acc,param_def.type,value)
			else
				write_value(proto,acc,param_def.type,value)			
			end		
		end)	
	end
	

	defp write_array_value(proto,bin,type,value) do	
		case value do
		nil ->
			<<bin :: binary,128>>
		_ ->
			len = length(value)	
			bin = write_int(bin,len)
			List.foldl(value,bin,fn(data,acc)->
				write_value(proto,acc,type,data)
			end)
		end
	end

	defp write_value(proto,bin,type_name,value) do	

		if value != nil do	
			case type_name do
			"String" ->
				write_string(bin,value)
			"Int"	 ->
				write_int(bin,value)
			"Single"  ->
				write_float(bin,value)
			"Boolean" ->
				write_bool(bin,value)
			_ ->
				type = get_type(proto,type_name)
				if type.is_enum do
					value = Enum.find_index(type.enum_values,fn(x)-> x == value end)
					write_int(bin,value)
				else
					bin = write_int(bin,0)
					List.foldl(type.menbers,bin,fn(param_def,acc)->
						atom_name = String.to_atom(param_def.name)
						Tools.log({atom_name,value})
						child_value = value[atom_name]
						if param_def.is_array do
							write_array_value(proto,acc,param_def.type,child_value)
						else
							write_value(proto,acc,param_def.type,child_value)			
						end		 
					end)
				end			
			end		
		else
			write_null(bin)
		end
	end

	defp get_fun(proto,fun_id) when is_number(fun_id) do	
		proto.funs_hash[fun_id]
	end

	defp get_fun(proto,fun_id) do	
		proto.funs_str_hash[fun_id.class <> fun_id.fun]
	end

	defp get_type(proto,type_name) do
		proto.types_hash[type_name]
	end


	defp read_value(proto,bin,type) do
		#Tools.log(type)

		case type do
		"String" ->
			read_string(bin)
		"Int"	 ->
			read_int(bin)
		"Single"  ->
			read_float(bin)
		"Boolean" ->
			read_bool(bin)
		_ ->
			type = get_type(proto,type)
			if type.is_enum do
				{value,bin} = read_int(bin)
				if value do
					{type.enum_values[value],bin}
				else
					{nil,bin}
				end
			else			
				{value,bin} = read_int(bin)

				IO.puts value

				if value do	
					List.foldl(type.menbers,{%{},bin},fn(type_def,acc)->
						{data,bin} = acc
						{value,bin} = if type_def.is_array do
						 	read_array_value(proto,bin,type_def.type)
						else
						 	read_value(proto,bin,type_def.type)
						end						
						if value != nil do
							atom_name = String.to_atom(type_def.name)
							{Map.put(data,atom_name,value),bin}
						else
							{data,bin}
						end
					end)			
				else
					{nil,bin}
				end	
			end
		end		
	end

	defp read_array_value(proto,bin,type) do
		{len,bin} = read_int(bin)

		case len do		
		nil ->
			{nil,bin} 
		0 ->
			{[],bin}
		_ ->
			for_read_value(proto,bin,len,type,[])
		end
	end

	defp for_read_value(proto,bin,0,type,ret) do
		{ret,bin}
	end

	defp for_read_value(proto,bin,n,type,ret) do
		{value,bin} = read_value(proto,bin,type)
		for_read_value(proto,bin,n-1,type,ret++[value])
	end


	defp write_null(bin) do
		<<bin :: binary,128>>
	end

	defp split_128(value) do				
		split_128_base(div(value,128),[rem(value,128)])
	end

	defp split_128_base(value,ret) do
		if value < 128 do
			[value+128|ret]
		else
			split_128_base(div(value,128),[rem(value,128)|ret])
		end
	end

	defp write_int(bin,value) do
		if value == nil do
			<<bin :: binary,128>>
		else 
			value = trunc(value)			
			if value >= 128 do
				list = split_128(value)
				List.foldl(list,bin,fn(data,acc)->
					<<acc :: binary,data>>
				end)				
			else
				<<bin :: binary,value>>
			end
		end
	end

	defp write_bool(bin,value) do
		case value do
		nil ->
			<<bin :: binary,128>>
		1 -> 
			<<bin :: binary,1>>
		_ ->
			<<bin :: binary,0>>
		end
	end

	defp write_float(bin,value) do
		case value do
		nil  ->
			<<bin :: binary,128>>;
		_ ->
			write_int(bin,value*100)
		end
	end

	defp write_string(bin,value) do
		case value do
		nil  ->
			<<bin :: binary,128>>;
		_ ->
			len = byte_size(value)
			bin = write_int(bin,len)
			<<bin :: binary, value :: binary>>
		end
	end

	defp read_string(bin) do
		{len,bin} = read_int(bin)
		if len do
			if len <= 0 do
				{<<>>,bin}
			else
				<<value :: binary-size(len), bin :: binary>> = bin
				{value,bin}		
			end	
		else
			{nil,bin}
		end
	end

	defp read_int(bin) do
		<<a,bin :: binary>> = bin
		if a == 128 do
			{nil,bin}
		else 
			if a < 128 do
				{a,bin}
			else
				read_int(bin,a-128)
			end
		end
	end

	defp read_int(bin,base) do
		<<a,bin :: binary>> = bin
		if a >= 128 do
			read_int(bin,base*128+(a-128))
		else
			{base * 128 + a, bin}
		end
	end

	defp read_float(bin) do
		IO.puts "read_float"
		{value,bin} = read_int(bin)
		IO.puts "read_float"
		IO.puts Macro.to_string(value)
		IO.puts Macro.to_string(bin)
		if value do
			{value/100,bin}
		else
			{nil,bin}
		end
	end

	defp read_bool(bin) do
		IO.puts "read bool"
		{value,bin} = read_int(bin)
		if value == 1 do					
			{true,bin}
		else
			if value == nil do
				{nil,bin}
			else
				{false,bin}
			end
		end
	end
	

	
end