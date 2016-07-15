
require("type_define")
require("config.exConfig")

require("base.tools")

Proto = require("base.proto_tools")
Client = require("base.proto_client")
UI = require("base.ui")


function Main()
    math.randomseed(os.time())
    
    client = require("game.client").create()
    client.my_id = 1
    client:create_actor({id=1})
end



function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0

end

function OnDragDirect(v)
    if client then
        client:OnDragDirect(v)
    end
end
