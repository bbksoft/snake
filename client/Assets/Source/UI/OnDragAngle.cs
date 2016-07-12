﻿using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

public class OnDragAngle : MonoBehaviour,
    IPointerDownHandler,
    IPointerUpHandler,
    IBeginDragHandler,
    IDragHandler, IEndDragHandler
{

    public string fun_name;


    Vector2 direct;
    float   dirtyTime;
    bool    dirty;

    public void OnBeginDrag(PointerEventData data)
    {
    }

    public void OnDrag(PointerEventData data)
    {        
        SetDirect(data.position);
    }

    public void OnEndDrag(PointerEventData data)
    {        
    }

    public void OnPointerDown(PointerEventData data)
    {        
        SetDirect(data.position);
    }

    public void OnPointerUp(PointerEventData data)
    {
    }

    void SetDirect(Vector2 position)
    {
        if (dirty == false)
        { 
            if (dirtyTime < Time.realtimeSinceStartup)
            {                
                dirtyTime = Time.realtimeSinceStartup;                
            }
        }
        dirty = true;
        Vector2 v = position - new Vector2(Screen.width/2, Screen.height/2);
        direct = v.normalized;
    }

    // Update is called once per frame
    void Update () {
        if (dirty && (dirtyTime < Time.realtimeSinceStartup))
        {
            LuaClient.CallFun(fun_name, direct);
            dirty = false;
            dirtyTime += 0.2f;
        }
    }


}
