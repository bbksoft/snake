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
			:pos -> 3
			:atk_dis -> 4
			:at_dis -> 5
			:atk_speed -> 6
			:radius -> 7
			:speed -> 8
			:damaged_put -> 9
			:damaged_get -> 10
			:die_put -> 11
			:max_energy -> 12
			:skill_loop -> 13
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_actor,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4",:"$5",:"$6",:"$7",:"$8",:"$9",:"$10",:"$11",:"$12",:"$13",:"$14"}
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

	def pos(record) when is_tuple(record) do
		elem(record,3)
	end
	def pos(id) do
		Cfg.get_field(:cfg_actor,id,3)
	end

	def atk_dis(record) when is_tuple(record) do
		elem(record,4)
	end
	def atk_dis(id) do
		Cfg.get_field(:cfg_actor,id,4)
	end

	def at_dis(record) when is_tuple(record) do
		elem(record,5)
	end
	def at_dis(id) do
		Cfg.get_field(:cfg_actor,id,5)
	end

	def atk_speed(record) when is_tuple(record) do
		elem(record,6)
	end
	def atk_speed(id) do
		Cfg.get_field(:cfg_actor,id,6)
	end

	def radius(record) when is_tuple(record) do
		elem(record,7)
	end
	def radius(id) do
		Cfg.get_field(:cfg_actor,id,7)
	end

	def speed(record) when is_tuple(record) do
		elem(record,8)
	end
	def speed(id) do
		Cfg.get_field(:cfg_actor,id,8)
	end

	def damaged_put(record) when is_tuple(record) do
		elem(record,9)
	end
	def damaged_put(id) do
		Cfg.get_field(:cfg_actor,id,9)
	end

	def damaged_get(record) when is_tuple(record) do
		elem(record,10)
	end
	def damaged_get(id) do
		Cfg.get_field(:cfg_actor,id,10)
	end

	def die_put(record) when is_tuple(record) do
		elem(record,11)
	end
	def die_put(id) do
		Cfg.get_field(:cfg_actor,id,11)
	end

	def max_energy(record) when is_tuple(record) do
		elem(record,12)
	end
	def max_energy(id) do
		Cfg.get_field(:cfg_actor,id,12)
	end

	def skill_loop(record) when is_tuple(record) do
		elem(record,13)
	end
	def skill_loop(id) do
		Cfg.get_field(:cfg_actor,id,13)
	end
end
defmodule Cfg_buff do

	def get(id) do
		Cfg.get(:cfg_buff,id)
	end

	def get_field_id(id) do
		case id do
			:id -> 0
			:key -> 1
			:effect -> 2
			:count -> 3
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_buff,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4"}
		Cfg.find(:cfg_buff,list,q,fn(x)-> get_field_id(x) end)
	end

	def id(record) when is_tuple(record) do
		elem(record,0)
	end
	def id(id) do
		Cfg.get_field(:cfg_buff,id,0)
	end

	def key(record) when is_tuple(record) do
		elem(record,1)
	end
	def key(id) do
		Cfg.get_field(:cfg_buff,id,1)
	end

	def effect(record) when is_tuple(record) do
		elem(record,2)
	end
	def effect(id) do
		Cfg.get_field(:cfg_buff,id,2)
	end

	def count(record) when is_tuple(record) do
		elem(record,3)
	end
	def count(id) do
		Cfg.get_field(:cfg_buff,id,3)
	end
