using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto_def
{

// ------ for test ------
    struct data_tt
    {
        int id;
    }

    struct data_id
    {
        string key;
        int index;
        int[] array;
        string[] datas;
        data_tt[] datatts;
    }

    interface test
    {
        int login(data_id id,string token,int[] datas,float z,bool t);                         
    }
}
