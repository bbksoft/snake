local socket = require("socket")

local Class  = {}

function  Class:connect(ip,port)

	self:close()

	self.sock = socket.connect(ip, port)
	if self.sock then
		print "connectted to server"

		self.sock:settimeout(0)

		self.fun = function()
			self:update()
		end

		UpdateBeat:Add(self.fun,self)

		return true
	else
		print("connectted to server faile", ip, tostring(port))
		return false
	end
end

function  Class:send(class,fun,...)
	local bin = proto:call_to_bin(class,fun,...)
	local len = #bin

	local n1 =  len / 256
	local n2 =  len % 256

	bin = string.char(n1,n2) .. bin

	if self.sock then
		self.sock:send(bin)
	end
end

function Class:set_event_disconnect(fun)
	self.on_disconnect = fun
end

function Class:update()
	if self.sock then
		local response, receive_status

		if self.pack_len then
			response, receive_status = self.sock:receive(self.pack_len)
		else
			response, receive_status = self.sock:receive(2)
		end

        if receive_status ~= "closed" then
            if response then
               	if self.pack_len then
                	self:do_response(response)
                	self.pack_len = nil
                else
                	self.pack_len = string.byte(response,1) * 256 + string.byte(response,2)
                end
                self:update()
            end
        else
        	if self.on_disconnect then
        		self.on_disconnect()
        	end
            self.sock = nil
        end
	end
end

function  Class:do_response(data)
	local call_class,call_fun,call_params = proto:bin_to_call(data)

	print("call",call_class,call_fun)

	_G[call_class][call_fun](unpack(call_params))
end

function Class:close()
	if self.fun then
		UpdateBeat:Remove(self.fun,self)
		self.fun = nil
	end

	if self.sock then
		self.sock:close()
		self.sock = nil
	end
	self.temp_data = nil
	self.pack_len = nil

end


function Class:new()
	local o = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function Class:destroy()
	self:close()
end

return Class
