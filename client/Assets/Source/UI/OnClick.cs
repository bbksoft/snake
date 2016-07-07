using UnityEngine;using UnityEngine.UI;using System.Collections;public class OnClick : MonoBehaviour {    public enum EventType
    {
        on_click
    }    public EventType type = EventType.on_click;    public string fun_name;	// Use this for initialization	void Start () {        if (type == EventType.on_click)
        {
            Button btn = GetComponent<Button>();
            btn.onClick.AddListener(() => Do());
        }    }    public void Do()    {        LuaClient.CallFun(fun_name);            }}