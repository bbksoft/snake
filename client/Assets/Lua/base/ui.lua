

local UI_display = {
	ui_list = {},
	ui_key = {},
}

local UI = {}

function UI.create( name, data )

	local view

	local full_name = "uiview."..name
	local class = require(full_name)


	view = class.create(data)
	view._type = "ui"

	local t =  UITools.Show(view.res_name)


	--print("create node",t)


	local len = #UI_display.ui_list
	if len > 0 then
		local ui = UI_display.ui_list[len]
		if ui.lost_focus then
			ui:lost_focus()
		end
	end

	view.node = t

	table.insert(UI_display.ui_list,view)

	view.key_name = name
	UI_display.ui_key[name] = view

	if not view.hide then
		UI.show( view )
	end

	return view
end

function UI.get(name)
	return UI_display.ui_key[name]
end

function UI.refresh( ui )
	--print("show node",t)
	ui.node.gameObject:SetActive(true)
	UI.display(ui)
end

function UI.show( ui )
	if ui._type and (ui._type == "ui") then
		UI.display(ui)
	else
		print("It is not ui gameobj. Maybe used create().")
	end
end

function UI.hide( ui )
	ui.node.gameObject:SetActive(false)
end

function UI.close( ui )
	local len = #UI_display.ui_list
	if len <= 0 then
		return
	end

	local set_focus = nil
	if ui == nil then
		ui =  UI_display.ui_list[len]
		if len > 1 then
			set_focus = UI_display.ui_list[len-1]
		end
		UI_display.ui_list[len] = nil
	else
		if UI_display.ui_list[len] == ui then
			UI_display.ui_list[len] = nil
			if len > 1 then
				set_focus = UI_display.ui_list[len-1]
			end
		else
			for k,v in pairs(UI_display.ui_list) do
				if v == ui then
					table.remove(UI_display.ui_list,k)
					break
				end
			end
		end
	end

	UITools.Close(ui.node)

	if ui.destroy then
		ui:destroy()
	end

	UI_display.ui_key[ui.key_name] = nil

	if set_focus then
		if set_focus.on_focus then
			set_focus:on_focus()
		end

		UI.refresh(set_focus)
	end
end

function UI.close_all()
	for _,ui in pairs(UI_display.ui_list) do
		UITools.Close(ui.node)
		if ui.destroy then
			ui:destroy()
		end
	end
	UI.enable3d(false)
	UI_display.ui_list = {}
	UI_display.ui_key = {}


	UITools.ClearAll()
end

function UI.enable3d(value)
	-- maybe TODO:
	-- if UI_display.enable3d ~= value then
	-- 	UITools.EnableUI3dCamera(value)
	-- 	UI_display.enable3d = value
	-- end
end

function UI.display(ui,node,data)

	if not node then
		node = ui.node
		if ui.enable3d then
			UI.enable3d(true)
		else
			UI.enable3d(false)
		end
	end

	local child_node = node

	if ui.node_name then
		child_node = node:Find(ui.node_name)
	end

	local child_data = data

	if ui.data_name then
		if string.sub(ui.data_name,1,1) == '@' then
			child_data = get_path_value(string.sub(ui.data_name,2))
		else
			child_data = get_path_value(ui.data_name,data)
		end
	elseif ui.data then
		child_data = ui.data
	end

	if ui.type then
		local fun = UI_display[ui.type]
		assert(fun,"not function in UI_display:"..ui.type)
		fun(child_node,ui,child_data)
	end

	if ui.children then
		for _,child in pairs(ui.children) do
			UI.display(child,child_node,child_data)
		end
	end
end

function UI.find_child(node,child)
	if string.sub(child,1,2) == '..' then
		if string.sub(child,3,3) == "/" then
			return UI.find_child(node.parent,string.sub(child,4))
		else
			return node.parent
		end
	else
		return node:Find(child)
	end
end

function UI.set_text(node,data)
	if type(data) == "string" then
		UITools.SetText(node,data)
	else
		UITools.SetText(node,tostring(data))
	end
end

function UI.set_child_text(node,child,data)
	node = UI.find_child(node,child)
	UI.set_text(node,data)
end

function UI.set_enable_image(node,data)
	if data then
		UITools.SetEnableImage(node,true)
	else
		UITools.SetEnableImage(node,false)
	end
end

function UI.set_child_enable_image(node,child,data)
	node = UI.find_child(node,child)
	UI.set_enable_image(node,data)
end


function UI_display.enable(node,ui,data)
	if data then
		node.gameObject:SetActive(true)
	else
		node.gameObject:SetActive(false)
	end
end

function UI_display.text(node,ui,data)
	--print("text",node)
	if ui.text then
		UITools.SetText(node,ui.text)
	else
		--print("test",data)
		--print(_s(ui))
		local t = type(data)
		if t == "string" then
			UITools.SetText(node,data)
		elseif t == "number" then
			UITools.SetText(node,format_number(data))
		else
			UITools.SetText(node,tostring(data))
		end
	end
end

function UI_display.sprite(node,ui,data)
	UITools.SetPic(node,ui.sprite_type,data)
end

function UI_display.button(node,ui,data)
	--print("node",node)
	local fun = function()
		local old_index = sound_player.index
		ui.fun(data,node)
		if sound_player.index == old_index then
			sound_player.play("aow2_sfx_button_click")
		end
	end
	UITools.SetButton(node,fun)
end

function UI_display.button_index(node,ui,data)
	--print("node",node)
	local fun = function(index)
		ui.fun(index,data,node)
	end
	UITools.SetButton(node,fun,_ui_index)
end

function UI_display.drag_button(node,ui,data)
	local fun = function(drag,pos)
		ui.fun(drag,pos,data,node)
	end
	UITools.SetDragFun(node,fun)
end

function UI_display.list(node,ui,data)
	local n = 0
	for _,v in pairs(data) do
		n = n + 1
		_ui_index = n
		child_node = UITools.GetListChild(node,n)
		UI.display(ui.control,child_node,v)
	end
	UITools.SetListLen(node,n)

	if ui.drag_fun then
		local fun = function(id1,id2)
			ui.drag_fun(data,node,id1,id2)
		end
		UITools.SetDragChange(node,fun)
	end

	if ui.cancel_node then
		UITools.SetDragCancel(node,UI.find_child(ui.cancel_node))
	end
end

function UI_display.list_fixed(node,ui,data)
	for i=1,ui.fixed_count do
		child_node = UITools.GetListChild(node,i)
		UI.display(ui.control,child_node,data[i])
	end

	if ui.drag_fun then
		local fun = function(id1,id2)
			ui.drag_fun(data,node,id1,id2)
		end
		UITools.SetDragChange(node,fun)
	end

	if ui.cancel_node then
		UITools.SetDragCancel(node,UI.find_child(node,ui.cancel_node))
	end
end

function UI_display.fill(node,ui,data)
	UITools.SetFill(node,data)
end

function UI_display.close(node,ui,data)
	local fun = function()
		sound_player.play("aow2_sfx_button_close")
		UI.close()
	end
	UITools.SetButton(node,fun)
end

function UI_display.fun(node,ui,data)
	ui.fun(data,node)
end

return UI
