
require Tools


defmodule Main_runner do
	def start() do
		servers = [
			G,
			Proto,
			{Server.User,[[Game]]},
			Game
		]
		start(servers)
	end

	defp start(servers) do
		servers = Enum.map(servers,fn(value)->
			case value do
			{server,params} ->
				apply(server,:start,params)
				server
			_ ->
				apply(value,:start,[])
				value
			end
		end)
		run(servers)
	end

	defp stop(servers) do
		Enum.map(servers,fn(value)->
			apply(value,:stop,[])
		end)
	end

	defp run(servers) do
		receive do
		:stop ->
			Tools.log("server stop ...")
			stop(servers)
		_ ->
			run(servers)
		end
	end
end

Main_runner.start()
