﻿using UnityEngine;
using System.Collections;
using LuaInterface;

public class OnDragChange : MonoBehaviour {

    public LuaFunction fun;

    public void Do(int value1,int value2)
    {
        fun.Call(value1, value2);
    }

    public RectTransform nodeCancel;

    public void SetCancel(Transform node)
    {
        nodeCancel = node as RectTransform;
    }
}
