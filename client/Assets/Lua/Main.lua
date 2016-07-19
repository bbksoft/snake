
require("type_define")
require("config.exConfig")

require("base.tools")
Client = require("base.proto_client")
UI = require("base.ui")

proto = require("base.proto_tools")


function Main()
    math.randomseed(os.time())

    net_client = Client:new()
    net_client:connect("127.0.0.1",8178)

    client = require("game.client").create()
    client.my_id = 1
    client:create_actor({id=1,length=1})

    net_client:send("Game","snake_enter")
end



function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end

function OnDragDirect(v)
    if client then
        client:OnDragDirect(v)
    end
end
