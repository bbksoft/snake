
function _s(data,head,name)

	if not head then
		head = ""
	end

	if not name then
		name = "{}"
	elseif type(name) ~= "string" then
		name = tostring(name)
	end

	if data == nil then
		return "\n" .. head .. name .. "[nil]"
	elseif type(data) == "table" then
		local str = "\n" .. head .. tostring(name) .. " ->"
		local nextHead = head .. "    "

		for k,v in pairs(data) do
			str = str .. _s(v,nextHead,k)
		end
		return str
	else
		return "\n" .. head .. name .. "[" .. tostring(data) .. "]"
	end
end

function _bs(data)
	local n = #data
	local str = ""
	for i=1,n do
		str = str .. "." .. string.byte(data,i)
	end
	return str
end

function clone_table( t, depth )
	local ret = {}

	for k,v in pairs(t) do
		if depth and (depth>1) then
			if type(v) == "table" then
				ret[k] = clone_table(v,depth-1)
			else
				ret[k] = v
			end
		else
			ret[k] = v
		end
	end

	return ret
end

function merge_table( t1, t2, deep )
	if deep == nil then
		deep = 1
	elseif deep == 0 then
		return
	end

	for k,v in pairs(t2) do
		if deep == 1 then
			t1[k] =  v
		elseif t1[k] == nil then
			t1[k] =  v
		else
			merge_table(t1[k],v,deep-1)
		end
	end
end


-- for UI
function _ui_begin(obj,add)
	if _ui_datas == nil then
		_ui_datas = {}
	else
		if _ui_datas.cur then
			table.insert(_ui_datas,_ui_datas.cur)
		end
	end

	if add then
	 	_ui_add(obj)
	end
	_ui_datas.cur = obj
end

function _ui_add(obj)
	if not _ui_datas.cur.children then
		_ui_datas.cur.children = {}
	end
	table.insert(_ui_datas.cur.children,obj)
	--obj.parent = _ui_datas.cur
	return obj
end

function _ui_end()
	local len =  #_ui_datas
	if len > 0 then
		_ui_datas.cur = _ui_datas[len]
		_ui_datas[len] = nil
	else
		_ui_datas = nil
	end
end

function get_path_value(path,value)

	if not value then
		value = _G
	end

	local pos = string.find(path,"%.")
	if pos then
		local key = string.sub(path,1,pos-1)
		return get_path_value(string.sub(path,pos+1),value[key])
	else
		return value[path]
	end
end


function pairKeys(t)
    local a = {}
    for n in pairs(t) do
        a[#a+1] = n
    end
	table.sort(a)
    local i = 0
    return function()
	    i = i + 1
	    return a[i], t[a[i]]
    end
end

function load_gameobject(res,parent)
	local resObj = Resources.Load(res)
	if not resObj then
		print("can't load res " .. res)
		return nil
	end
	local obj = Object.Instantiate(resObj)

	if parent then
		obj.transform.parent = parent.transform
		obj.transform.localScale = Vector3(1,1,1)
		obj.transform.localPosition = Vector3(0,0,0)
	end

	return obj
end

function line_inter_circle(pt_start,pt_end,pt_center,radius)
    local dx = pt_end.x - pt_start.x
    local dz = pt_end.z - pt_start.z

    local dis = math.sqrt(dx^2 + dz^2);


    local d_x = dx / dis;
    local d_z = dz / dis;


    local e_x = pt_center.x - pt_start.x;
    local e_z = pt_center.z - pt_start.z;

    local a = e_x * d_x + e_z * d_z
    local a2 = a * a

    local e2 = e_x * e_x + e_z * e_z

    local r2 = radius * radius

    return ((r2 - e2 + a2) >= 0)
end

function dis_pos(a,b)
	local dx = a.x - b.x
	local dz = a.z - b.z

	return math.sqrt(dx*dx+dz*dz)
end

function line_pos(pos1,pos2,dis)
	local dx = pos2.x - pos1.x
	local dz = pos2.z - pos1.z

	local pos_dis =  math.sqrt(dx*dx+dz*dz)

	if pos_dis > 0 then
		return Vector3(pos1.x+dx*dis/pos_dis,pos1.y,pos1.z+dz*dis/pos_dis)
	else
		return pos1
	end
end


my_call = function(fun)
	fun()
end

function set_value(value)
	if value == "test_skill" then
		my_call = function(fun)
			xpcall(fun, function(e) print(debug.traceback()) return e end)
		end
	end

	_G[value] = true
end

function format_number(data)
	local low = data % 1
	local str = ""
	if low  ~= 0 then
		data = data - low
		low = math.floor(low*100)
		str = "." .. tostring(low)
	end
	while ( data > 1000) do
		local low = data % 1000
		str =  "," ..  string.format("%03d",low) .. str
		data = data - low
		data = data / 1000
	end
	return (tostring(data)..str)
end
