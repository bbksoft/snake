using UnityEngine;
using System.Collections;
using LuaInterface;
using UnityEngine.UI;

public class UITools
{

    public static Transform gCanvas;
    public static Camera    gCam;

    public static Transform gLightCanvas;
    public static Camera gLightCamera;

    public static void ClearAll()
    {
        gCanvas.DetachChildren();
    }

    public static void Init()
    {
        gCanvas = LuaClient.Instance.transform.FindChild("Canvas");
        Transform t = LuaClient.Instance.transform.Find("CameraUI");
        gCam = t.GetComponent<Camera>();
    }

    public static GameObject CreateUIObj(string res,bool zero_size=true)
    {
        res = "UI/" + res;

        var prefab = Resources.Load(res);

        Debug.Assert(prefab, "can't find [" + res + "] in UI/prefab/.");


        GameObject obj = GameObject.Instantiate(prefab) as GameObject;

        obj.transform.SetParent(gCanvas);

        obj.transform.localScale = Vector3.one;
        obj.transform.localPosition = Vector3.zero;

        if (zero_size)
        {
            RectTransform rt = obj.GetComponent<RectTransform>();
            if (rt)
            {
                rt.sizeDelta = new Vector2(0, 0);
            }
        }

        int pos = res.LastIndexOf('/');
        obj.name = res.Substring(pos + 1);

        return obj;
    }

    public static GameObject CreateUIObjLight(string res, bool zero_size = true)
    {
        res = "UI/" + res;

        var prefab = Resources.Load(res);

        Debug.Assert(prefab, "can't find [" + res + "] in UI/prefab/.");


        GameObject obj = GameObject.Instantiate(prefab) as GameObject;
        obj.transform.SetParent(gLightCanvas);

        obj.transform.localScale = Vector3.one;
        obj.transform.localPosition = Vector3.zero;

        if (zero_size)
        {
            RectTransform rt = obj.GetComponent<RectTransform>();
            if (rt)
            {
                rt.sizeDelta = new Vector2(0, 0);
            }
        }

        int pos = res.LastIndexOf('/');
        obj.name = res.Substring(pos + 1);

        return obj;
    }

    

    public static Transform Show(string res)
    {
        GameObject obj = CreateUIObj(res);

        obj.SetActive(true);

        return obj.transform;
    }

    public static void Close(Transform t)
    {
        if (t != null)
        {
            GameObject.Destroy(t.gameObject);
        }
    }

    public static void SetText(Transform t, string text)
    {
        if (t == null) return;

        Text guiText = t.GetComponent<Text>();

        if (guiText == null)
        {
            t = t.FindChild("Text");
            if (t == null)
            {
                return;
            }

            guiText = t.GetComponent<Text>();
        }

        if (guiText != null)
        {
            guiText.text = text;
        }
    }

    public static void SetButton(Transform t, LuaFunction fun)
    {
        if (t == null) return;

        OnClickFun onClick = t.gameObject.GetComponent<OnClickFun>();

        if (onClick == null)
        {
            onClick = t.gameObject.AddComponent<OnClickFun>();
        }

        onClick.fun = fun;
    }

    public static void SetButton(Transform t, LuaFunction fun, int param)
    {
        if (t == null) return;

        OnClickFunInt onClick = t.gameObject.GetComponent<OnClickFunInt>();

        if (onClick == null)
        {
            onClick = t.gameObject.AddComponent<OnClickFunInt>();
        }

        onClick.fun = fun;
        onClick.param = param;
    }

    public static void SetDragFun(Transform t, LuaFunction fun)
    {
        if (t == null) return;

        UIDragFun onClick = t.gameObject.GetComponent<UIDragFun>();

        if (onClick == null)
        {
            onClick = t.gameObject.AddComponent<UIDragFun>();
        }

        onClick.fun = fun;
    }



    public static void SetPic(Transform t, string type, string picName)
    {
        if (t == null) return;

        Image img = t.GetComponent<Image>();
        img.sprite = UIRes.GetSprite(type, picName);
    }


    public static void SetEnable(Transform t, bool enable)
    {
        t.gameObject.SetActive(enable);
    }

    public static void SetChildEnable(Transform t, string path, bool enable)
    {
        SetEnable(t.FindChild(path), enable);
    }

    public static void SetFill(Transform t, float value)
    {
        if (t == null) return;

        Slider s = t.GetComponent<Slider>();
        s.value = (s.maxValue - s.minValue) * value;
    }

    public static Transform FllowUI(GameObject obj, string res)
    {
        return FllowUI(obj, res, false);
    }

    public static Transform FllowUI(GameObject obj, string res,bool light)
    {
        GameObject ui_obj;

        if (light)
        {
            ui_obj = CreateUIObjLight(res, false);

            UITools.SetToObjTop(obj, ui_obj.transform);
        }
        else
        {
            ui_obj = CreateUIObj(res, false);
        }

        FllowObj f = ui_obj.AddComponent<FllowObj>();

        f.obj = obj;

        return ui_obj.transform;
    }


    public static void SetChildTimeText(Transform t,string path,float value)
    {
        SetTimeText(t.FindChild(path), value);
    }

    public static void SetTimeText(Transform t, float value)
    {
        int s = (int)(value);
        int m = s / 60;
        s = s % 60;

        string str = string.Format("{0:D2}:{1:D2}", m, s);

        SetText(t, str);
    }

