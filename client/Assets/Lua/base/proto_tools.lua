
local Class  = {}
Class.config = require("config/proto")

Class.__index = Class
setmetatable(Class,Class)

function Class:call_to_bin(class_name,fun,...)
	local arg = {...}

	self.bin = ""

	local fun = self:get_fun(class_name,fun)

	self:write_int(0)
	self:write_int(fun.id)

	for i,param_def in ipairs(fun.param_list) do
		if arg[i] ~= nil then
			if param_def.is_array then
				self:write_array(param_def.type,arg[i])
			else
				self:write(param_def.type,arg[i])
			end
		else
			self:write_null()
		end
	end

	return self.bin
end

function Class:bin_to_call(bin,pos)
	self.bin = bin
	self.pos = pos or 1
	self.len = #bin

	local call_type = self:read_int()

	local fun = nil

	if call_type == 0 then
		local id = self:read_int()
		fun = self:get_fun_by_id(id)
	else
		local class_name = self:read_string()
		local fun_name = self:read_string()
		fun = self:get_fun(class_name,fun_name)
	end

	local params = {}
	for i,param_def in ipairs(fun.param_list) do

		if param_def.is_array then
			params[i] = self:read_array(param_def.type)
		else
			params[i] = self:read_value(param_def.type)
		end
	end

	return fun.class_name,fun.name,params
end

function Class:read_array( type_name  )

	local n = self:read_int()
	if n == 0 then
		return {}
	elseif n then
		local data = {}
		for i=1,n do
			data[i] = self:read_value(type_name)
		end
		return data
	else
		return nil
	end
end

function  Class:read_value( type_name  )
	if type_name == "Int" then
		return self:read_int()
	elseif type_name == "String" then
		return self:read_string()
	elseif type_name == "Boolean" then
		return self:read_bool()
	elseif type_name == "Single" then
		return self:read_float()
	else
		local type_data = self:get_type(type_name)

		if type_data.is_enum then
			local n = self:read_int()
			if n then
				return type_data[n]
			else
				return nil
			end
		else
			local n = self:read_int()
			if n then
				local data = {}
				for i,v in ipairs(type_data.menbers) do
					if v.is_array then
						data[v.name] = self:read_array(v.type)
					else
						data[v.name] = self:read_value(v.type)
					end
				end
				return data
			else
				return nil
			end
		end
	end
end

function  Class:read_int()
	local n = string.byte(self.bin,self.pos)
	self.pos = self.pos + 1

	if n == 128 then
		return nil
	else
		local ret = 0
		while n >= 128 do
			ret = ret * 128 + (n - 128)
			n = string.byte(self.bin,self.pos)
			self.pos = self.pos + 1
		end
		ret = ret * 128 + n
		return ret
	end
end

function  Class:read_bool( )
	local n = self:read_int()
	if n then
		if n == 0 then
			return false
		else
			return true
		end
	else
		return nil
	end
end

function  Class:read_string( )
	local len = self:read_int()

	if len then
		if len == 0 then
			return ""
		else
			local ret = string.sub(self.bin,self.pos,self.pos+len-1)
			self.pos = self.pos + len
			return ret
		end
	else
		return nil
	end
end

function  Class:read_float( )
	local data = self:read_int()
	if data then
		return data / 100.0
	else
		return nil
	end
end


function Class:get_fun_by_id(id)

	for _,fun in pairs(self.config.funs) do
		if fun.id == id then
			return fun
		end
	end

	assert(false,"can't found fun:" .. id)
end

function Class:get_fun(class_name,fun)

	for _,v in pairs(self.config.funs) do
		if v.name == fun and v.class_name == class_name then
			return v
		end
	end

	assert(false,"can't found fun:" .. class_name .. "->" .. fun)
end

function Class:get_type(type_name)

	for _,v in pairs(self.config.types) do
		if v.name == type_name then
			return v
		end
	end

	assert(false,"can't found type:" .. type_name)
end


function Class:write_array( type_name, data )
	if data == nil then
		self:write_null()
	else
		assert(type(data) == "table")

		self:write_int(#data)
		for i,value in ipairs(data) do
			self:write(type_name,value)
		end
	end
end

function Class:write(type_name,data)
	if data == nil then
		self:write_null()
	else
		if type_name == "Int" then
			self:write_int(data)
		elseif type_name == "String" then
			self:write_string(data)
		elseif type_name == "Boolean" then
			self:write_bool(data)
		elseif type_name == "Single" then
			self:write_float(data)
		else
			data_type = self:get_type(type_name)

			if data_type.is_enum then
				local id = nil
				for i,v in ipairs(data_type.enum_values) do
					if v == data then
						id = i
						break
					end
				end
				if id then
					self:write_int(id)
				else
					self:write_null()
				end
			else
				self:write_int(0)
				for i,v in ipairs(data_type.menbers) do
					if data[v.name] then
						if v.is_array then
							self:write_array(v.type,data[v.name])
						else
							self:write(v.type, data[v.name])
						end
					else
						self:write_null()
					end
				end
			end
		end
	end
end

function  Class:write_null()
	self.bin = self.bin .. string.char(128)
end

function  Class:write_int(data)
	assert(type(data) == "number")

	data = math.floor(data)

	if data < 128 then
		self.bin = self.bin .. string.char(data)
	else
		local datas = {}
		local n = 0
		while data >= 128 do
			n = n + 1
			datas[n] = data % 128
			data = data / 128
		end

		n = n + 1
		datas[n] =  data

		while n > 1 do
			self.bin = self.bin .. string.char(128+datas[n])
			n = n - 1
		end

		self.bin = self.bin .. string.char(datas[n])
	end
end

function  Class:write_string(data)
	assert(type(data) == "string")

	self:write_int(#data)
	self.bin = self.bin .. data
end

function  Class:write_bool(data)
	assert(type(data) == "boolean")

	if data then
		self.bin = self.bin .. string.char(1)
	else
		self.bin = self.bin .. string.char(0)
	end
end

function  Class:write_float(data)
	assert(type(data) == "number")

	self:write_int(data*100)
end


return Class
