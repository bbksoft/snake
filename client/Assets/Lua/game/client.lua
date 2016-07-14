

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
    self.fixed_dt  = 0.2

    self.time = Time.realtimeSinceStartup
    self.fixed_time = Time.realtimeSinceStartup

    local fun = function()
        while ( self.fixed_time < Time.realtimeSinceStartup ) do
            self:update_fixed()

            if (self.time < self.fixed_time) then
                self:update(self.fixed_dt)
            end

            self.fixed_time = self.fixed_time + self.fixed_dt
        end
        self:update(Time.realtimeSinceStartup-self.time)
        self:draw()
    end

    UpdateBeat:Add(fun,self)
end

function Client:draw()
    for k,v in pairs(self.actors) do
        v:draw()
    end
end

function Client:update(dt)

    self.dt = dt
    self.time = self.time + dt

    for k,v in pairs(self.actors) do
        v:update()
    end

end

function Client:update_fixed()
    for k,v in pairs(self.actors) do
        v:update_fixed()
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
