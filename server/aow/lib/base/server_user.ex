require Tools


defmodule Server.User do

# ---  tcp listen  ---
#

	def start(mods) do
		spawn fn -> accept(8178,mods) end
	end

	def stop() do


	end

	def accept(port,mods) do
	  	{:ok, socket} = :gen_tcp.listen(port,
	                    [:binary, packet: 2, active: true, reuseaddr: true])

	  	Tools.log("Server.User started.")

	  	loop_acceptor(socket,mods)
	end

	defp loop_acceptor(socket,mods) do
	  	{:ok, client} = :gen_tcp.accept(socket)

	  	IO.puts "accepted socket"
	  	pid = start_user(client,mods)
	  	:gen_tcp.controlling_process(client,pid)

		loop_acceptor(socket,mods)
	end

	def call_client(pid,class,fun,params) do
		GenServer.cast(pid,{:send,%{class: class, fun: fun, params: params}})
	end

	def call_client(class,fun,params) do
		call_client(self(),class,fun,params)
	end


	#- self call functions
	def add_mod(state, mods) when is_list(mods) do
		mods = List.foldl(mods,state.mods,fn(v,acc)->
			key = Macro.to_string(v)
			Map.put(acc,key,v)
		end)
		%{state | mods: mods}
	end

	def add_mod(state, mod)do
		key = Macro.to_string(mod)
		mods = Map.put(state.mods,key,mod)
		%{state | mods: mods}
	end

# --- client link server logic ---
#

	use GenServer

	defp start_user(socket,mods) do
		case GenServer.start(__MODULE__,{socket,mods}) do
		{:ok,pid} ->
			pid;
		_ ->
			nil
		end
	end

	def init({socket,mods}) do
		state = %{socket: socket, proto: G.get(:proto), mods: %{} }
		state = add_mod(state,mods)
		{:ok, state}
	end

	def handle_call(params,_from,state) do
		Tools.log({:handle_call,params})
		{:reply,nil,state}
	end

	def handle_cast({:send,data},state) do
		try do
			bin = Proto.term_to_bin(state.proto,data)

			if state.socket do
				Tools.log("send data")
				Tools.log(bin)
				:gen_tcp.send(state.socket,bin)
			end
		rescue
 			er ->
 				Tools.error(data)
 				Tools.error(er)
		end

		{:noreply, state}
	end

	def handle_cast(params,state) do
		Tools.log({:handle_cast,params})
		{:noreply, state}
	end




	def handle_info({:tcp,_,data},state) do
		Tools.log(data)
		:gen_tcp.send(state.socket,data)

		#Server.User.call_client("server_handle","login",[nil,"test",nil,1.234567,true])

		Tools.log("test")
		call_data = Proto.bin_to_term(state.proto,data)

		mod = state.mods[call_data.class]
		state =
		if mod do
			apply(mod,String.to_atom(call_data.fun),call_data.params)
		else
			Tools.log("can't find mod:" <> call_data.class)
			state
		end

		{:noreply, state}
	end

	def handle_info({:tcp_closed,socket},state) do

		state = if state.socket === socket do
			Tools.log("do close socket")
			%{state | socket: nil}
		else
			Tools.log("close socket outtime")
			state
		end

		{:noreply, state}
	end

	def handle_info(params,state) do

		Tools.log({:handle_info,params})

		{:noreply, state}
	end


end
