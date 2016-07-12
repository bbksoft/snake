using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto_def
{
    struct AcountData
    {
        int id;
        string name;
    }

    interface Account
    {
        AcountData login(string name, string pwd);
    }

    interface Game
    {
        void snake_turn(float x,float y);                         
    }
}
