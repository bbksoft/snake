using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto_def
{ 

    interface Game
    {
        void snake_enter();
        void snake_turn(float time,float x,float y);                         
    }
}
