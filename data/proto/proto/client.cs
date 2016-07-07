using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto_def
{
    enum test_enum
    {
        te_one,
        te_two,
    }

    struct test_data
    {

    }

    struct player_data
    {
        int id;
        string[] name;
        test_data[] datas;
    }

    interface client_handle
    {
        void player_update(player_data data);
    }
}
