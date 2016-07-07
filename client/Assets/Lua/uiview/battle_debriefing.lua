

local Class = {}


function Class.create(data)
    local self = data or {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()
    --print("UI_battle_debriefing")
    self.res_name = "UI_battle_debriefing"

    _ui_begin(self)
        local fun = function()
            game_client:destroy()
            UI.close_all()
            GameAPI.LoadScene(0)
        end
        _ui_add({type="button",node_name="Button_Close",fun=fun})

        _ui_add({type="text",node_name="info/result/Text",data=self.result})
    _ui_end()
end


return Class
