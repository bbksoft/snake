using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace proto
{
    class Program
    {
        static void Main(string[] args)
        {
            string curPath = System.IO.Directory.GetCurrentDirectory();

            while(curPath.IndexOf("data")>0)
            {
                System.IO.Directory.SetCurrentDirectory("..");
                curPath = System.IO.Directory.GetCurrentDirectory();
            }

            exporter.init();

            string fileNameClient = curPath + "/client/Assets/Lua/config/proto.lua";
            exporter.do_export_lua(fileNameClient);

            string fileNameServer = curPath + "/server/config/proto.txt";
            exporter.do_export(fileNameServer);

            Console.WriteLine("It's done.");

            Console.ReadKey();
        }
    }
}
