# make by the tool[config]
defmodule Cfg_actor do

	def get(id) do
		Cfg.get(:cfg_actor,id)
	end

	def get_field_id(id) do
		case id do
			:id -> 0
			:icon -> 1
			:res -> 2
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_"}
		Cfg.match(:cfg_actor,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3"}
		Cfg.find(:cfg_actor,list,q,fn(x)-> get_field_id(x) end)
	end

	def id(record) when is_tuple(record) do
		elem(record,0)
	end
	def id(id) do
		Cfg.get_field(:cfg_actor,id,0)
	end

	def icon(record) when is_tuple(record) do
		elem(record,1)
	end
	def icon(id) do
		Cfg.get_field(:cfg_actor,id,1)
	end

	def res(record) when is_tuple(record) do
		elem(record,2)
	end
	def res(id) do
		Cfg.get_field(:cfg_actor,id,2)
	end
end