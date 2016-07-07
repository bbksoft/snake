using UnityEngine;
using System.Collections;
using System.Text;
using System.Net;
using System.IO;
using System;
using System.Threading;
using LuaInterface;

public class HttpDown : MonoBehaviour {

    string httpPath;
    int version;

    HttpHelper help;
    string rootPath;

    Thread thread;

    public void StartDown(string path,int serverVer,string fun)
    {
        rootPath = Application.persistentDataPath;

        if (rootPath[rootPath.Length - 1] != '/')
        {
            rootPath += "/";
        }

        help = new HttpHelper(rootPath);

        help.fun = LuaClient.GetFun(fun);

        httpPath = "http://" + path;
        if (httpPath[httpPath.Length - 1] != '/')
        {
            httpPath += "/";
        }

        version = serverVer;

        StartCoroutine(UpdateDown());

        //thread = new Thread(UpdateDown);
        //thread.Start();        
    }



    public void ContinueDown()
    {
        help.error = HttpHelper.Error.NONE;
    }

    IEnumerator UpdateDown()
    {
        string verFileName = "ver_" + version;

        while (true)
        {
            help.AsyDownLoad(httpPath + verFileName);

            while (HttpHelper.Error.NONE == help.error )
            {
                yield return new WaitForSeconds(0);
            }

            if (HttpHelper.Error.OK == help.error)
            {
                break;
            }

            OnError();

            while ( checkedDownload() )
            {
                yield return new WaitForSeconds(0);
            }
        }

        byte[] datas = File.ReadAllBytes(rootPath + verFileName);

        int count = datas.Length / 8;
        int[] oldVers = new int[count];
        int[] fileVers = new int[count];
        int[] fileLens = new int[count];

        for (int i = 0; i < datas.Length; i += 8)
        {
            fileVers[i] = BitConverter.ToInt32(datas, i);
            fileLens[i] = BitConverter.ToInt32(datas, i + 4);
        }

        datas = File.ReadAllBytes(rootPath + "ver");
        bool needCreateVer = true;
        if (datas != null)
        {
            int newCount = datas.Length / 4;

            if (newCount < count)
            {
                count = newCount;
            }
            else
            {
                needCreateVer = false;
            }

            for (int i = 0; i < count; i += 4)
            {
                oldVers[i] = BitConverter.ToInt32(datas, i);
            }
        }        

        int maxSize = 0;
        int maxCount = 0;
        for (int i = 0; i < fileVers.Length; i++)
        {
            if (fileVers[i] > oldVers[i])
            {
                maxSize += fileLens[i];
                maxCount++;
            }
        }

        help.fun.Call( "max", count, maxSize);

        FileStream fs = null;
        while (needCreateVer)
        {
            try
            {
                fs = new FileStream(rootPath + "ver", FileMode.Create);

                for (int i = 0; i < oldVers.Length; i++)
                {
                    byte[] versDatas = BitConverter.GetBytes(oldVers[i]);

                    fs.Write(versDatas, 0, 4);
                }

                fs.Seek(0, SeekOrigin.Begin);

                help.error = HttpHelper.Error.OK;
            }
            catch(Exception)
            {
                help.error = HttpHelper.Error.DISK_FULL;
                if (fs!=null)
                {
                    fs.Close();
                }
            }

            if (HttpHelper.Error.OK == help.error) break;


            OnError();

            while (checkedDownload())
            {
                yield return new WaitForSeconds(0);
            }
        }

        if (fs==null)
        {
            fs = new FileStream(rootPath + "ver", FileMode.Open);
        }

        for (int i = 0; i < fileVers.Length; i++)
        {
            if (fileVers[i] > oldVers[i])
            { 
                while(true)
                {
                    help.fun.Call("begin", i, fileLens[i]);

                    help.AsyDownLoad(httpPath + i);

                    while (HttpHelper.Error.NONE == help.error)
                    {
                        yield return new WaitForSeconds(0);
                    }

                    if (HttpHelper.Error.OK == help.error)
                    {
                        oldVers[i] = fileVers[i];
                        byte[] versDatas = BitConverter.GetBytes(oldVers[i]);
                        fs.Seek(4 * i, SeekOrigin.Begin);
                        fs.Write(versDatas, 0, 4);

                        help.fun.Call("end");

                        break;
                    }

                    OnError();

                    while (checkedDownload())
                    {
                        yield return new WaitForSeconds(0);
                    }                   
                }
            }            
        }

        fs.Flush();
        fs.Close();
    }

