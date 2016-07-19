


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

    self.rotate_speed = 90

    if not self.forward_angle then
        self.forward_angle = 0
    end
    self.draw_angle = self.forward_angle
    self.rotate_angle = self.forward_angle
    self.forward = Vector2.FromAngle(self.forward_angle)

    if not self.speed then
        self.speed = 1
    end

    if not self.path then
        self.path = {self.pos:Clone(),self.pos}
    end


    self.trail_len = self.length

    self.obj = load_gameobject("snake/snake")
    self.obj_head = self.obj.transform:FindChild("head").gameObject
end


function Actor:update()
    self:update_move()
end


function Actor:turn_forward(v)
    self.rotate_angle = v:ToAngle()
end

function Actor:update_fixed()
    if self.rotate_angle ~= self.forward_angle then
        local r = self.rotate_speed * client.fixed_dt

        local d_angle = self.rotate_angle - self.forward_angle
        local abs_angle = math.abs(d_angle)

        if abs_angle > 180 then
            abs_angle = 360 - abs_angle
            d_angle = -d_angle
        end

        if abs_angle <= r then
            self.forward_angle = self.rotate_angle
        else
            if d_angle > 0 then
                self.forward_angle = self.forward_angle + r
            else
                self.forward_angle = self.forward_angle - r
            end
        end
        self:add_path()

        self.forward = Vector2.FromAngle(self.forward_angle)
    end
end

function Actor:update_move()

    --self.draw_angle = self.forward_angle
    if self.rotate_angle ~= self.draw_angle then
        local r = self.rotate_speed * client.dt

        local d_angle = self.rotate_angle - self.draw_angle
        local abs_angle = math.abs(d_angle)

        if abs_angle > 180 then
            abs_angle = 360 - abs_angle
            d_angle = -d_angle
        end

        if abs_angle <= r then
            self.draw_angle = self.rotate_angle
        else
            if d_angle > 0 then
                self.draw_angle = self.forward_angle + r
            else
                self.draw_angle = self.forward_angle - r
            end
        end
    end

    -- for test
    --self.trail_len = self.trail_len + 0.5 * client.dt

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

        local test1 = pos1.x

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

function Actor:set_length(value)
    self:add_trail(self.length-value)
    self.length = value
end

function Actor:add_trail(value)
    value = value or 0.2
    self.trail_len = self.trail_len + value
end

function Actor:draw()
    --print(self.draw_angle)
    self.obj_head.transform.eulerAngles = Vector3(0,0,self.draw_angle)
    self.obj.transform.localPosition = Vector3(self.pos.x,self.pos.y,0)
    GameAPI.DrawPath(self.obj,self.forward,self.path,0.4)
end

return Actor
