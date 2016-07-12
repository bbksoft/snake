using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto_def
{
    struct snake_data
    {
        int id;

        float[] path_x;
        float[] path_y;
    }

    interface client_handle
    {
        void update_snakes(snake_data[] datas);
    }
}