end
defmodule Cfg_level do

	def get(id) do
		Cfg.get(:cfg_level,id)
	end

	def get_field_id(id) do
		case id do
			:id -> 0
			:level -> 1
			:max_hp -> 2
			:p_atk -> 3
			:m_atk -> 4
			:p_pass -> 5
			:m_pass -> 6
			:p_def -> 7
			:m_def -> 8
			:cirt -> 9
			:anit_cirt -> 10
			:cirt_value -> 11
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_level,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4",:"$5",:"$6",:"$7",:"$8",:"$9",:"$10",:"$11",:"$12"}
		Cfg.find(:cfg_level,list,q,fn(x)-> get_field_id(x) end)
	end

	def id(record) when is_tuple(record) do
		elem(record,0)
	end
	def id(id) do
		Cfg.get_field(:cfg_level,id,0)
	end

	def level(record) when is_tuple(record) do
		elem(record,1)
	end
	def level(id) do
		Cfg.get_field(:cfg_level,id,1)
	end

	def max_hp(record) when is_tuple(record) do
		elem(record,2)
	end
	def max_hp(id) do
		Cfg.get_field(:cfg_level,id,2)
	end

	def p_atk(record) when is_tuple(record) do
		elem(record,3)
	end
	def p_atk(id) do
		Cfg.get_field(:cfg_level,id,3)
	end

	def m_atk(record) when is_tuple(record) do
		elem(record,4)
	end
	def m_atk(id) do
		Cfg.get_field(:cfg_level,id,4)
	end

	def p_pass(record) when is_tuple(record) do
		elem(record,5)
	end
	def p_pass(id) do
		Cfg.get_field(:cfg_level,id,5)
	end

	def m_pass(record) when is_tuple(record) do
		elem(record,6)
	end
	def m_pass(id) do
		Cfg.get_field(:cfg_level,id,6)
	end

	def p_def(record) when is_tuple(record) do
		elem(record,7)
	end
	def p_def(id) do
		Cfg.get_field(:cfg_level,id,7)
	end

	def m_def(record) when is_tuple(record) do
		elem(record,8)
	end
	def m_def(id) do
		Cfg.get_field(:cfg_level,id,8)
	end

	def cirt(record) when is_tuple(record) do
		elem(record,9)
	end
	def cirt(id) do
		Cfg.get_field(:cfg_level,id,9)
	end

	def anit_cirt(record) when is_tuple(record) do
		elem(record,10)
	end
	def anit_cirt(id) do
		Cfg.get_field(:cfg_level,id,10)
	end

	def cirt_value(record) when is_tuple(record) do
		elem(record,11)
	end
	def cirt_value(id) do
		Cfg.get_field(:cfg_level,id,11)
	end
end
defmodule Cfg_position do

	def get(id) do
		Cfg.get(:cfg_position,id)
	end

	def get_field_id(id) do
		case id do
			:team -> 0
			:id -> 1
			:x -> 2
			:z -> 3
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_position,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4"}
		Cfg.find(:cfg_position,list,q,fn(x)-> get_field_id(x) end)
	end

	def team(record) when is_tuple(record) do
		elem(record,0)
	end
	def team(id) do
		Cfg.get_field(:cfg_position,id,0)
	end

	def id(record) when is_tuple(record) do
		elem(record,1)
	end
	def id(id) do
		Cfg.get_field(:cfg_position,id,1)
	end

	def x(record) when is_tuple(record) do
		elem(record,2)
	end
	def x(id) do
		Cfg.get_field(:cfg_position,id,2)
	end

	def z(record) when is_tuple(record) do
		elem(record,3)
	end
	def z(id) do
		Cfg.get_field(:cfg_position,id,3)
	end
end
defmodule Cfg_skill do

	def get(id) do
		Cfg.get(:cfg_skill,id)
	end

	def get_field_id(id) do
		case id do
			:id -> 0
			:index -> 1
			:script -> 2
			:params -> 3
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_skill,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4"}
		Cfg.find(:cfg_skill,list,q,fn(x)-> get_field_id(x) end)
	end

	def id(record) when is_tuple(record) do
		elem(record,0)
	end
	def id(id) do
		Cfg.get_field(:cfg_skill,id,0)
	end

	def index(record) when is_tuple(record) do
		elem(record,1)
	end
	def index(id) do
		Cfg.get_field(:cfg_skill,id,1)
	end

	def script(record) when is_tuple(record) do
		elem(record,2)
	end
	def script(id) do
		Cfg.get_field(:cfg_skill,id,2)
	end

	def params(record) when is_tuple(record) do
		elem(record,3)
	end
	def params(id) do
		Cfg.get_field(:cfg_skill,id,3)
	end
