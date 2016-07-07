
local Class = {}


function Class.create()
    local self = {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()
    self.res_name = "UI_Heroes_Levelup"

    _ui_begin(self)

        _ui_add({type="close",node_name="Button_Close"})

        local control = {}
        _ui_add({type="list",node_name="HEROES",control=control,data_name = "@player.heros"})
        _ui_begin(control)
            _ui_add({type="sprite",node_name="Icon",data_name="icon",sprite_type="HeroIcon"})

            local fun = function(data,node)
                if data.level < 5 then
                    data.level = data.level + 1
                    UI.set_child_text(node,"../Text",data.level)
                end
            end
            _ui_add({type="button",node_name="Button_add",fun=fun})
            local fun = function(data,node)
                if data.level > 1 then
                    data.level = data.level - 1
                    UI.set_child_text(node,"../Text",data.level)
                end
            end
            _ui_add({type="button",node_name="Button_delete",fun=fun})
            _ui_add({type="text",node_name="Text",data_name="level"})
        _ui_end()

    _ui_end()
end

function Class:on_focus()
    
end


return Class
