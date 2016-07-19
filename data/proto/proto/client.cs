using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto_def
{
    struct snake_point
    {
        float x;
        float y;
    }

    struct snake_data
    {
        int id;
        snake_point[] path;
    }

    struct top_info
    {
        string name;
        float  len;
    }

    interface client_handle
    {
        void enter_ack(float time,int id);
        void update_snakes(float time,snake_data[] datas);
        void update_top(top_info[] datas);
        void snake_death(int id);
    }
}