end
defmodule Cfg_master_skill do

	def get(id) do
		Cfg.get(:cfg_master_skill,id)
	end

	def get_field_id(id) do
		case id do
			:id -> 0
			:u_type -> 1
			:u_range -> 2
			:d_range -> 3
			:d_type -> 4
			:obj_type -> 5
			:energy -> 6
			:pre_anim -> 7
			:pre_effect -> 8
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_master_skill,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4",:"$5",:"$6",:"$7",:"$8",:"$9"}
		Cfg.find(:cfg_master_skill,list,q,fn(x)-> get_field_id(x) end)
	end

	def id(record) when is_tuple(record) do
		elem(record,0)
	end
	def id(id) do
		Cfg.get_field(:cfg_master_skill,id,0)
	end

	def u_type(record) when is_tuple(record) do
		elem(record,1)
	end
	def u_type(id) do
		Cfg.get_field(:cfg_master_skill,id,1)
	end

	def u_range(record) when is_tuple(record) do
		elem(record,2)
	end
	def u_range(id) do
		Cfg.get_field(:cfg_master_skill,id,2)
	end

	def d_range(record) when is_tuple(record) do
		elem(record,3)
	end
	def d_range(id) do
		Cfg.get_field(:cfg_master_skill,id,3)
	end

	def d_type(record) when is_tuple(record) do
		elem(record,4)
	end
	def d_type(id) do
		Cfg.get_field(:cfg_master_skill,id,4)
	end

	def obj_type(record) when is_tuple(record) do
		elem(record,5)
	end
	def obj_type(id) do
		Cfg.get_field(:cfg_master_skill,id,5)
	end

	def energy(record) when is_tuple(record) do
		elem(record,6)
	end
	def energy(id) do
		Cfg.get_field(:cfg_master_skill,id,6)
	end

	def pre_anim(record) when is_tuple(record) do
		elem(record,7)
	end
	def pre_anim(id) do
		Cfg.get_field(:cfg_master_skill,id,7)
	end

	def pre_effect(record) when is_tuple(record) do
		elem(record,8)
	end
	def pre_effect(id) do
		Cfg.get_field(:cfg_master_skill,id,8)
	end
end
defmodule Cfg_skill_lvl do

	def get(id) do
		Cfg.get(:cfg_skill_lvl,id)
	end

	def get_field_id(id) do
		case id do
			:id -> 0
			:level -> 1
			:params_A -> 2
			:params_B -> 3
			_ -> nil
		end
	end

	def match(list) do
		q = {:"_",:"_",:"_",:"_"}
		Cfg.match(:cfg_skill_lvl,list,q,fn(x)-> get_field_id(x) end)
	end

	def find(list) do
		q = {:"$1",:"$2",:"$3",:"$4"}
		Cfg.find(:cfg_skill_lvl,list,q,fn(x)-> get_field_id(x) end)
	end

	def id(record) when is_tuple(record) do
		elem(record,0)
	end
	def id(id) do
		Cfg.get_field(:cfg_skill_lvl,id,0)
	end

	def level(record) when is_tuple(record) do
		elem(record,1)
	end
	def level(id) do
		Cfg.get_field(:cfg_skill_lvl,id,1)
	end

	def params_A(record) when is_tuple(record) do
		elem(record,2)
	end
	def params_A(id) do
		Cfg.get_field(:cfg_skill_lvl,id,2)
	end

	def params_B(record) when is_tuple(record) do
		elem(record,3)
	end
	def params_B(id) do
		Cfg.get_field(:cfg_skill_lvl,id,3)
	end
end