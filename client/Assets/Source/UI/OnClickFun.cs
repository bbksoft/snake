﻿using UnityEngine;using UnityEngine.UI;using System.Collections;using LuaInterface;public class OnClickFun : MonoBehaviour {    public LuaFunction fun;	// Use this for initialization	void Start () {        
        Button btn = GetComponent<Button>();
        btn.onClick.AddListener(() => Do());            }    public void Do()    {        fun.Call();
    }}