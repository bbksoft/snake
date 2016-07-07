using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;
using UnityEngine.UI;

public class UIDragFun : MonoBehaviour, IBeginDragHandler, 
    IDragHandler, IEndDragHandler, IPointerDownHandler
{
    public LuaFunction fun;

    bool isDragged;
   
    void Start()
    {
        Button btn = GetComponent<Button>();
        if (btn != null)
        {
            btn.onClick.AddListener(() => Do());
        }
        isDragged = false;
    }

    public void OnBeginDrag(PointerEventData data)
    {
        Vector3 pos = GetWorldPos(data);
        fun.Call("begin",pos);

        isDragged = true;
    }

    public void OnDrag(PointerEventData data)
    {

        Vector3 pos = GetWorldPos(data);

        fun.Call("move",pos);
    }

    public void OnEndDrag(PointerEventData data)
    {
        isDragged = false;
        fun.Call("end");
    }

    public Vector3 GetWorldPos(PointerEventData data)
    {
        Ray r = Camera.main.ScreenPointToRay(data.position);
        Vector3 pos = r.origin - r.direction * r.origin.y / r.direction.y;

        return pos;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        fun.Call("down");
    }

    public void Do()    {        if (isDragged == false)
        {
            fun.Call();
        }        
    }
}
