

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


    self.pt_time = self.time
    self.pts = {}
    self.pt_colors = {}
    self.max_pt_id = 1
    self.pt_obj = GameObject.Find("Pts")

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

    GameAPI.SetPoints(self.pt_obj,self.pts,self.pt_colors)
end

function Client:update(dt)

    self.dt = dt
    self.time = self.time + dt

    for k,v in pairs(self.actors) do
        v:update()

        local pt_k = 1
        while self.pts[pt_k] do
            local pt = self.pts[pt_k]
            local dis2 = dis_pos_2(v.pos,pt)
            --print(pt_k,dis2,_s(v.pos),_s(pt))
            if dis2 < 0.25 then
                v:add_trail()
                table.remove(self.pts,pt_k)
                table.remove(self.pt_colors,pt_k)
            else
                pt_k = pt_k + 1
            end
        end
    end

end

function Client:update_fixed()
    for k,v in pairs(self.actors) do
        v:update_fixed()
    end

    if self.pt_time < self.time then
        local x = (math.random() - 0.5) * 5 + self.me.pos.x
        local y = (math.random() - 0.5) * 5 + self.me.pos.y


        table.insert(self.pts,Vector2(x,y))
        table.insert(self.pt_colors,self.max_pt_id)
        self.max_pt_id = self.max_pt_id + 1

        self.pt_time = self.time + 1
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
