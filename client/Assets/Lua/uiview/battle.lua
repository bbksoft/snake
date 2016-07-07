
local Class = {}


function Class.create(data)
    local self = data or {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()
    self.res_name = "UI_battle"

    _ui_begin(self)


    local control = {}
    _ui_add({type="list",node_name="Heroes",control=control,data_name = "@game_client.my_heros"})
    _ui_begin(control)
        local fun = function(drag,pos,data,node)

            if drag == "down" then
                data:pre_master_skill()
            elseif drag == nil then
                data:used_master_skill()
            else
                if drag == "begin" then
                    data:move_master_skill(pos)
                elseif drag == "move" then
                    data:move_master_skill(pos)
                elseif drag == "end" then
                    data:used_master_skill()
                end
            end
        end
        _ui_add({type="drag_button",node_name="Button",fun=fun})
        _ui_add({type="sprite",node_name="hero1",data_name="cfg.icon",sprite_type="HeroIcon"})
        _ui_add({type="fill",node_name="life",data_name="hp"})
        _ui_add({type="fill",node_name="ap",data_name="energy"})

        local set_ui = function(data,node)
            data.ui = node
        end
        _ui_add({type="fun",fun=set_ui})
    _ui_end()

    local fun = function()

        if not game_client.is_paused then
            game_client.speed_up = not game_client.speed_up

            if game_client.speed_up then
                Time.timeScale = 2.0
            else
                Time.timeScale = 1.0
            end
        end
    end
    _ui_add({type="button",node_name="button/speedup",fun=fun})

    local fun = function()
        game_client:send_server("set_auto", {})
    end
    _ui_add({type="button",node_name="button/autobattle",fun=fun})

    _ui_end()
end


return Class
