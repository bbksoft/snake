
require("type_define")
require("config.exConfig")

require("base.tools")

Proto = require("base.proto_tools")
Client = require("base.proto_client")
UI = require("base.ui")


--local socket = require("socket")
-- local socket = require("socket")

-- function Update()
--     if sock then
--
--             local response, receive_status = sock:receive(2)
--             if receive_status ~= "closed" then
--                 if response then
--
--                 end
--             else
--                 sock = nil
--             end
--
--     end
-- end


-- function wait(value)
--     coroutine.yield()
--     print("wait...")
-- end


-- Actor = require("game.actor")

--主入口函数。从这里开始lua逻辑
function Main()
    -- for demo only -----------------------------------------
    player = {}

    player.atk_frm = {}
    player.atk_frm.heros = {}
    player.atk_frm.frm = {}
    for k,v in pairKeys(cfg_actor) do
        table.insert(player.atk_frm.heros,{level=1,id=k,icon=v.icon})
        table.insert(player.atk_frm.heros,{level=1,id=k,icon=v.icon})
        table.insert(player.atk_frm.heros,{level=1,id=k,icon=v.icon})
    end

    player.def_frm = {}
    player.def_frm.heros = {}
    player.def_frm.frm = {}
    for k,v in pairKeys(cfg_actor) do
        table.insert(player.def_frm.heros,{level=1,id=k,icon=v.icon})
        table.insert(player.def_frm.heros,{level=1,id=k,icon=v.icon})
        table.insert(player.def_frm.heros,{level=1,id=k,icon=v.icon})
    end
    ----------------------------------------------------------

    UI.create("choice_heros")

    --local obj = GameObject.Find("Cube")
    --UITools.ShowTextFrom3D(obj,"Game/hp","1000000")

    --GameAPI.LoadScene(1)

    -- a =  Actor.create()
    --
    -- a.name = "namexxx"
    -- a:init()
    --
    -- local fun = function ()
    --     local t = require("test_fun")
    --     t()
    -- end
    --
    -- local co = coroutine.create(fun)
    -- print("0")
    -- coroutine.resume(co)
    -- print(coroutine.status(co))
    -- print("1")
    -- coroutine.resume(co)
    -- print("2")
    -- coroutine.resume(co)
    -- print("3")
    -- coroutine.resume(co)

    -- local fun = function ( )
    --     print("do fun in ui")
    -- end

    -- ui = UI.create(
    --     {
    --         res_name="Button",
    --         children={
    --             {type="button",fun=fun},
    --             {type="text",text="mytest"},
    --         },
    --     })



    -- data = true
    -- assert(type(data) == "boolean")
    -- data = 12
    -- assert(type(data) == "number")
    -- data = 12.3
    -- assert(type(data) == "number")
    -- data = "dsada"
    -- assert(type(data) == "string")
    -- data = {}
    -- assert(type(data) == "table")


    -- function test_fun()
    --     print("test!")
    --     return true
    -- end

    -- function CoExample()
    --     --socket.try( test_fun(). "dddsadds" )
    -- end
    -- StartCoroutine(CoExample)




    -- print("test")
-- client:connect("127.0.0.1",8178)
    -- local data = {}
    -- data.key =  "123"
    -- data.index = 1
    -- data.array = {1,2,3,4}
    -- data.datas = {"a","b"}
    -- data.datatts = {}


 --    local bin = proto:call_to_bin("server_handle", "login",data,"test",{1,2,3},12.3,false)

 --    print(_bs(bin))
 --    local call_class,call_fun,call_params = proto:bin_to_call(bin)

 --    print(_s(call_class))
 --    print(_s(call_fun))
 --    print(_s(call_params))

	-- local host = "127.0.0.1"
	-- local port = 8178
	-- print("start....")
 --    sock = socket.connect(host, port)
 --    print("start...ok")
	-- sock:settimeout(0)

 --    fun = function ()
 --        Update()
 --    end

 --    timer = Timer.New(fun,0,-1,false)
 --    timer:Start()

 --    print("ttt")
 --    Timer.New(test_run, 0, -1, false):Start()
 --    print("111ttt")

    --print("OnLevelWasLoaded...")

    -- local GameObject = UnityEngine.GameObject

    -- local go = GameObject('go')
    -- com = go:AddComponent(typeof(HttpDown))
    -- print(com)
    -- com:StartDown("127.0.0.1/test",1,"test_run")
end



--
--
-- function test_run(p,p2,p3 )
--     print(p)
--     print(p2)
--     print(p3)
-- end

--场景切换通知
function OnLevelWasLoaded(level)

    --print("OnLevelWasLoaded")
	Time.timeSinceLevelLoad = 0

    if level  == 0 then
        UI.create("choice_heros")
    else
        GameClient = require("game.game_client")
        game_client = GameClient.create()

        gamedata = {
            self_team = 1,
            actors = {
            },
            game_time = 90,
            rnd_seed = 1234,
        }

        for k,v in pairs(player.atk_frm.frm) do
            local hero = player.atk_frm.heros[v]
            table.insert(gamedata.actors,{
                team = 1,
                type_id = hero.id,
                pos_index = k,
                level = hero.level,
            })
        end

        for k,v in pairs(player.def_frm.frm) do
            local hero = player.def_frm.heros[v]
            table.insert(gamedata.actors,{
                team = 2,
                type_id = hero.id,
                pos_index = k,
                level = hero.level,
            })
        end

        game_client:init(gamedata)

        game_client.ui_battle = UI.create("battle")
        --print(game_client.ui_battle)
    end
end


function main_test()
    -- if paused then
    --     Time.timeScale = 1
    --     paused = nil
    --     local o = GameObject.Find("p")
    --     GameAPI.RealParitcleQuit(o)
    --     GameAPI.StopParticleLoop(o)
    --
    --     local o = GameObject.Find("test")
    --     GameAPI.RealAnimQuit(o)
    -- else
    --     local o = GameObject.Find("p")
    --     GameAPI.RealParitcle(o)
    --
    --     local o = GameObject.Find("test")
    --     GameAPI.RealAnim(o,"run")
    --
    --     paused = true
    --     Time.timeScale = 0
    -- end
end

function on_click(  )
    print("on_click")
    game_client:destroy()
    game_client = nil
    GameAPI.LoadScene(0)
    --client:send("server_handle", "login",nil,"test",nil,1.234567,true)

	-- if sock then
 --        sock:send( "test123\n")
 --    end
end
