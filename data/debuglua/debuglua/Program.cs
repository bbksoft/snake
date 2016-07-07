using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace debuglua
{
    class Program
    {
        static void Main(string[] args)
        {
            TcpClient tcp = new TcpClient();
            int port = 7172;
            if ((args.Length>0) && (args[0] == "log"))
            {
                port = 7173;
            }            
            
            try
            {
                tcp.Connect("127.0.0.1", port);
                Thread.Sleep(100);
                while (tcp.Available > 0)
                {
                    NetworkStream stream = tcp.GetStream();
                    int len = (int)tcp.Available;
                    byte[] buf = new byte[len];
                    stream.Read(buf, 0, len);

                    string message = Encoding.Unicode.GetString(
                           buf, 0, len);
                    Console.Write(message);
                }
            }
            catch (Exception) { }
            //Console.ReadKey();
            /*
            IPEndPoint remoteIpep = new IPEndPoint(IPAddress.Any, 0);

            IPEndPoint localIpep = new IPEndPoint(
                   IPAddress.Parse("0.0.0.0"), 7172);

            UdpClient client = new UdpClient(localIpep);

            while (true)
            {
                byte[] bytRecv = client.Receive(ref remoteIpep);
                if (bytRecv.Length > 0)
                {
                    string message = Encoding.Unicode.GetString(
                           bytRecv, 0, bytRecv.Length);
                    Console.WriteLine(message);
                }                
                Thread.Sleep(1);
            }*/
        }
    }
}
