

local Class = {}


function Class.create(data)
    local self = data or {}

    Class.__index = Class
    setmetatable(self,Class)

    self:init()
    return self
end

function Class:init()
    self.res_name = "UI_ChooseHeroes"

    player.select_another = nil
    player.heros = player.atk_frm.heros
    player.frm   = player.atk_frm.frm

    _ui_begin(self)
        local view_select = function(data,node)
            if player.select_another then
                UI.set_child_enable_image(node,"attack",false)
                UI.set_child_enable_image(node,"defence",true)
            else
                UI.set_child_enable_image(node,"attack",true)
                UI.set_child_enable_image(node,"defence",false)
            end
        end
        _ui_add({type="fun",node_name="FORMATION",fun=view_select})

        local fun = function()
            player.select_another = not player.select_another

            if player.select_another then
                player.heros = player.def_frm.heros
                player.frm   = player.def_frm.frm
            else
                player.heros = player.atk_frm.heros
                player.frm   = player.atk_frm.frm
            end


            UI.refresh(self)
        end
        _ui_add({type="button",node_name="btns/btn_changeTeam",fun=fun})

        local fun = function()
            --if (#player.atk_frm.frm > 0)and(#player.def_frm.frm > 0) then
                --UITools.EnableObj("Camera")
                GameAPI.LoadScene(1)
                UI.close_all()
            --end
        end
        _ui_add({type="button",node_name="btns/btn_battle",fun=fun})

        local fun = function()
            UI.create("heros_lvl")
        end
        _ui_add({type="button",node_name="btns/btn_lvlUp",fun=fun})


        local control = {}
        _ui_add({type="list",node_name="HERO/heroes",control=control,data_name = "@player.heros"})
        _ui_begin(control)
            _ui_add({type="sprite",data_name="icon",sprite_type="HeroIcon"})
            local fun = function(index,data)

                if not data.pos_index then
                    local frm = player.frm
                    if self:get_frm_count(frm) < 5 then
                        data.pos_index= self:set_frm(frm,index)
                    end
                else
                    player.frm[data.pos_index] = nil
                    data.pos_index = nil
                end
                UI.refresh(self)
            end
            _ui_add({type="button_index",node_name="Button",fun=fun})
            _ui_add({type="text",node_name="Text",data_name="level"})
            _ui_add({type="enable",node_name="choosesign",data_name="pos_index"})
        _ui_end()

        local view_mod_fun = function(data,node)

            if data then
                data = player.atk_frm.heros[data].id
                UITools.AddMod(node,"mod","actor/"..cfg_actor[data].res,30,Vector3(1,0,0))
            else
                UITools.DelMod(node,"mod")
            end
        end
        local drag_fun = function(id1,id2)
            --print(id1,id2)
            local temp = player.atk_frm.frm[id1]
            player.atk_frm.frm[id1] = player.atk_frm.frm[id2]
            player.atk_frm.frm[id2] = temp
            UI.refresh(self)
        end
        local control = {type="fun",fun=view_mod_fun}
        _ui_add({type="list_fixed",fixed_count=9,node_name="FORMATION/attack",
                    drag_fun = drag_fun,
                    control=control,data_name = "@player.atk_frm.frm"})


        local view_mod_fun = function(data,node)
            if data then
                data = player.def_frm.heros[data].id
                UITools.AddMod(node,"mod","actor/"..cfg_actor[data].res,30,Vector3(-1,0,0))
            else
                UITools.DelMod(node,"mod")
            end
        end
        local drag_fun = function(id1,id2)
            local temp = player.def_frm.frm[id1]
            player.def_frm.frm[id1] = player.def_frm.frm[id2]
            player.def_frm.frm[id2] = temp
            UI.refresh(self)
        end
        local control = {type="fun",fun=view_mod_fun}
        _ui_add({type="list_fixed",fixed_count=9,node_name="FORMATION/defence",
                    drag_fun = drag_fun,
                    control=control,data_name = "@player.def_frm.frm"})
    _ui_end()
end

function Class:get_frm_count(frm)
    local count = 0
    for i=1,9 do
        if frm[i] then
            count = count + 1
        end
    end
    return count
end

function Class:set_frm(frm,id)

    local n = self:get_frm_pos(frm,id)

    frm[n] = id
    return n
end

function Class:get_frm_pos(frm,id)

    local hero = player.heros[id]

    local cfg = cfg_actor[hero.id]

    local pos = 4 - cfg.pos

    if player.select_another then
        pos = cfg.pos
    end

    if not frm[pos+3] then
        return (pos + 3)
    end

    if not frm[pos] then
        return (pos + 0)
    end

    if not frm[pos+6] then
        return (pos + 6)
    end

    if player.select_another then
        if pos == 3 then
            pos = 2
        else
            pos = pos - 1
        end
    else
        if pos == 1 then
            pos = 2
        else
            pos = pos - 1
        end
    end

    if not frm[pos+3] then
        return (pos +3)
    end

    if not frm[pos] then
        return (pos + 0)
    end

    if not frm[pos+6] then
        return (pos + 6)
    end
end

function Class:on_focus()

end

function Class:lost_focus()
    UI.hide(self)
end

return Class
