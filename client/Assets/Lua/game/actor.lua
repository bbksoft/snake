


local Actor = {}



function Actor.create(data)
    local actor = data or {}

    Actor.__index = Actor
    setmetatable(actor,Actor)

    actor:init()

    return actor
end

function Actor:init()

    if not self.pos then
        self.pos = Vector2(0,0)
    end

    if not self.forward then
        self.forward = Vector2(1,0)
    end

    if not self.speed then
        self.speed = 1
    end

    if not self.path then
        self.path = {self.pos:Clone(),self.pos}
    end

    if not self.trail_len  then
        self.trail_len = 1
    end

    self.obj = load_gameobject("snake/snake")
end


function Actor:update()
    self:update_forward()
    self:update_move()

    self:draw()
end


function Actor:turn_forward(v)
    v:SetNormalize()
    local a = v:ToAngle()
    local b = self.forward:ToAngle()

    local d = a - b

    if d > 180 then
         d = d - 360
    elseif d < -180 then
         d = d + 360
    end
    self.rotate_value = d
    --self.forward = v
    --self:add_path()
end

function Actor:update_forward()
    if self.rotate_value then
        self.rotate_time = self.rotate_time or 0

        if self.rotate_time < client.time then
            local r = 0.2 * 180

            if self.rotate_value < 0 then
                r = -r
                if r < self.rotate_value then
                    r = self.rotate_value
                    self.rotate_value = nil
                else
                    self.rotate_value = self.rotate_value - r
                end
            else
                if r > self.rotate_value then
                    r = self.rotate_value
                    self.rotate_value = nil
                else
                    self.rotate_value = self.rotate_value - r
                end
            end

            self.forward:Rotate(r):SetNormalize()
            self:add_path()

            self.rotate_time = client.time + 0.2
        end
    end
end

function Actor:update_move()
    self.trail_len = self.trail_len + 0.5 * client.dt

    local dis = self.speed * client.dt
    self.pos:Add(self.forward:Clone():Mul(dis))

    if self.trail_len >= dis then
        self.trail_len = self.trail_len - dis
        dis = 0
    elseif self.trail_len > 0 then
        dis = dis - self.trail_len
        self.trail_len = 0
    end

    while dis > 0.000001 do

        local pos1 = self.path[1]
        local pos2 = self.path[2]
        local d = pos2:Clone():Sub(pos1)
        local len = d:Magnitude()

        if len <= dis then
            dis = dis - len
            table.remove(self.path,1)
        else
            pos1:Add(d:Div(len):Mul(dis))
            dis = 0
        end
    end


end

function Actor:add_path()
    local len = table.maxn(self.path)
    table.insert(self.path,len,self.pos:Clone())

    --print("---")
    -- for i,v in ipairs(self.path) do
    --     print(v.x,v.y)
    -- end
end

function Actor:draw()
    self.obj.transform.localPosition = Vector3(self.pos.x,self.pos.y,0);
    GameAPI.DrawPath(self.obj,self.forward,self.path,0.1)
end

return Actor
