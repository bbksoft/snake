using UnityEngine;
using UnityEngine.EventSystems;

public class DragUIActor : MonoBehaviour, IBeginDragHandler,
        IDragHandler, IEndDragHandler 
{
    GameObject dragObj;
    GameObject oldObj;

  

    Camera mCamera;

    void Start()
    {
        GameObject obj = GameObject.Find("Main");
        obj= obj.transform.FindChild("CameraUI3d").gameObject;
        mCamera = obj.GetComponent<Camera>();
    }

   

    public void OnBeginDrag(PointerEventData data)
    {
        //Debug.Log("OnBeginDrag");

        
        Ray r = mCamera.ScreenPointToRay(data.position);        

        int layer = LayerMask.NameToLayer("UIActor");

        RaycastHit[] rhs = Physics.RaycastAll(r, 100000, 1 << layer);

        if ( rhs != null && rhs.Length > 0)
        {
            //Debug.Log(r.origin);
            //Debug.Log(rhs[0].collider.gameObject.transform.position);

            oldObj = rhs[0].collider.gameObject;
            dragObj = GameObject.Instantiate(oldObj);

            dragObj.transform.parent = oldObj.transform.parent;
            dragObj.transform.localScale = oldObj.transform.localScale;
            dragObj.transform.localRotation = oldObj.transform.localRotation;
            dragObj.transform.localPosition = oldObj.transform.localPosition;

            oldObj.SetActive(false);

            Transform p = oldObj.transform.parent.parent;
            OnDragChange change = p.GetComponent<OnDragChange>();
            change.Do(0, 0);
        }
    }

    public void OnDrag(PointerEventData data)
    {
        if (dragObj == null) return;

        Ray r = mCamera.ScreenPointToRay(data.position);
        float dis = (dragObj.transform.position.z - r.origin.z) / r.direction.z;
        dragObj.transform.position = r.origin + r.direction * dis;
    }

    public void OnEndDrag(PointerEventData data)
    {
        if (dragObj == null) return;

        GameObject.Destroy(dragObj);
        oldObj.SetActive(true);

        Transform p = oldObj.transform.parent.parent;

        //GameObject obj = GameObject.Find("Main/CameraUI");
        //Camera ui_camera = obj.GetComponent<Camera>();
        //Ray r = ui_camera.ScreenPointToRay(data.position);

        Vector3 globalMousePos;        

        int n1 = -1;
        int n2 = -1;
        for (int i=0; i<p.childCount; i++)
        {
            RectTransform child = p.GetChild(i) as RectTransform;

            if (oldObj.transform.parent == child)
            {                
                n1 = i + 1;
                continue;
            }

            //Vector3 globalMousePos;
            if (RectTransformUtility.ScreenPointToWorldPointInRectangle(
                child, data.position, data.pressEventCamera,out globalMousePos))
            {                
                Vector3 v = globalMousePos - child.position;                
                if (v.magnitude<=1)
                {
                    n2 = i + 1;
                }
            }
        }

        OnDragChange change = p.GetComponent<OnDragChange>();

        if (change.nodeCancel != null)
        {
            Vector2 localPos;
            if (RectTransformUtility.ScreenPointToLocalPointInRectangle(
                change.nodeCancel, data.position, data.pressEventCamera, out localPos))
            {                
                if (change.nodeCancel.rect.Contains(localPos))
                {                    
                    change.Do(n1,0);
                    return;
                }
            }
        }

        if ( n2 >= 0 )
        {            
            change.Do(n1, n2);
        }        
    }   
    
}
