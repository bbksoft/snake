/*
Copyright (c) 2015-2016 topameng(topameng@qq.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
using UnityEngine;
using System.Collections.Generic;
using LuaInterface;
using System.Collections;
using System.IO;
using System;

#if UNITY_EDITOR
using System.Net;
using System.Net.Sockets;
using System.Text;
#endif


public class LuaClient : MonoBehaviour
{
    public static LuaClient Instance
    {
        get;
        protected set;
    }

    public static void CallFun(string fun_name, params object[] args)
    {
        LuaFunction fun = Instance.luaState.GetFunction(fun_name);
        fun.Call(args);
        fun.Dispose();
        fun = null;
    }

    public static LuaFunction GetFun(string fun_name)
    {
        return Instance.luaState.GetFunction(fun_name);
    }

    public static Lua_Debug GetInfo()
    {
        Lua_Debug degug = Instance.luaState.GetInfo();

        return degug;
    }


    public bool enable_run = true;
    public bool test_skill = false;

    protected LuaState luaState = null;
    protected LuaLooper loop = null;
    protected LuaFunction levelLoaded = null;

    protected bool openLuaSocket = false;
    protected bool beZbStart = false;

    protected virtual LuaFileUtils InitLoader()
    {
        if (LuaFileUtils.Instance != null)
        {
            return LuaFileUtils.Instance;
        }

        return new LuaFileUtils();
    }

    protected virtual void LoadLuaFiles()
    {
        OnLoadFinished();
    }

    protected virtual void OpenLibs()
    {
        luaState.OpenLibs(LuaDLL.luaopen_pb);
        luaState.OpenLibs(LuaDLL.luaopen_struct);
        luaState.OpenLibs(LuaDLL.luaopen_lpeg);
#if UNITY_STANDALONE_OSX || UNITY_EDITOR_OSX
        luaState.OpenLibs(LuaDLL.luaopen_bit);
#endif

        if (LuaConst.openLuaSocket)
        {
            OpenLuaSocket();            
        }        

        if (LuaConst.openZbsDebugger)
        {
            OpenZbsDebugger();
        }
    }

    public void OpenZbsDebugger(string ip = "localhost")
    {
        if (!Directory.Exists(LuaConst.zbsDir))
        {
            Debugger.LogWarning("ZeroBraneStudio not install or LuaConst.zbsDir not right");
            return;
        }

        if (!LuaConst.openLuaSocket)
        {                            
            OpenLuaSocket();
        }

        if (!string.IsNullOrEmpty(LuaConst.zbsDir))
        {
            luaState.AddSearchPath(LuaConst.zbsDir);
        }

        luaState.LuaDoString(string.Format("DebugServerIp = '{0}'", ip));
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int LuaOpen_Socket_Core(IntPtr L)
    {        
        return LuaDLL.luaopen_socket_core(L);
    }

    [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
    static int LuaOpen_Mime_Core(IntPtr L)
    {
        return LuaDLL.luaopen_mime_core(L);
    }

    protected void OpenLuaSocket()
    {
        LuaConst.openLuaSocket = true;

        luaState.BeginPreLoad();
        luaState.RegFunction("socket.core", LuaOpen_Socket_Core);
        luaState.RegFunction("mime.core", LuaOpen_Mime_Core);                
        luaState.EndPreLoad();                     
    }

    //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
    protected void OpenCJson()
    {
        luaState.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
        luaState.OpenLibs(LuaDLL.luaopen_cjson);
        luaState.LuaSetField(-2, "cjson");

        luaState.OpenLibs(LuaDLL.luaopen_cjson_safe);
        luaState.LuaSetField(-2, "cjson.safe");                
    }

    protected virtual void CallMain()
    {
        LuaFunction main = luaState.GetFunction("Main");
        main.Call();
        main.Dispose();
        main = null;                
    }

    protected virtual void StartMain()
    {
        luaState.DoFile("Main.lua");
        levelLoaded = luaState.GetFunction("OnLevelWasLoaded");
        CallMain();
    }

    protected void StartLooper()
    {
        loop = gameObject.AddComponent<LuaLooper>();
        loop.luaState = luaState;
    }

    protected virtual void Bind()
    {        
        LuaBinder.Bind(luaState);
        LuaCoroutine.Register(luaState, this);
    }

    protected void Init()
    {
        UITools.Init();

        InitLoader();
        luaState = new LuaState();
        OpenLibs();

        OpenCJson();

        luaState.LuaSetTop(0);
        Bind();
        LoadLuaFiles();    

        if (test_skill)
        {
            CallFun("set_test_skill");
        }
    }

    protected void Awake()
    {
        if (enable_run == false) return;

        if ( Instance )
        {
            GameObject.Destroy(gameObject);
            return;
        }     

        DontDestroyOnLoad(gameObject);

        Instance = this;
        Init();                 
    }

         

    protected virtual void OnLoadFinished()
    {
        luaState.Start();                
        StartLooper();
        StartMain();
    }

    protected void OnLevelWasLoaded(int level)
    {
        if (levelLoaded != null)
        {
            levelLoaded.BeginPCall();
            levelLoaded.Push(level);
            levelLoaded.PCall();
            levelLoaded.EndPCall();
        }
    }

    protected void Destroy()
    {
        if (luaState != null)
        {

            if (levelLoaded != null)
            {
                levelLoaded.Dispose();
                levelLoaded = null;
            }

            if (loop != null)
            {
                loop.Destroy();
                loop = null;
            }

            if (luaState != null)
            {
                luaState.Dispose();
                luaState = null;
            }

            Instance = null;
        }

        DestroyBebug();
    }

    protected void OnDestroy()
    {
        Destroy();        
    }

    protected void OnApplicationQuit()
    {
        Destroy();
    }

    public static LuaState GetMainState()
    {
        return Instance.luaState;
    }

    public LuaLooper GetLooper()
    {
        return loop;
    }





#if UNITY_EDITOR
    static public void Debug_Info(string msg, bool isError = true)
    {
        Instance.SendDebugInfo(msg, isError);
        //Debug.Log(sendStr);
    }
    // for debug...
    //UdpClient udp;
    string errorInfo = "";
    string logInfo = "";

    TcpListener tcpServer;
    TcpListener tcpLogServer;

    private void DestroyBebug()
    {
        if (tcpServer!=null)
        {
            try {
                tcpLogServer.EndAcceptTcpClient(null);
                tcpServer.EndAcceptTcpClient(null);
            }
            catch (Exception) { }
            tcpServer = null;
            tcpLogServer = null;
        }
    }

    private void doMsg(TcpClient client,bool isError)
    {
        NetworkStream clientStream = client.GetStream();
        byte[] sendbytes = null;
        if (isError)
        {
            sendbytes = Encoding.Unicode.GetBytes(errorInfo);
        }
        else
        {
            sendbytes = Encoding.Unicode.GetBytes(logInfo);
        }
        clientStream.Write(sendbytes, 0, sendbytes.Length);
        client.Close();
    }

    private void Acceptor(IAsyncResult o)
    {
        TcpListener server = o.AsyncState as TcpListener;
        try
        {
            TcpClient client = server.EndAcceptTcpClient(o);
            doMsg(client, false);
        }
        catch
        {
        }
        //IAsyncResult result = 
        server.BeginAcceptTcpClient(new AsyncCallback(Acceptor), server);        
    }

    private void AcceptorDebug(IAsyncResult o)
    {
        TcpListener server = o.AsyncState as TcpListener;
        try
        {
            TcpClient client = server.EndAcceptTcpClient(o);
            doMsg(client, true);
        }
        catch
        {
        }
        //IAsyncResult result = 
        server.BeginAcceptTcpClient(new AsyncCallback(Acceptor), server);
    }

    void SendDebugInfo(string msg,bool isError)
    {
        string[] msgs = msg.Split('\n');

        string sendStr = "";        

        for (int i = 0; i < msgs.Length; i++)
        {
            int n = msgs[i].IndexOf("[string");

            if (n >= 0)
            {
                string str = msgs[i];
                string tempStr = "";
                while (n >= 0)
                {
                    if (tempStr != "")
                    {
                        tempStr += str.Substring(0, n);
                        tempStr += "\n";
                    }

                    str = str.Substring(n + 9);

                    int pos = str.IndexOf('"');

                    tempStr += "Lua/";
                    string fileString = str.Substring(0, pos);
                    tempStr += fileString;

                    if (fileString.IndexOf(".lua") < 0)
                    {
                        tempStr += ".lua";
                    }

                    str = str.Substring(pos + 2);
                    n = str.IndexOf("[string");
                }
                tempStr += str + "\n";
                sendStr += tempStr;
            }
            else
            {
                if (msgs[i].IndexOf("stack") == 0)
                {
                    sendStr += msgs[i] + "\n";
                }
            }

        }

        if (isError)
        {
            errorInfo += sendStr;
        }
        else
        {
            if (logInfo.Length > 3000) logInfo = "";
            logInfo += sendStr;
        }

        if (tcpServer == null)
        {
            tcpServer = new TcpListener(new System.Net.IPEndPoint(0, 7172));
            tcpServer.Start(100);
            tcpServer.BeginAcceptTcpClient(new AsyncCallback(AcceptorDebug), tcpServer);

            tcpLogServer = new TcpListener(new System.Net.IPEndPoint(0, 7173));
            tcpLogServer.Start(100);
            tcpLogServer.BeginAcceptTcpClient(new AsyncCallback(Acceptor), tcpLogServer);
        }
        /*
        if (udp == null)
        {
            IPEndPoint localIpep = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 7171);
            udp = new UdpClient(localIpep);
        }

        byte[] sendbytes = Encoding.Unicode.GetBytes(sendStr);

        IPEndPoint remoteIpep = new IPEndPoint(
            IPAddress.Parse("127.0.0.1"), 7172);

        udp.Send(sendbytes, sendbytes.Length, remoteIpep); */
    }
#else
    private void DestroyBebug()
    {
    }

    static public void Debug_Info(string msg,bool isError=true)
    {        
    }
#endif
}
