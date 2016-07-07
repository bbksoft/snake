
defmodule Tools do
 	
 	def list_fold_2([a|list1],[b|list2],acc,fun) do
		acc = fun.(a,b,acc)
		list_fold_2(list1,list2,acc,fun)
	end
	
	def list_fold_2(_,_,acc,_) do
		acc
	end

	def list_fold_3([a|list1],[b|list2],[c|list3],acc,fun) do
		acc = fun.(a,b,c,acc)
		list_fold_3(list1,list2,list3,acc,fun)
	end
	
	def list_fold_3(_,_,_,acc,_) do
		acc
	end
	

	defmacro log(term) do		
		quote do
			list = String.split(__ENV__.file,"/")
			file_name = List.last(list)
			IO.puts "[file:" <> to_string(file_name) 
				<> " line:" 
				<> to_string(__ENV__.line) <> "] " 
				<> Macro.to_string(unquote(term))
		end
	end

	defmacro error(term) do
		quote do
			list = String.split(__ENV__.file,"/")
			file_name = List.last(list)
			IO.puts "[error -> file:" <> to_string(file_name) 
				<> " line:" 
				<> to_string(__ENV__.line) <> "] " 
				<> Macro.to_string(unquote(term))
		end
	end

	defmacro debug(term) do
		quote do
			list = String.split(__ENV__.file,"/")
			file_name = List.last(list)
			IO.puts "[debug -> file:" <> to_string(file_name) 
				<> " line:" 
				<> to_string(__ENV__.line) <> "] " 
				<> Macro.to_string(unquote(term))
		end
	end

end