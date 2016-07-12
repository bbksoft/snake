
client = {}

function client.create(data)
    local self = data or {}

    client.__index = client
    setmetatable(self,client)

    self:init()

    return self
end



function client:init()
    self.actors = {}
end

function client:update()

end





return client
