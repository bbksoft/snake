
require Tools

defmodule G do
	use GenServer

	def start() do
		GenServer.start(__MODULE__,nil,[name: :g_values]) 			
	end

	def get(key) do
		GenServer.call(:g_values,key)		
	end

	def put(key,value) do
		GenServer.cast(:g_values,{key,value})		
	end

	def init(_) do

		Tools.log("global value server[G] started.")

		{:ok, %{}}
	end

	def handle_call(key,_from,state) do		
		{:reply,Map.get(state,key),state}
	end

	def handle_cast({key,value},state) do		
		{:noreply, Map.put(state,key,value)}
	end

	def handle_cast(params,state) do	
		Tools.log({:error,:handle_cast,params})
		{:noreply, state}
	end

	def handle_info(params,state) do		
		Tools.log({:handle_info,params})
		{:noreply, state}
	end

end