    public static void SetEnableImage(Transform t, bool enable)
    {
        if (t == null) return;

        Image img = t.GetComponent<Image>();
        img.enabled = enable;
    }


    public static Transform GetListChild(Transform t, int index)
    {
        int count = t.childCount;

        Transform ret = null;

        if (count >= index)
        {
            ret = t.GetChild(index - 1);
        }
        else
        {
            Transform child = t.GetChild(0);

            GameObject obj = GameObject.Instantiate(child.gameObject);

            ret = obj.transform;
            ret.SetParent(child.parent);
            ret.localScale = Vector3.one;
            ret.localPosition = Vector3.zero;
        }

        ret.gameObject.SetActive(true);

        return ret;
    }

    public static void SetListLen(Transform t, int len)
    {
        int count = t.childCount;

        for (int i = len; i < count; i++)
        {
            t.GetChild(i).gameObject.SetActive(false);
        }
    }

    public static void SetDragChange(Transform t,LuaFunction fun)
    {
        OnDragChange change = t.GetComponent<OnDragChange>();
        if (change == null)
        {
            change = t.gameObject.AddComponent<OnDragChange>();
            change.fun = fun;
        }
    }

    public static void SetDragCancel(Transform t, Transform node)
    {
        OnDragChange change = t.GetComponent<OnDragChange>();
        if (change != null)
        {
            change.SetCancel(node);
        }
    }

    public static void EnableUI3dCamera(bool value)
    {
        Transform t = LuaClient.Instance.transform.Find("CameraUI3d");
        t.gameObject.SetActive(value);
    }

    public static void AddMod(Transform t, string name, string res,float size,Vector3 faceto)
    {
        if (t == null) return;
        Transform child = t.Find(name);
        if (child != null)
        {
            GameObject.Destroy(child.gameObject);
        }

        GameObject obj = GameObject.Instantiate(Resources.Load(res)) as GameObject;

        obj.transform.SetParent(t);

        Transform rt = obj.GetComponent<Transform>();
        obj.transform.localScale = Vector3.one * size;
        obj.transform.localPosition = Vector3.zero;

        obj.transform.forward = faceto;
        obj.name = name;

        int layer = LayerMask.NameToLayer("UIActor");

        ChangeLayer(obj.transform,layer);
    }

    public static void ChangeObjLight(GameObject obj, bool light)
    {
        int layer;

        if (light)
        {
            layer = LayerMask.NameToLayer("LightActor");
        }
        else
        {
            layer = LayerMask.NameToLayer("Actor");
        }


        ChangeLayer(obj.transform, layer);
    }

    public static void ChangeUILight(Transform t, bool light)
    {
        int layer;

        if (light)
        {
            layer = LayerMask.NameToLayer("LightUI");            
        }
        else
        {
            layer = LayerMask.NameToLayer("UI");
        }

        ChangeLayer(t, layer);
    }

    public static void ChangeLayer(Transform t,int layer)
    {
        t.gameObject.layer = layer;
        for (int i=0; i<t.childCount; i++)
        {
            ChangeLayer(t.GetChild(i), layer);
        }
    }

    public static void DelMod(Transform t, string name)
    {
        if (t==null) return;

        Transform child =  t.Find(name);
        if (child != null)
        {
            GameObject.Destroy(child.gameObject);
        }

    }

    public static void AddOff(Transform t, Vector2 v)
    {
        RectTransform rt = t as RectTransform;

        rt.anchoredPosition += v;
    }

    public static Transform ShowTextFrom3D(GameObject obj, string res, string text)
    {
        GameObject uiObj = CreateUIObj(res);

        RectTransform t = uiObj.transform as RectTransform;

        t.anchoredPosition = Get2DTop(obj, t, gCam);

        Text[] ts = uiObj.GetComponentsInChildren<Text>();
        for (int i=0; i<ts.Length; i++)
        {
            ts[i].text = text;
        }

        return uiObj.transform;
    }

    public static void SetToObjTop(GameObject obj,Transform t)
    {
        RectTransform rt = t as RectTransform;
        RectTransform parent = t.parent as RectTransform;

        Camera c = gCam;
        if (parent == null)
        {
            parent = gCanvas as RectTransform;
        }
        

        if (parent != gCanvas)
        {
            c = gLightCamera;
        }        

        //Debug.Log(parent);

        rt.anchoredPosition = Get2DTop(obj, parent, gCam);
    }

    static Vector2 Get2DTop(GameObject obj, RectTransform rect,Camera c)
    {
        BoxCollider box = obj.GetComponent<BoxCollider>();

        float y = 1.8f;
        if ( box != null ) {
            y = box.size.y;
        }

        Vector3 v = obj.transform.position + new Vector3(0,y,0);
        return D3_TO_UI(v, rect,c);
    }

    static Vector2 D3_TO_UI(Vector3 pos,RectTransform rect,Camera c)
    {      
        Vector3 p = Camera.main.WorldToScreenPoint(pos);

        Vector2 pt;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, p,
            c, out pt);

        return pt;
    }

    public static void SetAnimId(Transform t, int id)
    {
        Animator a = t.GetComponent<Animator>();
        a.SetInteger("ID", id);
    }
}
