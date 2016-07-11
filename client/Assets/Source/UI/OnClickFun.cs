using UnityEngine;using UnityEngine.UI;using System.Collections;using LuaInterface;public class OnClickFun : MonoBehaviour {    public LuaFunction fun;	// Use this for initialization	void Start () {        
        Button btn = GetComponent<Button>();
        if (btn)
        {
            btn.onClick.AddListener(() => Do());
        }        else
        {
            Toggle tgl = GetComponent<Toggle>();
            tgl.onValueChanged.AddListener((value) => Do());
        }    }    public void Do()    {        fun.Call();
    }}