    void OnError()
    {
        if (help.error != HttpHelper.Error.NONE)
        {
            help.fun.Call("error", help.error.ToString());           
        }
    }

    bool checkedDownload()
    {                

        if (HttpHelper.Error.NONE != help.error)
        {
            return true;
        }

        return false;
    }
}

internal class WebReqState
{
    public byte[] Buffer;

    public FileStream fs;

    public const int BufferSize = 1024;

    public Stream OrginalStream;

    public HttpWebResponse WebResponse;

    public WebReqState(string path)
    {
        Buffer = new byte[BufferSize];
        fs = new FileStream(path, FileMode.Create);
    }

    ~WebReqState()
    {
        if ( fs != null ) fs.Close();
    }
}

internal class HttpHelper
{
    public enum Error
    {        
        OK,
        NET,
        DISK_FULL,
        NONE,
    }

    public Error error;
    public LuaFunction fun;

    HttpWebRequest httpRequest;

    string path = null;
    string assetName;
    public HttpHelper(string path)
    {
        this.path = path;
    }

    public void AsyDownLoad(string url)
    {
        //Debug.Log(url);

        string[] strs = url.Split('/');

        assetName = strs[strs.Length - 1];
        //Debug.Log(assetName);

        error = Error.NONE;

        httpRequest = WebRequest.Create(url) as HttpWebRequest;
        httpRequest.BeginGetResponse(new AsyncCallback(ResponseCallback), this);              
    }

    void ResponseCallback(IAsyncResult ar)
    {
        //Debug.Log(path);

        HttpHelper self = ar.AsyncState as HttpHelper;
        HttpWebRequest req = self.httpRequest;
        if (req == null)
        {
            error = Error.NET;
            return;
        }
                
        HttpWebResponse response = null;
        try
        { 
            response = req.EndGetResponse(ar) as HttpWebResponse;
            if (response.StatusCode != HttpStatusCode.OK)
            {
                error = Error.NET;
                response.Close();
                return;
            }        

            //Debug.Log(path + "/" + assetName);
            WebReqState st = new WebReqState(path + "/" + assetName);
            st.WebResponse = response;
            Stream responseStream = response.GetResponseStream();
            st.OrginalStream = responseStream;
            responseStream.BeginRead(st.Buffer, 0, WebReqState.BufferSize, new AsyncCallback(ReadDataCallback), st);
        }
        catch (Exception)
        {
            error = Error.NET;
            return;
        }

    }

    void ReadDataCallback(IAsyncResult ar)
    {
        try
        {
            WebReqState rs = ar.AsyncState as WebReqState;
            int read = rs.OrginalStream.EndRead(ar);
            if (read > 0)
            {
                rs.fs.Write(rs.Buffer, 0, read);
                rs.fs.Flush();

                fun.Call("add", read);

                rs.OrginalStream.BeginRead(rs.Buffer, 0, WebReqState.BufferSize,
                       new AsyncCallback(ReadDataCallback), rs);
            }
            else
            {
                rs.fs.Close();
                rs.OrginalStream.Close();
                rs.WebResponse.Close();
                //Debug.Log(assetName + " downloaded.");

                error = Error.OK;
            }
        }
        catch(Exception)
        {
            error = Error.NET;
            return;
        }
    }
}
