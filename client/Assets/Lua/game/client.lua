

-- global require
local Actor = require "game.actor"



local Client = {}

function Client.create(data)
    local self = data or {}

    Client.__index = Client
    setmetatable(self,Client)

    self:init()

    return self
end



function Client:init()
    self.actors = {}
    self.dt = 0
    self.time = 0

    local fun = function()
        self:update(Time.deltaTime)
    end

    UpdateBeat:Add(fun,self)
end

function Client:update(dt)

    self.dt = dt
    self.time = self.time + dt

    for k,v in pairs(self.actors) do
        v:update()
    end

end

function Client:create_actor(data)
    local a = Actor.create(data)
    if data.id == self.my_id then
        self.me = a
        GameAPI.SetCameraFllow2D(a.obj)
    end
    self.actors[data.id] = a
end

function Client:OnDragDirect(v)
    self.me:turn_forward(v)
end

return Client
